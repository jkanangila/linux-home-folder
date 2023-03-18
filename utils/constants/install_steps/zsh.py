from utils.dataclass.steps import (
    Command,
    InstallDirective,
    InstallSteps,
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
                        echo=f"Installing zsh using `{install}`...",
                        command=f"{install} zsh",
                    )
                ],
                setup=[
                    Command(
                        echo="Creating config directory...",
                        command=f"mkdir -p {config_dest}",
                    ),
                    Command(
                        echo="Copying zsh config folder...",
                        command=f"cp -r {config_src} {config_dest}",
                    ),
                    Command(
                        echo="Copying .zshrc file...",
                        command=f"cp {zshrc} {home}",
                    ),
                    Command(
                        echo="Run `source ~/.zshrc`",
                        command="",
                    ),
                    Command(
                        echo="Run `sudo usermod --shell $(which zsh) $USER` to make zsh the default shell",
                        command="",
                    ),
                    Command(
                        echo="Remember to change your terminal font to a powerline font after sourcing the `,zshrc` file",
                        command="",
                    ),
                ],
            )
        ],
    )
