from util import Git, Neovim, Bashrc, Tmux, Host, Inputrc

__BASE_CONFIG = {Neovim, Tmux, Bashrc, Inputrc}

CONFIGS = {
    Host.Home: __BASE_CONFIG,
    Host.Work: __BASE_CONFIG,
}
