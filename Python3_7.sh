#!/bin/bash
#
# ----------------------------------------------------------------------------
#
# version of:
# https://gist.githubusercontent.com/SeppPenner/6a5a30ebc8f79936fa136c524417761d/raw/3060da171c0653daac52b17e1598919a0ecb17e6/setup.sh
#
PY_VER=3.7.2
cd /tmp
sudo apt update
sudo apt upgrade
sudo apt install gcc python3-dev python3-pip libxml2-dev libxslt1-dev zlib1g-dev g++
sudo apt-get update -y
sudo apt-get install build-essential tk-dev libncurses5-dev libncursesw5-dev libreadline6-dev libdb5.3-dev libgdbm-dev libsqlite3-dev libssl-dev libbz2-dev libexpat1-dev liblzma-dev zlib1g-dev libffi-dev -y
wget https://www.python.org/ftp/python/${PY_VER}/Python-${PY_VER}.tar.xz
tar xf Python-${PY_VER}.tar.xz
cd Python-${PY_VER}
./configure
make -j 4
sudo make altinstall
cd ..
sudo rm -r Python-${PY_VER}
rm Python-${PY_VER}.tar.xz
sudo apt-get --purge remove build-essential tk-dev libncurses5-dev libncursesw5-dev libreadline6-dev libdb5.3-dev libgdbm-dev libsqlite3-dev libssl-dev libbz2-dev libexpat1-dev liblzma-dev zlib1g-dev libffi-dev -y
sudo apt-get autoremove -y
sudo apt-get clean
#
sudo python3.7 -m pip install --upgrade pip
#
sudo apt update
sudo apt upgrade
sudo apt install gcc python3-dev python3-pip libxml2-dev libxslt1-dev zlib1g-dev g++
#
sudo python3.7 -m pip install gpiozero
sudo python3.7 -m pip install rpi.gpio
sudo python3.7 -m pip install pigpio
sudo python3.7 -m pip install RPIO
#
sudo python3.7 -m pip install pyodbc
#
cd ~
echo "now use python3.7 command to use this version."
#
