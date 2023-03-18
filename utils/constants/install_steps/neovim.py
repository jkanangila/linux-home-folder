from utils.dataclass.steps import (
    Command,
    InstallDirective,
    InstallSteps,
)


def get_neovim(
    install: str,
    home: str,
    base_dir: str,
    distro: str,
) -> InstallSteps:
    return InstallSteps(
        package="neovim",
        short_name="nvim",
        install_directives=[
            InstallDirective(
                distro="android",
                dependencies=["curl"],
                source="https://dev.to/oscarjeremiasdev/how-to-configure-neovim-from-scratch-in-termux-24gl",
                steps=[
                    Command(
                        echo="Install neovim",
                        command=f"{install} neovim",
                    )
                ],
                setup=[
                    Command(
                        echo="Clear directory if present",
                        command=f"rm -rf {home}/.config/nvim",
                    ),
                    Command(
                        echo="Create config directory",
                        command=f"mkdir -p {home}/.config/nvim",
                    ),
                    Command(
                        echo="Copy config",
                        command=f"cp -R {base_dir}/.config/nvim/{distro}/. {home}/.config/nvim",
                    ),
                    Command(
                        echo="",
                        command=f"cat {home}/.config/nvim/README.txt",
                    ),
                ],
            ),
            InstallDirective(
                distro="default",
                dependencies=[],
                source="",
                steps=[
                    Command(
                        echo="Install neovim",
                        command=f"{install} neovim",
                    )
                ],
                setup=[],
            ),
        ],
    )
