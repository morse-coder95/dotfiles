#! /bin/bash

echo "Reloading bashrc..."
. ~/.bashrc

echo "Sourcing tmux conf..."
tmux source-file ~/.tmux.conf

echo "Installing FZF..."
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install

echo "Downloading git completion..."
curl https://raw.githubusercontent.com/git/git/master/contrib/completion/git-completion.bash -o ~/.git-completion.bash

echo "Downloading neovim..."
~/dotfiles/setup/./download_neovim.sh

echo "Creating virtual environment..."
~/dotfiles/setup/./create_virtualenv.sh

echo "Creating symlinks..."
~/dotfiles/setup/./symlink.sh


echo -e "Done! Make sure to run the following in neovim:\n\t:PlugInstall\n\t:TSInstall lua python\n\t:UpdateRemotePlugins"
