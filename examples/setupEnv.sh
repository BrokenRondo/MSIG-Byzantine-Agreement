./stop.sh
./init.sh
rm ./log/*.log
cp ./keys/UTC--2018-01-11T15-19-37.897561446Z--8510ef1f05fa2c0698fc1c93a4cad683465d17b5 ./data/node1/keystore
cp ./keys/UTC--2018-01-11T15-20-14.905594216Z--5b52a95f0f47f7b58a5b4c092d12ae8953838526 ./data/node2/keystore
cp ./keys/UTC--2018-01-11T15-20-19.976269950Z--c8d1bc936217e50d72b06b9dfc6d0006e8414d22 ./data/node3/keystore
cp ./keys/UTC--2018-01-11T15-20-21.593534625Z--3ead0b0987220b828ec40c44ac23fbccfec9ffb4 ./data/node4/keystore

cp ./keys/UTC--2018-03-02T04-04-34.746963912Z--3aa5a8c5bc7a160c3363ebbdd9c0b5e3f6badafe ./data/node5/keystore
cp ./keys/UTC--2018-03-02T04-04-44.116691094Z--9d2ef6da20c9f0246a226155917a28f3dd7d1433 ./data/node6/keystore
cp ./keys/UTC--2018-03-02T04-04-46.460421373Z--7b009dfe9f050b72e9f42c910ae9c94bf390b4be ./data/node7/keystore
cp ./keys/UTC--2018-03-02T04-04-48.339003631Z--59b002a654f625996d79ba85b07bdd97e091c2c5 ./data/node8/keystore

cp ./static-nodes.json ./data/node1
cp ./static-nodes.json ./data/node2
cp ./static-nodes.json ./data/node3
cp ./static-nodes.json ./data/node4
cp ./static-nodes.json ./data/node5
cp ./static-nodes.json ./data/node6
cp ./static-nodes.json ./data/node7
cp ./static-nodes.json ./data/node8

# start the nodes1 to node4 and connect each others 
rm node*.sh
cp nodeCofig/8nodes/*.sh ./
./start.sh
