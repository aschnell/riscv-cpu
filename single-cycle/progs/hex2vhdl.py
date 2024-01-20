#!/usr/bin/python3

import sys
import getopt
import intelhex


def load_hex(filename):
    ihex = intelhex.IntelHex(filename)
    ihex.padding = 0x00
    return ihex


def dump_text(ihex):

    start = 0x1ffff
    end = 0x10000

    # TODO proper intersect with allowed region
    # TODO is there a Python class that with intersection, merge to do this?

    for segment in ihex.segments():
        if segment[0] >= 0x10000 and segment[1] < 0x20000:
            start = min(start, segment[0])
            end = max(end, segment[1])

    for addr in range(start, end, 4):
        bytes = [ ihex[addr + (3 - o)] for o in range(4) ]
        print('    x"' + ''.join('{:02x}'.format(byte) for byte in bytes) + '",')


def dump_data(ihex):

    start = 0x2ffff
    end = 0x20000

    for segment in ihex.segments():
        if segment[0] >= 0x20000 and segment[1] < 0x30000:
            start = min(start, segment[0])
            end = max(end, segment[1])

    for addr in range(start, end, 4):
        bytes = [ ihex[addr + (3 - o)] for o in range(4) ]
        chars = [ chr(byte) if chr(byte).isprintable() else '.' for byte in bytes ]
        print('    x"' + ''.join('{:02x}'.format(byte) for byte in bytes) + '",  -- ' + ''.join(chars))


do_text = False
do_data = False

opts, args = getopt.gnu_getopt(sys.argv[1:], "td:", ["text", "data"])
for o, a in opts:
    if o in ("--text"):
        do_text = True
    elif o in ("--data"):
        do_data = True

if not args:
    raise getopt.GetoptError('hex file not specified')
if len(args) > 1:
    raise getopt.GetoptError('too many arguments')

ihex = load_hex(args[0])

if do_text:
    dump_text(ihex)
if do_data:
    dump_data(ihex)
