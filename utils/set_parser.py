import argparse


def config_parser():
    parser = argparse.ArgumentParser()

    script_subparsers = (
        parser.add_subparsers(dest="script")
    )

    install_parser = script_subparsers.add_parser(
        "install",
        help="Install and set up package",
    )

    install_parser.add_argument(
        "package",
        help="Name of package to Install",
    )

    return parser
