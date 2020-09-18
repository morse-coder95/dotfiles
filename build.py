import os
import stat
from io import open
import shutil

from jinja2 import Environment, FileSystemLoader
from config import CONFIGS
from util import configure_logging, Host

DOTFILES_ROOT = os.path.dirname(os.path.realpath(__file__))
SUBMODULES = os.path.join(DOTFILES_ROOT, 'submodules')
COMPILED = os.path.join(DOTFILES_ROOT, 'compiled')


try:
    from pathlib import Path
except ImportError:
    from pathlib2 import Path

try:
    from bunch import Bunch
except ImportError:
    from ecn.util.bunch import Bunch


log = configure_logging()


def get_host():
    hostfile = Path.home() / '.config' / 'build_target'
    with open(str(hostfile)) as fl:
        return fl.readlines()[0].rstrip()


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


def render_target(host, target_file):
    if target_file.copy_only:
        shutil.copy(target_file.template_path, target_file.output_path)
        return

    template_obj = get_template_object(target_file)

    output_dir = os.path.dirname(target_file.output_path)
    if not os.path.isdir(output_dir):
        os.makedirs(output_dir)

    with open(target_file.output_path, 'w', encoding='utf-8') as fl:
        fl.write(template_obj.render({
            'HOST': host.value,
            'DOTFILES': DOTFILES_ROOT,
            'SUBMODULES': SUBMODULES,
        }))

    if target_file.executable:
        make_executable(target_file.output_path)


def clean_compiled_dir():
    if os.path.isdir(COMPILED):
        shutil.rmtree(COMPILED)


def main():
    clean_compiled_dir()
    task = get_task()
    for target_class in task.targets:
        target = target_class(DOTFILES_ROOT)
        for fl in target:
            render_target(task.host, fl)


if __name__ == '__main__':
    main()
