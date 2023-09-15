`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/13/2023 05:42:09 PM
// Design Name: 
// Module Name: test_count
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


module test_count(
    input logic clk, 
    input logic BTNU, BTNC, BTNR,
    output logic [3:0] AN,
    output logic CA, CB, CC, CD, CE, CF, CG, DP
);
    logic [3:0] d3, d2, d1, d0;
    logic [7:0] sseg;

    disp_mux disp_unit (
        .clk(clk),
        .rst(BTNC),
        .hex3(d3),
        .hex2(d2),
        .hex1(d1),
        .hex0(d0),
        .an(AN),
        .sseg(sseg)
    );
    
    count myCount (
        .clk(clk),
        .start(BTNU),
        .clear(BTNC),
        .clear_in(BTNR),
        .d3(d3),
        .d2(d2),
        .d1(d1),
        .d0(d0)
    );
    
    assign sseg = {DP, CG, CF, CE, CD, CC, CB, CA};
    

endmodule
