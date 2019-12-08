module multiplier (output[15:0] result, input[7:0] A, B, input clk);
    reg signed[15:0] result, multiplicand, partial_product;
    reg signed[8:0] multiplier;
    integer i;
    
    always @(A, B) begin
        partial_product <= 16'b0;
        multiplicand <= {{8{A[7]}},A[7:0]};
        multiplier <= {B[7:0],1'b0};
        i = -1;
    end

    always @ (posedge clk) begin
        if(i != 8) begin
            case (multiplier[i+1-:2])
                2'b00: begin
                    partial_product <= partial_product;
                    multiplicand <= multiplicand<<1;
                end
                2'b01: begin
                    partial_product <= partial_product+multiplicand;
                    multiplicand <= multiplicand<<1;
                end
                2'b10: begin
                    partial_product <= partial_product-multiplicand;
                    multiplicand <= multiplicand<<1;
                end
                2'b11: begin
                    partial_product <= partial_product;
                    multiplicand <= multiplicand<<1;
                end
            endcase
            i = i+1;
        end
        else
            result <= partial_product;
    end
endmodule
