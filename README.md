# Hephaestus

<p align="center">
    <a target="_blank" rel="noopener noreferrer"><img width="400" src="./hephaestus.png" alt="Hephaestus Logo"></a>
<br></p>

<p align='center'>An intuitive 8-bit processor</p>

# IMPORTANT ⚠️ ⚠️
## There is an issue with Branch instructions - if the branch isn't going to happen, then the next instruction will not be executed properly (it stays in it for one cycle only). If anyone can please help me resolve this, it would be great. 

## Main Features
*   8-Bit data.
*   16-Bit instructions.
*   256-line data and instruction memories.
*   Based on [Harvard Architecture](https://en.wikipedia.org/wiki/Harvard_architecture).
*   Register File:
    *   8 General Purpose Registers `GPR` - for ALU operations and temporary storage. 
    *   1 `mulHigh` register - for storing the high byte of result of multiplication.
*   4-Bit Flag register:
        |V|S|C|Z|
    |---|---|---|---|

    `Z` - Zero Flag  
    `C` - Carry Flag  
    `S` - Sign Flag  
    `V` - Overflow Flag 

## Instruction Set

|Instruction Name|Syntax|OPCODE|Type|Instruction Format|Remarks|
|:---:|:-----:|:---:|:---:|:---:|:---:|
|ADD| ADD *Ra* *Rb* *Rd* |**00** 0000|ALU|*000000* aaa bbb ddd 0|*Rd = Ra + Rb*|
|SUB| SUB *Ra* *Rb* *Rd* |**00** 0001|ALU|*000001* aaa bbb ddd 0 |*Rd = Ra - Rb*|
|ADDC| ADDC *Ra* *Rb* *Rd* |**00** 0010|ALU|*000010* aaa bbb ddd 0 |*Rd = Ra + Rb + C*|
|SUBC| SUBC *Ra* *Rb* *Rd* |**00** 0011|ALU|*000011* aaa bbb ddd 0 |*Rd = Ra - Rb - C*|
|XOR| XOR *Ra* *Rb* *Rd* |**00** 0100|ALU|*000100* aaa bbb ddd 0 |*Rd = Ra ^ Rb*|
|AND| AND *Ra* *Rb* *Rd* |**00** 0101|ALU|*000101* aaa bbb ddd 0 |*Rd = Ra & Rb*|
|OR| OR *Ra* *Rb* *Rd* |**00** 0110|ALU|*000110* aaa bbb ddd 0 |*Rd = Ra \|\| Rb*|
|NAND| NAND *Ra* *Rb* *Rd* |**00** 0111|ALU|*000111* aaa bbb ddd 0 |*Rd = ~(Ra & Rb)*|
|LLS| LLS *Ra* *Rd* |**00** 1000|ALU|*001000* aaa 000 ddd 0 |*Rd = Ra << 1*| 
|LRS| LRS *Ra* *Rd* |**00** 1001|ALU|*001001* aaa 000 ddd 0 |*Rd = Ra >> 1*|  
|ALS| ALS *Ra* *Rd* |**00** 1010|ALU|*001010* aaa 000 ddd 0 |*Rd = Ra <<< 1*|  
|ARS| ARS *Ra* *Rd* |**00** 1011|ALU|*001011* aaa 000 ddd 0 |*Rd = Ra >>> 1*|  
|ROL| ROL *Ra* *Rd* |**00** 1100|ALU|*001100* aaa 000 ddd 0 |*Rd = rotateLeft(Ra)*|
|ROR| ROR *Ra* *Rd* |**00** 1101|ALU|*001101* aaa 000 ddd 0 |*Rd = rotateRight(Ra)*| 
|MUL| MUL *Ra* *Rb* *Rd* | **00** 1110|ALU| *001110* aaa bbb ddd 0|*Rd = Ra x Rb*|
|CMP| CMP *Ra* *Rb* | **00** 1111|ALU| *001111* aaa bbb 0000|*Z = (a==b)?1:0*|
|||||||
|LDI|LDI *Value* *Rd*| **01** 00|Memory| *0100* 0 vvvvvvvv ddd | *Rd <--- Value*|
|LDR|LDR *Rd* *Ra*| **01** 01|Memory| *0101* 00 ddd aaa 0000 | *Rd <--- Ra*|
|LD|LD *Rd* *Ra*| **01** 10|Memory| *0110* 00 ddd aaa 0000 | *Rd <--- data[Ra]*|
|ST|ST *Loc* *Ra*| **01** 11|Memory| *0111* 0 llllllll aaa| *data[Loc] <--- Ra*|
|||||||
|JMP|JMP *label*|**10** 1000|Branch|*101000* llllllll 00|*Unconditional branch*|
|JMPZS|JMPZS *label*|**10** 0000|Branch|*100000* llllllll 00|*Branch if zero flag is set*|
|JMPZC|JMPZC *label*|**10** 0001|Branch|*100001* llllllll 00|*Branch if zero flag is cleared*|
|JMPCS|JMPCS *label*|**10** 0010|Branch|*100010* llllllll 00|*Branch if carry flag is set*|
|JMPCC|JMPCC *label*|**10** 0011|Branch|*100011* llllllll 00|*Branch if carry flag is cleared*|
|JMPSS|JMPSS *label*|**10** 0100|Branch|*100100* llllllll 00|*Branch if sign flag is set*|
|JMPSC|JMPSC *label*|**10** 0101|Branch|*100101* llllllll 00|*Branch if sign flag is cleared*|
|JMPVS|JMPVS *label*|**10** 0110|Branch|*100110* llllllll 00|*Branch if overflow flag is set*|
|JMPVC|JMPVC *label*|**10** 0111|Branch|*100111* llllllll 00|*Branch if overflow flag is cleared*|
|||||||
|MOV|MOV LocA LocB|**11**|Memory|*11* aaaaaaaa bbbbbbbb|data[Loc2] <--- data[Loc1]|
|||||||
|||||||

### How is the Instruction Set organized?
*   ALU instructions start with `00`.
*   Memory Instructions that involve GPRs start with `01`.
*   Branch Instructions start with `10`.
*   Miscellaneous instructions start with `11`. (More instructions to be added later)

## Can this be scaled to 32-bit or 64-bit versions?
As of now, I have hard-coded the size for each variable. But in the future, I am planning to make a scalable version of this which can easily be extended to 32-bit and 64-bit versions.

## Who is this for?
I made this processor to implement the ideas covered in _**EE2016: Microprocessor Theory and Lab**_, so that I will gain a better understanding of them. There are some ideas like Interrupts, Cache memory and pipelining which I haven't implemented, but am working on it. Do feel free to open up a pull request or an issue on anything related to [Hephaestus](https://github.com/aklsh/hephaestus).

## Sample programs
- [Fibonacci Term Calculator](programs/fibonacci.txt)
- [Powers of Two](programs/multiply.txt)

## TO-DO (in order of priority)
- [ ] Reducing the average CPI
- [ ] Add LDM, STI, STR instructions
    - [ ] **LDM**: Load from memory location
    - [ ] **STI**: Store Immediate to memory location
    - [ ] **STR**: Store to location given by Register value
- [ ] Interrupts 
    - [ ] I Bit in SREG 
    - [ ] Vector Tables
    - [ ] Read up RISC-V spec on interrupts
    - [ ] [ZipCPU interrupt controller](https://zipcpu.com/zipcpu/2019/04/02/icontrol.html)
- [ ] Scaling to 32-bit
- [ ] Cache  
- [ ] Pipelining  
