from ..shell import (
    get_distro_name,
    get_install_directive,
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
                "is_installed('curl')",
            ],
            "steps": [
                {
                    "echo": "Install neovim",
                    "command": f"{install_directive} neovim",
                },
                {
                    "echo": "Install Plug-vim",
                    "command": [
                        "sh",
                        "-c",
                        "curl",
                        "-fLo",
                        '"${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim',
                        "--create-dirs",
                        "https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim",
                    ],
                },
            ],
            "source": "https://dev.to/oscarjeremiasdev/how-to-configure-neovim-from-scratch-in-termux-24gl",
        },
    }
}
