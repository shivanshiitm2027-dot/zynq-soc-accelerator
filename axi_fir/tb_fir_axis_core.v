`timescale 1ns/1ps

module tb_fir_axis_core;

    reg clk;
    reg rstn;

    reg signed [15:0] s_axis_tdata;
    reg s_axis_tvalid;
    wire s_axis_tready;

    wire signed [31:0] m_axis_tdata;
    wire m_axis_tvalid;
    reg m_axis_tready;

    fir_axis_core dut (
        .clk(clk),
        .rstn(rstn),

        .s_axis_tvalid(s_axis_tvalid),
        .s_axis_tready(s_axis_tready),
        .s_axis_tdata(s_axis_tdata),

        .m_axis_tvalid(m_axis_tvalid),
        .m_axis_tready(m_axis_tready),
        .m_axis_tdata(m_axis_tdata)
    );

    // Clock generation: 10 ns period
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    // Task to send one input sample
    task send_sample;
        input signed [15:0] sample;
        begin
            @(posedge clk);
            s_axis_tvalid <= 1'b1;
            s_axis_tdata  <= sample;

            while (!s_axis_tready) begin
                @(posedge clk);
            end

            @(posedge clk);
            s_axis_tvalid <= 1'b0;
            s_axis_tdata  <= 16'sd0;
        end
    endtask

    initial begin
        // For GTKWave waveform
        $dumpfile("dump.vcd");
        $dumpvars(0, tb_fir_axis_core);

        rstn = 0;
        s_axis_tvalid = 0;
        s_axis_tdata = 0;
        m_axis_tready = 1;

        #50;
        rstn = 1;

        send_sample(16'sd10);
        send_sample(16'sd20);
        send_sample(16'sd30);
        send_sample(16'sd40);
        send_sample(16'sd50);
        send_sample(16'sd60);

        #100;
        $finish;
    end

    always @(posedge clk) begin
        if (rstn && m_axis_tvalid && m_axis_tready) begin
            $display("Time=%0t | Output y = %0d", $time, m_axis_tdata);
        end
    end

endmodule