module logicUnit (output[7:0] out, input[7:0] A, B, input[1:0] sel);
    wire[7:0] xor_out, and_out, or_out, nand_out;

    xor eoru(xor_out, A, B);
    and andu(and_out, A, B);
    or oru(or_out, A, B);
    nand nandu(nand_out, A, B);

    multiplexer4to1 mux(out, xor_out, and_out, or_out, nand_out, sel);
endmodule
