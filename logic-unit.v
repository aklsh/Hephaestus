module logicUnit (output[7:0] out, input[7:0] A, B, input[1:0] sel);
    wire[7:0] xor_out, and_out, or_out, nand_out;

    assign xor_out = A^B;
    assign and_out = A&B;
    assign or_out = A|B;
    assign nand_out = ~(A&B);

    multiplexer4to1 mux(out, xor_out, and_out, or_out, nand_out, sel);
endmodule
