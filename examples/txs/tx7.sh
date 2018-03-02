../build/bin/geth --exec 'personal.unlockAccount("0x7b009dfe9f050b72e9f42c910ae9c94bf390b4be","1234",10000)' attach ipc:./data/node7/geth.ipc
../build/bin/geth --exec 'eth.sendTransaction({from:"0x7b009dfe9f050b72e9f42c910ae9c94bf390b4be", to:"0x5b52a95f0f47f7b58a5b4c092d12ae8953838526", value: 44})' attach ipc:./data/node7/geth.ipc
