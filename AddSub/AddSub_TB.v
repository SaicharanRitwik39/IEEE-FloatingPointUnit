`timescale 1ns / 1ps

module IEEE754_FPU_Testbench;
  reg [31:0] a, b;
  reg add_sub;
  wire [31:0] result;
  wire overflow;

  // Instantiate the IEEE754_FPU module
  IEEE754_FPU uut (
    .a(a),
    .b(b),
    .add_sub(add_sub),
    .result(result),
    .overflow(overflow)
  );

  // Initial values
  initial begin
    $display("Test started.");
    
    // Test 1: Addition
    a = 32'b01000000100000000000000000000000;  // 3.0
    b = 32'b01000000010000000000000000000000;  // 1.5
    add_sub = 0;  // Addition
    #10;
    $display("Test 1: Addition");
    check_result(32'b01000000110000000000000000000000, 0);  // 4.5

    // Test 2: Subtraction
    a = 32'b11000000100000000000000000000000;  // -3.0
    b = 32'b01000000010000000000000000000000;  // 1.5
    add_sub = 1;  // Subtraction
    #10;
    $display("Test 2: Subtraction");
    check_result(32'b11000000110000000000000000000000, 0);  // -4.5

    // Test 3: Overflow test (addition)
    a = 32'b01111111011111111111111111111111;  // Max positive value
    b = 32'b01000000000000000000000000000001;  // 1.0
    add_sub = 0;  // Addition
    #10;
    $display("Test 3: Overflow test (addition)");
    check_result(32'b01111111100000000000000000000000, 1);  // Overflow to infinity

    $display("Testbench finished.");
    $finish;
  end

  // Helper task to check the result
  task check_result(input [31:0] expected_result, input expected_overflow);
    if (result === expected_result && overflow === expected_overflow)
      $display("Result is correct: %f", result);
    else
      $display("Error: Expected %f (Overflow=%b), Got %f (Overflow=%b)", expected_result, expected_overflow, result, overflow);
  endtask
endmodule
