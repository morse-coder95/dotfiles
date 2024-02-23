#! /bin/bash

mkdir -p ~/.virtualenvs && cd ~/.virtualenvs
python3 -m venv nvim
source ~/.virtualenvs/nvim/bin/activate
pip install pynvim python-lsp-server pyls-flake8 black==22.10.0 isort
