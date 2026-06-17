`timescale 1ns/1ps

module tb_sync_2ff;

    reg clk_a;
    reg clk_b;
    reg rstn_b;
    reg async_in;

    wire sync_out;

    // Debug wires to show internal FFs in GTKWave
    wire ff1_debug;
    wire ff2_debug;

    sync_2ff dut (
        .clk_dst(clk_b),
        .rstn_dst(rstn_b),
        .async_in(async_in),
        .sync_out(sync_out)
    );

    assign ff1_debug = dut.ff1;
    assign ff2_debug = dut.ff2;

    // Source clock A: 10 ns period
    initial begin
        clk_a = 1'b0;
        forever #5 clk_a = ~clk_a;
    end

    // Destination clock B: 20 ns period
    initial begin
        clk_b = 1'b0;
        forever #10 clk_b = ~clk_b;
    end

    initial begin
        $dumpfile("sim/dump.vcd");
        $dumpvars(0, tb_sync_2ff);

        rstn_b   = 1'b0;
        async_in = 1'b0;

        // Reset active
        #25;
        rstn_b = 1'b1;

        // Make clear async input changes
        #17 async_in = 1'b1;   // async change, not aligned with clk_b
        #80 async_in = 1'b0;

        #35 async_in = 1'b1;
        #70 async_in = 1'b0;

        #60;
        $finish;
    end

endmodule