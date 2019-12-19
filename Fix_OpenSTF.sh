#!/bin/bash

mkdir -p ~/tmp
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

sudo apt-get purge -y nodejs npm
sudo apt-get autoremove -y
sudo apt install -y --allow-downgrades nodejs=8.17.0-1nodesource1

mkdir -p ~/.npm-global
npm config set prefix '~/.npm-global'
echo "export PATH=~/.npm-global/bin:\$PATH" >> ~/.profile
source ~/.profile

#Install OpenSTF
npm install -g stf

sudo rm  ~/start_stf.sh

echo "stf local -t 9999999" > ~/start_stf.sh
chmod +x ~/start_stf.sh
