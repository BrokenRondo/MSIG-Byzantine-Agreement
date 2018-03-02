../build/bin/geth --exec 'personal.unlockAccount("0x3aa5a8c5bc7a160c3363ebbdd9c0b5e3f6badafe","1234",10000)' attach ipc:./data/node5/geth.ipc
../build/bin/geth --exec 'eth.sendTransaction({from:"0x3aa5a8c5bc7a160c3363ebbdd9c0b5e3f6badafe", to:"0x5b52a95f0f47f7b58a5b4c092d12ae8953838526", value: 74})' attach ipc:./data/node5/geth.ipc
