`timescale 1ns/1ps

module tb_array_multiplier_4bit;

    reg  [3:0] A;
    reg  [3:0] B;
    wire [7:0] P;

    array_multiplier_4bit uut (
        .A(A),
        .B(B),
        .P(P)
    );

    initial begin
        $display("Time | A | B | Product");
        $display("----------------------");

        A = 4'd3;  B = 4'd5;  #10;
        $display("%4t | %d | %d | %d", $time, A, B, P);

        A = 4'd7;  B = 4'd8;  #10;
        $display("%4t | %d | %d | %d", $time, A, B, P);

        A = 4'd15; B = 4'd15; #10;
        $display("%4t | %d | %d | %d", $time, A, B, P);

        A = 4'd9;  B = 4'd6;  #10;
        $display("%4t | %d | %d | %d", $time, A, B, P);

        #10;
        $finish;
    end

endmodule