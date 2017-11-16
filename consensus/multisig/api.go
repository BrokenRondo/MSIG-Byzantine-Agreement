package multisig

import (
	"github.com/ethereum/go-ethereum/common"
	"github.com/ethereum/go-ethereum/consensus"
)

// API is a user facing RPC API to allow controlling the signer and voting
// mechanisms of the proof-of-authority scheme.
type API struct {
	chain consensus.ChainReader
	multisig   *MSIG
}

func (api *API) GetEtherbase() common.Address {
	return api.multisig.signer
}
