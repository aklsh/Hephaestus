module partialproduct(input1,segment,output1);
    input [7:0] input1;
    input [2:0] segment;
    output reg [15:0] output1;

        always @(*) begin
            case (segment)
                3'b000:output1=$signed(1'b0);
                3'b001:output1=$signed(input1);
                3'b010:output1=$signed(input1);
                3'b011: begin
                    output1=$signed(input1);
                    output1=$signed(input1)<<<1;
                end
                3'b100: begin
                    output1=$signed(input1);
                    output1=$signed(~output1+1'b1);
                    output1=$signed(output1)<<<1;
                end
                3'b101: begin
                    output1=$signed(input1);
                    output1=$signed(~output1+1'b1);
                end
                3'b110: begin
                    output1=$signed(input1);
                    output1=$signed(~output1+1'b1);
                end
                3'b111:output1=$signed(16'b0);
            endcase
        end

endmodule

module multiplier(output[15:0] c, input[7:0] a, b);
    wire [15:0] temp [3:0];

    partialproduct p0(a,{b[1:0],1'b0},temp[0]);
    partialproduct p1(a,b[3:1],temp[1]);
    partialproduct p2(a,b[5:3],temp[2]);
    partialproduct p3(a,b[7:5],temp[3]);

    assign c = $signed(temp[0])+$signed(temp[1]<<<2)+$signed(temp[2]<<<4)+$signed(temp[3]<<<6);

endmodule
