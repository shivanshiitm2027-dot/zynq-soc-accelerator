`timescale 1ns/1ps

module simple_reg_block (
    input  wire        clk,
    input  wire        rstn,

    // Simple write interface
    input  wire        wr_en,
    input  wire [7:0]  wr_addr,
    input  wire [31:0] wr_data,

    // Simple read interface
    input  wire        rd_en,
    input  wire [7:0]  rd_addr,
    output reg  [31:0] rd_data,

    // Debug/status output
    output reg         done
);

    // Register addresses
    localparam ADDR_CTRL   = 8'h00;
    localparam ADDR_STATUS = 8'h04;
    localparam ADDR_DATA_A = 8'h08;
    localparam ADDR_DATA_B = 8'h0C;
    localparam ADDR_RESULT = 8'h10;

    // Internal registers
    reg [31:0] ctrl_reg;
    reg [31:0] status_reg;
    reg [31:0] data_a_reg;
    reg [31:0] data_b_reg;
    reg [31:0] result_reg;

    wire start;
    assign start = ctrl_reg[0];

    // Write + compute logic
    always @(posedge clk or negedge rstn) begin
        if (!rstn) begin
            ctrl_reg   <= 32'd0;
            status_reg <= 32'd0;
            data_a_reg <= 32'd0;
            data_b_reg <= 32'd0;
            result_reg <= 32'd0;
            done       <= 1'b0;
        end else begin
            done <= 1'b0;

            // Register write
            if (wr_en) begin
                case (wr_addr)
                    ADDR_CTRL: begin
                        ctrl_reg <= wr_data;
                        status_reg[0] <= 1'b0;   // clear done when starting new command
                    end

                    ADDR_DATA_A: begin
                        data_a_reg <= wr_data;
                    end

                    ADDR_DATA_B: begin
                        data_b_reg <= wr_data;
                    end

                    default: begin
                        // no write
                    end
                endcase
            end

            // Hardware operation
            if (start) begin
                result_reg    <= data_a_reg + data_b_reg;
                status_reg[0] <= 1'b1;   // done bit
                done          <= 1'b1;
                ctrl_reg[0]   <= 1'b0;   // auto-clear start bit
            end
        end
    end

    // Read logic
    always @(*) begin
        rd_data = 32'd0;

        if (rd_en) begin
            case (rd_addr)
                ADDR_CTRL:   rd_data = ctrl_reg;
                ADDR_STATUS: rd_data = status_reg;
                ADDR_DATA_A: rd_data = data_a_reg;
                ADDR_DATA_B: rd_data = data_b_reg;
                ADDR_RESULT: rd_data = result_reg;
                default:     rd_data = 32'hDEAD_BEEF;
            endcase
        end
    end

endmodule