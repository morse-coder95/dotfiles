import logging
import os
from enum import Enum


def configure_logging():
    log = logging.getLogger()
    log.setLevel(logging.INFO)
    handler = logging.StreamHandler()
    formatter = logging.Formatter("%(asctime)s | %(levelname)s | %(message)s ")
    handler.setFormatter(formatter)
    log.addHandler(handler)
    return log


class Host(Enum):
    Home = "home"
    Work = "work"
