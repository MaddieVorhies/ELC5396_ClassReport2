`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/12/2023 09:02:57 PM
// Design Name: 
// Module Name: count
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


module count(
    input logic clk,
    input logic start,
    input logic clear, clear_in,
    output logic [3:0] d0, d1, d2, d3
);

    localparam DVSR = 100000;
    logic [22:0] ms_reg;
    logic [22:0] ms_next;
    logic [3:0] d3_reg, d2_reg, d1_reg, d0_reg;
    logic [3:0] d3_next, d2_next, d1_next, d0_next;
    logic ms_tick;
    
    always_ff @(posedge clk, posedge clear)
        if (clear)
            begin
                ms_reg <= 0;
                d3_reg <= 0;
                d2_reg <= 0;
                d1_reg <= 0;
                d0_reg <= 0;
            end
        else
            begin
                ms_reg <= ms_next;
                d3_reg <= d3_next;
                d2_reg <= d2_next;
                d1_reg <= d1_next;
                d0_reg <= d0_next;
            end
            
    assign ms_next = (clear_in || (ms_reg==DVSR && start)) ? 4'b0 : (start) ? ms_reg + 1 : ms_reg;
    assign ms_tick = (ms_reg==DVSR) ? 1'b1 : 1'b0;
    
    always_comb
        begin
            d0_next = d0_reg;
            d1_next = d1_reg;
            d2_next = d2_reg;
            d3_next = d3_reg;
            if(clear_in) 
                begin
                    d0_next = 4'b0;
                    d1_next = 4'b0;
                    d2_next = 4'b0;
                    d3_next = 4'b0;
                end
            else if (ms_tick)
                if (d0_reg != 9)
                    d0_next = d0_reg + 1;
                else
                    begin
                        d0_next = 4'b0;
                        if (d1_reg != 9)
                            d1_next = d1_reg + 1;
                        else
                            begin
                                d1_next = 4'b0;
                                if (d2_reg != 9)
                                    d2_next = d2_reg + 1;
                                else
                                    begin
                                        d2_next = 4'b0;
                                        if (d3_reg != 9)
                                            d3_next = d3_reg + 1;
                                        else 
                                            d3_next = 4'b0;
                                    end
                            end
                    end
        end
        
        assign d0 = d0_reg;
        assign d1 = d1_reg;
        assign d2 = d2_reg;
        assign d3 = d3_reg;

endmodule
