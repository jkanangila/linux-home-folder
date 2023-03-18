from utils.constants.const import BASE_DIR
from utils.dataclass.steps import (
    Command,
    InstallDirective,
    InstallSteps,
)


def get_colorls(
    install: str,
) -> InstallSteps:

    return InstallSteps(
        package="colorls",
        install_directives=[
            InstallDirective(
                distro="default",
                dependencies=[],
                source="https://github.com/athityakumar/colorls",
                steps=[
                    Command(
                        echo="",
                        command=(
                            f"export INSTALL={install} && "
                            + f"bash {BASE_DIR / 'scripts' / 'sh' / 'install-colorls.sh'}"
                        ),
                    )
                ],
                setup=[],
            )
        ],
    )
