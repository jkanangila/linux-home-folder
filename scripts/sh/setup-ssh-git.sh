#!/usr/bin/env bash

# ----------------------------- Define variables ----------------------------- #
CONFIG_FILE="$HOME/.ssh/config"
CONFIG_TEXT="
Host *
    AddKeysToAgent yes
    IdentityFile ~/.ssh/id_ed25519"

# ---------------------------- Generating key file --------------------------- #
echo "Generating key file..."
echo "NOTE: Press enter to save key in default location"
echo "NOTE: Password can be empty"
ssh-keygen -t ed25519 -C jkanangila@gmail.com

# ------------------------ Adding keyfile to ssh agent ----------------------- #
echo "Adding keyfile to ssh agent..."
eval "$(ssh-agent -s)"

if [ -d $CONFIG_FILE ]; then
    echo "$CONFIG_TEXT" >>$CONFIG_FILE
else
    touch $CONFIG_FILE
    echo "$CONFIG_TEXT" >>$CONFIG_FILE
fi

ssh-add ~/.ssh/id_ed25519

# ------------------------------ Complete setup ------------------------------ #
SSH_KEY=$(cat ~/.ssh/id_ed25519.pub)

echo "
Complete the setup

1. Go to your: https://github.com/settings/ssh/new
2. Enter a meaningfull name in the $(Title) field
3. Past the following text in the $(Key) field:
    $SSH_KEY
4. Click: Add SSH key
"
