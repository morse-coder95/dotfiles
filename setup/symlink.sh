#! /bin/bash
mkdir -p ~/.config/nvim
mkdir -p ~/.local/
mkdir -p ~/.local/bin
mkdir -p ~/.ssh/
ln -sf ~/dotfiles/dots/bashrc ~/.bashrc
ln -sf ~/dotfiles/dots/tmux.conf ~/.tmux.conf
ln -sf ~/dotfiles/dots/inputrc ~/.inputrc
ln -sf ~/dotfiles/dots/init.lua ~/.config/nvim/init.lua
ln -sf ~/dotfiles/nvim ~/.local/bin/nvim
