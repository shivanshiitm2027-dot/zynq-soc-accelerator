`timescale 1ns/1ps

module tb_fsm_vending_machine;

    reg clk;
    reg reset;
    reg coin_5;
    reg coin_10;
    wire dispense;
    wire change_5;

    fsm_vending_machine uut (
        .clk(clk),
        .reset(reset),
        .coin_5(coin_5),
        .coin_10(coin_10),
        .dispense(dispense),
        .change_5(change_5)
    );

    always #5 clk = ~clk;

    initial begin
        $display("Time | coin_5 | coin_10 | dispense | change_5");
        $display("----------------------------------------------");

        clk = 0;
        reset = 1;
        coin_5 = 0;
        coin_10 = 0;

        #10 reset = 0;

        // Case 1: Rs.5 + Rs.5 = dispense
        coin_5 = 1; coin_10 = 0; #10;
        coin_5 = 0;              #10;
        coin_5 = 1; coin_10 = 0; #10;
        $display("%4t |   %b    |    %b    |    %b     |    %b",
                 $time, coin_5, coin_10, dispense, change_5);
        coin_5 = 0;              #10;

        // Case 2: Rs.10 directly = dispense
        coin_10 = 1; coin_5 = 0; #10;
        $display("%4t |   %b    |    %b    |    %b     |    %b",
                 $time, coin_5, coin_10, dispense, change_5);
        coin_10 = 0;             #10;

        // Case 3: Rs.5 + Rs.10 = dispense + Rs.5 change
        coin_5 = 1; coin_10 = 0; #10;
        coin_5 = 0;              #10;
        coin_10 = 1; coin_5 = 0; #10;
        $display("%4t |   %b    |    %b    |    %b     |    %b",
                 $time, coin_5, coin_10, dispense, change_5);
        coin_10 = 0;             #10;

        $finish;
    end

endmodule
