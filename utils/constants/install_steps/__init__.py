from utils.shell import (
    get_distro_name,
    get_install_directive,
)
from utils.constants.const import (
    USER_HOME,
    BASE_DIR,
)
from .neovim import get_neovim
from .nvm import get_nvm

distro = get_distro_name()
directive = get_install_directive(distro)

INSTALL_INSTRUCTIONS_MAP = {
    "neovim": get_neovim(
        install=directive,
        home=USER_HOME,
        base_dir=BASE_DIR,
        distro=distro,
    ),
    "nvm": get_nvm(),
}
