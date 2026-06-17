`timescale 1ns / 1ps

module axi_lite_reg_block (
    input  wire        clk,
    input  wire        resetn,

    // Write address channel
    input  wire [31:0] awaddr,
    input  wire        awvalid,
    output reg         awready,

    // Write data channel
    input  wire [31:0] wdata,
    input  wire        wvalid,
    output reg         wready,

    // Write response channel
    output reg  [1:0]  bresp,
    output reg         bvalid,
    input  wire        bready,

    // Read address channel
    input  wire [31:0] araddr,
    input  wire        arvalid,
    output reg         arready,

    // Read data channel
    output reg  [31:0] rdata,
    output reg  [1:0]  rresp,
    output reg         rvalid,
    input  wire        rready
);

    // Internal registers
    reg [31:0] reg0_control;
    reg [31:0] reg1_status;
    reg [31:0] reg2_data;
    reg [31:0] reg3_config;

    // Address decode
    localparam ADDR_REG0 = 32'h00;
    localparam ADDR_REG1 = 32'h04;
    localparam ADDR_REG2 = 32'h08;
    localparam ADDR_REG3 = 32'h0C;

    // Write logic
    always @(posedge clk) begin
        if (!resetn) begin
            awready      <= 0;
            wready       <= 0;
            bvalid       <= 0;
            bresp        <= 2'b00;

            reg0_control <= 32'h00000000;
            reg1_status  <= 32'h000000A5;
            reg2_data    <= 32'h00000000;
            reg3_config  <= 32'h00000000;
        end else begin
            awready <= 0;
            wready  <= 0;

            if (awvalid && wvalid && !bvalid) begin
                awready <= 1;
                wready  <= 1;

                case (awaddr[3:0])
                    ADDR_REG0[3:0]: reg0_control <= wdata;
                    ADDR_REG1[3:0]: reg1_status  <= wdata;
                    ADDR_REG2[3:0]: reg2_data    <= wdata;
                    ADDR_REG3[3:0]: reg3_config  <= wdata;
                    default: ;
                endcase

                bvalid <= 1;
                bresp  <= 2'b00;   // OKAY response
            end

            if (bvalid && bready) begin
                bvalid <= 0;
            end
        end
    end

    // Read logic
    always @(posedge clk) begin
        if (!resetn) begin
            arready <= 0;
            rvalid  <= 0;
            rdata   <= 32'h00000000;
            rresp   <= 2'b00;
        end else begin
            arready <= 0;

            if (arvalid && !rvalid) begin
                arready <= 1;

                case (araddr[3:0])
                    ADDR_REG0[3:0]: rdata <= reg0_control;
                    ADDR_REG1[3:0]: rdata <= reg1_status;
                    ADDR_REG2[3:0]: rdata <= reg2_data;
                    ADDR_REG3[3:0]: rdata <= reg3_config;
                    default:        rdata <= 32'hDEADBEEF;
                endcase

                rvalid <= 1;
                rresp  <= 2'b00;   // OKAY response
            end

            if (rvalid && rready) begin
                rvalid <= 0;
            end
        end
    end

endmodule