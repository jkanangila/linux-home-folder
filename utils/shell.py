from shutil import which
import subprocess
import sys
from utils.constants import PlatformOptions
import distro


def get_distro_name() -> str:
    if hasattr(sys, "getandroidapilevel"):
        return "android"
    if sys.platform == PlatformOptions.LINUX.value:
        return distro.id()


def get_install_directive() -> str:
    pass


def execute_command(cmd: str):
    subprocess.run(cmd.split(" "), check=True)


def is_installed(name: str) -> bool:
    return which(name) is not None
