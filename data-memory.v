module dataMemory (output reg[7:0] memOut, input[7:0] memIn, input[7:0] lineNumber, input memRead, memWrite);
    reg[7:0] dMEM[0:255];

    integer i;
    initial begin
        for(i=0; i<256;i=i+1) begin
            dMEM[i] <= 0;
        end
    end

    always @ (*) begin
        if (memWrite)
            dMEM[lineNumber] <= memIn;
        if (memRead)
            memOut <= dMEM[lineNumber];
    end
endmodule
