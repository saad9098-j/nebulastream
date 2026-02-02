#!/usr/bin/env python3
import sys
with open("nes-systests/testdata/small/out-linuxprocess.csv", "w") as f:
    for line in sys.stdin:
        f.write(line)