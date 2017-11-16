package multisig

import (
	"errors"
	"math/big"
	// "math/rand"
	"time"

	"github.com/ethereum/go-ethereum/common"
	"github.com/ethereum/go-ethereum/consensus"
	"github.com/ethereum/go-ethereum/core"
	"github.com/ethereum/go-ethereum/core/state"
	"github.com/ethereum/go-ethereum/core/types"
	"github.com/ethereum/go-ethereum/core/vm"
	"github.com/ethereum/go-ethereum/crypto"
	"github.com/ethereum/go-ethereum/ethdb"
	"github.com/ethereum/go-ethereum/event"
	"github.com/ethereum/go-ethereum/log"
	"github.com/ethereum/go-ethereum/p2p"
	"github.com/ethereum/go-ethereum/params"
	"github.com/ethereum/go-ethereum/rpc"
)

var (
	errZeroBlockTime     = errors.New("timestamp equals parent's")
	errInvalidDifficulty = errors.New("invalid difficulty")

	fixDifficulty = big.NewInt(1)
)

type MSIG struct {
	config     *params.ChainConfig // Consensus engine configuration parameters
	db         ethdb.Database      // Database to store and retrieve snapshot checkpoints
	blockchain *core.BlockChain
	txpool     *core.TxPool

	pm *ProtocolManager

	signer common.Address // Ethereum address of the signing key
}

func New(config *params.ChainConfig, db ethdb.Database) *MSIG {
	conf := *config

	multisig := &MSIG{
		config: &conf,
		db:     db,
	}
	return multisig
}

func (m *MSIG) SetupProtocolManager(chainConfig *params.ChainConfig, networkId uint64, mux *event.TypeMux, txpool *core.TxPool, blockchain *core.BlockChain, chainDb ethdb.Database, multisigDb ethdb.Database, vmConfig vm.Config, validators []common.Address, privateKeyHex string, etherbase common.Address, allowEmpty bool, byzantineMode int) error {
	var err error
	privkey, _ := crypto.HexToECDSA(privateKeyHex)
	// addr := crypto.ToECDSAPub(crypto.FromECDSA(privkey))
	m.signer = crypto.PubkeyToAddress(privkey.PublicKey)
	m.blockchain = blockchain
	m.txpool = txpool
	if m.pm, err = NewProtocolManager(chainConfig, networkId, mux, txpool, blockchain, chainDb, multisigDb, vmConfig, validators, privateKeyHex, etherbase, allowEmpty, byzantineMode); err != nil {
		return err
	}
	return nil
}

func (m *MSIG) Start() {
	m.pm.Start()
}

func (m *MSIG) Author(header *types.Header) (common.Address, error) {
	return header.Coinbase, nil
}

func (m *MSIG) VerifyHeader(chain consensus.ChainReader, header *types.Header, seal bool) error {
	// Short circuit if the header is known, or it's parent not
	number := header.Number.Uint64()
	if chain.GetHeader(header.Hash(), number) != nil {
		return nil
	}
	parent := chain.GetHeader(header.ParentHash, number-1)
	if parent == nil {
		return consensus.ErrUnknownAncestor
	}
	return m.verifyHeader(chain, header)
}

func (m *MSIG) VerifyHeaders(chain consensus.ChainReader, headers []*types.Header, seals []bool) (chan<- struct{}, <-chan error) {
	abort := make(chan struct{})
	results := make(chan error, len(headers))

	go func() {
		for _, header := range headers {
			err := b.verifyHeader(chain, header)
			select {
			case <-abort:
				return
			case results <- err:
			}
		}
	}()
	return abort, results
}

func (m *MSIG) verifyHeader(chain consensus.ChainReader, header *types.Header) error {
	if header.Time.Cmp(big.NewInt(time.Now().Unix())) > 0 {
		return consensus.ErrFutureBlock
	}
	number := header.Number.Uint64()

	if number > 0 {
		if header.Difficulty == nil || header.Difficulty.Cmp(fixDifficulty) != 0 {
			return errInvalidDifficulty
		}
	}
	return b.verifySeal(chain, header)
}

func (m *MSIG) VerifyUncles(chain consensus.ChainReader, block *types.Block) error {
	if len(block.Uncles()) > 0 {
		return errors.New("uncles not allowed")
	}
	return nil
}

func (m *MSIG) VerifySeal(chain consensus.ChainReader, header *types.Header) error {
	return m.verifySeal(chain, header)
}

func (m *MSIG) verifySeal(chain consensus.ChainReader, header *types.Header) error {
	if err := b.pm.consensusManager.verifyVotes(header); err != nil {
		log.Error("verifySeal failed", "err", err)
		return err
	}

	return nil
}

func (m *MSIG) Prepare(chain consensus.ChainReader, header *types.Header) error {
	header.Difficulty = fixDifficulty
	header.Coinbase = m.signer
	return nil
}

func (b *BFT) Finalize(chain consensus.ChainReader, header *types.Header, state *state.StateDB, txs []*types.Transaction, uncles []*types.Header, receipts []*types.Receipt) (*types.Block, error) {

	header.Root = state.IntermediateRoot(chain.Config().IsEIP158(header.Number))
	header.UncleHash = types.CalcUncleHash(nil)

	return types.NewBlock(header, txs, nil, receipts), nil
}

func (m *MSIG) Seal(chain consensus.ChainReader, block *types.Block, stop <-chan struct{}) (*types.Block, error) {
	// start voting mechanism
	log.Info("Sealing", "block n", block.Number(), "txs", len(block.Transactions()))
	abort := make(chan struct{})
	found := make(chan *types.Block)

	go m.pm.consensusManager.Process(block, abort, found)
	var result *types.Block

	select {
	case <-stop:
		log.Info("stop by outside", "height", block.Number())
		close(abort)
		return nil, nil
	case result = <-found:
		log.Info("have a consensus on the block")
		close(abort)
	}
	if result.Header().Coinbase != m.signer {
		// delay := time.Duration(rand.Intn(5)+6) * 500 * time.Millisecond
		// select {
		// case <-stop:
		// 	return nil, nil
		// case <-time.After(delay):
		// }
		return nil, nil
	}
	return result, nil
}

func (m *MSIG) APIs(chain consensus.ChainReader) []rpc.API {
	return []rpc.API{{
		Namespace: "multisig",
		Version:   "1.0",
		Service:   &API{chain: chain, multisig: m},
		Public:    false,
	}}
}

func (m *MSIG) Protocols() []p2p.Protocol {
	return m.pm.SubProtocols
}
