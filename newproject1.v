
`timescale 1ns/1ps
module tb_shift_register;
    reg clk; reg rst_n; reg load; reg shift;
    reg [7:0] d_in; reg serial_in; wire [7:0] q;

    shift_register uut (
        .clk(clk),
        .rst_n(rst_n),
        .load(load),
        .shift(shift),
        .d_in(d_in),
        .serial_in(serial_in),
        .q(q)
    );

    initial clk = 0;
    always #5 clk = ~clk;

    initial begin
        rst_n = 0; load = 0; shift = 0; d_in = 8'b00000000; serial_in = 0;
        #10; rst_n = 1; #10;

        load = 1; d_in = 8'b10101010; #10; load = 0;
        shift = 1; serial_in = 1; #10;
        serial_in = 0; #10;
        shift = 0; #10;

        $finish;
    end
endmodule
