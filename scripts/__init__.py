from .install_script import Install


def resolver(args):
    script = args.script
    package = args.package

    if script == "install":
        Install(package).run()
