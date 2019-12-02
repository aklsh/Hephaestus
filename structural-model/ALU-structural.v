module ALU_struct (output[7:0] mul_high, output[7:0] result, output[3:0] SREG, input[7:0] A, input[7:0] B, input[3:0] fsl);

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


    assign SREG[0] = (result === 0)?1:0;
    assign SREG[2] = result[7];
    assign SREG[1] = (fsl[3:2] === 2'b00)?asu_carry:((fsl === LEFTSHIFT | fsl === RIGHTSHIFT)?bsu_carry:0);
    assign SREG[3] = (fsl === ADD | fsl === SUB)?asu_overflow:0;
    assign mul_high = (fsl === MULTIPLY)?mul_out_high:0;

    wire asu_carry, asu_overflow, Cin;
    wire[7:0] asu_sum;
    adderSubtractor asu (asu_overflow, asu_carry, asu_sum, A, B, fsl[0], fsl[1]&SREG[1]);

    wire[7:0] bsu_out;
    wire bsu_carry;
    barrelShifter bsu (bsu_carry, bsu_out, A, fsl[0], fsl[1]);

    wire[7:0] ru_out;
    rotator ru (ru_out, A, fsl[0]);

    wire[7:0] lu_out;
    logicUnit lu(lu_out, A, B, fsl[1:0]);

    wire[7:0] mulu_out_high, mulu_out_low;
    multiplier mulu({mulu_out_high, mulu_out_low}, A, B);

    wire cmpu_out;
    comparator cmpu(cmpu_out, A, B);

    multiplexer16to1 muxResult(result, asu_sum, asu_sum, asu_sum, asu_sum, lu_out, lu_out, lu_out, lu_out, bsu_out, bsu_out, bsu_out, bsu_out, ru_out, ru_out, mulu_out_low, cmpu_out, fsl);
endmodule
