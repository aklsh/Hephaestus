import argparse
import sys

parser = argparse.ArgumentParser()
parser.add_argument("--input", default='input.txt')
args = parser.parse_args()

BIN = lambda n, b : format(int(n), '0' + str(b) + 'b') # Converts numbers to binary with zeros before
INSTRUCTION_LENGTH = 16

inputFile = args.input

ASMLines = []
labels = {}
with open (inputFile, 'r') as f:
    for number, line in enumerate(f.readlines()):
        line = line.split('#')[0].split('\n')[0] # Remove comments and \n
        if ':' in line:
            label, line = line.split(': ')
            labels[label] = number
        ASMLines.append(line)

def getMachineCode(line):
    tokens = line.split(':')[-1].split() # Remove branch label

    if tokens[0] in ALU2Args.keys():
        machineCode = ALU2Args[tokens[0]] + BIN(tokens[1][:1], 3) + BIN(0, 3) + BIN(tokens[2][:1], 3)

    elif tokens[0] in ALU3Args.keys():
        machineCode = ALU3Args[tokens[0]] + BIN(tokens[1][1:], 3) + BIN(tokens[2][1:], 3) + BIN(tokens[3][1:], 3)

    elif tokens[0] in memory.keys():
        machineCode = memory[tokens[0]] + BIN(tokens[1], 8) + BIN(tokens[2][1:], 3)

    elif tokens[0] in branch.keys():
        machineCode = branch[tokens[0]] + BIN(labels[tokens[1]], 8)

    elif tokens[0] == 'MOV':
        machineCode = '11'+ BIN(tokens[1], 7) + BIN(tokens[2], 7)

    elif tokens[0] in others.keys():
        machineCode = others[tokens[0]] + BIN(tokens[1][1:], 3) + BIN(tokens[2][1:], 3)

    else:
        raise Exception(f'{tokens[0]} is not a valid instruction')

    machineCode += '0' * (16 - len(machineCode)) # Fill the rest with zeros

    return machineCode

ALU3Args = {
                'ADD'    :    '000000',
                'SUB'    :    '000001',
                'ADDC'   :    '000010',
                'SUBC'   :    '000011',
                'XOR'    :    '000100',
                'AND'    :    '000101',
                'OR'     :    '000110',
                'NAND'   :    '000111',
                'MUL'    :    '001110'}

ALU2Args = {
                'LLS'    :    '001000',
                'LRS'    :    '001001',
                'ALS'    :    '001010',
                'ARS'    :    '001011',
                'ROL'    :    '001100',
                'ROR'    :    '001101'}

memory = {
                'LDI'   :   '01000',
                'ST'    :   '01110'}

branch = {
                    'JMP'   :   '101000',
                    'JMPZS' :   '100000',
                    'JMPZC' :   '100001',
                    'JMPCS' :   '100010',
                    'JMPCC' :   '100011',
                    'JMPSS' :   '100100',
                    'JMPSC' :   '100101',
                    'JMPVS' :   '100110',
                    'JMPVC' :   '100111'}

others = {
            'CMP':  '001111',
            'LDR':  '010100',
            'LD' :  '011000'}

machineCodes = []
for line in ASMLines:
    # print(line)
    machineCodes.append(getMachineCode(line))

with open('instructionMemory.txt', 'w') as f:
    for machineCode in machineCodes:
        f.write(machineCode + '\n')
    f.write(('x' * 16 + '\n') * (256 - len(ASMLines))) # Fill rest with x
