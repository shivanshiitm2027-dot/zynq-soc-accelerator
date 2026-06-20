`timescale 1ns/1ps

module tb_fir_controller;

    reg clk;
    reg rstn;
    reg start;
    reg sample_done;

    wire busy;
    wire done;
    wire enable_filter;

    fir_controller dut (
        .clk(clk),
        .rstn(rstn),
        .start(start),
        .sample_done(sample_done),
        .busy(busy),
        .done(done),
        .enable_filter(enable_filter)
    );

    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    initial begin
        $dumpfile("sim/dump.vcd");
        $dumpvars(0, tb_fir_controller);

        rstn = 0;
        start = 0;
        sample_done = 0;

        #20;
        rstn = 1;

        // Start FIR operation
        #15;
        start = 1;
        #10;
        start = 0;

        // Processing time
        #60;
        sample_done = 1;
        #10;
        sample_done = 0;

        // Start again
        #40;
        start = 1;
        #10;
        start = 0;

        #50;
        sample_done = 1;
        #10;
        sample_done = 0;

        #40;
        $finish;
    end

endmodule