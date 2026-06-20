module uart_top (
    input  wire       clk,
    input  wire       reset,
    input  wire       tx_start,
    input  wire [7:0] tx_data,
    output wire       tx_line,
    output wire [7:0] rx_data,
    output wire       tx_busy,
    output wire       tx_done,
    output wire       rx_done
);

    wire baud_tick;

    baud_gen #(
        .CLK_FREQ(50000000),
        .BAUD_RATE(9600)
    ) baud_gen_inst (
        .clk(clk),
        .reset(reset),
        .baud_tick(baud_tick)
    );

    uart_tx tx_inst (
        .clk(clk),
        .reset(reset),
        .baud_tick(baud_tick),
        .tx_start(tx_start),
        .tx_data(tx_data),
        .tx(tx_line),
        .tx_busy(tx_busy),
        .tx_done(tx_done)
    );

    uart_rx rx_inst (
        .clk(clk),
        .reset(reset),
        .baud_tick(baud_tick),
        .rx(tx_line),        // TX connected to RX for loopback
        .rx_data(rx_data),
        .rx_done(rx_done)
    );

endmodule