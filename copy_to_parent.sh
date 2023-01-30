#!/bin/sh

# FILES
CONFIG="$HOME"/.config
IMAGE="$HOME"/nvim-appimage

cd $HOME/linux-home-folder
mkdir -p $HOME/.config

cp -r .config/nvim $CONFIG
echo "copied vim config"

cp -r .config/zsh $CONFIG
echo "copied zsh config"

# yes | cp -r scripts $HOME
# echo "copied scripts"

# mkdir -p $IMAGE && nvim.appimage $IMAGE
# echo "copied nvim.appimage"
