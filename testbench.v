module testbench;
  reg a;
  wire y;

  MyInverter uut (.a(a), .y(y)); // instantiate MyInverter

  initial begin
    $monitor("At time %t: a = %b, y = %b", $time, a, y);
    a = 0;
    #10 a = 1;
    #10 $finish;
  end
endmodule
