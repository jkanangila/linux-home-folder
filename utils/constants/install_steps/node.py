from utils.constants.const import BASE_DIR
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
                        echo="",
                        command=f"bash {BASE_DIR / 'scripts' / 'sh' / 'nvm-install-node.sh'}",
                    ),
                ],
                setup=[],
            ),
        ],
    )
