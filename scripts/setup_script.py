from utils.constants.install_steps_map import (
    INSTALL_STEPS_MAP,
    distro,
)
from utils.shell import (
    is_installed,
    execute_command,
)


class Setup(object):
    def __init__(self, package: str):
        self.package = package

    def run(self):
        (
            self.steps
        ) = self.get_install_directive()

        self.setup_package()

    def setup_package(self):
        for step in self.steps["setup"]:
            print(step["echo"])
            execute_command(step["command"])

    def get_install_directive(self):
        try:
            steps = INSTALL_STEPS_MAP[
                self.package
            ][distro]

        except KeyError:
            raise KeyError(
                f"There are no install directive for package {self.package}"
            )

        return steps
