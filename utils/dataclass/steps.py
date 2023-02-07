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
    disto: str = "default"
    dependencies: List[str]
    steps: List[Command]
    setup: Optional[List[Command]] = None
    source: str = ""


class InstallSteps(BaseModel):
    package: str
    short_name: str = ""
    install_directives: List[
        InstallDirective
    ]
