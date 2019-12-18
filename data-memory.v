module dataMemory (output[7:0] memOut, input[7:0] memIn, input[2:0] lineNumber, input memRead, memWrite, clk);
    reg[7:0] dMemory[7:0];

    initial begin
        $readmemb("dataMemory.txt", dMemory);
    end

    always @ (posedge clk) begin
        if (memWrite)
            dMemory[lineNumber] <= memIn;
        if (memRead)
            memOut <= dMemory[lineNumber];
    end
endmodule
