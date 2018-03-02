../build/bin/geth --exec 'personal.unlockAccount("0x3ead0b0987220b828ec40c44ac23fbccfec9ffb4","1234",10000)' attach ipc:./data/node4/geth.ipc
../build/bin/geth --exec 'eth.sendTransaction({from:"0x3ead0b0987220b828ec40c44ac23fbccfec9ffb4", to:"0xc8d1bc936217e50d72b06b9dfc6d0006e8414d22", value: 50})' attach ipc:./data/node4/geth.ipc
