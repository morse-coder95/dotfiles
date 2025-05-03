import logging
import os
from enum import Enum


def configure_logging():
    log = logging.getLogger()
    log.setLevel(logging.INFO)
    handler = logging.StreamHandler()
    formatter = logging.Formatter("%(asctime)s | %(levelname)s | %(message)s ")
    handler.setFormatter(formatter)
    log.addHandler(handler)
    return log


class Host(Enum):
    Home = "home"
    Work = "work"


# class ConfigFile(object):
    # def __init__(
        # self, template_file, destination_file, symlink_path=None, executable=False, copy_only=False
    # ):
        # self.template_file = template_file
        # self.destination_file = destination_file
        # self.symlink_path = symlink_path
        # self.executable = executable
        # self.dotfiles_root = None
        # self.name = None
        # self.copy_only = copy_only

    # @property
    # def template_path(self):
        # return os.path.join(
            # self.dotfiles_root,
            # "templates",
            # self.name,
            # self.template_file,
        # )

    # @property
    # def output_path(self):
        # return os.path.join(
            # self.dotfiles_root,
            # "compiled",
            # self.name,
            # self.destination_file,
        # )


# class Config(object):
    # name = None
    # files = []

    # def __init__(self, dotfiles_root):
        # self.dotfiles_root = dotfiles_root

    # def __iter__(self):
        # self.index = 0
        # return self

    # def __next(self):
        # if not self.files:
            # raise StopIteration

        # if self.index >= len(self.files):
            # raise StopIteration

        # val = self.files[self.index]
        # self.index += 1
        # val.dotfiles_root = self.dotfiles_root
        # val.name = self.name
        # return val

    # def __next__(self):
        # return self.__next()

    # def next(self):
        # return self.__next()


# class Neovim(Config):
    # name = "neovim"
    # files = [
        # ConfigFile("init.lua", ".config/nvim/init.lua", symlink_path=".config/nvim/init.lua"),
        # ConfigFile(
            # "python-snippets.conf",
            # ".config/nvim/UltiSnips/python.snippets",
            # symlink_path=".config/nvim/UltiSnips/python.snippets",
        # ),
        # ConfigFile("sql-snippets.conf", ".config/nvim/UltiSnips/sql.snippets"),
    # ]


# class Tmux(Config):
    # name = "tmux"
    # files = [
        # ConfigFile("tmux.conf", ".tmux.conf", symlink_path=".tmux.conf"),
    # ]


# class Git(Config):
    # name = "git-config"
    # files = [
        # ConfigFile("gitconfig.conf", ".gitconfig", symlink_path=".gitconfig"),
    # ]


# class Inputrc(Config):
    # name = "inputrc"
    # files = [ConfigFile("inputrc", ".inputrc", symlink_path=".inputrc")]


# class Bashrc(Config):
    # name = "bashrc"
    # files = [ConfigFile("bashrc", ".bashrc", symlink_path=".bashrc")]
