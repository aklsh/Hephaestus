module PC (output reg[7:0] pCounterOut, input[7:0] pCounterIn, jumpLine, input jump, hold, clk);
    initial begin
        pCounterOut <= 8'b0;
    end

    always @ (posedge clk) begin
        case({hold, jump})
            2'b00: pCounterOut <= pCounterIn+1'b1;
            2'b01: pCounterOut <= jumpLine;
            2'b10: pCounterOut <= pCounterIn;
            2'b11: pCounterOut <= jumpLine;
        endcase
    end
endmodule
