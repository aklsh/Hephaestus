module barrelShifter (output Carry, output [7:0] out, input[7:0] in, input direction, input arithmetic);
    assign Carry = (direction)?in[7]:in[0];

    multiplexer4to1_1bit out7 (out[7], in[6], 1'b0, in[6], in[7], {arithmetic, direction});
    multiplexer4to1_1bit out6 (out[6], in[5], in[7], in[5], in[7], {arithmetic, direction});
    multiplexer4to1_1bit out5 (out[5], in[4], in[6], in[4], in[6], {arithmetic, direction});
    multiplexer4to1_1bit out4 (out[4], in[3], in[5], in[3], in[5], {arithmetic, direction});
    multiplexer4to1_1bit out3 (out[3], in[2], in[4], in[2], in[4], {arithmetic, direction});
    multiplexer4to1_1bit out2 (out[2], in[1], in[3], in[1], in[3], {arithmetic, direction});
    multiplexer4to1_1bit out1 (out[1], in[0], in[2], in[0], in[2], {arithmetic, direction});
    multiplexer4to1_1bit out0 (out[0], 1'b0, in[1], 1'b0, in[1], {arithmetic, direction});

endmodule
