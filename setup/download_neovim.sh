#! /bin/bash

mkdir -p ~/apps/neovim/ && cd ~/apps/neovim

rm *appimage* 2>/dev/null

APPIMAGE="nvim-linux-x86_64.appimage"
wget https://github.com/neovim/neovim/releases/download/v0.11.1/$APPIMAGE
chmod u+x $APPIMAGE
mv $APPIMAGE nvim.appimage
