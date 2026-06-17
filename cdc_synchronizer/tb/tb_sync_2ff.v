`timescale 1ns/1ps

module tb_sync_2ff;

    reg clk_a;
    reg clk_b;
    reg rstn_b;
    reg async_in;

    wire sync_out;

    sync_2ff dut (
        .clk_dst(clk_b),
        .rstn_dst(rstn_b),
        .async_in(async_in),
        .sync_out(sync_out)
    );

    // Source clock: 100 MHz, 10 ns period
    initial begin
        clk_a = 0;
        forever #5 clk_a = ~clk_a;
    end

    // Destination clock: ~71 MHz, 14 ns period
    initial begin
        clk_b = 0;
        forever #7 clk_b = ~clk_b;
    end

    initial begin
        $dumpfile("sim/dump.vcd");
        $dumpvars(0, tb_sync_2ff);

        rstn_b   = 0;
        async_in = 0;

        #30;
        rstn_b = 1;

        // async_in changes at times not aligned with clk_b
        #17 async_in = 1;
        #38 async_in = 0;
        #23 async_in = 1;
        #41 async_in = 0;
        #29 async_in = 1;
        #35 async_in = 0;

        #80;
        $finish;
    end

endmodule