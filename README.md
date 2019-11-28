# 8-bit Microprocessor implementation in Verilog

### Specifications:
*   1 Byte data
*   256 Byte Main memory
*   64 Byte Cache memory with 4 Byte block size.
*   Data Instructions:
    *   `ADD A, B;` ---> _out = A+B;_
    *   `SUB A, B;`  ---> _out = A-B;_
    *   `INC A;` ---> _A = A+1;_
    *   `CMP A, B;` ---> _compare A, B;_
    *   `OR A, B;` ---> _out = A&B;_
    *   `AND A, B;` ---> _out = A|B;_
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
*   
