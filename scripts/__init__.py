from .install_script import Install
from .setup_script import Setup


def resolver(args):
    script = args.script
    package = args.package

    if hasattr(args, "setup"):
        setup = args.setup
    else:
        setup = False

    if script == "install":
        Install(package, setup).run()

    if script == "setup":
        Setup(package).run()
