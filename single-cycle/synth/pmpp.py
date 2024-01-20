#!/usr/bin/python3

# poor mans preprocessor

import fileinput
import re

rx1 = re.compile("( *)-- rtl_synthesis off")
rx2 = re.compile("( *)-- rtl_synthesis on")

b = True

for line in fileinput.input():

    line = line.rstrip()

    if rx1.match(line):
        b = False

    if b:
        print(line)

    if rx2.match(line):
        b = True
