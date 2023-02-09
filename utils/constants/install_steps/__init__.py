from utils.constants.const import BASE_DIR, USER_HOME
from utils.shell import get_distro_name, get_install_directive

from .astrovim import get_astrovim
from .neovim import get_neovim
from .node import get_node
from .nvm import get_nvm
from .pyenv import get_pyenv
from .zsh import get_zsh

distro = get_distro_name()
directive = get_install_directive(distro)

INSTALL_INSTRUCTIONS_MAP = {
    "astrovim": get_astrovim(home=USER_HOME,),
    "neovim": get_neovim(
        install=directive,
        home=USER_HOME,
        base_dir=BASE_DIR,
        distro=distro,
    ),
    "nvm": get_nvm(
        home=USER_HOME,
    ),
    "node": get_node(install=directive,),
    "pyenv": get_pyenv(),
    "zsh": get_zsh(
        install=directive,
        home=USER_HOME,
        base_dir=BASE_DIR,
    )
}
