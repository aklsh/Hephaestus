`timescale 1ns/1ns

// This test bench will run for a fixed 1000 clock cycles and then dump out the memory
// Test cases are such that they should finish within this time
// If the CPU continues after this point, it should not result in changes in data
// Safe to assume that imem contains only 0 after the last instruction

// MACROS:
// A single parameter is passed into the code,
// which is the path to the files imem.mem, dmem0-3.mem and expout.mem
// Test cases ensure the files are named appropriately
`ifndef TESTDIR
  `define TESTDIR "."
`endif

module cpu_tb ();
    reg  clk, reset;
    wire [31:0] iaddr, idata, daddr, drdata, dwdata;
    wire [3:0] dwe;
    integer i, s, fail, log_file, exp_file;
    reg [31:0] dtmp, exp_reg;

    // Instantiate the CPU
    cpu u1(
        .clk(clk),
        .reset(reset),
        .iaddr(iaddr),
        .idata(idata),
        .daddr(daddr),
        .drdata(drdata),
        .dwdata(dwdata),
        .dwe(dwe)
    );

    imem u2(
        .iaddr(iaddr),
        .idata(idata)
    );

    dmem u3(
        .clk(clk),
        .daddr(daddr),
        .drdata(drdata),
        .dwdata(dwdata),
        .dwe(dwe)
    );

    // Set up clock
    always #5 clk=~clk;

    initial begin
	// Uncomment below to dump out VCD file for gtkwave
	// NOTE: This will NOT work on the jupyter terminal
        // $dumpfile("cpu_tb.vcd");
        // $dumpvars(0, cpu_tb);
        // for(i=0;i<32;i=i+1)
        //     $dumpvars(0, u1.rf.internalRegisters[i]);
        $display("RUNNING TEST FROM ", `TESTDIR);
        clk = 1;
        reset = 1;   // This is active high reset
        #100         // At least 100 because Xilinx assumes 100ns reset in post-syn sim
        reset = 0;   // Reset removed - normal functioning resumes
        log_file = $fopen("cpu_tb.log", "a");
        exp_file = $fopen({`TESTDIR,"/expout.txt"}, "r");
        @(posedge clk);
        for (i=0; i<1000; i=i+1) begin
            @(posedge clk);
        end

        fail = 0;
        // Dump top dmem
        for (i=0; i<32; i=i+1) begin
            s = $fscanf(exp_file, "%d\n", exp_reg);
            dtmp = {u3.mem3[i], u3.mem2[i], u3.mem1[i], u3.mem0[i]};
            if(exp_reg !== dtmp) begin
                $display("FAIL: Expected Reg[%d] = %x vs. Got Reg[%d] = %x", i, $signed(exp_reg), i, dtmp);
                fail = fail + 1;
            end
        end
        if(fail != 0) begin
            $display("FAILED. %d registers do not match.\n", fail);
            $fwrite(log_file, "FAIL\n");
        end else begin
            $fwrite(log_file, "PASS\n");
        end
        $finish;
    end

endmodule
