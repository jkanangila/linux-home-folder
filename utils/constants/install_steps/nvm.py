from utils.dataclass.steps import (
    InstallDirective,
    InstallSteps,
    Command,
)


def get_nvm() -> InstallSteps:
    return InstallSteps(
        package="nvm",
        install_directives=[
            InstallDirective(
                disto="default",
                dependencies=["curl"],
                source="https://github.com/nvm-sh/nvm#install--update-script",
                steps=[
                    Command(
                        echo="Install nvm",
                        command=[
                            "curl",
                            "-o-",
                            "'https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.3/install.sh'",
                            "|",
                            "bash",
                        ],
                    )
                ],
                setup=[
                    Command(
                        echo="",
                        command=[
                            "echo",
                            post_install,
                        ],
                    ),
                ],
            )
        ],
    )


post_install = """Successfuly installed nvm
    
    * Run `python main.py setup zsh`: to copy over zsh config folder;
    * Navigate to `~/.config/zsh/zsh-exports` and uncomment everything under nvm
"""
