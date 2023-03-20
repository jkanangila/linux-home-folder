from utils.constants.const import BASE_DIR
from utils.dataclass.steps import (
    Command,
    InstallDirective,
    InstallSteps,
)


def get_code_commit_ssh() -> InstallSteps:
    return InstallSteps(
        package="code_commit_ssh",
        short_name="",
        install_directives=[
            InstallDirective(
                distro="default",
                dependencies=[],
                source="",
                steps=[
                    Command(
                        echo=f"",
                        command=f"bash {BASE_DIR / 'scripts' / 'sh' / 'setup-ssh-aws-codecommit.sh'}",
                    ),
                ],
                setup=[
                    Command(
                        echo=f"",
                        command=f"bash {BASE_DIR / 'scripts' / 'sh' / 'setup-ssh-aws-codecommit.sh'}",
                    ),
                ],
            ),
        ],
    )
