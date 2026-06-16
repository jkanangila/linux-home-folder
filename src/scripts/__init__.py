from .install_script import Install
from .ls import List
from .setup_script import Setup


def resolver(args):
    script = args.script

    if hasattr(args, "package"):
        package = args.package
    else:
        package = None

    if hasattr(args, "setup"):
        setup = args.setup
    else:
        setup = False

    if script == "install":
        Install(package, setup).run()

    if script == "setup":
        Setup(package).run()

    if script == "ls":
        List().run()
