module ALU (output reg[7:0] reg_out, output reg[3:0] SREG, input[3:0] function_select_lines, input[7:0] operandA, input[7:0] operandB, input clk);
    wire signed[7:0] operandA, operandB;

    always @ (posedge clk, operandA, operandB, function_select_lines) begin
        case(function_select_lines)
            4'b0000: begin
                         SREG <= 4'b0000;
                         reg_out <= reg_out;
                     end
            4'b0001: begin
                         {SREG[1], reg_out} = operandA+operandB;
                         SREG[0] = (reg_out === 0)?1:0;
                         SREG[2] = reg_out[7];
                         SREG[3] = (~reg_out[7]&operandA[7]&operandB[7]) | (reg_out[7]&~operandA[7]&~operandB[7]);
                     end
            4'b0010: begin
                         {SREG[1], reg_out} = operandA-operandB;
                         SREG[0] = (reg_out === 0)?1:0;
                         SREG[2] = reg_out[7];
                         SREG[3] = (~reg_out[7]&operandA[7]&~operandB[7]) | (reg_out[7]&~operandA[7]&operandB[7]);
                     end
            4'b0011: begin
                         {SREG[1], reg_out} = operandA+operandB+SREG[1];
                         SREG[0] = (reg_out === 0)?1:0;
                         SREG[2] = reg_out[7];
                         SREG[3] = (~reg_out[7]&operandA[7]&operandB[7]) | (reg_out[7]&~operandA[7]&~operandB[7]);
                     end
            4'b0100: begin
                         {SREG[1], reg_out} = operandA-operandB-SREG[1];
                         SREG[0] = (reg_out === 0)?1:0;
                         SREG[2] = reg_out[7];
                         SREG[3] = (~reg_out[7]&operandA[7]&~operandB[7]) | (reg_out[7]&~operandA[7]&operandB[7]);
                     end
            4'b0101: begin
                         SREG[0] <= ({operandA[7], operandA} <= {operandB[7], operandB})?1:0;
                         SREG[1] <= 1'b0;
                         SREG[2] <= 1'b0;
                         SREG[3] <= 1'b0;
                     end
            4'b0110: begin
                         SREG[3:1] <= 3'b000;
                         reg_out = operandA|operandB;
                         SREG[0] = (reg_out === 0)?1:0;
                     end
            4'b0111: begin
                         SREG[3:1] <= 3'b000;
                         reg_out = operandA&operandB;
                         SREG[0] = (reg_out === 0)?1:0;
                     end
            4'b1000: begin
                         
            default: begin
                         SREG <= 4'b0000;
                         reg_out <= reg_out;
                     end
        endcase
    end
endmodule
