# 8-bit Microprocessor implementation in Verilog

### Specifications:
*   1 Byte data
*   256 Byte Main memory
*   64 Byte Cache memory with 4 Byte block size.
*   Data Instructions:
    *   ALU Instructions:
        *   `ADD A, B;` ---> _out = A+B;_
        *   `SUB A, B;`  ---> _out = A-B;_
        *   `ADDC A, B;` ---> _out = A+B+Carry;_
        *   `SUBC A, B;` ---> _out = A-B-Carry;_
        *   `XOR A, B;` ---> _out = A^B;_
        *   `AND A, B;` ---> _out = A&B;_
        *   `OR A, B;` ---> _out = A|B;_
        *   `NAND A, B;` ---> _out = ~(A&B);_
        *   `LLS A;` ---> _out = A<<1;_
        *   `LRS A;` ---> _out = A>>1;_
        *   `ALS A;` ---> _out = A<<1;_
        *   `ARS A;` ---> _out = A>>1; sign retained_
        *   `ROL A;` ---> _out = rotate left A;_
        *   `ROR A;` ---> _out = rotate right A;_
        *   `MUL A, B;` ---> _out = A*B; 16-bit output_
        *   `CMP A, B;` ---> _compare A, B;_

    *   Memory Instructions:
        *   `MOV A, B` ---> _A <== B;_x
        *   `LDI A, n` ---> _Load A with value n;_
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
