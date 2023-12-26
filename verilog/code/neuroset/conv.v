module conv(
    clk, Y1, prov, matrix, matrix2, i, 
    w1, w2, w3, w4, w5, w6, w7, w8, w9,
    w11, w12, w13, w14, w15, w16, w17, w18, w19,
    conv_en, dense_en
);

parameter SIZE=11;          // Size of each weight in the kernels
input clk;
output reg signed [SIZE+SIZE-2:0] Y1; // Output of the convolution
input [1:0] prov;           // Boundary condition signal
input [4:0] matrix;         // Current row of the i-th pixel in the 28 rows of input matrix
input [9:0] matrix2;        // Total number of pixels in the 28x28 input matrix (784)
input [9:0] i;              // Current pixel index in the input matrix
input signed [SIZE-1:0] w1, w2, w3, w4, w5, w6, w7, w8, w9; // Weights for first kernel
input signed [SIZE-1:0] w11, w12, w13, w14, w15, w16, w17, w18, w19; // Weights for second kernel
input conv_en;              // Enable signal for convolution operation
input dense_en;             // Enable signal for fully connected (dense) layer

always @(posedge clk) begin
    if (conv_en == 1) begin // Check if convolution operation is enabled
        Y1 = 0;

        // Center pixel
        Y1 = Y1 + Y(w1, w11);

        // Right boundary condition: Check if not on the right edge or in dense layer
        if ((prov != 2'b10) || (dense_en == 1)) begin
            Y1 = Y1 + Y(w2, w12);
        end

        // Left boundary condition: Check if not on the left edge or in dense layer
        if ((prov != 2'b11) || (dense_en == 1)) begin
            Y1 = Y1 + Y(w3, w13);
        end

        // Down-left boundary condition: Check if not in the last row and not on the left edge or in dense layer
        if (((i < matrix2 - matrix) && (prov != 2'b11)) || (dense_en == 1)) begin
            Y1 = Y1 + Y(w4, w14);
        end

        // Upright boundary condition: Check if not in the first row and not on the right edge or in dense layer
        if (((i > matrix - 1'b1) && (prov != 2'b10)) || (dense_en == 1)) begin
            Y1 = Y1 + Y(w5, w15);
        end

        // Down boundary condition: Check if not in the last row or in dense layer
        if ((i < matrix2 - matrix) || (dense_en == 1)) begin
            Y1 = Y1 + Y(w6, w16);
        end

        // Up boundary condition: Check if not in the first row or in dense layer
        if ((i > matrix - 1'b1) || (dense_en == 1)) begin
            Y1 = Y1 + Y(w7, w17);
        end

        // Downright boundary condition: Check if not in the last row and not on the right edge or in dense layer
        if (((i < matrix2 - matrix) && (prov != 2'b10)) || (dense_en == 1)) begin
            Y1 = Y1 + Y(w8, w18);
        end

        // Upleft boundary condition: Check if not in the first row and not on the left edge or in dense layer
        if (((i > matrix - 1'b1) && (prov != 2'b11)) || (dense_en == 1)) begin
            Y1 = Y1 + Y(w9, w19);
        end
    end
end

function signed [SIZE+SIZE-2:0] Y;
    input signed [SIZE-1:0] a, b;
    begin
        Y = a * b; // Multiplication of kernel weights
    end
endfunction

endmodule
