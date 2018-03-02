../build/bin/geth --exec 'personal.unlockAccount("0x8510ef1f05fa2c0698fc1c93a4cad683465d17b5","1234",10000)' attach ipc:./data/node1/geth.ipc
../build/bin/geth --exec 'eth.sendTransaction({from:"0x8510ef1f05fa2c0698fc1c93a4cad683465d17b5", to:"0x5b52a95f0f47f7b58a5b4c092d12ae8953838526", value: 66})' attach ipc:./data/node1/geth.ipc

