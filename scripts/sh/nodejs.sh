#!/usr/bin/bash

echo "########
# JAVA #
########"
echo "Installing JDK"
sudo apt install default-jdk

echo "Installing JRE"
sudo apt install default-jre

java --version
javac --version


echo "##########
# NODEJS #
##########\n"
# requires terminal restart

# curl -fsSL https://fnm.vercel.app/install | bash
curl -sL https://raw.githubusercontent.com/creationix/nvm/v0.35.3/install.sh -o install_nvm.sh

bash install_nvm.sh

# List all nodejs versions available
# fnm list-remote
nvm ls-remote

echo "\nSpecify a version to install from the list above. (e.g. v12.4.0): "

# user specified version
read VERSION

# install version specified by user
# fnm install $VERSION
nvm install $VERSION
# fnm use $VERSION
nvm use $VERSION

# verify installation
node -v
npm -v

########
# YARN #
########
npm i -g yarn
