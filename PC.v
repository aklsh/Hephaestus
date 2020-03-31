module PC (output reg[7:0] pCounterOut, input[7:0] pCounterIn, jumpLine, input jump, hold, clk);
    initial begin
        pCounterOut = 8'b0;
    end

    always @ (posedge clk) begin
        if ((hold === 1) && (jump === 0))
            pCounterOut<=pCounterIn;
        else begin
            if (jump === 1)
                pCounterOut<=jumpLine;
            else
                pCounterOut<=pCounterIn+1'b1;
        end
    end
endmodule
