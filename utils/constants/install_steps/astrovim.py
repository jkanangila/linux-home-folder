from utils.dataclass.steps import (
    InstallDirective,
    InstallSteps,
    Command,
)


def get_astrovim(
    home: str,
) -> InstallSteps:
    return InstallSteps(
        package="astrovim",
        short_name="",
        install_directives=[
            InstallDirective(
                distro="default",
                dependencies=["git","neovim","clang","lua-language-server"],
                source="Astrovim docs",
                steps=[
                    Command(
                        echo="Backup '~/.config/nvim' directory",
                        command=f"mv {home}/.config/nvim {home}/.config/nvim.backup",
                    ),
                    Command(
                        echo="Backup '.local/share/nvim' directory",
                        command=f"mv {home}/.local/share/nvim {home}/.local/share/nvim.backup",
                    ),
                    Command(
                        echo="Clone Astrovim repo",
                        command=f"git clone https://github.com/AstroNvim/AstroNvim {home}/.config/nvim",
                    ),
                ],
                setup = [
                    Command(
                        echo=post_install,
                        command="",
                    ),
                    
                ]
            ),
        ],
    )

post_install = """
    * 'nvim +PackerSync | install pluggins'
    * ':TSIntall <language_to_install>' | instal syntax highlighting with Treesiter
    * ':LspInstall' | choose language server
"""
