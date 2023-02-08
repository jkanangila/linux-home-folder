import argparse


def config_parser():
    parser = argparse.ArgumentParser()

    script_subparsers = (
        parser.add_subparsers(dest="script")
    )

    add_install_parser(script_subparsers)
    add_setup_parser(script_subparsers)

    return parser


def add_install_parser(script_subparsers):
    install_parser = script_subparsers.add_parser(
        "install",
        help="Install and set up package",
    )

    install_parser.add_argument(
        "package",
        help="Name of package to Install",
    )
    install_parser.add_argument(
        "-s",
        "--setup",
        help="Copy custom settings over",
        action="store_true",
    )


def add_setup_parser(script_subparsers):
    setup_parser = (
        script_subparsers.add_parser(
            "setup",
            help="Customize package configs",
        )
    )
    setup_parser.add_argument(
        "package",
        help="Name of package to configure",
    )
