module CU (input[31:0] instruction, input[3:0] SREG);
    wire[7:0] operandA, operandB;
    wire[4:0] opcode;
    wire[8:0] pCounter;
    wire hold;

    assign operandA = instruction[7:0];
    assign operandA = instruction[15:8];
    assign opcode = instruction[20:16];
    assign hold = (opcode === MULTIPLY)?hold+1:0;

    PC programCounter (pCounter, jump_en, jump_line_num, clk, hold);
endmodule
