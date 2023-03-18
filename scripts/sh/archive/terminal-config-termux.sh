#!/usr/bin/bash

echo "
##############################
# INSTALLING USEFUL PLUGGINS #
##############################"
pkg install git curl


echo "#######
# ZSH #
#######"
if ! package="$(type -p "zsh")" || [[ -z $package ]];
then
    # Modify package manager accordignly
    pkg install zsh
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
    usermod --shell $(which zsh) $USER
else
    echo "oh-my-zsh is already installed. Updating it to the latest version"
    #omz update # TODO update
fi


echo "################
# ZSH PLUGGINS #
################"
echo "installing zsh plugins"
# 1. SYNTAX HIGHLIGHTING
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

# add: zsh-syntax-highlighting to pluggin list

# 2. Autosuggestions
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions

# add: zsh-autosuggestions to pluggin list

# 3. Fuzzy finder
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf && ~/.fzf/install

# add: fzf to pluggins

echo "##############
# Nerd Fonts #
##############\n"
# TODO Fix this part
#echo "installing nerfonts"
curl https://github.com/ryanoasis/nerd-fonts/releases/download/v2.1.0/Inconsolata.zip -O -J -L

#echo "moving downloaded fonts to dir"
mkdir ~/.fonts
unzip Incosolata.zip -d ~/.fonts


echo "###############
# p10k themes #
###############\n"
echo "install p10k"
git clone --depth=1 https://github.com/romkatv/powerlevel10k $ZSH_CUSTOM/themes/powerlevel10k

# set ZSH_THEME="powerlevel10k/powerlevel10k"

echo "###########
# Colorls #
###########\n"
echo "installing colorls"
apt install ruby-full

gem install colorls

echo "##########
# NEOVIM #
##########\n"
echo "installing and configuring neovim"
apt-get install neovim

# create nvim config directory if it's not installed
if ! [[ -d "~/.config/nvim" ]];
then 
    mkdir ~/.config/nvim
fi

# My pluggin configurations from github
git clone https://github.com/jkanangila/configurations-scripts.git ~/.config/nvim

# vim-plug
curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

