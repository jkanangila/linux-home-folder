from utils.constants.const import BASE_DIR
from utils.dataclass.steps import (
    Command,
    InstallDirective,
    InstallSteps,
)


def get_nvm() -> InstallSteps:
    return InstallSteps(
        package="nvm",
        install_directives=[
            InstallDirective(
                distro="default",
                dependencies=["curl"],
                source="https://github.com/nvm-sh/nvm#install--update-script",
                steps=[
                    Command(
                        echo="",
                        command=f"bash {BASE_DIR / 'scripts' / 'sh' / 'install-nvm.sh'}",
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
