`timescale 1ns/1ps

module tb_simple_reg_block;

    reg clk;
    reg rstn;

    reg        wr_en;
    reg [7:0]  wr_addr;
    reg [31:0] wr_data;

    reg        rd_en;
    reg [7:0]  rd_addr;
    wire [31:0] rd_data;

    wire done;

    simple_reg_block dut (
        .clk(clk),
        .rstn(rstn),

        .wr_en(wr_en),
        .wr_addr(wr_addr),
        .wr_data(wr_data),

        .rd_en(rd_en),
        .rd_addr(rd_addr),
        .rd_data(rd_data),

        .done(done)
    );

    // Clock generation: 100 MHz
    initial begin
        clk = 1'b0;
        forever #5 clk = ~clk;
    end

    // Write task
    task write_reg;
        input [7:0] addr;
        input [31:0] data;
        begin
            @(posedge clk);
            wr_en   <= 1'b1;
            wr_addr <= addr;
            wr_data <= data;

            @(posedge clk);
            wr_en   <= 1'b0;
            wr_addr <= 8'd0;
            wr_data <= 32'd0;
        end
    endtask

    // Read task
    task read_reg;
        input [7:0] addr;
        begin
            @(posedge clk);
            rd_en   <= 1'b1;
            rd_addr <= addr;

            @(posedge clk);
            $display("Read addr 0x%02h = %0d  hex = 0x%08h", addr, rd_data, rd_data);

            rd_en   <= 1'b0;
            rd_addr <= 8'd0;
        end
    endtask

    initial begin
        $dumpfile("sim/dump.vcd");
        $dumpvars(0, tb_simple_reg_block);

        rstn    = 1'b0;
        wr_en   = 1'b0;
        wr_addr = 8'd0;
        wr_data = 32'd0;
        rd_en   = 1'b0;
        rd_addr = 8'd0;

        #30;
        rstn = 1'b1;

        // Write DATA_A = 10
        write_reg(8'h08, 32'd10);

        // Write DATA_B = 25
        write_reg(8'h0C, 32'd25);

        // Write CTRL[0] = 1 to start operation
        write_reg(8'h00, 32'd1);

        // Wait for hardware operation
        repeat (5) @(posedge clk);

        // Read STATUS register
        read_reg(8'h04);

        // Read RESULT register
        read_reg(8'h10);

        #50;
        $finish;
    end

endmodule