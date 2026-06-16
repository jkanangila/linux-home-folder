#!/usr/bin/env bash

# Install guest additions on linux. 
# RUN THIS FROM GUEST-OS i.e. INSIDE YOUR VIRTUAL MACHINE
# Tutorial-source: https://daylifetips.com/install-virtualbox-guest-additions-on-pop-os/

echo "installing build essantial for guest additions"

sudo apt install build-essential dkms linux-headers-$(uname -r)

sudo adduser $USER vboxsf

echo "
 -------------------------------------------------------------------------------------------------------
| On virtualbox's menubar' --> click on 'Devices menu' --> then choose 'insert guest addtions CD Image' |
 -------------------------------------------------------------------------------------------------------
 "

echo "
 ---------------------------------------------------------------------------
| to enable shared clipboard, run: 'sudo apt install virtualbox-guest-dkms' |
 ---------------------------------------------------------------------------
 "

echo "Restart GuestOS after this"
