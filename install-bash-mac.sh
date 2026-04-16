#!/usr/bin/env bash

set -eu

# copy .bash_profile and .bashrc to home directory.
# if exists, backup them to .bash_profile.bak and .bashrc.bak
# and then copy .bash_profile and .bashrc from this repository.
if [ -f ~/.bash_profile ]; then
    mv -f ~/.bash_profile ~/.bash_profile.bak
fi
cp -f ./mac/.bash_profile ~/.bash_profile

if [ -f ~/.bashrc ]; then
    mv -f ~/.bashrc ~/.bashrc.bak
fi
cp -f ./mac/.bashrc ~/.bashrc

echo "Installed .bash_profile and .bashrc to home directory."
exit 0
