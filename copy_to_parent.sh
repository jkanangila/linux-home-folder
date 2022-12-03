#!/bin/sh

# FILES
NVIM="$HOME"/.config/nvim
ZSH="$HOME"/.config/zsh
SCRIPTS="$HOME"/scripts
IMAGE="$HOME"/nvim-appimage

cd $HOME/linux-home-folder
mkdir -p $HOME/.config
mkdir -p $NVIM && yes | cp -r .config/nvim $NVIM
echo "copied vim config"
mkdir -p $ZSH && yes | cp -r .config/zsh $ZSH
echo "copied zsh config"
mkdir -p $SCRIPTS && yes | cp -r scripts $SCRIPTS
echo "copied scripts"
mkdir -p $IMAGE && yes | cp nvim.appimage $IMAGE
echo "copied nvim.appimage"
