module comparator (output AequaltoB, input[7:0] A, B);
    assign AequaltoB = (A == B)?1:0;
endmodule
