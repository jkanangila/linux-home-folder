from utils.dataclass.steps import Command, InstallDirective, InstallSteps


def get_pyenv(
) -> InstallSteps:

    return InstallSteps(
        package="pyenv",
        install_directives=[
            InstallDirective(
                distro="default",
                dependencies=["https://github.com/pyenv/pyenv-installer"],
                source="",
                steps=[
                    Command(
                        echo="",
                        command="curl https://pyenv.run | bash"
                    )
                ],
                setup=[
                    Command(
                        echo="Restart your shell for the changes to take effect",
                        command=""
                    )
                ],
            )
        ],
    )