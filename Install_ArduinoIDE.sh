#!/bin/bash

# Install dependencies
echo "Installing dependencies..."
sudo apt update > /dev/null 2>&1
sudo apt install -y git tar wget > /dev/null 2>&1

# Get latest version of Arduino IDE
cd ~
git init ArduinoIDE_TMP > /dev/null 2>&1
cd ArduinoIDE_TMP
git remote add origin https://github.com/arduino/Arduino.git > /dev/null 2>&1

VERSION=$(git ls-remote -q --tags --refs | grep --regexp='refs/tags/[0-9][0-9]*\.[0-9][0-9]*\.[0-9][0-9]*.*' | tail -1 | cut -d '/' -f 3)

cd ..
rm -rf ArduinoIDE_TMP

echo "Starting installation of Arduino IDE $VERSION..."

# Discovering CPU Architecture
CPU_ARCH=$(dpkg --print-architecture)

if [ "$CPU_ARCH" == "amd64" ];then
	ARDUINO="arduino-$VERSION-linux64.tar.xz"
elif [ "$CPU_ARCH" == "i386" ];then
	ARDUINO="arduino-$VERSION-linux32.tar.xz"
elif [ "$CPU_ARCH" == "armhf" ];then
	ARDUINO="arduino-$VERSION-linuxarm.tar.xz"
else
	echo "CPU Architecture not found!";
	exit 1;
fi

# Remove old versions
echo "Removing old versions..."
sudo apt purge -y arduino > /dev/null 2>&1
sudo rm -rf /opt/arduino-* > /dev/null 2>&1
sudo rm /usr/local/bin/arduino > /dev/null 2>&1

# Download new version
echo 'Downloading Arduino IDE...'
cd /opt
sudo wget https://downloads.arduino.cc/$ARDUINO -O $ARDUINO > /dev/null 2>&1

echo 'Uncompressing Arduino IDE...'
sudo tar xJf $ARDUINO --overwrite > /dev/null 2>&1 

echo 'Installing Arduino IDE...'
cd arduino-$VERSION/
sudo ./install.sh > /dev/null 2>&1 
sudo rm ../$ARDUINO

sudo usermod -aG dialout $USER
sudo ldconfig

echo 'Starting Arduino IDE...'
cd ~
sudo arduino &
