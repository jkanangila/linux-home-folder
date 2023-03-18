from utils.dataclass.steps import (
    Command,
    InstallDirective,
    InstallSteps,
)


def get_node(install: str) -> InstallSteps:
    return InstallSteps(
        package="node",
        install_directives=[
            InstallDirective(
                distro="android",
                dependencies=[],
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
                dependencies=[],
                source="https://github.com/nvm-sh/nvm#install--update-script",
                steps=[
                    Command(
                        echo="Installing node",
                        command=f"nvm install node --lts",
                    ),
                    Command(
                        echo="Installing yarn",
                        command="npm i -g yarn",
                    ),
                ],
                setup=[
                    Command(
                        echo="Setting default node version",
                        command=f"nvm use --lts",
                    )
                ],
            ),
        ],
    )
