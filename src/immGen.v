//**************************************************************
// Assignment 5
// File name: immGen.v
// Last modified: 2020-10-03 09:57
// Created by: Akilesh Kannan EE18B122
// Description: Immediate Value Generator
//              - Combinational Unit
//              - Generates all immediate values from the
//                instruction
//**************************************************************

module immGen ( input [31:0] idata,     // instruction
                output [31:0] imm       // immediate value
              );

    // localparam statements for opcodes
    localparam LUI = 7'b0110111;
    localparam AUIPC = 7'b0010111;
    localparam JAL = 7'b1101111;
    localparam JALR = 7'b1100111;
    localparam BXX = 7'b1100011;
    localparam LXX = 7'b0000011;
    localparam SXX = 7'b0100011;
    localparam IXX = 7'b0010011;
    localparam RXX = 7'b0110011;

    // dummy register
    reg [31:0] imm_r;

    // combinational always block
    always @(idata) begin
        // Refer to RV32I ISA manual for extracting
        // immediate value from instruction
        case(idata[6:0])
            LUI,
            AUIPC:
                imm_r = idata[31:12] << 12;
            JAL:
                imm_r = $signed({idata[31], idata[19:12], idata[20], idata[30:21], 1'b0});
            BXX:
                imm_r = $signed({idata[31], idata[7], idata[30:25], idata[11:8], 1'b0});
            SXX:
                imm_r = $signed({idata[31:25], idata[11:7]});
            LXX,
            JALR:
                imm_r = $signed(idata[31:20]);
            IXX:
                case(idata[14:12])
                    3'd0,       // ADDI
                    3'd2,       // SLTI
                    3'd3,       // SLTIU
                    3'd4,       // XORI
                    3'd6,       // ORI
                    3'd7:       // ANDI
                        imm_r = $signed(idata[31:20]);
                    3'd1,       // SLLI
                    3'd5:       // SRLI, SRAI
                        imm_r = {27'b0, idata[24:20]};
                endcase
            RXX:
                imm_r = 32'b0;
            default:
                imm_r = 32'b0;
        endcase
    end

    // assigning outputs
    assign imm = imm_r;

endmodule
