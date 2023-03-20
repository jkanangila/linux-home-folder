#!/usr/bin/bash

# ------------------------- Source external functions ------------------------ #
. "scripts/sh/functions"

# --------------------------------- Variables -------------------------------- #
PRIVATE_KEY="$HOME/.ssh/codecommit_rsa"
PUBLIC_KEY="$HOME/.ssh/codecommit_rsa"

CONFIG_FILE="$HOME/.ssh/config"
CONFIG_TEXT="
Host git-codecommit.*.amazonaws.com
  User APKAEIBAERJR2EXAMPLE
  IdentityFile $PRIVATE_KEY"

# --------------------------------- Functions -------------------------------- #
generate_key_file() {
    ssh-keygen -N "" -f $PRIVATE_KEY
}

add_key_to_aws_instructions() {
    local -r KEY_CONTENT=$(cat $PUBLIC_KEY)

    echo "SET-UP INSTRUCTIONS

1. Sign in to the AWS Management Console and open the IAM console at https://console.aws.amazon.com/iam/
2. In the IAM console, in the navigation pane, choose Users, and from the list of users, choose your IAM user.
3. On the user details page, choose the Security Credentials tab, and then choose Upload SSH public key.
4. Paste the following into the field, and then choose Upload SSH public key.
    $KEY_CONTENT
5. Copy or save the information in SSH Key ID
"

    read -p "Enter your AWS_SSH_KEY_ID (Get it from your IAM console): " AWS_SSH_KEY_ID
}
