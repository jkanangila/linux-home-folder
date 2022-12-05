from shutil import which
import subprocess
import sys
from utils.constants import PlatformOptions

def get_distro_name() ->:
    if hasattr(sys, "getandroidapilevel"):
        return "android"
    if sys.platform == PlatformOptions.LINUX.value:
        pass

def get_install_directive() -> str:
    pass

def execute_command(cmd: str):
    subprocess.run(cmd.split(" "), check=True)

def is_installed(name: str) -> bool:
    return which(name) is not None