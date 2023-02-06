from utils.constants.install_steps_map import (
    INSTALL_STEPS_MAP,
    distro,
)
from utils.shell import (
    is_installed,
    execute_command,
)


class Install(object):
    def __init__(self, package: str):
        self.package = package

    def run(self):
        (
            self.steps,
            self.short_name,
        ) = self.get_install_directive()

        if self.already_installed():
            return

        self.check_dependencies()
        self.install_package()

    def install_package(self):
        for step in self.steps["steps"]:
            print(step["echo"])
            execute_command(step["command"])

    def get_install_directive(self):
        try:
            steps = INSTALL_STEPS_MAP[
                self.package
            ][distro]
            short_name = INSTALL_STEPS_MAP[
                self.package
            ]["short_name"]

        except KeyError:
            raise KeyError(
                f"There are no install directive for package {self.package}"
            )

        return steps, short_name

    def already_installed(self):
        if is_installed(
            self.package
        ) or is_installed(self.short_name):
            print(
                f"{self.package} is already installed"
            )
            return True

    def check_dependencies(self):
        for dep in self.steps[
            "dependencies"
        ]:
            if not eval(dep):
                raise RuntimeErro(
                    f"A required dependency ({dep}) is not installed."
                )
