`timescale 1ns/1ps

module fir_axis_core (
    input  wire clk,
    input  wire rstn,

    input  wire        s_axis_tvalid,
    output wire        s_axis_tready,
    input  wire signed [15:0] s_axis_tdata,

    output reg         m_axis_tvalid,
    input  wire        m_axis_tready,
    output reg signed [31:0] m_axis_tdata
);

    parameter signed [15:0] H0 = 16'sd1;
    parameter signed [15:0] H1 = 16'sd2;
    parameter signed [15:0] H2 = 16'sd2;
    parameter signed [15:0] H3 = 16'sd1;

    reg signed [15:0] x0, x1, x2, x3;

    wire signed [31:0] p0, p1, p2, p3;

    wire input_fire;
    wire output_fire;

    assign input_fire  = s_axis_tvalid && s_axis_tready;
    assign output_fire = m_axis_tvalid && m_axis_tready;

    assign s_axis_tready = (!m_axis_tvalid) || output_fire;

    assign p0 = x0 * H0;
    assign p1 = x1 * H1;
    assign p2 = x2 * H2;
    assign p3 = x3 * H3;

    always @(posedge clk) begin
        if (!rstn) begin
            x0 <= 16'sd0;
            x1 <= 16'sd0;
            x2 <= 16'sd0;
            x3 <= 16'sd0;

            m_axis_tvalid <= 1'b0;
            m_axis_tdata  <= 32'sd0;
        end else begin
            if (input_fire) begin
                x3 <= x2;
                x2 <= x1;
                x1 <= x0;
                x0 <= s_axis_tdata;

                m_axis_tdata  <= p0 + p1 + p2 + p3;
                m_axis_tvalid <= 1'b1;
            end else if (output_fire) begin
                m_axis_tvalid <= 1'b0;
            end
        end
    end

endmodule