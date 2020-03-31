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

def getMachineCode(line):
    lineTokens = line.split()
    if(getLabel(line)):
        lineTokens.remove(getLabel(line)+':')

    if lineTokens[0] in ALUInstructions:
        machineCode = '00'+ ALUOpcode[lineTokens[0]]+ "{}".format(format(int(lineTokens[1][1]), '03b'))+ "{}".format(format(int(lineTokens[2][1]), '03b'))+ "{}".format(format(int(lineTokens[3][1]), '03b'))+ '0'
        print(machineCode)

    elif lineTokens[0] in memInstructions:
        machineCode = '01'+ memOpcode[lineTokens[0]]+ '0'
        if lineTokens[0] == 'LDI':
            machineCode += "{}".format(format(int(lineTokens[1]), '08b'))+ "{}".format(format(int(lineTokens[2][1]), '03b'))
        if lineTokens[0] == 'LDR' or lineTokens[0] == 'LD':
            machineCode += '0'+ "{}".format(format(int(lineTokens[1][1]), '03b'))+ "{}".format(format(int(lineTokens[2][1]), '03b'))+ '0000'
        if lineTokens[0] == 'ST':
            machineCode += '0'+ "{}".format(format(int(lineTokens[1]), '07b'))+ "{}".format(format(int(lineTokens[2][1]), '03b'))
        print(machineCode)

    elif lineTokens[0] in branchInstructions:
        machineCode = '10' + branchOpcode[lineTokens[0]] + "{}".format(format(labels.index(lineTokens[1]), '08b')) + '00'
        print(machineCode)
    elif lineTokens[0] == 'MOV':
        machineCode = '11'+ "{}".format(format(int(lineTokens[1]), '07b'))+ "{}".format(format(int(lineTokens[2]), '07b'))
        print(machineCode)

    return machineCode

ALUInstructions = ['ADD', 'SUB', 'ADDC', 'SUBC', 'XOR', 'AND', 'OR', 'NAND', 'LLS', 'LRS', 'ALS', 'ARS', 'ROL', 'ROR', 'MUL', 'CMP']
ALUOpcode = {
                'ADD'    :    '0000',
                'SUB'    :    '0001',
                'ADDC'   :    '0010',
                'SUBC'   :    '0011',
                'XOR'    :    '0100',
                'AND'    :    '0101',
                'OR'     :    '0110',
                'NAND'   :    '0111',
                'LLS'    :    '1000',
                'LRS'    :    '1001',
                'ALS'    :    '1010',
                'ARS'    :    '1011',
                'ROL'    :    '1100',
                'ROR'    :    '1101',
                'MUL'    :    '1110',
                'CMP'    :    '1111'
            }

memInstructions = ['LDI', 'LDR', 'LD', 'ST']
memOpcode = {
                'LDI'   :   '00',
                'LDR'   :   '01',
                'LD'    :   '10',
                'ST'    :   '11'
            }

branchInstructions = ['JMP', 'JMPZC', 'JMPZS', 'JMPCC', 'JMPCS', 'JMPSC', 'JMPSS', 'JMPVC', 'JMPVS']
branchOpcode = {
                    'JMP'   :   '1000',
                    'JMPZS' :   '0000',
                    'JMPZC' :   '0001',
                    'JMPCS' :   '0010',
                    'JMPCC' :   '0011',
                    'JMPSS' :   '0100',
                    'JMPSC' :   '0101',
                    'JMPVS' :   '0110',
                    'JMPVC' :   '0111'
               }

def getLabel(line):
    if ':' in line:
        return line.split(':')[0]
    else:
        return

labels = []

for line in ASMLines:
    lineTokens = line.split()
    lineLabel = getLabel(line)
    if lineLabel:
        labels.append(lineLabel)
    else:
        labels.append('~')

machineCodes = []
for line in ASMLines:
    machineCodes.append(getMachineCode(line))

with open('instructionMemory.txt', 'w') as f:
    for machineCode in machineCodes:
        f.write(machineCode+'\n')
    for i in range(0, 128-len(ASMLines)):
        f.write('xxxxxxxxxxxxxxxx'+'\n')
