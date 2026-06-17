module uart_fifo_top (
    input  wire       clk,
    input  wire       reset,

    input  wire       tx_fifo_wr_en,
    input  wire [7:0] tx_fifo_wr_data,
    output wire       tx_fifo_full,

    input  wire       rx_fifo_rd_en,
    output wire [7:0] rx_fifo_rd_data,
    output wire       rx_fifo_empty,

    output wire       tx_line,
    output wire       tx_busy,
    output wire       tx_done,
    output wire       rx_done
);

    wire baud_tick;

    wire [7:0] tx_fifo_rd_data;
    wire       tx_fifo_empty;
    reg        tx_fifo_rd_en;

    reg        tx_start;
    reg  [7:0] tx_data_reg;

    wire [7:0] rx_data_wire;
    wire       rx_fifo_full;
    wire       rx_fifo_wr_en;

    localparam TX_IDLE      = 2'd0;
    localparam TX_READ_FIFO = 2'd1;
    localparam TX_START     = 2'd2;
    localparam TX_WAIT      = 2'd3;

    reg [1:0] tx_ctrl_state;

    baud_gen #(
        .CLK_FREQ(50000000),
        .BAUD_RATE(9600)
    ) baud_gen_inst (
        .clk(clk),
        .reset(reset),
        .baud_tick(baud_tick)
    );

    fifo #(
        .DATA_WIDTH(8),
        .DEPTH(16),
        .ADDR_WIDTH(4)
    ) tx_fifo_inst (
        .clk(clk),
        .reset(reset),
        .wr_en(tx_fifo_wr_en),
        .wr_data(tx_fifo_wr_data),
        .full(tx_fifo_full),
        .rd_en(tx_fifo_rd_en),
        .rd_data(tx_fifo_rd_data),
        .empty(tx_fifo_empty)
    );

    uart_tx tx_inst (
        .clk(clk),
        .reset(reset),
        .baud_tick(baud_tick),
        .tx_start(tx_start),
        .tx_data(tx_data_reg),
        .tx(tx_line),
        .tx_busy(tx_busy),
        .tx_done(tx_done)
    );

    uart_rx rx_inst (
        .clk(clk),
        .reset(reset),
        .baud_tick(baud_tick),
        .rx(tx_line),
        .rx_data(rx_data_wire),
        .rx_done(rx_done)
    );

    assign rx_fifo_wr_en = rx_done && !rx_fifo_full;

    fifo #(
        .DATA_WIDTH(8),
        .DEPTH(16),
        .ADDR_WIDTH(4)
    ) rx_fifo_inst (
        .clk(clk),
        .reset(reset),
        .wr_en(rx_fifo_wr_en),
        .wr_data(rx_data_wire),
        .full(rx_fifo_full),
        .rd_en(rx_fifo_rd_en),
        .rd_data(rx_fifo_rd_data),
        .empty(rx_fifo_empty)
    );

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            tx_ctrl_state <= TX_IDLE;
            tx_fifo_rd_en <= 1'b0;
            tx_start      <= 1'b0;
            tx_data_reg   <= 8'd0;
        end else begin
            tx_fifo_rd_en <= 1'b0;
            tx_start      <= 1'b0;

            case (tx_ctrl_state)

                TX_IDLE: begin
                    if (!tx_fifo_empty && !tx_busy) begin
                        tx_fifo_rd_en <= 1'b1;
                        tx_ctrl_state <= TX_READ_FIFO;
                    end
                end

                TX_READ_FIFO: begin
                    tx_data_reg   <= tx_fifo_rd_data;
                    tx_ctrl_state <= TX_START;
                end

                TX_START: begin
                    tx_start      <= 1'b1;
                    tx_ctrl_state <= TX_WAIT;
                end

                TX_WAIT: begin
                    if (tx_done) begin
                        tx_ctrl_state <= TX_IDLE;
                    end
                end

                default: begin
                    tx_ctrl_state <= TX_IDLE;
                end

            endcase
        end
    end

endmodule