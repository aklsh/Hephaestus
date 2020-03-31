`include "adder-subtractor.v"
`include "barrel-shifter.v"
`include "comparator.v"
`include "FA.v"
`include "HA.v"
`include "logic-unit.v"
`include "multiplier.v"
`include "mux4to1.v"
`include "mux16to1.v"
`include "rotator.v"


module ALU (output reg[7:0] mul_high, output reg[7:0] result, output reg[3:0] SREG, input[7:0] A, input[7:0] B, input[3:0] fsl);

/*******************
    4-BIT OPCODES
********************/
    parameter ADD = 4'b0000;
    parameter SUB = 4'b0001;
    parameter ADDC = 4'b0010;
    parameter SUBC = 4'b0011;
    parameter XOR = 4'b0100;
    parameter AND = 4'b0101;
    parameter OR = 4'b0110;
    parameter NAND = 4'b0111;
    parameter LOGICALLEFTSHIFT = 4'b1000;
    parameter LOGICALRIGHTSHIFT = 4'b1001;
    parameter ARITHMETICLEFTSHIFT = 4'b1010;
    parameter ARITHMETICRIGHTSHIFT = 4'b1011;
    parameter ROTATELEFT = 4'b1100;
    parameter ROTATERIGHT = 4'b1101;
    parameter MULTIPLY = 4'b1110;
    parameter COMPARE = 4'b1111;

/**************************************************************************************
    STATUS FLAGS

    Status Register:
    +-----+-----+-----+-----+
    |  V  |  S  |  C  |  Z  |
    +-----+-----+-----+-----+

    Z - Zero Flag: Set if result of operation is 0; Cleared otherwise
    C - Carry Flag: Set if operation generates a carry bit; Cleared otherwise
    S - Sign Flag: Set if operation results in a negative number; Cleared otherwise
    V - Overflow Flag: Set if operation results in an overflow,
                       i.e., result cannot be fit into 8 bits.

***************************************************************************************/

    always @(mul_high, result) begin
        SREG[0] = (fsl === COMPARE)?cmpu_out:((fsl === MULTIPLY & ({mul_high, result} === 16'b0))?1:(result===0)?1:0);
        SREG[2] = (fsl === MULTIPLY)?mul_high[7]:result[7];
        SREG[1] = (fsl[3:2] === 2'b00)?asu_carry:((fsl[3:2] === 2'b10)?bsu_carry:0);
        SREG[3] = (fsl[3:2] === 2'b00)?asu_overflow:0;
    end

/***************************************************************************************
    ADDER cum SUBTRACTOR

    OUTPUTS:
            1. OVERFLOW - Set if addition or subtraction results in overflow.
            2. CARRY - Set if carry is generated in addition or subtraction operation.
            3. SUM - Contains the result of addition or subtraction.

    INPUTS:
            1. A - operand 1
            2. B - operand 2
            3. SELECT - Set if subtraction (A - B) to be performed.
                        Cleared if addition (A + B) to be performed.
            4. CARRY_IN - Carry In for addition and subtraction operations.
                          Set only if both CARRY Flag and SUBC are enabled.
*****************************************************************************************/
    wire asu_carry, asu_overflow, asu_CIN;
    wire[7:0] asu_sum;
    assign asu_CIN = fsl[1]&SREG[1];
    adderSubtractor asu (asu_overflow, asu_carry, asu_sum, A, B, fsl[0], asu_CIN);

/*************
    SHIFTER
**************/
    wire[7:0] bsu_out;
    wire bsu_carry;
    barrelShifter bsu (bsu_carry, bsu_out, A, fsl[0], fsl[1]);

/*************
    ROTATOR
**************/
    wire[7:0] ru_out;
    rotator ru (ru_out, A, fsl[0]);

/****************
    LOGIC UNIT
*****************/
    wire[7:0] lu_out;
    logicUnit lu(lu_out, A, B, fsl[1:0]);

/****************
    MULTIPLIER
*****************/
    wire[7:0] mulu_out_high, mulu_out_low;
    multiplier mulu({mulu_out_high, mulu_out_low}, A, B);

/****************
    COMPARATOR
*****************/
    wire cmpu_out;
    comparator cmpu(cmpu_out, A, B);

    wire[7:0] result_continuous;
    multiplexer16to1 muxResult(result_continuous, asu_sum, asu_sum, asu_sum, asu_sum, lu_out, lu_out, lu_out, lu_out, bsu_out, bsu_out, bsu_out, bsu_out, ru_out, ru_out, mulu_out_low, result, fsl[3:0]);

    always @ (*) begin
        {mul_high, result} = {(mulu_out_high&{8{fsl===MULTIPLY}}), result_continuous};
    end
endmodule
