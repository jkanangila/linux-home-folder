#!/usr/bin/env bash

# ------------------------- Check `nvm` installation ------------------------- #
NVM_DIR="$HOME/.nvm"
if [ -s "$NVM_DIR/nvm.sh" ]; then
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
    [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
else
    echo "It appears Nvm is not installed. Please install it and then execute this script."
    exit 1
fi

# ----------------------- Get verstion input from user ----------------------- #
echo "Retrieving node versions from external sources..."
VERSION_LIST=$(nvm ls-remote)

echo $VERSION_LIST
read -p "Which version would you like to install? The default is the latest lts version: " NODE_VERSION
NODE_VERSION=${NODE_VERSION:-"--lts"}

# ------------------------------ Install node js ----------------------------- #
echo "Installing node",
nvm install node $NODE_VERSION

echo "Setting default node version"
nvm use $NODE_VERSION

# ------------------------------- Install yarn ------------------------------- #
read -p "Do you want to add yarn to your install as well? [y/yes]: " INSTALL_YARN

if [ $INSTALL_YARN == "y" ] || [ $INSTALL_YARN == "yes" ]; then
    echo "Installing yarn..."
    npm i -g yarn
else
    exit 1
fi
