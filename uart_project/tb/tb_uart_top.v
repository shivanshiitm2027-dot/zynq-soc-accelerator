`timescale 1ns/1ps

module tb_uart_top;

    reg clk;
    reg reset;
    reg tx_start;
    reg [7:0] tx_data;

    wire tx_line;
    wire [7:0] rx_data;
    wire tx_busy;
    wire tx_done;
    wire rx_done;

    uart_top dut (
        .clk(clk),
        .reset(reset),
        .tx_start(tx_start),
        .tx_data(tx_data),
        .tx_line(tx_line),
        .rx_data(rx_data),
        .tx_busy(tx_busy),
        .tx_done(tx_done),
        .rx_done(rx_done)
    );

    // 50 MHz clock = 20 ns
    always #10 clk = ~clk;

    initial begin
        clk = 0;
        reset = 1;
        tx_start = 0;
        tx_data = 8'h00;

        #100;
        reset = 0;

        #100;
        tx_data = 8'hA5;
        tx_start = 1;

        #20;
        tx_start = 0;

        wait(rx_done);

        #1000;

        if (rx_data == 8'hA5)
            $display("TEST PASSED: Received data = %h", rx_data);
        else
            $display("TEST FAILED: Received data = %h", rx_data);

        #1000;
        $stop;
    end

endmodule