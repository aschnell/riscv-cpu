#!/usr/bin/python3

import fileinput
import re
from enum import Enum
import subprocess
from string import Template


class Test:

    def __init__(self, setup, asm, check):

        if not asm:
            raise RuntimeError("empty ASM")

        if not check:
            raise RuntimeError("empty CHECK")

        self.setup = setup
        self.asm = asm
        self.check = check

        self.asm.append("")
        self.asm.append("\tpause")


def load_tests():

    rx0 = re.compile("^\*\*\*\*\* TEST \*\*\*\*\*$")
    rx1 = re.compile("^-- SETUP$")
    rx2 = re.compile("^-- ASM$")
    rx3 = re.compile("^-- CHECK$")

    Stage = Enum('Stage', ['NONE', 'TEST', 'SETUP', 'ASM', 'CHECK'])

    tests = []

    stage = Stage.NONE

    setup = []
    asm = []
    check = []

    for line in fileinput.input():
        line = line.rstrip()

        if not line or line.startswith("#"):
            continue

        if rx0.match(line):
            if stage != Stage.NONE:
                tests.append(Test(setup, asm, check))
            setup = []
            asm = []
            check = []
            stage = Stage.TEST
            continue

        if rx1.match(line):
            stage = Stage.SETUP
            continue

        if rx2.match(line):
            stage = Stage.ASM
            continue

        if rx3.match(line):
            stage = Stage.CHECK
            continue

        if stage == Stage.SETUP:
            setup.append(line)

        if stage == Stage.ASM:
            asm.append(line)

        if stage == Stage.CHECK:
            check.append(line)

    tests.append(Test(setup, asm, check))

    return tests


def write_asm(test):

    with open('tmp.s', 'w') as f:
        for line in test.asm:
            f.write(line)
            f.write('\n')


def run_as(test):

    cmd = ["riscv64-elf-as", "-march=rv32i_zihintpause", "-mabi=ilp32", "tmp.s", "-o", "tmp.o"]
    subprocess.run(cmd, check = True)


def write_vhdl(test):

    setup = []

    for t in test.setup:
        setup.append('  probe_in_{0};'.format(t))

    cmd = ["riscv64-elf-objdump", "-march=rv32i", "-mabi=ilp32", "--disassemble", "-m", "riscv", "tmp.o"]
    popen = subprocess.Popen(cmd, stdout = subprocess.PIPE, universal_newlines = True)

    machine_code = []

    for line in iter(popen.stdout.readline, ""):
        line = line.rstrip()
        machine_code.append(line)

    popen.stdout.close()

    return_code = popen.wait()
    if return_code:
        raise subprocess.CalledProcessError(return_code, cmd)

    rx1 = re.compile("^ +([0-9a-f]+):[ \t]+([0-9a-f]{8}) [ \t]+(.+)$")
    rx2 = re.compile("^([0-9a0-f]{8}) (<.+>):$")

    asm = []
    num_asm = 0

    for line in machine_code:

        m = rx1.match(line)
        if m:
            asm.append("  probe_in_imem{0} <= x\"{1}\"; -- {2: >4}: {3} ".format(num_asm, m[2], m[1], m[3]))
            num_asm += 1

        m = rx2.match(line)
        if m:
            asm.append("                              -- {1}:".format(m[1], m[2]))

    check = []

    for t in test.check:
        check.append('    if not(probe_out_{0}) then'.format(t))
        check.append('      report "test failed" severity failure;')
        check.append('    end if;')

    with open('test.vhdl-template') as f:
        template = f.readlines()

    form = Template("".join(template))

    w = { 'setup': "\n".join(setup), 'asm': "\n".join(asm), 'check': "\n".join(check) }

    with open('tmp.vhdl', 'w') as f:
        f.write(form.substitute(w))


def run_test(test):
    subprocess.run(["ghdl", "-a", "--std=08", "tmp.vhdl"], check = True)
    subprocess.run(["ghdl", "-r", "--std=08", "tmp"], check = True)


tests = load_tests()

for test in tests:
    write_asm(test)
    run_as(test)
    write_vhdl(test)
    run_test(test)
