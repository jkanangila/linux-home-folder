from utils.dataclass.steps import (
    Command,
    InstallDirective,
    InstallSteps,
)


def get_neovim(
    install: str,
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
                setup=[],
            ),
            InstallDirective(
                distro="default",
                dependencies=[],
                source="",
                steps=[
                    Command(
                        echo="Install neovim",
                        command=f"sudo {install} neovim",
                    )
                ],
                setup=[],
            ),
        ],
    )
