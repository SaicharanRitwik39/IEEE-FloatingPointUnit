module FastInverseSqrt (
    input wire [31:0] x,       // 32-bit input floating-point number
    output wire [31:0] result  // 32-bit output approximate inverse square root
);

    reg [31:0] xhalf;
    wire [31:0] approx, improved;

    always @* begin
        xhalf = (x >> 1);
    end

    // Convert floating-point input to integer representation
    reg [31:0] x_int;
    always @* begin
        x_int = x;
    end

    // Initial approximation using bit manipulation
    wire [31:0] initial_approx;
    assign initial_approx = 32'h5f3759df - (x_int >> 1);

    // Convert integer approximation back to floating-point
    reg [31:0] initial_approx_float;
    always @* begin
        initial_approx_float = initial_approx;
    end

    // Perform one iteration of Newton's method to refine the approximation
    always @* begin
        approx = initial_approx_float;
        improved = approx * (32'h3fc00000 - (xhalf * approx * approx));
    end

    assign result = improved;

endmodule
