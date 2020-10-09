from util import Git, Neovim, Bashrc, Tmux, Host, Inputrc

# __BASE_CONFIG = {Git, Neovim, PythonDev, Tmux, Inputrc}
__BASE_CONFIG = {Neovim, Tmux, Bashrc}

CONFIGS = {
    Host.Home: __BASE_CONFIG,
    Host.Work: __BASE_CONFIG,
}
