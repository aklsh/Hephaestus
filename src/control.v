//**************************************************************
// Assignment 5, 6
// File name: control.v
// Last modified: 2020-10-02 23:47
// Created by: Akilesh Kannan EE18B122
// Description: CPU Control Module
//              - Generates the control signals required
//                by the ALU and REG-FILE
//**************************************************************

module control ( input [31:0] idata,    // instruction
                 input reset,           // reset
                 output branch,         // branch type instruction
                 output jump,           // jump type instruction
                 output dMEMToReg,      // read from dMEM into Regfile
                 output [5:0] aluOp,    // ALU function lines
                 output [4:0] rs1,      // regfile rs1 address
                 output [4:0] rs2,      // regfile rs2 address
                 output [4:0] rd,       // regfile write address
                 output regOrImm,       // read from regfile or ALU
                 output regWrite        // regfile write signal
               );

    reg dMEMToReg_r, regOrImm_r, regWrite_r, branch_r, jump_r;
    reg [5:0] aluOp_r;
    reg [4:0] rs1_r, rs2_r, rd_r;

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

    always @(idata) begin
        case(idata[6:0])
            // Use ALU to calculate the value to store to regfile rd
            // LUI: rd <-- immediate << 12
            // AUIPC: rd <-- pc + (immediate << 12)
            LUI,
            AUIPC: begin
                branch_r = 1'b0;
                jump_r = 1'b0;
                dMEMToReg_r = 1'b0;
                aluOp_r = 6'd0;
                rs1_r = 5'd0;
                rs2_r = 5'd0;
                rd_r = idata[11:7];
                regOrImm_r = 1'b1;
                regWrite_r = 1'b1;
            end
            JAL: begin
                branch_r = 1'b0;
                jump_r = 1'b1;
                dMEMToReg_r = 1'b0;
                aluOp_r = 6'd0;
                rs1_r = 5'd0;
                rs2_r = 5'd0;
                rd_r = idata[11:7];
                regOrImm_r = 1'b0;
                regWrite_r = 1'b1;
            end
            JALR: begin
                branch_r = 1'b0;
                jump_r = 1'b1;
                dMEMToReg_r = 1'b0;
                aluOp_r = 6'd0;
                rs1_r = idata[19:15];
                rs2_r = 5'd0;
                rd_r = idata[11:7];
                regOrImm_r = 1'b0;
                regWrite_r = 1'b1;
            end
            BXX: begin
                branch_r = 1'b1;
                jump_r = 1'b0;
                dMEMToReg_r = 1'b0;
                case(idata[14:12])
                    3'd0:   // BEQ
                        aluOp_r = 6'd9;
                    3'd1:   // BNE
                        aluOp_r = 6'd9;
                    3'd4:   // BLT
                        aluOp_r = 6'd2;
                    3'd5:   // BGE
                        aluOp_r = 6'd2;
                    3'd6:   // BLTU
                        aluOp_r = 6'd3;
                    3'd7:   // BGEU
                        aluOp_r = 6'd3;
                    default:
                        aluOp_r = 6'd15;
                endcase
                rs1_r = idata[19:15];
                rs2_r = idata[24:20];
                rd_r = 5'd0;
                regOrImm_r = 1'b0;
                regWrite_r = 1'b0;
            end
            LXX: begin
                branch_r = 1'b0;
                jump_r = 1'b0;
                dMEMToReg_r = 1'b1;
                aluOp_r = 6'd0;
                rs1_r = idata[19:15];
                rs2_r = 5'd0;
                rd_r = idata[11:7];
                regOrImm_r = 1'b1;
                regWrite_r = 1'b1;
            end
            SXX: begin
                branch_r = 1'b0;
                jump_r = 1'b0;
                dMEMToReg_r = 1'b0;
                aluOp_r = 6'd0;
                rs1_r = idata[19:15];
                rs2_r = idata[24:20];
                rd_r = 5'd0;
                regOrImm_r = 1'b1;
                regWrite_r = 1'b0;
            end
            IXX: begin
                branch_r = 1'b0;
                jump_r = 1'b0;
                dMEMToReg_r = 1'b0;
                case (idata[14:12])
                    3'd0,   // ADDI
                    3'd2,   // SLTI
                    3'd3,   // SLTU
                    3'd4,   // XORI
                    3'd6,   // ORI
                    3'd7:   // ANDI
                        aluOp_r = {3'd0, idata[14:12]};
                    3'd1:   // SLLI
                        aluOp_r = {3'd0, idata[14:12]};
                    3'd5:   // SRLI or SRAI
                        aluOp_r = (idata[30]) ? 6'd8:6'd5;
                    default:
                        aluOp_r = {3'd0, idata[14:12]};
                endcase
                rs1_r = idata[19:15];
                rs2_r = 5'd0;
                rd_r = idata[11:7];
                regOrImm_r = 1'b1;
                regWrite_r = 1'b1;
            end
            RXX: begin
                branch_r = 1'b0;
                jump_r = 1'b0;
                dMEMToReg_r = 1'b0;
                case(idata[14:12])
                    3'd1,   // SLL
                    3'd2,   // SLT
                    3'd3,   // SLTU
                    3'd4,   // XOR
                    3'd6,   // OR
                    3'd7:   // AND
                        aluOp_r = {3'd0, idata[14:12]};
                    3'd0:   // ADD or SUB
                        aluOp_r = (idata[30]) ? 6'd9:6'd0;
                    3'd5:   // SRL or SRA
                        aluOp_r = (idata[30]) ? 6'd8:6'd5;
                    default:
                        aluOp_r = {3'd0, idata[14:12]};
                endcase
                rs1_r = idata[19:15];
                rs2_r = idata[24:20];
                rd_r = idata[11:7];
                regOrImm_r = 1'b0;
                regWrite_r = 1'b1;
            end
            default: begin // set everything to 0
                branch_r = 1'b0;
                jump_r = 1'b0;
                dMEMToReg_r = 1'b0;
                aluOp_r = 6'd0;
                rs1_r = 5'd0;
                rs2_r = 5'd0;
                rd_r = 5'd0;
                regOrImm_r = 1'b0;
                regWrite_r = 1'b0;
            end
        endcase
    end

    // assigning outputs
    assign branch = ~reset & branch_r;
    assign jump = ~reset & jump_r;
    assign dMEMToReg = ~reset & dMEMToReg_r;
    assign aluOp = ~reset & aluOp_r;
    assign rs1 = ~reset & rs1_r;
    assign rs2 = ~reset & rs2_r;
    assign rd = ~reset & rd_r;
    assign regOrImm = ~reset & regOrImm_r;
    assign regWrite = ~reset & regWrite_r;
endmodule
