#!/bin/bash
#Install srsLTE LandoNet
mkdir ~/tmp

#Install dependencies
sudo apt -y install build-essential cmake libfftw3-dev libmbedtls-dev libboost-program-options-dev libconfig++-dev libsctp-dev uhd-host libuhd003 libuhd-dev

#Install GCC-7 & G++-7
sudo apt -y install software-properties-common
sudo add-apt-repository -y ppa:ubuntu-toolchain-r/test
sudo apt update
sudo apt -y install g++-7

sudo update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-7 60 --slave /usr/bin/g++ g++ /usr/bin/g++-7 
sudo update-alternatives --config gcc

#Download, build and install Pistache
cd ~/tmp
git clone https://github.com/oktal/pistache.git
cd pistache
git submodule update --init
mkdir build
cd build
cmake -G "Unix Makefiles" -DCMAKE_BUILD_TYPE=Release ../
make
sudo make install
sudo ldconfig

cd ~/
sudo rm -rf ~/tmp

#Download and build srsLTE
cd ~/
git clone https://gitlab.com/futebol/srsLTE_LandoNet.git
cd srsLTE_LandoNet
mkdir build
cd build
cmake ../
make

#Install srsLTE
sudo make install
sudo srslte_install_configs.sh service
sudo ldconfig

#List USRPs
sudo uhd_find_devices
