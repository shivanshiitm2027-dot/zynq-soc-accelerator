`timescale 1ns/1ps

module tb_uart_fifo_top;

    reg clk;
    reg reset;

    reg        tx_fifo_wr_en;
    reg [7:0] tx_fifo_wr_data;
    wire       tx_fifo_full;

    reg        rx_fifo_rd_en;
    wire [7:0] rx_fifo_rd_data;
    wire       rx_fifo_empty;

    wire tx_line;
    wire tx_busy;
    wire tx_done;
    wire rx_done;

    uart_fifo_top dut (
        .clk(clk),
        .reset(reset),

        .tx_fifo_wr_en(tx_fifo_wr_en),
        .tx_fifo_wr_data(tx_fifo_wr_data),
        .tx_fifo_full(tx_fifo_full),

        .rx_fifo_rd_en(rx_fifo_rd_en),
        .rx_fifo_rd_data(rx_fifo_rd_data),
        .rx_fifo_empty(rx_fifo_empty),

        .tx_line(tx_line),
        .tx_busy(tx_busy),
        .tx_done(tx_done),
        .rx_done(rx_done)
    );

    always #10 clk = ~clk;

    task write_tx_fifo;
        input [7:0] data;
        begin
            @(posedge clk);
            tx_fifo_wr_data <= data;
            tx_fifo_wr_en   <= 1'b1;
            @(posedge clk);
            tx_fifo_wr_en   <= 1'b0;
        end
    endtask

    task read_rx_fifo;
        begin
            @(posedge clk);
            rx_fifo_rd_en <= 1'b1;
            @(posedge clk);
            rx_fifo_rd_en <= 1'b0;
            @(posedge clk);
            $display("RX FIFO READ DATA = %h", rx_fifo_rd_data);
        end
    endtask

    initial begin
        clk = 0;
        reset = 1;
        tx_fifo_wr_en = 0;
        tx_fifo_wr_data = 8'h00;
        rx_fifo_rd_en = 0;

        #100;
        reset = 0;

        write_tx_fifo(8'hA5);
        write_tx_fifo(8'h3C);
        write_tx_fifo(8'hF0);
        write_tx_fifo(8'h55);

        repeat(4) @(posedge rx_done);

        #100000;

        read_rx_fifo();
        read_rx_fifo();
        read_rx_fifo();
        read_rx_fifo();

        #1000;
        $display("FIFO UART TEST COMPLETED");
        $stop;
    end

endmodule