`timescale 1ns / 1ps

module FastInverseSqrt_Testbench;
  reg [31:0] x;
  wire [31:0] result;

  // Instantiate the FastInverseSqrt module
  FastInverseSqrt uut (
    .x(x),
    .result(result)
  );

  // Initial values
  initial begin
    $display("Test started.");

    // Test 1: Inverse square root of 4.0
    x = 32'h40800000;  // 4.0 (in IEEE 754 format)
    #10;
    $display("Test 1: Inverse square root of 4.0");
    check_result(32'h3ea6a09e);  // Approximate inverse square root of 4.0

    // Test 2: Inverse square root of 2.0
    x = 32'h3f000000;  // 2.0 (in IEEE 754 format)
    #10;
    $display("Test 2: Inverse square root of 2.0");
    check_result(32'h3f317218);  // Approximate inverse square root of 2.0

    $display("Testbench finished.");
    $finish;
  end

  // Helper task to check the result
  task check_result(input [31:0] expected_result);
    if (result === expected_result)
      $display("Result is correct: %f", result);
    else
      $display("Error: Expected %f, Got %f", expected_result, result);
  endtask
endmodule
