#! /bin/bash
mkdir -p ~/.config/nvim
mkdir -p ~/.config/nvim/UltiSnips
mkdir -p ~/.local/
mkdir -p ~/.local/bin
ln -sf ~/dotfiles/dots/bashrc ~/.bashrc
ln -sf ~/dotfiles/dots/tmux.conf ~/.tmux.conf
ln -sf ~/dotfiles/dots/inputrc ~/.inputrc
ln -sf ~/dotfiles/dots/init.lua ~/.config/nvim/init.lua
ln -sf ~/dotfiles/dots/psqlrc ~/.psqlrc
ln -sf ~/dotfiles/dots/python.snippets ~/.config/nvim/UltiSnips/python.snippets
ln -sf ~/dotfiles/dots/sql.snippets ~/.config/nvim/UltiSnips/sql.snippets
ln -sf ~/dotfiles/nvim ~/.local/bin/nvim
ln -sf ~/dotfiles/envstat.py ~/.local/bin/envstat.py
