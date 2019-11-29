module testbench;

    wire[3:0] SREG;
    wire[7:0] reg_out;
    reg[7:0] A, B;
    reg[3:0] function_select_lines;

    initial begin
        $dumpfile("test-ALU-adder-sub.vcd");
        $dumpvars(0, testbench);
    end

    ALU uut (reg_out, SREG, function_select_lines, A, B);

    initial begin
        #1 A = 6; B = 9; function_select_lines = 1;
        #5 A = 3; B = 6; function_select_lines = 2;
        #5 B = 50;
        #5 A = 127; B = 125; function_select_lines = 1;
        #5 function_select_lines = 2;
        #5 B = -120;
        #5 A = 1; B = 2; function_select_lines = 3;
        #5 function_select_lines = 0;
        #5 A = 13; B = 85; function_select_lines = 6;
        #5 function_select_lines = 7;
        #5 $finish;
    end
endmodule
