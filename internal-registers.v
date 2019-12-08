module GPR (output reg[7:0] GPR[7:0], output[7:0] readFromReg, input read_en, input write_en, input[7:0] writeToReg, input[2:0] reg_num, input clk);
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
        if (read_en)
            readFromReg <= GPR[reg_num];
        else if (write_en)
            GPR[reg_num] <= writeToReg;
    end
endmodule
