module testbench;

    wire[3:0] SREG;
    wire[15:0] reg_out;
    reg[7:0] A, B;
    reg[3:0] function_select_lines;
    wire clk;

    initial begin
        $dumpfile("test.vcd");
        $dumpvars(0, testbench);
    end

    clock clok(clk);
    ALU_struct uut (reg_out[15:8], reg_out[7:0], SREG, function_select_lines, A, B, clk);

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
        #5 $finish;
    end
endmodule
