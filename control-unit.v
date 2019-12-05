module CU (input[31:0] instruction, input[3:0] SREG);
    wire[7:0] operandA, operandB;
    wire[4:0] opcode;
    wire[8:0] PC;

    assign operandA = instruction[];
    assign operandA = instruction[];
    assign opcode = instruction[];

    always @ (instruction, SREG) begin

    end
endmodule
