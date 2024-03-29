from pathlib import Path
from enum import Enum

USER_HOME = Path.home()
BASE_DIR = Path().resolve()


class PlatformOptions(Enum):
    LINUX = "linux"
    WINDOWS = "win32"
    CYGWIN = "cygwin"
    OSX = "darwin"
