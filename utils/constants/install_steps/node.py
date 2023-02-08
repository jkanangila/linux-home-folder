from utils.dataclass.steps import (
    InstallDirective,
    InstallSteps,
    Command,
)

VERSION = "16.14.1"


# TODO make node version dynamic
def get_node(install: str) -> InstallSteps:
    return InstallSteps(
        package="node",
        install_directives=[
            InstallDirective(
                distro="android",
                dependencies=["nvm"],
                source="https://github.com/nvm-sh/nvm#install--update-script",
                steps=[
                    Command(
                        echo="Installing node",
                        command=f"{install} nodejs",
                    ),
                    Command(
                        echo="Installing yarn",
                        command="npm i -g yarn",
                    ),
                ],
            ),
            InstallDirective(
                distro="default",
                dependencies=["nvm"],
                source="https://github.com/nvm-sh/nvm#install--update-script",
                steps=[
                    Command(
                        echo="Installing node",
                        command=f"nvm install node {VERSION}",
                    ),
                    Command(
                        echo="Installing yarn",
                        command="npm i -g yarn",
                    ),
                ],
                setup=[
                    Command(
                        echo="Setting default node version",
                        command=f"nvm use {VERSION}",
                    )
                ],
            )
        ],
    )
