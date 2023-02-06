from pathlib import Path
from enum import Enum


USER_HOME = Path.home()
BASE_DIR = Path().resolve().parent.parent


class PlatformOptions(Enum):
    LINUX = "linux"
    WINDOWS = "win32"
    CYGWIN = "cygwin"
    OSX = "darwin"


PACKAGE_MANAGER_MAP = {
    "ubuntu": {
        "package_manager": "apt",
        "install_directive": "apt-get install",
    },
    "android": {"package_manager": "pkg", "install_directive": "pkg install"},
    "arch": {"package_manager": "pacman", "install_directive": "pacman -S"},
}
