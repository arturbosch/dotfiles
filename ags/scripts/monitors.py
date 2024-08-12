#!/usr/bin/env python3

from typing import List
import sys
import json
import subprocess
import argparse


class Monitor:

    INTERNAL_MONITOR = "eDP-1"

    def __init__(self, json_obj):
        self.name = json_obj["name"]
        self.description = json_obj["description"]
        self.mode = json_obj["availableModes"][0]

    def __str__(self) -> str:
        return str(self.__dict__)

    def enabled(self) -> str:
        return f"{self.name}, {self.mode}, auto, 1"

    def disabled(self) -> str:
        return f"{self.name}, disable"

    def mirror(self) -> str:
        return f"{self.name}, {self.mode}, auto, 1, mirror, " + Monitor.INTERNAL_MONITOR

    def is_internal(self):
        return self.name == Monitor.INTERNAL_MONITOR

    def is_dell_U2518D(self) -> bool:
        return "U2518D" in self.description

    def is_external(self) -> bool:
        return self.is_dell_U2518D()


def hyprctl(suffix: str) -> List[str]:
    return ["hyprctl", "keyword", "monitor", suffix]


def run(monitor_format: str):
    cmd = hyprctl(monitor_format)
    print(cmd)
    subprocess.run(cmd)


# Usage: hyprctl monitors all | ./monitors.py --mode all|external etc
parser = argparse.ArgumentParser()
parser.add_argument(
    "--mode", type=str, help="Mode: all,mirror,external,internal", default="all"
)
args = parser.parse_args()
mode = args.mode

input_text = sys.stdin.read()
monitors_array = json.loads(input_text)
monitors = [Monitor(obj) for obj in monitors_array]

for monitor in monitors:
    if monitor.is_internal():
        if mode in ("all", "mirror", "internal"):
            run(monitor.enabled())
        else:
            run(monitor.disabled())
    elif monitor.is_external():
        if mode in ("all", "external"):
            run(monitor.enabled())
        elif mode in ("internal"):
            run(monitor.disabled())
        elif mode in ("mirror"):
            run(monitor.mirror())
        else:
            print(
                "Unsupported mode for external monitor: ", monitor.name, " mode: ", mode
            )
