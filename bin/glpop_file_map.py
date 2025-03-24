#! /usr/bin/env python3
# vim:fenc=utf-8

"""
Extract output from nf-GL_popstructure
to a pong_filemap to be used in plotting.
See <https://github.com/ramachandran-lab/pong>.

Usage: ./NGSadmix2pong.py directory > file_map

With no arguments, it will automatically read folder
../output if it exists.

Copyright 2025 nylander <johan.nylander@nrm.se>
Distributed under terms of the MIT license.

Version: 0.2

Created: 2025-03-19 10:05

Last modified: mån 24 mar 2025 16:35:24
"""

import os
import sys
import re
import argparse
from pathlib import Path

VERSION = "0.2"
q_list = []
HoH = {}

def wanted(path):
    if path.is_file() and path.suffix == ".qopt":
        q_list.append(path)

def natural_sort_key(s, _nsre=re.compile(r'(\d+)')):
    return [int(text) if text.isdigit() else text.lower() for text in _nsre.split(s)]

parser = argparse.ArgumentParser(description="Extract output from nf-GL_popstructure to a pong_filemap to be used in plotting.")
parser.add_argument("directory", help="Directory with *.qopt files", nargs='?')
parser.add_argument("-a", "--absolute", help="Use absolute path to .qopt files", action="store_true")
parser.add_argument("-v", "-V", "--version", action="version", version=f"%(prog)s v{VERSION}")
args = parser.parse_args()

if not args.directory:
    if os.path.isdir("../output"):
        directory = Path("../output")
    else:
        print(f"ERROR: input directory is needed\nUsage: {sys.argv[0]} <directory>")
        sys.exit(1)
else:
    directory = Path(args.directory)
    if not directory.is_dir():
        print(f"ERROR: input directory {directory} does not exist\nUsage: {sys.argv[0]} <directory>")
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
    if args.absolute:
        real_path = qfile.resolve()
        HoH[basename] = {'path': str(real_path), 'k': k}
    else:
        relative_qfile = qfile.relative_to(directory)
        HoH[basename] = {'path': str(relative_qfile), 'k': k}

for basename in sorted(HoH.keys(), key=natural_sort_key):
    print(f"{basename}\t{HoH[basename]['k']}\t{HoH[basename]['path']}")
