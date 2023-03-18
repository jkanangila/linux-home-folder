#!/usr/bin/env bash

# install pip if it's not present
if ! package="$(type -p "pip3")" || [[ -z $package ]]; 
then
  sudo apt install python3-pip
fi

cd ~

# kivymd
pip3 install kivymd

# buildozer
pip3 install --user --upgrade buildozer

git clone https://github.com/kivy/buildozer

cd buildozer

python setup.py build

sudo pip install -e .

# buildozer android dependecies
sudo apt install -y git zip unzip python3-pip autoconf libtool pkg-config zlib1g-dev libncurses5-dev libncursesw5-dev libtinfo5 cmake libffi-dev libssl-dev libpq-dev
pip3 install --user --upgrade Cython==0.29.19 virtualenv  # the --user should be removed if you do this in a venv

# add the following line at the end of your ~/.bashrc file
# export PATH=$PATH:~/.local/bin/
