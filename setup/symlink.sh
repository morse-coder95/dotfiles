#! /bin/bash
mkdir -p ~/.config/nvim
mkdir -p ~/.config/nvim/UltiSnips
mkdir -p ~/.local/
mkdir -p ~/.local/bin
ln -sf ~/dotfiles/dots/compiled/bashrc ~/.bashrc
ln -sf ~/dotfiles/dots/compiled/tmux.conf ~/.tmux.conf
ln -sf ~/dotfiles/dots/compiled/inputrc ~/.inputrc
ln -sf ~/dotfiles/dots/compiled/init.lua ~/.config/nvim/init.lua
ln -sf ~/dotfiles/dots/compiled/psqlrc ~/.psqlrc
ln -sf ~/dotfiles/dots/compiled/python.snippets ~/.config/nvim/UltiSnips/python.snippets
ln -sf ~/dotfiles/dots/compiled/sql.snippets ~/.config/nvim/UltiSnips/sql.snippets
ln -sf ~/apps/neovim/nvim.appimage ~/.local/bin/nvim

