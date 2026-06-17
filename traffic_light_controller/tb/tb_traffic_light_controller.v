`timescale 1ns / 1ps

module tb_traffic_light_controller;

    reg clk;
    reg resetn;

    wire main_red;
    wire main_yellow;
    wire main_green;

    wire side_red;
    wire side_yellow;
    wire side_green;

    traffic_light_controller dut (
        .clk(clk),
        .resetn(resetn),

        .main_red(main_red),
        .main_yellow(main_yellow),
        .main_green(main_green),

        .side_red(side_red),
        .side_yellow(side_yellow),
        .side_green(side_green)
    );

    // Clock: 10 ns period
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    initial begin
        $dumpfile("sim/traffic_light.vcd");
        $dumpvars(0, tb_traffic_light_controller);

        resetn = 0;

        #20;
        resetn = 1;

        #400;

        $finish;
    end

    initial begin
        $monitor(
            "Time=%0t | Main RYG=%b%b%b | Side RYG=%b%b%b",
            $time,
            main_red, main_yellow, main_green,
            side_red, side_yellow, side_green
        );
    end

endmodule