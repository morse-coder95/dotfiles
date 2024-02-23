#! /bin/bash

mkdir -p ~/apps/neovim/ && cd ~/apps/neovim

if [ -f "nvim.appimage" ]; then
    rm nvim.appimage
fi

wget https://github.com/neovim/neovim/releases/download/stable/nvim.appimage
chmod u+x nvim.appimage
