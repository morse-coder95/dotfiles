import os
import shutil
import stat
from io import open
from socket import gethostname
from pathlib import Path

from jinja2 import Environment, FileSystemLoader

from config import CONFIGS
from util import Host, configure_logging

DOTFILES_ROOT = os.path.dirname(os.path.realpath(__file__))
SUBMODULES = os.path.join(DOTFILES_ROOT, "submodules")
COMPILED = os.path.join(DOTFILES_ROOT, "compiled")


try:
    from bunch import Bunch
except ImportError:
    from ecn.util.bunch import Bunch


log = configure_logging()


def get_host():
    host = gethostname()
    log.info(f"Building configuration files for {host}")
    return {"morsecodingmachine": Host.Home, "lxlc-nmor02.etc.cboe.net": Host.Work, "kclc-nmor01.etc.cboe.net": Host.Work}[
        host
    ]


def get_task():
    host = Host(get_host())
    return Bunch(
        host=host,
        targets=CONFIGS[host],
    )


def get_template_object(target_file):
    target_dir = os.path.dirname(target_file.template_path)
    loader = FileSystemLoader(target_dir)
    with open(target_file.template_path) as fl:
        return Environment(
            loader=loader,
            trim_blocks=True,
            lstrip_blocks=True,
        ).from_string(fl.read())


def make_executable(path):
    st = os.stat(path)
    os.chmod(path, st.st_mode | stat.S_IEXEC)


def render_target(host, config_file):
    log.info(f"Building {config_file.output_path} from {config_file.template_path}")
    if config_file.copy_only:
        shutil.copy(config_file.template_path, config_file.output_path)
        return

    template_obj = get_template_object(config_file)

    output_dir = os.path.dirname(config_file.output_path)
    if not os.path.isdir(output_dir):
        os.makedirs(output_dir)

    with open(config_file.output_path, "w", encoding="utf-8") as fl:
        fl.write(
            template_obj.render(
                {
                    "HOST": host.value,
                    "DOTFILES": DOTFILES_ROOT,
                    "SUBMODULES": SUBMODULES,
                }
            )
        )

    if config_file.executable:
        make_executable(config_file.output_path)


def clean_compiled_dir():
    if os.path.isdir(COMPILED):
        shutil.rmtree(COMPILED)


def create_symlink(target, link_name):
    link_path = os.path.join(Path.home(), link_name)
    log.info(f"Creating symlink to {target} at {link_path}")
    if os.path.islink(link_path):
        log.info("Symlink already exists")
        return
    if os.path.isfile(link_path):
        os.remove(link_path)
    os.symlink(target, link_path)


def main():
    clean_compiled_dir()
    task = get_task()
    for target_class in task.targets:
        log.info(f"Processing {target_class.name} config")
        target = target_class(DOTFILES_ROOT)
        for config_file in target:
            render_target(task.host, config_file)
            if config_file.symlink_path is not None:
                create_symlink(config_file.output_path, config_file.symlink_path)


if __name__ == "__main__":
    main()
