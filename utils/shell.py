import sys
from shlex import split
from shutil import which
from subprocess import PIPE, Popen, call, run

import distro

from .constants.const import PlatformOptions
from .constants.package_manager_map import (
    PACKAGE_MANAGER_MAP,
)


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


def execute_command(cmd: str):
    if cmd:
        command = split(cmd)
        Popen(
            command, stdout=PIPE
        ).communicate()


def execute_command_shell(cmd: str):
    if cmd:
        run(
            cmd,
            shell=True,
            check=True,
        )


def is_installed(name: str) -> bool:
    return which(name) is not None
