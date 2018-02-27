# initialize the blockchain and cp the default keys into node1's keystore folder
# pwd:1234
#./stop.sh
#./init.sh
#rm ./log/*.log
#cp ./keys/UTC--2018-01-11T15-19-37.897561446Z--8510ef1f05fa2c0698fc1c93a4cad683465d17b5 ./data/node1/keystore
#cp ./keys/UTC--2018-01-11T15-20-14.905594216Z--5b52a95f0f47f7b58a5b4c092d12ae8953838526 ./data/node2/keystore
#cp ./keys/UTC--2018-01-11T15-20-19.976269950Z--c8d1bc936217e50d72b06b9dfc6d0006e8414d22 ./data/node3/keystore
#cp ./keys/UTC--2018-01-11T15-20-21.593534625Z--3ead0b0987220b828ec40c44ac23fbccfec9ffb4 ./data/node4/keystore
#cp ./static-nodes.json ./data/node1
#cp ./static-nodes.json ./data/node2
#cp ./static-nodes.json ./data/node3
#cp ./static-nodes.json ./data/node4

# start the nodes1 to node4 and connect each others 
#./start.sh

# start adding txs into txpool
echo "==================start to send the txs from client===================="
start=$(($(date +%s%N)/1000000)) 
nohup ./node1tx.sh &> log/preloadtx1.log &
sleep 0.3;
nohup ./node2tx.sh &> log/preloadtx2.log &
sleep 0.3;
nohup ./node3tx.sh &> log/preloadtx3.log &
sleep 0.3;
./node4tx.sh > log/preloadtx4.log
endCli=$(($(date +%s%N)/1000000))
echo "sending tx from client cost: $(($endCli-$start)) ms"

# start to exec the consensus mechanism
echo "==================start to exec the consensus mechanism=================="
./run-miner.sh
end=$(($(date +%s%N)/1000000))
echo "exec txs in geth cost: $(($end-$endCli)) ms"
