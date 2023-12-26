`timescale 1ns / 1ns

module cam_proj_top_tb;

    // Testbench-specific signals
    reg clk50;
    reg rst;
    reg start_gray_kn;

    // Camera interface signals
    reg [7:0] data_cam;
    reg VSYNC_cam, HREF_cam, PCLK_cam;
    wire XCLK_cam, res_cam, on_off_cam, sioc, siod;

    // VGA interface signals
    wire [4:0] r;
    wire [5:0] g;
    wire [4:0] b;

    // TFT interface signals
    reg  tft_sdo;
    wire tft_sck, tft_sdi, tft_dc, tft_reset, tft_cs;

    // LED outputs
    wire [7:0] LED;

    // Instantiate the module under test
    cam_proj_top uut (
        .clk50(clk50),
        .rst(rst),
        .start_gray_kn(start_gray_kn),
        .data_cam(data_cam),
        .VSYNC_cam(VSYNC_cam),
        .HREF_cam(HREF_cam),
        .PCLK_cam(PCLK_cam),
        .XCLK_cam(XCLK_cam),
        .res_cam(res_cam),
        .on_off_cam(on_off_cam),
        .sioc(sioc),
        .siod(siod),
        .r(r),
        .g(g),
        .b(b),
        .tft_sdo(tft_sdo),
        .tft_sck(tft_sck),
        .tft_sdi(tft_sdi),
        .tft_dc(tft_dc),
        .tft_reset(tft_reset),
        .tft_cs(tft_cs),
        .LED(LED)
    );

    // Clock generation
    initial begin
        clk50 = 0;
        forever #10 clk50 = ~clk50; // 50MHz clock
    end

    // Reset and start signal generation
    initial begin
        rst = 1;
        start_gray_kn = 0;
        #100 rst = 0; // Release reset
        #100 start_gray_kn = 1; // Start the gray-scale process
    end

    // Simulating camera input
    initial begin
        data_cam = 0;
        VSYNC_cam = 0;
        HREF_cam = 0;
        PCLK_cam = 0;
        // Further logic to simulate camera data, VSYNC, HREF, and PCLK signals
    end

    // Monitor and check outputs
    initial begin
        // Monitor relevant signals
        $monitor("Time = %t, r = %b, g = %b, b = %b, LED = %b", $time, r, g, b, LED);

        // Check the reset functionality of the system
        #150 if (!res_cam || !on_off_cam) $display("Reset functionality test failed at time %t", $time);

        // Further checks and validations
        // ...

    end

    // End the simulation after a certain time or condition
    initial begin
        #10000 $finish; // End simulation after 10000 time units
    end

endmodule
