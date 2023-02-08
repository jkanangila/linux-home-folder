from utils.set_parser import config_parser
from scripts import resolver

if __name__ == "__main__":
    parser = config_parser()
    args = parser.parse_args()

    resolver(args)
