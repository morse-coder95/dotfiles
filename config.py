from util import Bashrc, Git, Host, Inputrc, Neovim, Tmux

__BASE_CONFIG = {Neovim, Tmux, Bashrc, Inputrc}

CONFIGS = {
    Host.Home: (Tmux, Git, Inputrc, Bashrc, Neovim),
    Host.Work: __BASE_CONFIG,
}
