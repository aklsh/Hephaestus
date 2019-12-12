module instructionMemory (output[15:0] instruction, input[7:0] line);
    reg[15:0] iMEM[127:0]; // 128 lines of 16-bit instructions

    initial $readmemb("instructionMemory.txt", iMEM);

    assign instruction = iMEM[line];
endmodule
