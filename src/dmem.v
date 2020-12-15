//**************************************************************
// Assignment 5
// File name: dmem.v
// Last modified: 2020-10-01 12:25
// Created by: Akilesh Kannan EE18B122
// Description: Data Memory
// TODO: Parameterise line numbers and (word size?)
//**************************************************************

`timescale 1ns/1ps
`define DMEM_N_FILE(x,y) {x,y,".mem"}
`define MEMTOP 4095
`ifndef TESTDIR
  `define TESTDIR "."
`endif

module dmem ( input clk,                // clock input
              input [31:0] daddr,       // start address to read/write to/from
              input [31:0] dwdata,      // write data bus
              input [3:0] dwe,          // write enable
              output [31:0] drdata      // read data bus
            );

    //////////////////////////////////////////////////////////////////
    // Data Memory is designed like this, and is byte-addressable
    // -> 4K location, 16KB total, split in 4 banks
    //
    //                Byte 0     Byte 1     Byte 2     Byte 3
    //             +----------+----------+----------+----------+
    // line x      |          |          |          |          |
    //             +----------+----------+----------+----------+
    // line x+1    |          |          |          |          |
    //             +----------+----------+----------+----------+
    // line number -> address
    //
    //////////////////////////////////////////////////////////////////

    // 4K location, 16KB total, split in 4 banks
    reg [7:0] mem0[0:`MEMTOP];
    reg [7:0] mem1[0:`MEMTOP];
    reg [7:0] mem2[0:`MEMTOP];
    reg [7:0] mem3[0:`MEMTOP];
    reg [31:0] memt[0:`MEMTOP]; // temp to read

    // line number for dMEM
    wire [29:0] a;
    integer i;

    initial begin
        $readmemh({`TESTDIR,"/idata.mem"}, memt);
        for (i=0; i<2372; i=i+1) begin
            mem0[i] = memt[i][ 7: 0];
            mem1[i] = memt[i][15: 8];
            mem2[i] = memt[i][23:16];
            mem3[i] = memt[i][31:24];
        end
    end

    // assigning line number
    assign a = daddr[31:2];

    // Selecting bytes to be done inside CPU
    assign drdata = { mem3[a], mem2[a], mem1[a], mem0[a]};

    // synchronous write
    always @(posedge clk) begin
        if (dwe[3]) mem3[a] <= dwdata[31:24];
        if (dwe[2]) mem2[a] <= dwdata[23:16];
        if (dwe[1]) mem1[a] <= dwdata[15: 8];
        if (dwe[0]) mem0[a] <= dwdata[ 7: 0];
    end

endmodule
