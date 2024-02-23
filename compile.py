import os
import shutil
from socket import gethostname

from jinja2 import Environment, FileSystemLoader

from util import Host, configure_logging


DOTFILES_ROOT = os.path.expanduser("~/dotfiles/dots/")
SUBMODULES = os.path.join(DOTFILES_ROOT, "submodules")
COMPILED = os.path.join(DOTFILES_ROOT, "compiled")


log = configure_logging()


def clean_compiled_dir():
    if os.path.isdir(COMPILED):
        shutil.rmtree(COMPILED)


def get_host_type():
    host = gethostname()
    return {
        "chlc-nmor01.etc.cboe.net": Host.Work,
        "lxlc-nmor02.etc.cboe.net": Host.Work,
        "morsecodingmachine": Host.Home,
    }[host].value


class ConfigFile:
    def __init__(self, template_file, destination_file, symlink_path):
        self.template_file = template_file
        self.destination_file = destination_file
        self.symlink_path = symlink_path

        self.template_path = os.path.join(DOTFILES_ROOT, "templates/", self.template_file)
        self.output_path = os.path.join(DOTFILES_ROOT, "compiled/", self.destination_file)


FILES = [
    ConfigFile("tmux.conf", "tmux.conf", "~/.tmux.conf"),
    ConfigFile("init.lua", "init.lua", "~/.config/nvim/init.lua"),
    ConfigFile("bashrc", "bashrc", "~/.bashrc"),
]


def get_template_object(config_file):
    target_dir = os.path.dirname(config_file.template_path)
    loader = FileSystemLoader(target_dir)
    with open(config_file.template_path) as fl:
        return Environment(
            loader=loader,
            trim_blocks=True,
            lstrip_blocks=True,
        ).from_string(fl.read())


def render_target(host_type, config_file):
    output_dir = os.path.dirname(config_file.output_path)
    if not os.path.isdir(output_dir):
        os.makedirs(output_dir)

    template_obj = get_template_object(config_file)
    with open(config_file.output_path, "w", encoding="utf-8") as f:
        f.write(template_obj.render({"HOST": host_type}))


def compile_config_file(host_type, config_file):
    log.info(f"Compiling {config_file.template_path} to {config_file.output_path}")
    render_target(host_type, config_file)


def create_symlink(target, link_path):
    link_path = os.path.expanduser(link_path)
    log.info(f"Creating symlink to {target} at {link_path}")
    if os.path.islink(link_path):
        log.info("Symlink already exists")
        return
    if os.path.isfile(link_path):
        os.remove(link_path)
    os.symlink(target, link_path)


def main():
    clean_compiled_dir()
    host_type = get_host_type()
    log.info(f"Compiling configs for {host_type} machine")
    for config_file in FILES:
        compile_config_file(host_type, config_file)
        create_symlink(config_file.output_path, config_file.symlink_path)


if __name__ == "__main__":
    main()
