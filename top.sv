`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/13/2023 08:52:27 PM
// Design Name: 
// Module Name: top
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


module top(
    input logic clk, clear, stop, start,
    output logic [3:0] an,
    output logic led,
    output logic [7:0] sseg
);
    
    logic [3:0] d0, d1, d2, d3;
    logic [3:0] hex0, hex1, hex2, hex3;
    logic count_start, count_clear;
    logic [3:0] count;
    
    count myCounter (
        .clk(clk),
        .start(count_start),
        .clear(clear),
        .clear_in(count_clear),
        .d0(d0),
        .d1(d1),
        .d2(d2),
        .d3(d3)
    );
    
    PRBSLFSR random_num (
        .clk(clk),
        .rst(clear),
        .count(count),
        .rnd()
    );
    
    StateMachine myStateMacine (
        .clk(clk), 
        .stop(stop), 
        .start(start),
        .clear(clear),
        .rnd(count),
        .d0(d0), 
        .d1(d1), 
        .d2(d2), 
        .d3(d3),
        .hex0_out(hex0), 
        .hex1_out(hex1), 
        .hex2_out(hex2), 
        .hex3_out(hex3),
        .led(led), 
        .count_start(count_start), 
        .count_clear(count_clear)
    );
    
    disp_mux# (18) myDispMux(
        .clk(clk),
        .rst(clear),
        .hex3(hex3), 
        .hex2(hex2), 
        .hex1(hex1), 
        .hex0(hex0),
        .an(an),
        .sseg(sseg)
    ); 

endmodule
