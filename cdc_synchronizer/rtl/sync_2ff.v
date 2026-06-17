`timescale 1ns/1ps

module sync_2ff (
    input  wire clk_dst,
    input  wire rstn_dst,
    input  wire async_in,
    output wire sync_out
);

    reg ff1;
    reg ff2;

    always @(posedge clk_dst or negedge rstn_dst) begin
        if (!rstn_dst) begin
            ff1 <= 1'b0;
            ff2 <= 1'b0;
        end else begin
            ff1 <= async_in;
            ff2 <= ff1;
        end
    end

    assign sync_out = ff2;

endmodule