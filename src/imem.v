//**************************************************************
// Assignment 5, 6, 7, 8
// File name: imem.v
// Last modified: 2020-10-05 22:23
// Created by: Akilesh Kannan EE18B122
// Description: Instruction Memory Module
//              - 32-bit instructions
//              - Maximum of 4096 instructions
// TODO: parameterise no. of instructions for configurability
//**************************************************************

`timescale 1ns/1ps
`ifndef TESTDIR
  `define TESTDIR "."
`endif

module imem ( input [31:0] iaddr,
              output [31:0] idata
            );

    // Ignores LSB 2 bits, so will not generate alignment exception
    reg [31:0] mem[0:4095]; // Define a 4-K location memory (16KB)

    //////////////////////////////////////////////////////////////////
    // Instruction Memory is designed for 32-bit instructions
    // -> 4K location, 16KB total
    // -> the iaddr corresponds to byte number
    // -> to get line number, remove last 2 bits
    //
    //                Byte 0     Byte 1     Byte 2     Byte 3
    //             +----------+----------+----------+----------+
    // instr x     |          |          |          |          |
    //             +----------+----------+----------+----------+
    // instr x+1   |          |          |          |          |
    //             +----------+----------+----------+----------+
    //
    //////////////////////////////////////////////////////////////////

    // initialise memory
    initial
        $readmemh({`TESTDIR,"/idata.mem"},mem);

    // read instruction at required location
    assign idata = mem[iaddr[31:2]];

endmodule
