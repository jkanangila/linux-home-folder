from ..shell import (
    get_distro_name,
    get_install_directive,
)
from utils.constants.const import (
    USER_HOME,
    BASE_DIR,
)

distro = get_distro_name()
install_directive = get_install_directive(
    distro
)

INSTALL_STEPS_MAP = {
    "neovim": {
        "short_name": "nvim",
        "android": {
            "dependencies": [
                "curl",
            ],
            "steps": [
                {
                    "echo": "Install neovim",
                    "command": f"{install_directive} neovim",
                }
            ],
            "setup": [
                {
                    "echo": "Clear directory if present",
                    "command": f"rm -rf {USER_HOME}/.config/nvim",
                },
                {
                    "echo": "Create config directory",
                    "command": f"mkdir -p {USER_HOME}/.config/nvim",
                },
                {
                    "echo": "Copy config",
                    "command": f"cp -R {BASE_DIR}/.config/nvim/{distro}/. {USER_HOME}/.config/nvim",
                },
                {
                    "echo": "",
                    "command": f"cat {USER_HOME}/.config/nvim/README.txt",
                },
            ],
            "source": "https://dev.to/oscarjeremiasdev/how-to-configure-neovim-from-scratch-in-termux-24gl",
        },
    }
}
