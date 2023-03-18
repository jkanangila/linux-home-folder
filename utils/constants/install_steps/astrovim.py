from utils.constants.const import BASE_DIR
from utils.dataclass.steps import (
    Command,
    InstallDirective,
    InstallSteps,
)


def get_astrovim() -> InstallSteps:
    return InstallSteps(
        package="astrovim",
        short_name="",
        install_directives=[
            InstallDirective(
                distro="default",
                dependencies=[
                    "git",
                    "clang",
                    "lua-language-server",
                ],
                source="Astrovim docs",
                steps=[
                    Command(
                        echo="",
                        command=f"bash {BASE_DIR / 'scripts' / 'sh' / 'install-astrovim.sh'}",
                    ),
                ],
                setup=[
                    Command(
                        echo=post_install,
                        command="",
                    ),
                ],
            ),
        ],
    )


post_install = """
    * 'nvim +PackerSync | install pluggins'
    * ':TSIntall <language_to_install>' | instal syntax highlighting with Treesiter
    * ':LspInstall' | choose language server
"""
