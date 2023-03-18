#!/usr/bin/env bash

# -------------------------- Source functions files -------------------------- #
. "scripts/sh/functions"

# ------------------------------- Install Ruby ------------------------------- #
CHECK=$(isinstalled gem)
if [ ! $CHECK ]; then
    echo "Intalling ruby gem..."
    if [[ $INSTALL == "apt-get install" ]] || [[ $INSTALL == "apt install" ]]; then
        sudo $INSTALL ruby-full
    elif [[ $INSTALL == "yum install" ]] || [[ $INSTALL == "pacman -S" ]]; then
        sudo $INSTALL ruby
    elif [[ $INSTALL == "brew install" ]] || [[ $INSTALL == "pkg install" ]] || [[ $INSTALL == "choco install " ]]; then
        $INSTALL ruby
    fi
fi

# ------------------------------ Install colorls ----------------------------- #
gem install colorls
