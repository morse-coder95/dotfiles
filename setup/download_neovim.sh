#! /bin/bash

mkdir -p ~/.config/nvim/plugged
curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

mkdir -p ~/apps/neovim/ && cd ~/apps/neovim

rm *appimage* 2>/dev/null

APPIMAGE="nvim-linux-x86_64.appimage"
wget https://github.com/neovim/neovim/releases/download/stable/$APPIMAGE
chmod u+x $APPIMAGE
mv $APPIMAGE nvim.appimage
