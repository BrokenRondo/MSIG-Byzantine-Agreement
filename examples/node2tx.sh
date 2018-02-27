# start adding txs into txpool of node2
echo "==================start to send the txs to node2 from client===================="
start=$(($(date +%s%N)/1000000)) 
for ((i=0;i<200;i=i+1))
do
	../build/bin/geth --exec 'personal.unlockAccount("0x5b52a95f0f47f7b58a5b4c092d12ae8953838526","1234",10000)' attach ipc:./data/node2/geth.ipc
	../build/bin/geth --exec 'eth.sendTransaction({from:"5b52a95f0f47f7b58a5b4c092d12ae8953838526", to:"c8d1bc936217e50d72b06b9dfc6d0006e8414d22", value: 55})' attach ipc:./data/node2/geth.ipc
done
endCli=$(($(date +%s%N)/1000000))
echo "sending tx from client cost: $(($endCli-$start)) ms"


