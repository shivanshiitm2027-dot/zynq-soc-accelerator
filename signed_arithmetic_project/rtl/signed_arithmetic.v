module signed_arithmetic #(
    parameter N = 4
)(
    input  [N-1:0] A,
    input  [N-1:0] B,
    input          mode,       // 0 = add, 1 = subtract
    output [N-1:0] result,
    output         overflow
);

    wire [N-1:0] B_2s_comp;
    wire [N-1:0] B_selected;

    // 2's complement of B = invert B + 1
    assign B_2s_comp = ~B + 1'b1;

    // If mode = 0, use B
    // If mode = 1, use -B
    assign B_selected = (mode == 1'b0) ? B : B_2s_comp;

    // Addition/subtraction
    assign result = A + B_selected;

    // Signed overflow detection
    assign overflow = (A[N-1] == B_selected[N-1]) &&
                      (result[N-1] != A[N-1]);

endmodule