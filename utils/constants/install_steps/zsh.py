from utils.dataclass.steps import (
    InstallDirective,
    InstallSteps,
    Command,
)


def get_zsh(
    install: str, home: str, base_dir: str
) -> InstallSteps:
    config_src = f"{base_dir}/.config/zsh"
    config_dest = f"{home}/.config"
    zshrc = f"{base_dir}/.zshrc"
    
    return InstallSteps(
        package="zsh",
        install_directives=[
            InstallDirective(
                distro="default",
                dependencies=[],
                source="",
                steps=[
                    Command(
                        echo="Install zsh",
                        command=f"{install} zsh",
                    )
                ],
                setup=[
                    Command(
                        echo="Create config directory",
                        command=f"mkdir -p {config_dest}",
                    ),
                    Command(
                        echo="Copy config folder",
                        command=f"cp -r {config_src} {config_dest}",
                    ),
                    Command(
                        echo="Copy zshrc",
                        command=f"cp {zshrc} {home}",
                    ),
                    Command(
                        echo="Run `source ~/.zshrc~",
                        command=""
                    )
                ],
            )
        ],
    )