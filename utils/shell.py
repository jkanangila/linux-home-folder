from shutil import which
import subprocess
import sys
from .constants.const import PlatformOptions

from .constants.package_manager_map import (
    PACKAGE_MANAGER_MAP,
)
import distro


def get_distro_name() -> str:
    if hasattr(sys, "getandroidapilevel"):
        return "android"
    if (
        sys.platform
        == PlatformOptions.LINUX.value
    ):
        return distro.id()


def get_install_directive(
    distro_name: str,
) -> str:
    return PACKAGE_MANAGER_MAP[distro_name][
        "install_directive"
    ]


def execute_command(cmd):
    if type(cmd) == str:
        subprocess.run(
            cmd.split(" "), check=True
        )
    if type(cmd) == list:
        subprocess.run(cmd, check=True)


def is_installed(name: str) -> bool:
    return which(name) is not None
