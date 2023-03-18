#!/usr/bin/env bash

# -------------------------- Source functions files -------------------------- #
. "scripts/sh/functions"

# ---------------------------------------------------------------------------- #
echo f"Installing zsh..."
CHECK=$(isinstalled zsh)
[ ! $CHECK ] && sudo $INSTALL zsh

# ---------------------------------------------------------------------------- #
echo "Creating config directory..."
mkdir -p $CONFIG_DEST

# ---------------------------------------------------------------------------- #
echo "Copying zsh config folder..."
cp -r $CONFIG_SRC $CONFIG_DEST

# ---------------------------------------------------------------------------- #
echo "Copying .zshrc file..."
cp $ZSHRC $HOME
