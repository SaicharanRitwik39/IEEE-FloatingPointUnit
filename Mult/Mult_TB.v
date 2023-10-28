`timescale 1ns / 1ps

module IEEE754_FPU_Multiplier_Testbench;
  reg [31:0] a, b;
  wire [31:0] result;
  wire overflow;

  // Instantiate the IEEE754_FPU_Multiplier module
  IEEE754_FPU_Multiplier uut (
    .a(a),
    .b(b),
    .result(result),
    .overflow(overflow)
  );

  // Initial values
  initial begin
    $display("Test started.");

    // Test 1: Positive multiplication
    a = 32'b01000000100000000000000000000000;  // 3.0
    b = 32'b01000000010000000000000000000000;  // 1.5
    #10;
    $display("Test 1: Positive multiplication");
    check_result(32'b01000000110000000000000000000000, 0);  // 4.5

    // Test 2: Negative multiplication
    a = 32'b11000000100000000000000000000000;  // -3.0
    b = 32'b01000000010000000000000000000000;  // 1.5
    #10;
    $display("Test 2: Negative multiplication");
    check_result(32'b11000000110000000000000000000000, 0);  // -4.5

    // Test 3: Overflow test
    a = 32'b01111111011111111111111111111111;  // Max positive value
    b = 32'b01000000000000000000000000000001;  // 1.0000001
    #10;
    $display("Test 3: Overflow test");
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
