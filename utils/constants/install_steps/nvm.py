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
                distro="default",
                dependencies=["curl"],
                source="https://github.com/nvm-sh/nvm#install--update-script",
                steps=[
                    Command(
                        echo="Download install script",
                        command="curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.3/install.sh | bash",
                
                    ),
                    # Command(
                    #     echo="Install nvm",
                    #     command="bash install.sh",
                        
                    # )
                ],
                setup=[
                    Command(
                        echo="",
                        command=f"echo {post_install}",
                        
                    ),
                ],
            )
        ],
    )


post_install = """Successfuly installed nvm
    
    * Run `python main.py setup zsh`: to copy over zsh config folder;
    * Navigate to `~/.config/zsh/zsh-exports` and uncomment everything under nvm
"""
