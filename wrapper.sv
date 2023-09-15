`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/13/2023 09:05:04 PM
// Design Name: 
// Module Name: wrapper
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module wrapper(
    input logic clk, BTNL, BTNC, BTNR,
    output logic [7:0] AN,
    output logic [15:0] LED,
    output logic CA, CB, CC, CD, CE, CF, CG, DP
);

    logic [7:0] sseg;

    top myTop(
        .clk(clk), 
        .clear(BTNR), 
        .stop(BTNC), 
        .start(BTNL),
        .an(AN),
        .led(LED),
        .sseg(sseg)
    );
    
    assign LED[15:1] = 14'b0;
    assign AN[7:4] = 4'b1111;
    assign sseg = {DP, CG, CF, CE, CD, CC, CB, CA};

endmodule
