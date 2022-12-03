#!/bin/sh

# FILES
NVIM="$HOME"/.config/nvim
ZSH="$HOME"/.config/zsh
SCRIPTS="$HOME"/scripts
IMAGE="$HOME"/nvim-appimage

mkdir -p $HOME/.config
mkdir -p $NVIM && yes | cp -r .config/nvim $NVIM
mkdir -p $ZSH && yes | cp -r .config/zsh $ZSH
mkdir -p $SCRIPTS && yes | cp -r scripts $SCRIPTS
mkdir -p $IMAGE && yes | cp nvim.appimage $IMAGE