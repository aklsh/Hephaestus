module comparator (output AlessthanequaltoB, input[7:0] A, B);
    assign AlessthanequaltoB = (A <= B)?1:0;
endmodule
