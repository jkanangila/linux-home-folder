#!/usr/bin/bash

# ------------------------------ Define varibles ----------------------------- #
export NVM_DIR="$HOME/.nvm"
# load nvm
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
# load nvm bash_completion
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

echo "Installing node",
nvm install node --lts

echo "Setting default node version"
nvm use --lts

echo "Installing yarn"
npm i -g yarn
