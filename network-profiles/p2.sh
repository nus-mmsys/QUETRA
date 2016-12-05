#!/bin/bash
for (( c=1; c>0; c++ ))
do

sudo tc qdisc del dev eno1 root
sudo tc qdisc add dev eno1 root handle 1:0 tbf rate 1500kbit buffer 1600 limit 3000
sudo tc qdisc add dev eno1 parent 1:0 handle 10: netem delay 100ms loss 0.12%
sleep 30s

sudo tc qdisc del dev eno1 root
sudo tc qdisc add dev eno1 root handle 1:0 tbf rate 2000kbit buffer 1600 limit 3000
sudo tc qdisc add dev eno1 parent 1:0 handle 10: netem delay 88ms loss 0.09%
sleep 30s

sudo tc qdisc del dev eno1 root
sudo tc qdisc add dev eno1 root handle 1:0 tbf rate 3000kbit buffer 1600 limit 3000
sudo tc qdisc add dev eno1 parent 1:0 handle 10: netem delay 75ms loss 0.06%
sleep 30s

sudo tc qdisc del dev eno1 root
sudo tc qdisc add dev eno1 root handle 1:0 tbf rate 4000kbit buffer 1600 limit 3000
sudo tc qdisc add dev eno1 parent 1:0 handle 10: netem delay 50ms loss 0.08%
sleep 30s

sudo tc qdisc del dev eno1 root
sudo tc qdisc add dev eno1 root handle 1:0 tbf rate 5000kbit buffer 1600 limit 3000
sudo tc qdisc add dev eno1 parent 1:0 handle 10: netem delay 38ms loss 0.09%
sleep 30s

sudo tc qdisc del dev eno1 root
sudo tc qdisc add dev eno1 root handle 1:0 tbf rate 4000kbit buffer 1600 limit 3000
sudo tc qdisc add dev eno1 parent 1:0 handle 10: netem delay 50ms loss 0.08%
sleep 30s

sudo tc qdisc del dev eno1 root
sudo tc qdisc add dev eno1 root handle 1:0 tbf rate 3000kbit buffer 1600 limit 3000
sudo tc qdisc add dev eno1 parent 1:0 handle 10: netem delay 75ms loss 0.06%
sleep 30s

sudo tc qdisc del dev eno1 root
sudo tc qdisc add dev eno1 root handle 1:0 tbf rate 2000kbit buffer 1600 limit 3000
sudo tc qdisc add dev eno1 parent 1:0 handle 10: netem delay 88ms loss 0.09%
sleep 30s

done
