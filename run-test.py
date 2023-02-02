#!/usr/bin/python3

import fileinput
import re
from enum import Enum
import subprocess
from string import Template


class Test:

    def __init__(self, asm, checks):

        if not asm:
            raise RuntimeError("empty ASM")

        if not checks:
            raise RuntimeError("empty CHECKS")

        self.asm = asm
        self.checks = checks

        self.asm.append("")
        self.asm.append("\tpause")


def load_tests():

    rx1 = re.compile("^-- ASM ([0-9]+)$")
    rx2 = re.compile("^-- CHECKS ([0-9]+)$")

    Stage = Enum('Stage', ['NONE', 'ASM', 'CHECKS'])

    tests = []

    stage = Stage.NONE

    asm = []
    checks = []

    for line in fileinput.input():
        line = line.rstrip()

        if not line or line.startswith("#"):
            continue

        if rx1.match(line):
            if stage == Stage.CHECKS:
                tests.append(Test(asm, checks))
                asm = []
                checks = []
            stage = Stage.ASM
            continue

        if rx2.match(line):
            stage = Stage.CHECKS
            continue

        if stage == Stage.ASM:
            asm.append(line)

        if stage == Stage.CHECKS:
            checks.append(line)

    tests.append(Test(asm, checks))

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

    instructions = []
    num_instructions = 0

    for line in machine_code:

        m = rx1.match(line)
        if m:
            instructions.append("  probe_imem{0} <= x\"{1}\"; -- {2: >4}: {3} ".format(num_instructions, m[2], m[1], m[3]))
            num_instructions += 1

        m = rx2.match(line)
        if m:
            instructions.append("                              -- {1}:".format(m[1], m[2]))

    checks = []

    for t in test.checks:
        checks.append('    if not(probe_{0}) then'.format(t))
        checks.append('      report "test failed" severity failure;')
        checks.append('    end if;')

    with open('test.vhdl-template') as f:
        template = f.readlines()

    form = Template("".join(template))

    w = { 'instructions': "\n".join(instructions), "checks": "\n".join(checks) }

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
