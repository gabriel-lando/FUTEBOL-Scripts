#!/bin/bash

sudo apt-get purge -y nodejs npm
sudo apt-get autoremove -y
sudo apt -y install curl
curl -sL https://deb.nodesource.com/setup_8.x | sudo -E bash -
sudo apt install -y --allow-downgrades nodejs=8.17.0-1nodesource1

sudo rm -rf ~/.npm-global
mkdir -p ~/.npm-global
npm config set prefix '~/.npm-global'
echo "export PATH=~/.npm-global/bin:\$PATH" >> ~/.profile
source ~/.profile

#Install OpenSTF
npm install -g stf

sudo rm  ~/start_stf.sh

echo "stf local -t 9999999" > ~/start_stf.sh
chmod +x ~/start_stf.sh
