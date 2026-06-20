module fsm_vending_machine (
    input  wire clk,
    input  wire reset,
    input  wire coin_5,
    input  wire coin_10,
    output reg  product,
    output reg  change_5
);

    parameter S0  = 2'b00;
    parameter S5  = 2'b01;
    parameter S10 = 2'b10;

    reg [1:0] state, next_state;

    // State register
    always @(posedge clk or posedge reset) begin
        if (reset)
            state <= S0;
        else
            state <= next_state;
    end

    // Next state logic
    always @(*) begin
        next_state = state;
        product = 1'b0;
        change_5 = 1'b0;

        case (state)
            S0: begin
                if (coin_5)
                    next_state = S5;
                else if (coin_10)
                    next_state = S10;
            end

            S5: begin
                if (coin_5) begin
                    next_state = S10;
                end
                else if (coin_10) begin
                    product = 1'b1;
                    change_5 = 1'b0;
                    next_state = S0;
                end
            end

            S10: begin
                product = 1'b1;
                next_state = S0;
            end

            default: begin
                next_state = S0;
            end
        endcase
    end

endmodule