#!/usr/bin/bash

# ------------------------- Source external functions ------------------------ #
. "scripts/sh/functions"

# --------------------------------- Variables -------------------------------- #
PRIVATE_KEY="$HOME/.ssh/id_ed25519"
PUBLIC_KEY="$HOME/.ssh/id_ed25519.pub"

CONFIG_FILE="$HOME/.ssh/config"
CONFIG_TEXT="
Host *
    AddKeysToAgent yes
    IdentityFile $PRIVATE_KEY"

# --------------------------------- Functions -------------------------------- #
function generate_ssh_key() {
    echo "Generating key file..."
    ssh-keygen -t ed25519 -C jkanangila@gmail.com -N "" -f "$PRIVATE_KEY"
}

function echo_post_install() {
    SSH_KEY=$(cat $PUBLIC_KEY)

    echo "
    Complete the setup

    1. Open the following link in your browser: https://github.com/settings/ssh/new
    2. Enter a meaningfull name in the 'Title' field
    3. Past the following text in the 'Key' field:
        $SSH_KEY
    4. Click: Add SSH key
    "
}

# ----------------------------------- MAIN ----------------------------------- #
if [ -f $PRIVATE_KEY ] && [ -f $PUBLIC_KEY ]; then
    echo_post_install
else
    generate_ssh_key

    add_key_to_ssh_agent $CONFIG_TEXT $PRIVATE_KEY

    echo_post_install
fi
