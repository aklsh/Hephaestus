import argparse
import sys

parser = argparse.ArgumentParser()
parser.add_argument("--input", default='input.txt')
args = parser.parse_args()

inputFile = args.input

ASMLines = []
with open (inputFile, 'r') as f:
    for line in f.readlines():
        ASMLines.append(line.split('#')[0].split('\n')[0])

'''
Instruction     OPCODE

    ADD         000000
    SUB         000001
    ADDC        000010
    SUBC        000011
    XOR         000100
    AND         000101
    OR          000110
    NAND        000111
    LLS         001000
    LRS         001001
    ALS         001010
    ARS         001011
    ROL         001100
    ROR         001101
    MUL         001110
    CMP         001111
    LDI         010001
    LDR         010010
    LD          010100
    ST          011000
    MOV         11
'''

def getLabel(line):
    if ':' in line:
        return line.split(':')[0]
    else:
        return

labels = {}

for line in ASMLines:
    lineTokens = line.split()
    lineLabel = getLabel(line)
    if lineLabel:
        labels[ASMLines.index(line)] = lineLabel
    else:
        labels[ASMLines.index(line)] = '~'

for line in ASMLines:
    getMachineCode(line)
