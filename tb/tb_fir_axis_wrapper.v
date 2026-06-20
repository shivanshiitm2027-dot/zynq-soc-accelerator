`timescale 1ns/1ps

module tb_fir_axis_wrapper;

    reg aclk;
    reg aresetn;

    reg  [31:0] s_axis_tdata;
    reg         s_axis_tvalid;
    wire        s_axis_tready;

    wire [31:0] m_axis_tdata;
    wire        m_axis_tvalid;
    reg         m_axis_tready;

    fir_axis_wrapper dut (
        .aclk(aclk),
        .aresetn(aresetn),

        .s_axis_tdata(s_axis_tdata),
        .s_axis_tvalid(s_axis_tvalid),
        .s_axis_tready(s_axis_tready),

        .m_axis_tdata(m_axis_tdata),
        .m_axis_tvalid(m_axis_tvalid),
        .m_axis_tready(m_axis_tready)
    );

    always #5 aclk = ~aclk;

    task axis_send;
        input [31:0] sample;
        begin
            @(negedge aclk);
            s_axis_tdata  = sample;
            s_axis_tvalid = 1;

            wait(s_axis_tready == 1);

            @(negedge aclk);
            s_axis_tvalid = 0;
            s_axis_tdata  = 0;
        end
    endtask

    initial begin
        $dumpfile("sim/fir_axis_wrapper.vcd");
        $dumpvars(0, tb_fir_axis_wrapper);

        aclk = 0;
        aresetn = 0;

        s_axis_tdata = 0;
        s_axis_tvalid = 0;
        m_axis_tready = 1;

        #30;
        aresetn = 1;

        axis_send(10);
        axis_send(20);
        axis_send(30);
        axis_send(40);
        axis_send(50);
        axis_send(60);
        axis_send(70);
        axis_send(80);

        #100;
        $finish;
    end

    always @(posedge aclk) begin
        if (m_axis_tvalid && m_axis_tready) begin
            $display("AXIS Output = %0d", m_axis_tdata);
        end
    end

endmodule