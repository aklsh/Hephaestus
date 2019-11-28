# 8-bit Microprocessor implementation in Verilog

### Specifications:
*   1 Byte data
*   256 Byte Main memory
*   64 Byte Cache memory with 4 Byte block size.
*   8 instructions:
    *   `ADD A, B;` ---> _out = A+B;_
    *   `SUB A, B;`  ---> _out = A-B;_
    *   `INC A;` ---> _A = A+1;_
    *   `JMP line;` ---> _branch to line;_
    *   `CMP A, B;` ---> _compare A, B;_
    *   `OR A, B;` ---> _out = A&B;_
    *   `AND A, B;` ---> _out = A|B;_
*   8 Internal Registers (R0 - R7)
*   Status Register (SREG): 4 bits
    ![Status Register](/sreg.png)
*   
