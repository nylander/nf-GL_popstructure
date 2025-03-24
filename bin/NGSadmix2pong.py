#! /usr/bin/env python
# vim:fenc=utf-8

"""
Extract output from nf-GL_popstructure
to a pong_filemap to be used in plotting.
See <https://github.com/ramachandran-lab/pong>.

Usage: ./NGSadmix2pong.py directory > file_map

Will automatically read folder ../output if
it exists.

Copyright © 2025 nylander <johan.nylander@nrm.se>
Distributed under terms of the MIT license.

Version: 0.2

Created: 2025-03-19 10:05

Last modified: mån 24 mar 2025 09:14:07
"""

import os
import sys
import re
from pathlib import Path

VERSION = "0.2"
q_list = []
HoH = {}

def wanted(path):
    if path.is_file() and path.suffix == ".qopt":
        q_list.append(path)

def natural_sort_key(s, _nsre=re.compile(r'(\d+)')):
    return [int(text) if text.isdigit() else text.lower() for text in _nsre.split(s)]

if len(sys.argv) > 1:
    arg = sys.argv[1]
    if arg in ["-h", "--help"]:
        print(f"Usage: {sys.argv[0]} <directory>")
        sys.exit()
    elif arg in ["-v", "-V", "--version"]:
        print(f"{sys.argv[0]} v{VERSION}")
        sys.exit()
    elif os.path.isdir(arg):
        directory = Path(arg)
    else:
        print(f"ERROR: input directory {arg} does not exist\nUsage: {sys.argv[0]} <directory>")
        sys.exit(1)
else:
    if os.path.isdir("../output"):
        directory = Path("../output")
    else:
        print(f"ERROR: input directory ../output does not exist\nUsage: {sys.argv[0]} <directory>")
        sys.exit(1)

for path in directory.rglob("*.qopt"):
    wanted(path)

for qfile in q_list:
    basename = qfile.stem
    match = re.match(r".+_k(\d+)_permutate(\d+)", basename)
    if match:
        k = match.group(1)
    else:
        print("Could not find k from filename")
        sys.exit(1)
    relative_qfile = qfile.relative_to(directory)
    HoH[basename] = {'path': str(relative_qfile), 'k': k}

for basename in sorted(HoH.keys(), key=natural_sort_key):
    print(f"{basename}\t{HoH[basename]['k']}\t{HoH[basename]['path']}")
