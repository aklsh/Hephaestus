# 8-bit Microprocessor implementation in Verilog

### Specifications:
*   1 Byte data

*   Harvard Architecture

*   256 8-bit lines in memory.

*   ALU Instructions:
    *   `ADD out, A, B;` ---> _out = A+B;_
    *   `SUB out, A, B;`  ---> _out = A-B;_
    *   `ADDC out, A, B;` ---> _out = A+B+Carry;_
    *   `SUBC out, A, B;` ---> _out = A-B-Carry;_
    *   `XOR out, A, B;` ---> _out = A^B;_
    *   `AND out, A, B;` ---> _out = A&B;_
    *   `OR out, A, B;` ---> _out = A|B;_
    *   `NAND out, A, B;` ---> _out = ~(A&B);_
    *   `LLS out, A;` ---> _out = A<<1;_
    *   `LRS out, A;` ---> _out = A>>1;_
    *   `ALS out, A;` ---> _out = A<<<1;_
    *   `ARS out, A;` ---> _out = A>>>1;_
    *   `ROL out, A;` ---> _out = rotate left A_
    *   `ROR out, A;` ---> _out = rotate right A_
    *   `MUL out, A, B;` ---> _out = A*B; 16-bit output_
    *   `CMP A, B;` ---> _compare A, B;_

*   Memory Instructions:
    *   `MOV Addr1, Addr2` ---> _regA <== regB;_
    *   `LDI A, n` ---> _Load regA with value n;_
    *   `LDR A, B` ---> _regA <== data[regB];_
    *   `LD A, Addr` ---> _regA <== data[Addr];_
    *	`ST Addr, A` ---> _data[Addr] <== regA_

*   PFC Instructions:
    *   `JMP X;` ---> _jump to line X unconditionally;_
    *   `JMPZS X;` ---> _jump to line X if Z = 1;_
    *   `JMPZC X;` ---> _jump to line X if Z = 0;_
    *   `JMPCS X;` ---> _jump to line X if C = 1;_
    *   `JMPCC X;` ---> _jump to line X if C = 0;_
    *   `JMPSS X;` ---> _jump to line X if S = 1;_
    *   `JMPSC X;` ---> _jump to line X if S = 0;_
    *   `JMPVS X;` ---> _jump to line X if V = 1;_
    *   `JMPVC X;` ---> _jump to line X if V = 0;_
    *   `NOP;` ---> _no operation;_

*   8 Internal Registers (R0 - R7)

*   Status Register (SREG): 4 bits

    |V|S|C|Z|
    |---|---|---|---|

    `Z` - Zero Flag  
    `C` - Carry Flag  
    `S` - Sign Flag  
    `V` - Overflow Flag  

*   
