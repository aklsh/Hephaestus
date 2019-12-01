module ALU_struct (output[7:0] result, output[3:0] SREG, input[7:0] A, input[7:0] B, input[3:0] fsl);
    reg[7:0] result;
    reg[3:0] SREG;

    arithmetic_unit au();
    logic_unit lu();
    shift_unit su();

endmodule
