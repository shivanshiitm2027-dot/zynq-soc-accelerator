module fsm_vending_machine (
    input  wire clk,
    input  wire reset,
    input  wire coin_5,
    input  wire coin_10,
    output reg  dispense,
    output reg  change_5
);

    // State encoding
    parameter S0 = 1'b0;   // Rs. 0 inserted
    parameter S5 = 1'b1;   // Rs. 5 inserted

    reg state, next_state;

    // State register
    always @(posedge clk or posedge reset) begin
        if (reset)
            state <= S0;
        else
            state <= next_state;
    end

    // Next-state and output logic
    always @(*) begin
        // Default values
        next_state = state;
        dispense   = 1'b0;
        change_5   = 1'b0;

        case (state)

            S0: begin
                if (coin_5) begin
                    next_state = S5;
                end
                else if (coin_10) begin
                    dispense   = 1'b1;
                    next_state = S0;
                end
                else begin
                    next_state = S0;
                end
            end

            S5: begin
                if (coin_5) begin
                    dispense   = 1'b1;
                    next_state = S0;
                end
                else if (coin_10) begin
                    dispense   = 1'b1;
                    change_5   = 1'b1;
                    next_state = S0;
                end
                else begin
                    next_state = S5;
                end
            end

            default: begin
                next_state = S0;
            end

        endcase
    end

endmodule