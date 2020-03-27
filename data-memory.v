module dataMemory (output reg[7:0] memOut, input[7:0] memIn, input[2:0] lineNumber, input memRead, memWrite, clk);
    reg[7:0] dMEM[127:0];

    initial begin
        $readmemb("dataMemory.txt", dMEM);
    end

    always @ (posedge clk) begin
        if (memWrite)
            dMEM[lineNumber] <= memIn;
        if (memRead)
            memOut <= dMEM[lineNumber];
    end
endmodule
