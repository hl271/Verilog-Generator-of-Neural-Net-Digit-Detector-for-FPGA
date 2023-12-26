`timescale 1ns / 1ps

module conv_tb;

parameter SIZE = 11;
real w_float_1[9]; // Floating point weights
real w_float_2[9]; // Floating point weights
reg clk;
reg [1:0] prov;
reg [4:0] matrix = 28;
reg [9:0] matrix2 = 28*28;
reg [9:0] i;
reg signed [SIZE-1:0] w1, w2, w3, w4, w5, w6, w7, w8, w9;
reg signed [SIZE-1:0] w11, w12, w13, w14, w15, w16, w17, w18, w19;
reg conv_en = 1;
reg dense_en = 0;
wire signed [SIZE+SIZE-2:0] Y1;
real Y1_golden;
// real Y1_converted;

// Instantiate the Unit Under Test (UUT)
conv uut (
    .clk(clk), 
    .Y1(Y1), 
    .prov(prov), 
    .matrix(matrix), 
    .matrix2(matrix2), 
    .i(i), 
    .w1(w1), .w2(w2), .w3(w3), .w4(w4), .w5(w5), .w6(w6), .w7(w7), .w8(w8), .w9(w9),
    .w11(w11), .w12(w12), .w13(w13), .w14(w14), .w15(w15), .w16(w16), .w17(w17), .w18(w18), .w19(w19),
    .conv_en(conv_en), 
    .dense_en(dense_en)
);

initial begin
    // Initialize clock
    clk = 0;
    forever #5 clk = ~clk; // Toggle clock every 10 ns
end

initial begin
    // Initialize Inputs
    prov = 0;
    i = 0;

    // Initialize weights to binary values
    w1 = 11'b01000000000; // 0.5 in binary
    w2 = 11'b01000000000; // 0.5 in binary
    w3 = 11'b01000000000; // 0.5 in binary
    w4 = 11'b01000000000; // 0.5 in binary
    w5 = 11'b01000000000; // 0.5 in binary
    w6 = 11'b01000000000; // 0.5 in binary
    w7 = 11'b01000000000; // 0.5 in binary
    w8 = 11'b01000000000; // 0.5 in binary
    w9 = 11'b01000000000; // 0.5 in binary


    w11 = 11'b00001100110; // 0.1 in binary
    w12 = 11'b00011001100; // 0.2 in binary
    w13 = 11'b00100110011; // 0.3 in binary
    w14 = 11'b00110011001; // 0.4 in binary
    w15 = 11'b01000000000; // 0.5 in binary
    w16 = 11'b01001100110; // 0.6 in binary
    w17 = 11'b01011001100; // 0.7 in binary
    w18 = 11'b01100110011; // 0.8 in binary
    w19 = 11'b01110011001; // 0.9 in binary
    // Continue for w13 to w19 with respective binary values

    // Initialize floating point weights
    w_float_1[0] = 0.5;  // Corresponding to w1
    w_float_1[1] = 0.5;  // Corresponding to w2
    w_float_1[2] = 0.5;  // Corresponding to w3
    w_float_1[3] = 0.5;  // Corresponding to w4
    w_float_1[4] = 0.5;  // Corresponding to w5
    w_float_1[5] = 0.5;  // Corresponding to w6
    w_float_1[6] = 0.5;  // Corresponding to w7
    w_float_1[7] = 0.5;  // Corresponding to w8
    w_float_1[8] = 0.5;  // Corresponding to w9

    w_float_2[0] = 0.1;  // Corresponding to w11
    w_float_2[1] = 0.2; // Corresponding to w12
    // Continue for w13 to w19
    w_float_2[2] = 0.3;  // Corresponding to w13
    w_float_2[3] = 0.4;  // Corresponding to w14
    w_float_2[4] = 0.5;  // Corresponding to w15
    w_float_2[5] = 0.6;  // Corresponding to w16
    w_float_2[6] = 0.7;  // Corresponding to w17
    w_float_2[7] = 0.8;  // Corresponding to w18
    w_float_2[8] = 0.9;  // Corresponding to w19


    // // Wait for global reset
    // #100;

    // Test Cases
    // Case 1: Pass all boundary checks (i=250)
    i = 250;
    prov = 0; // Assuming normal case, no boundary
    calculate_golden_Y1(i, prov, w_float_1, w_float_2, Y1_golden); // Function to calculate golden Y1
    #10; // Wait for a few clock cycles
    // Y1_converted = convert_to_float(Y1); // Convert Y1 to floating point
    $display("Case 1: Pass all boundary checks (i=250)");
    $display("Case 1: Expected: %f, Actual: %b", Y1_golden, Y1);

    // Case 2: Upleft boundary (i=0)
    i = 0;
    prov = 1; // Left boundary
    calculate_golden_Y1(i, prov, w_float_1, w_float_2, Y1_golden); // Function to calculate golden Y1
    #10; // Wait for a few clock cycles
    $display("Case 2: Upleft boundary (i=0)");
    $display("Case 2: Expected: %f, Actual: %b", Y1_golden, Y1);

    // Case 3: Upright boundary (i=27)
    i = 27;
    prov = 0; // Right boundary
    calculate_golden_Y1(i, prov, w_float_1, w_float_2, Y1_golden); // Function to calculate golden Y1
    #10; // Wait for a few clock cycles
    $display("Case 3: Upright boundary (i=27)");
    $display("Case 3: Expected: %f, Actual: %b", Y1_golden, Y1);

    // Case 4: Downleft boundary (i=783-27)
    i = 783 - 27;
    prov = 1; // Left boundary
    calculate_golden_Y1(i, prov, w_float_1, w_float_2, Y1_golden); // Function to calculate golden Y1
    #10; // Wait for a few clock cycles
    $display("Case 4: Downleft boundary (i=783-27)");
    $display("Case 4: Expected: %f, Actual: %b", Y1_golden, Y1);

    // Case 5: Downright boundary (i=783)
    i = 783;
    prov = 0; // Right boundary
    calculate_golden_Y1(i, prov, w_float_1, w_float_2, Y1_golden); // Function to calculate golden Y1
    #10; // Wait for a few clock cycles
    $display("Case 5: Downright boundary (i=783)");
    $display("Case 5: Expected: %f, Actual: %b", Y1_golden, Y1);

    $finish; // End simulation

end

// Function to calculate golden Y1
task calculate_golden_Y1(
    input [9:0] i,
    input [1:0] boundary,
    input real w_float_1 [9],
    input real w_float_2 [9],
    output real Y1_golden
);
    static int matrix = 28; // One dimension of the input matrix
    static int matrix2 = matrix * matrix; // Total number of pixels in the input matrix
    static bit dense_en = 0; // Dense layer enable signal, assuming false for this task

    Y1_golden = 0;

    // Perform convolution operation:
    Y1_golden += w_float_1[0] * w_float_2[0]; // Y(w1, w11)

    if ((boundary != 2'b10) || dense_en)
        Y1_golden += w_float_1[1] * w_float_2[1]; // Y(w2, w12)

    if ((boundary != 2'b11) || dense_en)
        Y1_golden += w_float_1[2] * w_float_2[2]; // Y(w3, w13)

    if (((i < matrix2 - matrix) && (boundary != 2'b11)) || dense_en)
        Y1_golden += w_float_1[3] * w_float_2[3]; // Y(w4, w14)

    if (((i > matrix - 1) && (boundary != 2'b10)) || dense_en)
        Y1_golden += w_float_1[4] * w_float_2[4]; // Y(w5, w15)

    if ((i < matrix2 - matrix) || dense_en)
        Y1_golden += w_float_1[5] * w_float_2[5]; // Y(w6, w16)

    if ((i > matrix - 1) || dense_en)
        Y1_golden += w_float_1[6] * w_float_2[6]; // Y(w7, w17)

    if (((i < matrix2 - matrix) && (boundary != 2'b10)) || dense_en)
        Y1_golden += w_float_1[7] * w_float_2[7]; // Y(w8, w18)

    if (((i > matrix - 1) && (boundary != 2'b11)) || dense_en)
        Y1_golden += w_float_1[8] * w_float_2[8]; // Y(w9, w19)

endtask

// Function to convert a real decimal to 11-bit signed binary
function reg signed [10:0] decimalTo11BitBinary(input real decimal);
    decimalTo11BitBinary = decimal * (1 << 10); // Shift left by 10 bits
endfunction

endmodule
