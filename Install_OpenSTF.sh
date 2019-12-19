#!/bin/bash

#Prevent Subshell (for source)
if [[ $_ != $0 ]]
then
	echo "Starting instalation of OpenSTF"
else
	echo "Script is a subshell - please run the script by invoking \". Install_OpenSTF.sh\" command";
	exit 1;
fi

#Install Dependencies
mkdir ~/tmp

##Install ADB
sudo apt purge -y adb fastboot
sudo add-apt-repository universe
sudo apt update
sudo apt -y install android-tools-adb android-tools-fastboot

##Install RethinkDB
sudo apt purge -y rethinkdb
source /etc/lsb-release && echo "deb http://download.rethinkdb.com/apt $DISTRIB_CODENAME main" | sudo tee /etc/apt/sources.list.d/rethinkdb.list
wget -qO- https://download.rethinkdb.com/apt/pubkey.gpg | sudo apt-key add -
sudo apt update
sudo apt -y install rethinkdb

sudo cp /etc/rethinkdb/default.conf.sample /etc/rethinkdb/instances.d/openSTF.conf
sudo service rethinkdb restart

##Install ZeroMQ
wget https://github.com/zeromq/libzmq/releases/download/v4.3.2/zeromq-4.3.2.tar.gz
tar xvzf zeromq-4.3.2.tar.gz
sudo apt-get update
sudo apt-get install -y libtool pkg-config build-essential autoconf automake uuid-dev
cd zeromq-4.3.2
./configure
sudo make install
sudo ldconfig

##Install Protocol Buffers
cd ~/tmp
sudo apt -y install build-essential autoconf automake libtool curl
git clone https://github.com/protocolbuffers/protobuf.git
cd protobuf
git submodule update --init --recursive
./autogen.sh
./configure
make
sudo make install
sudo ldconfig

##Install Yasm
cd ~/tmp
sudo apt -y install cmake
git clone https://github.com/yasm/yasm.git
cd yasm
mkdir build && cd build
cmake ../
make
sudo make install
sudo ldconfig

##Install pkg-config
cd ~/tmp
git clone https://gitlab.freedesktop.org/pkg-config/pkg-config
cd pkg-config
./autogen.sh
./configure --with-internal-glib
make
sudo make install
sudo ldconfig

cd ~/
sudo rm -rf ~/tmp

#Install NodeJS v8
sudo apt -y install curl
curl -sL https://deb.nodesource.com/setup_8.x | sudo -E bash -
sudo apt install -y --allow-downgrades nodejs=8.17.0-1nodesource1

#Configure NPM
mkdir -p ~/.npm-global
npm config set prefix '~/.npm-global'
echo "export PATH=~/.npm-global/bin:\$PATH" >> ~/.profile
source ~/.profile

#Install OpenSTF
npm install -g stf

#Create shortcut to start OpenSTF
echo "stf local -t 9999999" > ~/start_stf.sh
chmod +x ~/start_stf.sh
