from utils.constants.install_steps_map import (
    INSTALL_STEPS_MAP,
    distro,
)
from utils.shell import (
    is_installed,
    execute_command,
)
from utils.constants.install_steps_map import (
    install_directive,
)
from .setup_script import Setup


class Install(object):
    def __init__(
        self, package: str, setup: bool
    ):
        self.package = package
        self.setup = setup
        self.should_setup = setup

        if self.should_setup:
            self.setup = Setup(package)

    def run(self):
        (
            self.steps,
            self.short_name,
        ) = self.get_install_directive(
            self.package
        )

        if self.already_installed():
            return

        self.check_dependencies()
        self.install_package(self.steps)

        if self.should_setup:
            self.setup.run()

    def install_package(self, steps: list):
        for step in steps["steps"]:
            print(step["echo"])
            execute_command(step["command"])

    def get_install_directive(self, package):
        try:
            steps = INSTALL_STEPS_MAP[
                package
            ][distro]
            short_name = INSTALL_STEPS_MAP[
                package
            ]["short_name"]

        except KeyError:
            try:
                steps = INSTALL_STEPS_MAP[
                    package
                ]["default"]
            except KeyError:
                raise KeyError(
                    f"There are no install directive for package {package}"
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
            if not is_installed(dep):
                print(
                    f"Could not locate {dep}. Attempting to install"
                )
                try:
                    steps = self.get_install_directive(
                        dep
                    )
                    self.install_package(
                        steps
                    )
                except KeyError:
                    execute_command(
                        f"{install_directive} {dep}"
                    )
                print(
                    f"Successfuly installed {dep}"
                )
