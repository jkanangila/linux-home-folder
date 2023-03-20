from utils.constants.const import BASE_DIR
from utils.dataclass.steps import (
    Command,
    InstallDirective,
    InstallSteps,
)


def get_git_ssh() -> InstallSteps:
    return InstallSteps(
        package="git_ssh",
        short_name="",
        install_directives=[
            InstallDirective(
                distro="default",
                dependencies=["git"],
                source="",
                steps=[],
                setup=[
                    Command(
                        echo=f"",
                        command=f"bash {BASE_DIR / 'scripts' / 'sh' / 'setup-ssh-git.sh'}",
                    ),
                ],
            ),
        ],
    )
