module IEEE754_FPU (
    input wire [31:0] a,  // 32-bit input operand A
    input wire [31:0] b,  // 32-bit input operand B
    input wire add_sub,   // 1-bit control: 0 for addition, 1 for subtraction
    output wire [31:0] result,  // 32-bit result
    output wire overflow    // 1-bit overflow flag
);

// IEEE 754 representation parameters
parameter EXPONENT_BITS = 8;
parameter FRACTION_BITS = 23;

// Extract exponent and fraction
wire [EXPONENT_BITS-1:0] exp_a = a[30:23];
wire [FRACTION_BITS-1:0] frac_a = a[22:0];
wire [EXPONENT_BITS-1:0] exp_b = b[30:23];
wire [FRACTION_BITS-1:0] frac_b = b[22:0];

// Bias for IEEE 754 exponent
parameter BIAS = 127;

// Calculate the biased exponent
wire [EXPONENT_BITS-1:0] exp_a_biased = exp_a - BIAS;
wire [EXPONENT_BITS-1:0] exp_b_biased = exp_b - BIAS;

// Calculate the fraction for the larger exponent
wire [FRACTION_BITS:0] larger_frac;
wire [FRACTION_BITS:0] smaller_frac;

assign larger_frac = (exp_a_biased > exp_b_biased) ? {1'b1, frac_a} : {1'b1, frac_b};
assign smaller_frac = (exp_a_biased > exp_b_biased) ? {1'b0, frac_b} : {1'b0, frac_a};

// Calculate the new exponent
wire [EXPONENT_BITS:0] new_exp;
assign new_exp = (exp_a_biased > exp_b_biased) ? exp_a_biased : exp_b_biased;

// Perform addition or subtraction of fractions
wire [FRACTION_BITS:0] result_frac;

always @* begin
    if (add_sub == 0)  // Addition
        result_frac = larger_frac + smaller_frac;
    else  // Subtraction
        result_frac = larger_frac - smaller_frac;
end

// Handle overflow
assign overflow = (result_frac[FRACTION_BITS+1] == 1);

// Normalize the result fraction
wire [FRACTION_BITS:0] normalized_frac;
assign normalized_frac = result_frac[FRACTION_BITS-1:0];

// Check for carry out during normalization
wire carry_out;
assign carry_out = result_frac[FRACTION_BITS+1];

// Adjust the exponent based on normalization
wire [EXPONENT_BITS:0] final_exp;
assign final_exp = carry_out ? new_exp + 1 : new_exp;

// Combine the sign, exponent, and fraction to get the result
assign result = {a[31], final_exp, normalized_frac};

endmodule
