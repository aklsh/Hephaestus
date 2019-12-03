module adderSubtractor (output Overflow, Carry, output[7:0] sum, input[7:0] A, input[7:0] B, input sel, input Cin);
    wire[7:0] B_feed;
    assign B_feed = (sel)?(~B+1):B;

    assign {Carry, sum} = (sel)?(A + B_feed - Cin):(A + B_feed + Cin);
    assign Overflow = (~sum[7]&A[7]&B_feed[7]) | (sum[7]&~A[7]&~B_feed[7]);
endmodule
