#!/bin/bash

mkdir -p ~/tmp
cd ~/tmp
wget https://github.com/zeromq/libzmq/releases/download/v4.3.2/zeromq-4.3.2.tar.gz
tar xvzf zeromq-4.3.2.tar.gz
sudo apt-get update && \
sudo apt-get install -y libtool pkg-config build-essential autoconf automake uuid-dev
cd zeromq-4.3.2
./configure
sudo make install
sudo ldconfig

cd ~/
sudo rm -rf ~/tmp

sudo apt update
sudo apt -y install libzmq3-dev

#Install OpenSTF
npm install -g stf

sudo rm  ~/start_stf.sh

echo "stf local -t 9999999" > ~/start_stf.sh
chmod +x ~/start_stf.sh
