`include "ALU-structural.v"
`include "adder-subtractor.v"
`include "barrel-shifter.v"
`include "comparator.v"
`include "FA.v"
`include "HA.v"
`include "logic-unit.v"
`include "multiplier.v"
`include "mux4to1.v"
`include "mux16to1.v"
`include "rotator.v"

module testbench;

    wire[3:0] SREG;
    wire[7:0] reg_out;
    wire[7:0] mul_high;
    reg[7:0] A, B;
    reg[3:0] function_select_lines;

    initial begin
        $dumpfile("test.vcd");
        $dumpvars(0, testbench);
    end

    ALU uut (mul_high, reg_out, SREG, A, B, function_select_lines);

    initial begin
        #5 A = 6; B = 9; function_select_lines = 1;
        #5 A = 3; B = 6; function_select_lines = 2;
        #5 A = 127; B = 125; function_select_lines = 3;
        #5 A = 1; B = 2; function_select_lines = 4;
        #5 function_select_lines = 0;
        #5 A = 5; B = 5; function_select_lines = 5;
        #5 A = 13; B = 85; function_select_lines = 6;
        #5 function_select_lines = 7;
        #5 function_select_lines = 8;
        #5 A = 120;
        #5 function_select_lines = 14;
        #5 $finish;
    end
endmodule