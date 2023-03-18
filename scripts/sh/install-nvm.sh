#!/usr/bin/env bash

echo "Download install script"
curl -o ~/install.sh https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.3/install.sh

echo "Install nvm"
bash ~/install.sh

echo "Delete install script"
rm ~/install.sh
