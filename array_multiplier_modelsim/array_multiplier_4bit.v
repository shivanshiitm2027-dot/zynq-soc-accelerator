module array_multiplier_4bit (
    input  [3:0] A,
    input  [3:0] B,
    output [7:0] P
);

    wire [3:0] pp0;
    wire [3:0] pp1;
    wire [3:0] pp2;
    wire [3:0] pp3;

    assign pp0 = A & {4{B[0]}};
    assign pp1 = A & {4{B[1]}};
    assign pp2 = A & {4{B[2]}};
    assign pp3 = A & {4{B[3]}};

    assign P = {4'b0000, pp0} +
               {3'b000, pp1, 1'b0} +
               {2'b00,  pp2, 2'b00} +
               {1'b0,   pp3, 3'b000};

endmodule