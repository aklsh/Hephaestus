module multiplexer16to1 (output [7:0] out, input[7:0] in0, in1, in2, in3, in4, in5, in6, in7, in8, in9, in10, in11, in12, in13, in14, in15, input[3:0] sel);
    wire[7:0] mux0Out, mux1Out, mux2Out, mux3Out;

    multiplexer4to1 mux0 (mux0Out, in0, in1, in2, in3, sel[1:0]);
    multiplexer4to1 mux1 (mux1Out, in4, in5, in6, in7, sel[1:0]);
    multiplexer4to1 mux2 (mux2Out, in8, in9, in10, in11, sel[1:0]);
    multiplexer4to1 mux3 (mux3Out, in12, in13, in14, in15, sel[1:0]);

    multiplexer4to1 muxOut (out, mux0Out, mux1Out, mux2Out, mux3Out, sel[3:2]);
endmodule
