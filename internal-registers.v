module GPRs (output[7:0] regA_out, regB_out, input readEn, writeEn, input[7:0] regC_in, input[2:0] regA_num, regB_num, regC_num, input clk);
    reg[7:0] GPR[7:0];
    initial begin
        GPR[0] = 8'b0;
        GPR[1] = 8'b0;
        GPR[2] = 8'b0;
        GPR[3] = 8'b0;
        GPR[4] = 8'b0;
        GPR[5] = 8'b0;
        GPR[6] = 8'b0;
        GPR[7] = 8'b0;
    end

    always @ (posedge clk) begin
        if (readEn) begin
            regA_out <= GPR[regA_num];
            regB_out <= GPR[regB_num];
        end
        else if (writeEn)
            GPR[regC_num] <= regC_in;
    end
endmodule
