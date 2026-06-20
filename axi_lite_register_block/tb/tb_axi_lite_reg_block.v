`timescale 1ns / 1ps

module tb_axi_lite_reg_block;

    reg clk;
    reg resetn;

    reg  [31:0] awaddr;
    reg         awvalid;
    wire        awready;

    reg  [31:0] wdata;
    reg         wvalid;
    wire        wready;

    wire [1:0]  bresp;
    wire        bvalid;
    reg         bready;

    reg  [31:0] araddr;
    reg         arvalid;
    wire        arready;

    wire [31:0] rdata;
    wire [1:0]  rresp;
    wire        rvalid;
    reg         rready;

    axi_lite_reg_block dut (
        .clk(clk),
        .resetn(resetn),

        .awaddr(awaddr),
        .awvalid(awvalid),
        .awready(awready),

        .wdata(wdata),
        .wvalid(wvalid),
        .wready(wready),

        .bresp(bresp),
        .bvalid(bvalid),
        .bready(bready),

        .araddr(araddr),
        .arvalid(arvalid),
        .arready(arready),

        .rdata(rdata),
        .rresp(rresp),
        .rvalid(rvalid),
        .rready(rready)
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk;   // 100 MHz clock
    end

    // AXI write task
    task axi_write;
        input [31:0] addr;
        input [31:0] data;
        begin
            @(posedge clk);
            awaddr  <= addr;
            awvalid <= 1;
            wdata   <= data;
            wvalid  <= 1;
            bready  <= 1;

            wait (awready && wready);

            @(posedge clk);
            awvalid <= 0;
            wvalid  <= 0;

            wait (bvalid);

            @(posedge clk);
            bready <= 0;

            $display("WRITE: Address = 0x%h, Data = 0x%h", addr, data);
        end
    endtask

    // AXI read task
    task axi_read;
        input [31:0] addr;
        begin
            @(posedge clk);
            araddr  <= addr;
            arvalid <= 1;
            rready  <= 1;

            wait (arready);

            @(posedge clk);
            arvalid <= 0;

            wait (rvalid);

            $display("READ : Address = 0x%h, Data = 0x%h", addr, rdata);

            @(posedge clk);
            rready <= 0;
        end
    endtask

    initial begin
        $dumpfile("sim/axi_lite_reg_block.vcd");
        $dumpvars(0, tb_axi_lite_reg_block);

        // Initial values
        resetn  = 0;
        awaddr  = 0;
        awvalid = 0;
        wdata   = 0;
        wvalid  = 0;
        bready  = 0;
        araddr  = 0;
        arvalid = 0;
        rready  = 0;

        #30;
        resetn = 1;

        // Test writes
        axi_write(32'h00, 32'h11111111);  // reg0_control
        axi_write(32'h04, 32'h22222222);  // reg1_status
        axi_write(32'h08, 32'h33333333);  // reg2_data
        axi_write(32'h0C, 32'h44444444);  // reg3_config

        // Test reads
        axi_read(32'h00);
        axi_read(32'h04);
        axi_read(32'h08);
        axi_read(32'h0C);

        #50;
        $finish;
    end

endmodule