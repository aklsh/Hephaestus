//***********************************************************************
// Single-Cycle RV32I CPU
// File name: alu32.v
// Created by: Akilesh Kannan EE18B122
// Description: Arithmetic Logic Unit
//              - Combinational Unit
//              - Does all arithmetic ops - add, sub etc.
//              - Does all logic ops - and, xor etc.
//              - Does all shifting ops - right-shift, left-shift etc.
//***********************************************************************

module alu32 ( input [5:0] op,      // some input encoding of your choice
               input [31:0] rv1,    // First operand
               input [31:0] rv2,    // Second operand
               output [31:0] rvout  // Output value
             );

    // using localparam statements for readability
    localparam ADD   = 6'd0;
    localparam SLL   = 6'd1;
    localparam SLT   = 6'd2;
    localparam SLTU  = 6'd3;
    localparam XOR   = 6'd4;
    localparam SRL   = 6'd5;
    localparam OR    = 6'd6;
    localparam AND   = 6'd7;
    localparam SRA   = 6'd8;
    localparam SUB   = 6'd9;

    // register to store outputs
    reg [31:0] rvout_r;

    // combinational logic for ALU
    always @(op, rv1, rv2) begin
        case(op)
            ADD:
                rvout_r = rv1 + rv2;
            SUB:
                rvout_r = rv1 - rv2;
            SLL:
                rvout_r = rv1 << rv2;
            SLT:
                rvout_r = $signed(rv1) < $signed(rv2);
            SLTU:
                rvout_r = rv1 < rv2;
            XOR:
                rvout_r = rv1 ^ rv2;
            SRL:
                rvout_r = rv1 >> rv2;
            SRA:
                rvout_r = $signed(rv1) >>> rv2;
            OR:
                rvout_r = rv1 | rv2;
            AND:
                rvout_r = rv1 & rv2;
            default:
                rvout_r = 32'b0;
        endcase
    end

    // assign statements
    assign rvout = rvout_r;
endmodule
