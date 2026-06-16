#!/usr/bin/bash

# ---------------------------------------------------------------------------- #
#                           Source external functions                          #
# ---------------------------------------------------------------------------- #
. "scripts/sh/functions"

# ---------------------------------------------------------------------------- #
#                                   Variables                                  #
# ---------------------------------------------------------------------------- #
PRIVATE_KEY="$HOME/.ssh/codecommit_rsa"
PUBLIC_KEY="$HOME/.ssh/codecommit_rsa.pub"
POST_INSTAL="
More info available at: https://docs.aws.amazon.com/codecommit/latest/userguide/setting-up-ssh-windows.html"

# ---------------------------------------------------------------------------- #
#                                   Functions                                  #
# ---------------------------------------------------------------------------- #
generate_key_file() {
    ssh-keygen -N "" -f $PRIVATE_KEY
}

add_ssh_key_to_aws_iam() {
    local -r KEY_CONTENT=$(cat $PUBLIC_KEY)

    echo "SET-UP INSTRUCTIONS

1. Sign in to the AWS Management Console and open the IAM console at https://console.aws.amazon.com/iam/
2. In the IAM console, in the navigation pane, choose Users, and from the list of users, choose your IAM user.
3. On the user details page, choose the Security Credentials tab, and then choose Upload SSH public key.
4. Paste the following into the field, and then choose Upload SSH public key.
    $KEY_CONTENT
5. Copy or save the information in SSH Key ID
"

    read -p "Enter the AWS_SSH_KEY_ID copied in step 5: " AWS_SSH_KEY_ID
}

make_config_text() {
    local -r HOST='git-codecommit.*.amazonaws.com'

    CONFIG_TEXT="

Host $HOST
  User $AWS_SSH_KEY_ID
  IdentityFile $PRIVATE_KEY"
}

# ---------------------------------------------------------------------------- #
#                                     MAIN                                     #
# ---------------------------------------------------------------------------- #
if [ -f $PRIVATE_KEY ] && [ -f $PUBLIC_KEY ]; then
    echo $POST_INSTAL
else
    generate_key_file

    add_ssh_key_to_aws_iam

    make_config_text

    add_key_to_ssh_agent $CONFIG_TEXT $PRIVATE_KEY

    echo $POST_INSTAL
fi
# ---------------------------------------------------------------------------- #
