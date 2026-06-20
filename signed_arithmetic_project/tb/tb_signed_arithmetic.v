`timescale 1ns/1ps

module tb_signed_arithmetic;

    reg  [3:0] A;
    reg  [3:0] B;
    reg        mode;
    wire [3:0] result;
    wire       overflow;

    signed_arithmetic uut (
        .A(A),
        .B(B),
        .mode(mode),
        .result(result),
        .overflow(overflow)
    );

    initial begin
        $dumpfile("sim/signed_arithmetic.vcd");
        $dumpvars(0, tb_signed_arithmetic);

        $display("Time | A    | B    | Mode | Result | Overflow");
        $display("-----------------------------------------------");

        // +3 + +2 = +5
        A = 4'b0011; B = 4'b0010; mode = 0;
        #10;
        $display("%4t | %b | %b | ADD  | %b   | %b", $time, A, B, result, overflow);

        // +5 + (-3) = +2
        A = 4'b0101; B = 4'b1101; mode = 0;
        #10;
        $display("%4t | %b | %b | ADD  | %b   | %b", $time, A, B, result, overflow);

        // -5 + +2 = -3
        A = 4'b1011; B = 4'b0010; mode = 0;
        #10;
        $display("%4t | %b | %b | ADD  | %b   | %b", $time, A, B, result, overflow);

        // +5 - +3 = +2
        A = 4'b0101; B = 4'b0011; mode = 1;
        #10;
        $display("%4t | %b | %b | SUB  | %b   | %b", $time, A, B, result, overflow);

        // +3 - +5 = -2
        A = 4'b0011; B = 4'b0101; mode = 1;
        #10;
        $display("%4t | %b | %b | SUB  | %b   | %b", $time, A, B, result, overflow);

        // Overflow example: +7 + +1 = overflow
        A = 4'b0111; B = 4'b0001; mode = 0;
        #10;
        $display("%4t | %b | %b | ADD  | %b   | %b", $time, A, B, result, overflow);

        // Overflow example: -8 + -1 = overflow
        A = 4'b1000; B = 4'b1111; mode = 0;
        #10;
        $display("%4t | %b | %b | ADD  | %b   | %b", $time, A, B, result, overflow);

        #10;
        $finish;
    end

endmodule