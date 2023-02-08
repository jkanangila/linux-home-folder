from utils.dataclass.steps import (
    InstallDirective,
    InstallSteps,
    Command,
)


def get_nvm(home: str) -> InstallSteps:
    return InstallSteps(
        package="nvm",
        install_directives=[
            InstallDirective(
                distro="default",
                dependencies=["curl"],
                source="https://github.com/nvm-sh/nvm#install--update-script",
                steps=[
                    Command(
                        echo="Download install script",
                        command=f"curl -o {home}/install.sh  https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.3/install.sh",
                    ),
                    Command(
                        echo="Install nvm",
                        command=f"bash {home}/install.sh",
                    ),
                    Command(
                        echo="Delete install script",
                        command=f"rm {home}/install.sh",
                    ),
                ],
                setup=[
                    Command(
                        echo=post_install,
                        command="",
                    ),
                ],
            )
        ],
    )


post_install = """Successfuly installed nvm
    
    * Run `python main.py setup zsh`: to copy over zsh config folder;
    * Open `~/.config/zsh/zsh-exports` with your favorite editor and uncomment everything under nvm
    * Run `source ~/.zshrc`
"""
