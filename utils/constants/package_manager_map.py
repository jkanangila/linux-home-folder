PACKAGE_MANAGER_MAP = {
    "ubuntu": {
        "package_manager": "apt",
        "install_directive": "apt-get install",
    },
    "android": {
        "package_manager": "pkg",
        "install_directive": "pkg install",
    },
    "arch": {
        "package_manager": "pacman",
        "install_directive": "pacman -S",
    },
}
