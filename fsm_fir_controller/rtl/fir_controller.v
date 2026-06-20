`timescale 1ns/1ps

module fir_controller (
    input  wire clk,
    input  wire rstn,
    input  wire start,
    input  wire sample_done,

    output reg  busy,
    output reg  done,
    output reg  enable_filter
);

    localparam IDLE    = 2'b00;
    localparam RUN     = 2'b01;
    localparam DONE_ST = 2'b10;

    reg [1:0] state, next_state;

    // State register
    always @(posedge clk or negedge rstn) begin
        if (!rstn)
            state <= IDLE;
        else
            state <= next_state;
    end

    // Next-state logic
    always @(*) begin
        next_state = state;

        case (state)
            IDLE: begin
                if (start)
                    next_state = RUN;
            end

            RUN: begin
                if (sample_done)
                    next_state = DONE_ST;
            end

            DONE_ST: begin
                next_state = IDLE;
            end

            default: begin
                next_state = IDLE;
            end
        endcase
    end

    // Moore output logic
    always @(*) begin
        busy          = 1'b0;
        done          = 1'b0;
        enable_filter = 1'b0;

        case (state)
            IDLE: begin
                busy          = 1'b0;
                done          = 1'b0;
                enable_filter = 1'b0;
            end

            RUN: begin
                busy          = 1'b1;
                done          = 1'b0;
                enable_filter = 1'b1;
            end

            DONE_ST: begin
                busy          = 1'b0;
                done          = 1'b1;
                enable_filter = 1'b0;
            end
        endcase
    end

endmodule