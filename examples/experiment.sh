# initialize the blockchain and cp the default keys into node1's keystore folder
# pwd:1234
./init.sh
cp ./keys/* ./data/node1/keystore
cp ./static-nodes.json ./data/node1
cp ./static-nodes.json ./data/node2
cp ./static-nodes.json ./data/node3
cp ./static-nodes.json ./data/node4

# start the nodes1 to node4 and connect each others 
./start.sh
