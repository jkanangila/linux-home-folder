#!/usr/bin/env bash

# -------------------------- Source functions files -------------------------- #
. "scripts/sh/functions"

# ----------------------------- install astrovim ----------------------------- #
CHECK=$(isinstalled nvim)
if [ $CHECK ]; then
    echo "Copying your current installation files for safekeeping."
    [ -d ~/.config/nvim ] && mv ~/.config/nvim ~/.config/nvim.backup
    [ -d ~/.local/share/nvim ] && mv ~/.local/share/nvim ~/.local/share/nvim.backup

    echo "Cloning Astrovim repo"
    git clone https://github.com/AstroNvim/AstroNvim ~/.config/nvim
else
    echo "It appears Neovim is not installed. Please install it and then execute this script."
    exit 1
fi
# ---------------------------------------------------------------------------- #
