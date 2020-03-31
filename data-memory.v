module dataMemory (output reg[7:0] memOut, input[7:0] memIn, input[6:0] lineNumber, input memRead, memWrite, clk);
    reg[7:0] dMEM[0:127];

    integer i;
    initial begin
        for(i=0; i<128;i=i+1) begin
            dMEM[i] <= 0;
        end
    end

    always @ (posedge clk) begin
        if (memWrite)
            dMEM[lineNumber] <= memIn;
        if (memRead)
            memOut <= dMEM[lineNumber];
    end
endmodule
