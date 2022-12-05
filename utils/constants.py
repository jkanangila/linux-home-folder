from pathlib import Path
from enum import Enum


HOME = Path.home()

class PlatformOptions(Enum):
    LINUX='linux'
    WINDOWS='win32'
    CYGWIN='cygwin'
    OSX='darwin'