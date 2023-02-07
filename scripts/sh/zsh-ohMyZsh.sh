#!/usr/bin/bash

cd ~

echo "#######
# ZSH #
#######"
if ! package="$(type -p "zsh")" || [[ -z $package ]];
then
    # Modify package manager accordignly
    sudo apt install zsh
else
  echo "zsh is already installed. Moving on..."
fi


echo "###########
# OhMyZsh #
###########"
if ! [[ -d "/home/${USER}/.oh-my-zsh" ]];
then
    curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh | sh; zsh
    # Set zsh as your default shell
    sudo usermod --shell $(which zsh) $USER
else
    echo "oh-my-zsh is already installed. Updating it to the latest version"
    #omz update # TODO update
fi