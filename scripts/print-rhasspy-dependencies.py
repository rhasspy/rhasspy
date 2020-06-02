#!/usr/bin/env python3
from pathlib import Path

_DIR = Path(__file__).parent

# -----------------------------------------------------------------------------


def main():
    base_dir = _DIR.parent
    with open(base_dir / "RHASSPY_DIRS", "r") as dirs_file:
        for dir_line in dirs_file:
            dir_line = dir_line.strip()
            if not dir_line:
                continue

            module_dir = base_dir / dir_line
            version = (module_dir / "VERSION").read_text().strip()
            print(f"{dir_line} ({version})")

            requirements = module_dir / "requirements.txt"
            with open(requirements, "r") as req_file:
                for req_line in req_file:
                    req_line = req_line.strip()
                    if not req_line:
                        continue

                    req_name, req_version = req_line.split("==")
                    if not req_line.startswith("rhasspy-"):
                        continue

                    print(f"  - {req_name} ({req_version})")

            print("")


# -----------------------------------------------------------------------------

if __name__ == "__main__":
    main()
