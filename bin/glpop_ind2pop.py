#! /usr/bin/env python3
# vim:fenc=utf-8
#
# Copyright © 2025 nylander <johan.nylander@nrm.se>
#
# Distributed under terms of the MIT license.

"""
Read first column values in file ONE (.list file from 02.NGSadmix),
then read lines in file TWO (or from stdin) and print them to stdout
if also present in column one, file ONE.
Output can be used as ind2pop.txt file when plotting with pong.
See <https://github.com/ramachandran-lab/pong>.
"""

import argparse
import sys
from typing import Dict, List

def read_file(file: str) -> List[str]:
    with open(file, 'r') as f:
        return f.read().splitlines()

def extract_labels(file: str) -> Dict[str, None]:
    return {line.split()[0]: None for line in read_file(file)}

def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('-n, --ngsadmix',
                        help='File ONE, .list file from 02.NGSAdmix',
                        dest='ngsadmix', required=True)
    parser.add_argument('-i, --input',
                        help='File TWO, input file',
                        dest='input', required=False, default=sys.stdin)
    parser.add_argument('-c, --column',
                        help='Column in file TWO to extract (one based)',
                        dest='column', required=False, default=None, type=int)
    parser.add_argument('-s, --subcolumn',
                        help='Sub column in column to extract (one based)',
                        dest='subcolumn', required=False, default=None, type=int)
    parser.add_argument('-d, --delimiter',
                        help='Delimiter to split column',
                        dest='delimiter', required=False, default='__')
    parser.add_argument('-V', '--version',
                        help='Show version',
                        action='version', version='%(prog)s 0.1')
    args = parser.parse_args()

    labels = read_file(args.ngsadmix)

    input_lines = {}
    if args.input == sys.stdin:
        for input_line in sys.stdin:
            input_lines[input_line.split()[0]] = input_line.rstrip()
    else:
        with open(args.input, 'r') as f:
            for line in f:
                input_lines[line.split()[0]] = line.rstrip()

    for label in labels:
        if label in input_lines:
            if args.column:
                column = input_lines[label].split('\t')[args.column-1]
                if args.subcolumn:
                    print(f"{column.split(args.delimiter)[args.subcolumn-1]}")
                else:
                    print(f"{column}")
            else:
                print(input_lines[label])

if __name__ == '__main__':
    main()
