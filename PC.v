module PC (output reg[7:0] pCounter, input jump_en, input[7:0] jump_line_num, input clk);
    initial begin
        pCounter = 8'b0;
    end

    always @ (posedge clk) begin
        if(jump_en)
            pCounter <= jump_line_num;
        else
            pCounter <= pCounter+8'b1;
    end
endmodule
