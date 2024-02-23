# Loop though and if the package is not installed, install it
APT_PACKAGES=(python-pip stow tmux neovim silversearcher-ag ranger rofi)
for pkg in "${APT_PACKAGES[@]}"
do
    echo "Checking/installing $pkg"
    dpkg -s $pkg 2>/dev/null >/dev/null || sudo apt-get -y install $pkg
done;

echo "Cloning vimplugged"
curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

# now pip isntall jinja2 to be able to build configs
echo "Installing jinja2"
pip install jinja2

# Install FZF
echo "Installing fzf"
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install

echo "Install pyenv? (y/n)"
read install_pyenv

if [ $install_pyenv = "y" ]; then
    echo "Installing pyenv"
    git clone https://github.com/pyenv/pyenv.git ~/.pyenv
    git clone https://github.com/pyenv/pyenv-virtualenv.git /home/$(whoami)/plugins/pyenv-virtualenv
else
    echo "Skipping pyenv install"
fi
