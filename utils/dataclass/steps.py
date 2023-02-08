from pydantic import BaseModel
from typing import (
    List,
    Optional,
    Union,
    Type,
)


class Command(BaseModel):
    echo: str
    command: Union[str, List]


class InstallDirective(BaseModel):
    distro: str = "default"
    dependencies: List[str]
    steps: List[Command]
    setup: Optional[List[Command]] = []
    source: str = ""


class InstallSteps(BaseModel):
    package: str
    short_name: str = ""
    install_directives: List[
        InstallDirective
    ]

    def get_instructions(self, distro):
        instructions = list(
            filter(
                lambda x: x.distro == distro,
                self.install_directives,
            )
        )
        if not instructions:
            return list(
            filter(
                lambda x: x.distro == "default",
                self.install_directives,
            )
        )
        return instructions
