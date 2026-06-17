module uart_rx (
    input  wire       clk,
    input  wire       reset,
    input  wire       baud_tick,
    input  wire       rx,
    output reg  [7:0] rx_data,
    output reg        rx_done
);

    localparam IDLE  = 3'd0;
    localparam START = 3'd1;
    localparam DATA  = 3'd2;
    localparam STOP  = 3'd3;
    localparam DONE  = 3'd4;

    reg [2:0] state;
    reg [2:0] bit_index;
    reg [7:0] data_reg;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state     <= IDLE;
            bit_index <= 3'd0;
            data_reg  <= 8'd0;
            rx_data   <= 8'd0;
            rx_done   <= 1'b0;
        end else begin
            rx_done <= 1'b0;

            case (state)

                IDLE: begin
                    bit_index <= 3'd0;

                    if (rx == 1'b0) begin
                        state <= START;
                    end
                end

                START: begin
                    if (baud_tick) begin
                        if (rx == 1'b0) begin
                            state <= DATA;
                        end else begin
                            state <= IDLE;
                        end
                    end
                end

                DATA: begin
                    if (baud_tick) begin
                        data_reg[bit_index] <= rx;

                        if (bit_index == 3'd7) begin
                            bit_index <= 3'd0;
                            state     <= STOP;
                        end else begin
                            bit_index <= bit_index + 1'b1;
                        end
                    end
                end

                STOP: begin
                    if (baud_tick) begin
                        if (rx == 1'b1) begin
                            state <= DONE;
                        end else begin
                            state <= IDLE;
                        end
                    end
                end

                DONE: begin
                    rx_data <= data_reg;
                    rx_done <= 1'b1;
                    state   <= IDLE;
                end

                default: begin
                    state <= IDLE;
                end

            endcase
        end
    end

endmodule