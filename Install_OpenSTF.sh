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
sudo apt update
sudo apt -y install adb fastboot

##Install RethinkDB
source /etc/lsb-release && echo "deb http://download.rethinkdb.com/apt $DISTRIB_CODENAME main" | sudo tee /etc/apt/sources.list.d/rethinkdb.list
wget -qO- https://download.rethinkdb.com/apt/pubkey.gpg | sudo apt-key add -
sudo apt update
sudo apt -y install rethinkdb

sudo cp /etc/rethinkdb/default.conf.sample /etc/rethinkdb/instances.d/openSTF.conf

##Install ZeroMQ
sudo su -c "echo 'deb http://download.opensuse.org/repositories/network:/messaging:/zeromq:/release-stable/Debian_9.0/ ./' >> /etc/apt/sources.list"
wget https://download.opensuse.org/repositories/network:/messaging:/zeromq:/release-stable/Debian_9.0/Release.key -O- | sudo apt-key add
sudo apt update
sudo apt -y install libzmq3-dev

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
git clone git://github.com/yasm/yasm.git
cd yasm
mkdir build && cd build
cmake ../
make
sudo make install
sudo ldconfig

##Install pkg-config
cd ~/tmp
git clone git://anongit.freedesktop.org/pkg-config
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
sudo apt -y install nodejs npm

#Configure NPM
mkdir ~/.npm-global
npm config set prefix '~/.npm-global'
echo "export PATH=~/.npm-global/bin:\$PATH" >> ~/.profile
source ~/.profile

#Install OpenSTF
npm install -g stf

#Create shortcut to start OpenSTF
echo "stf local -t 9999999" > ~/start_stf.sh
chmod +x ~/start_stf.sh
