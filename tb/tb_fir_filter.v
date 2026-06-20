`timescale 1ns/1ps

module tb_fir_filter;

    reg clk;
    reg rst;

    reg in_valid;
    reg [31:0] in_data;
    wire in_ready;

    wire out_valid;
    wire [31:0] out_data;
    reg out_ready;

    fir_filter dut (
        .clk(clk),
        .rst(rst),
        .in_valid(in_valid),
        .in_data(in_data),
        .in_ready(in_ready),
        .out_valid(out_valid),
        .out_data(out_data),
        .out_ready(out_ready)
    );

    always #5 clk = ~clk;

    integer i;

    task send_sample;
        input [31:0] sample;
        begin
            @(negedge clk);
            in_valid = 1;
            in_data  = sample;

            @(negedge clk);
            in_valid = 0;
            in_data  = 0;
        end
    endtask

    initial begin
        $dumpfile("sim/fir_filter.vcd");
        $dumpvars(0, tb_fir_filter);

        clk = 0;
        rst = 1;
        in_valid = 0;
        in_data = 0;
        out_ready = 1;

        #30;
        rst = 0;

        send_sample(10);
        send_sample(20);
        send_sample(30);
        send_sample(40);
        send_sample(50);
        send_sample(60);
        send_sample(70);
        send_sample(80);

        #100;
        $finish;
    end

    always @(posedge clk) begin
        if (out_valid) begin
            $display("Time=%0t Output=%0d", $time, out_data);
        end
    end

endmodule