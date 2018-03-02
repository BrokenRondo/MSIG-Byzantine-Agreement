# start adding txs into txpool of node2
echo "==================start to send the txs to node2 from client===================="
start=$(($(date +%s%N)/1000000)) 
for ((i=0;i<1000;i=i+1))
do
	(./txs/tx2.sh &)
	sleep 1.1;
done
endCli=$(($(date +%s%N)/1000000))
echo "sending tx from client cost: $(($endCli-$start)) ms"


