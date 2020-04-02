module multiplexer4to1 (output[7:0] out, input[7:0] in_0, in_1, in_2, in_3, input[1:0] sel);
    assign out = (sel[1])?((sel[0])?in_3:in_2):((sel[0])?in_1:in_0);
endmodule

module multiplexer4to1_1bit (output out, input in_0, in_1, in_2, in_3, input[1:0] sel);
    assign out = (sel[1])?((sel[0])?in_3:in_2):((sel[0])?in_1:in_0);
endmodule
