from utils.constants.const import BASE_DIR
from utils.dataclass.steps import (
    Command,
    InstallDirective,
    InstallSteps,
)


def get_zsh(
    install: str, home: str, base_dir: str
) -> InstallSteps:
    config_src = f"{base_dir}/.config/zsh"
    config_dest = f"{home}/.config"
    zshrc = f"{base_dir}/.zshrc"

    return InstallSteps(
        package="zsh",
        install_directives=[
            InstallDirective(
                distro="default",
                dependencies=[],
                source="",
                steps=[
                    Command(
                        echo=f"",
                        command=(
                            f"export INSTALL={install} && "
                            + f"export CONFIG_DEST={config_dest} && "
                            + f"export CONFIG_SRC={config_src} && "
                            + f"export ZSHRC={zshrc} && "
                            + f"bash {BASE_DIR / 'scripts' / 'sh' / 'install-zsh.sh'}"
                        ),
                    ),
                ],
                setup=[
                    Command(
                        echo=f"",
                        command=(
                            f"export INSTALL={install} && "
                            + f"export CONFIG_DEST={config_dest} && "
                            + f"export CONFIG_SRC={config_src} && "
                            + f"export ZSHRC={zshrc} && "
                            + f"bash {BASE_DIR / 'scripts' / 'sh' / 'install-zsh.sh'}"
                        ),
                    ),
                    Command(
                        echo=post_install,
                        command="",
                    ),
                ],
            )
        ],
    )


post_install = """
POST INSTALL
1. Run `sudo usermod --shell $(which zsh) $USER` to make zsh the default shell
2. Remember to change your terminal font to a powerline font after sourcing the `,zshrc` file
"""
