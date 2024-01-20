#!/usr/bin/python3

# convert disassembled otuput of objdump to VHDL

import fileinput
import re

rx1 = re.compile("^ +([0-9a-f]+):[ \t]+([0-9a-f]{8}) [ \t]+(.+)$")
rx2 = re.compile("^([0-9a0-f]{8}) (<.+>):$")

for line in fileinput.input():
    line = line.rstrip()

    m = rx1.match(line)
    if m:
        print("    x\"{0}\",  -- {1: >4}: {2}".format(m[2], m[1], m[3]))

    m = rx2.match(line)
    if m:
        print("                  -- {1}:".format(m[1], m[2]))
