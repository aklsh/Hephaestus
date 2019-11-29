module ALU (output reg[7:0] reg_out, output reg[3:0] SREG, input[3:0] function_select_lines, input[7:0] operandA, input[7:0] operandB);
    /*
    wire adderSubtractor_enable;
    wire increment_enable;
    wire comparator_enable;
    wire or_enable;
    wire and_enable;
    wire shifter_enable;
    wire not_enable;

    assign adderSubtractor_enable = (function_select_lines[3:1] == 3'b000)?1:0;
    assign incrementer_enable = (function_select_lines == 4'b0010)?1:0;
    assign comparator_enable = (function_select_lines == 4'b0011)?1:0;
    assign or_enable = (function_select_lines == 4'b0100)?1:0;
    assign and_enable = (function_select_lines == 4'b0101)?1:0;
    assign shifter_enable = (function_select_lines[3:1] == 3'b011)?1:0;
    assign not_enable = (function_select_lines == 4'b1000)?1:0;
    assign xor_enable = (function_select_lines == 4'b1001)?1:0;


    adderSubtractor8Bit adder_subtractor (SREG, reg_out, operandA, operandB, function_select_lines[0], adderSubtractor_enable);
    adderSubtractor8Bit incrementer (SREG, operandA, operandA, 8'b1, 1'b0, incrementer_enable);
    */
    always @ (function_select_lines, operandA, operandB) begin
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
                         {SREG[1], reg_out} <= operandA-operandB-SREG[1];
                         SREG[0] <= (reg_out === 0)?1:0;
                         SREG[2] <= reg_out[7];
                         SREG[3] <= (~reg_out[7]&operandA[7]&~operandB[7]) | (reg_out[7]&~operandA[7]&operandB[7]);
                     end
            4'b0101: begin
                         SREG[0] <= (operandA <= operandB)?1:0;
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
            default: begin
                         SREG <= 4'b0000;
                         reg_out <= reg_out;
                     end
        endcase
    end
endmodule
