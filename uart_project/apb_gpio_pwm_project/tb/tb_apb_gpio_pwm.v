`timescale 1ns/1ps

module tb_apb_gpio_pwm;

    reg         PCLK;
    reg         PRESETn;
    reg         PSEL;
    reg         PENABLE;
    reg         PWRITE;
    reg  [7:0]  PADDR;
    reg  [31:0] PWDATA;

    wire [31:0] PRDATA;
    wire        PREADY;
    wire [7:0]  gpio_out;
    wire        pwm_out;

    apb_gpio_pwm dut (
        .PCLK(PCLK),
        .PRESETn(PRESETn),
        .PSEL(PSEL),
        .PENABLE(PENABLE),
        .PWRITE(PWRITE),
        .PADDR(PADDR),
        .PWDATA(PWDATA),
        .PRDATA(PRDATA),
        .PREADY(PREADY),
        .gpio_out(gpio_out),
        .pwm_out(pwm_out)
    );

    always #5 PCLK = ~PCLK;

    task apb_write;
        input [7:0] addr;
        input [31:0] data;
        begin
            @(posedge PCLK);
            PSEL    = 1'b1;
            PENABLE = 1'b0;
            PWRITE  = 1'b1;
            PADDR   = addr;
            PWDATA  = data;

            @(posedge PCLK);
            PENABLE = 1'b1;

            @(posedge PCLK);
            PSEL    = 1'b0;
            PENABLE = 1'b0;
            PWRITE  = 1'b0;
        end
    endtask

    task apb_read;
        input [7:0] addr;
        begin
            @(posedge PCLK);
            PSEL    = 1'b1;
            PENABLE = 1'b0;
            PWRITE  = 1'b0;
            PADDR   = addr;

            @(posedge PCLK);
            PENABLE = 1'b1;

            @(posedge PCLK);
            $display("Read Address = %h, Read Data = %h", addr, PRDATA);

            PSEL    = 1'b0;
            PENABLE = 1'b0;
        end
    endtask

    initial begin
        PCLK    = 1'b0;
        PRESETn = 1'b0;
        PSEL    = 1'b0;
        PENABLE = 1'b0;
        PWRITE  = 1'b0;
        PADDR   = 8'h00;
        PWDATA  = 32'h00000000;

        #20;
        PRESETn = 1'b1;

        apb_write(8'h00, 32'h000000AA);
        apb_read(8'h00);

        apb_write(8'h04, 32'd20);
        apb_write(8'h08, 32'd5);
        apb_write(8'h0C, 32'd1);

        apb_read(8'h04);
        apb_read(8'h08);
        apb_read(8'h0C);

        #500;

        apb_write(8'h0C, 32'd0);

        #100;
        $stop;
    end

endmodule