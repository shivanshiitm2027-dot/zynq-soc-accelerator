module fir_filter (
    input  wire        clk,
    input  wire        rst,

    input  wire        in_valid,
    input  wire [31:0] in_data,
    output wire        in_ready,

    output reg         out_valid,
    output reg  [31:0] out_data,
    input  wire        out_ready
);

    reg [31:0] x0, x1, x2, x3;

    assign in_ready = out_ready;

    always @(posedge clk) begin
        if (rst) begin
            x0 <= 0;
            x1 <= 0;
            x2 <= 0;
            x3 <= 0;
            out_valid <= 0;
            out_data <= 0;
        end else begin
            if (in_valid && in_ready) begin
                x3 <= x2;
                x2 <= x1;
                x1 <= x0;
                x0 <= in_data;

                // Simple 4-tap FIR: y[n] = x0 + x1 + x2 + x3
                out_data <= in_data + x0 + x1 + x2;
                out_valid <= 1;
            end else if (out_ready) begin
                out_valid <= 0;
            end
        end
    end

endmodule