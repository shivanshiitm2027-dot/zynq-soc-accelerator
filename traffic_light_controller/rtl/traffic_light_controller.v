`timescale 1ns / 1ps

module traffic_light_controller (
    input  wire clk,
    input  wire resetn,

    output reg main_red,
    output reg main_yellow,
    output reg main_green,

    output reg side_red,
    output reg side_yellow,
    output reg side_green
);

    // FSM states
    localparam MAIN_GREEN  = 2'b00;
    localparam MAIN_YELLOW = 2'b01;
    localparam SIDE_GREEN  = 2'b10;
    localparam SIDE_YELLOW = 2'b11;

    reg [1:0] state;
    reg [3:0] counter;

    // State transition + counter
    always @(posedge clk) begin
        if (!resetn) begin
            state   <= MAIN_GREEN;
            counter <= 4'd0;
        end else begin
            case (state)

                MAIN_GREEN: begin
                    if (counter == 4'd9) begin
                        counter <= 4'd0;
                        state   <= MAIN_YELLOW;
                    end else begin
                        counter <= counter + 1;
                    end
                end

                MAIN_YELLOW: begin
                    if (counter == 4'd2) begin
                        counter <= 4'd0;
                        state   <= SIDE_GREEN;
                    end else begin
                        counter <= counter + 1;
                    end
                end

                SIDE_GREEN: begin
                    if (counter == 4'd6) begin
                        counter <= 4'd0;
                        state   <= SIDE_YELLOW;
                    end else begin
                        counter <= counter + 1;
                    end
                end

                SIDE_YELLOW: begin
                    if (counter == 4'd2) begin
                        counter <= 4'd0;
                        state   <= MAIN_GREEN;
                    end else begin
                        counter <= counter + 1;
                    end
                end

                default: begin
                    state   <= MAIN_GREEN;
                    counter <= 4'd0;
                end

            endcase
        end
    end

    // Output logic
    always @(*) begin
        main_red    = 0;
        main_yellow = 0;
        main_green  = 0;

        side_red    = 0;
        side_yellow = 0;
        side_green  = 0;

        case (state)

            MAIN_GREEN: begin
                main_green = 1;
                side_red   = 1;
            end

            MAIN_YELLOW: begin
                main_yellow = 1;
                side_red    = 1;
            end

            SIDE_GREEN: begin
                main_red   = 1;
                side_green = 1;
            end

            SIDE_YELLOW: begin
                main_red    = 1;
                side_yellow = 1;
            end

            default: begin
                main_green = 1;
                side_red   = 1;
            end

        endcase
    end

endmodule