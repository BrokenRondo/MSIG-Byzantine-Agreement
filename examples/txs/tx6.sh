../build/bin/geth --exec 'personal.unlockAccount("0x9d2ef6da20c9f0246a226155917a28f3dd7d1433","1234",10000)' attach ipc:./data/node6/geth.ipc
../build/bin/geth --exec 'eth.sendTransaction({from:"0x9d2ef6da20c9f0246a226155917a28f3dd7d1433", to:"c8d1bc936217e50d72b06b9dfc6d0006e8414d22", value: 55})' attach ipc:./data/node6/geth.ipc
