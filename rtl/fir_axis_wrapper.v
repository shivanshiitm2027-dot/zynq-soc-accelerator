module fir_axis_wrapper (
    input  wire        aclk,
    input  wire        aresetn,

    // AXI Stream Slave Input
    input  wire [31:0] s_axis_tdata,
    input  wire        s_axis_tvalid,
    input  wire        s_axis_tlast,
    output wire        s_axis_tready,

    // AXI Stream Master Output
    output wire [31:0] m_axis_tdata,
    output wire        m_axis_tvalid,
    output wire        m_axis_tlast,
    input  wire        m_axis_tready
);

    wire rst;
    assign rst = ~aresetn;

    fir_filter u_fir_filter (
        .clk       (aclk),
        .rst       (rst),

        .in_valid  (s_axis_tvalid),
        .in_data   (s_axis_tdata),
        .in_ready  (s_axis_tready),

        .out_valid (m_axis_tvalid),
        .out_data  (m_axis_tdata),
        .out_ready (m_axis_tready)
    );

    // Pass packet-end information from DMA input stream to DMA output stream
    assign m_axis_tlast = s_axis_tlast;

endmodule