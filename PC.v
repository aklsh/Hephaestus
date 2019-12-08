module PC (output reg[7:0] pCounter, input jump_en, input[7:0] jump_line_num, input clk, input hold);
    initial begin
        pCounter = 8'b0;
    end

    always @ (posedge clk) begin
        if(jump_en)
            pCounter <= jump_line_num;
        else begin
            if (hold === 1)
                pCounter <= pCounter+8'b0;
            else if (hold === 2 | hold === 0)
                pCounter <= pCounter+8'b1;
        end
    end
endmodule
