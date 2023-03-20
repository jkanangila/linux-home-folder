from utils.constants.const import (
    BASE_DIR,
    USER_HOME,
)
from utils.shell import (
    get_distro_name,
    get_install_directive,
)

from .astrovim import get_astrovim
from .code_commit_ssh import (
    get_code_commit_ssh,
)
from .colorls import get_colorls
from .git_ssh import get_git_ssh
from .neovim import get_neovim
from .node import get_node
from .nvm import get_nvm
from .pyenv import get_pyenv
from .zsh import get_zsh

distro = get_distro_name()
directive = get_install_directive(distro)

INSTALL_INSTRUCTIONS_MAP = {
    "astrovim": get_astrovim(),
    "code_commit_ssh": get_code_commit_ssh(),
    "colorls": get_colorls(
        install=directive
    ),
    "git_ssh": get_git_ssh(),
    "neovim": get_neovim(install=directive),
    "nvm": get_nvm(),
    "node": get_node(install=directive),
    "pyenv": get_pyenv(),
    "zsh": get_zsh(
        install=directive,
        home=USER_HOME,
        base_dir=BASE_DIR,
    ),
}
