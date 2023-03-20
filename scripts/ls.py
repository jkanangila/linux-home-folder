from utils.constants.install_steps import (
    INSTALL_INSTRUCTIONS_MAP,
)
from utils.shell import execute_command_shell


class List(object):
    def run(self):
        print(
            ", ".join(
                INSTALL_INSTRUCTIONS_MAP.keys()
            )
        )
