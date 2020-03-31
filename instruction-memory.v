module instructionMemory (output [15:0] instruction, input[7:0] line, input clk);
    reg[15:0] iMEM[0:255]; // 256 lines of 16-bit instructions

    initial $readmemb("./instructionMemory.txt", iMEM);

    assign instruction = iMEM[line];
endmodule
