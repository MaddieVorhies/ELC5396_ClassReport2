`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/12/2023 07:47:04 PM
// Design Name: 
// Module Name: disp_mux
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


module disp_mux# (parameter N = 18)(
    input logic clk,
    input logic rst,
    input logic [3:0] hex3, hex2, hex1, hex0,
    output logic [3:0] an,
    output logic [7:0] sseg
); 
    
    logic [N-1:0] q_reg = 0;
    logic [N-1:0] q_next;
    logic [3:0] hex_in;
    
    always_ff @(posedge clk, posedge rst) 
        if (rst)
            q_reg <= 0;
        else 
            q_reg <= q_next;
            
    assign q_next = q_reg + 1;
    
    always_comb
        case (q_reg[N-1:N-2])
            2'b00:
                begin
                    an = 4'b1110;
                    hex_in = hex0;
                end
            2'b01:
                begin
                    an = 4'b1101;
                    hex_in = hex1;
                end
            2'b10:
                begin
                    an = 4'b1011;
                    hex_in = hex2;
                end
            default:
                begin
                    an = 4'b0111;
                    hex_in = hex3;
                end
        endcase
        
    always_comb
        begin
            case(hex_in)
                4'h0: sseg = 8'b11000000;
                4'h1: sseg = 8'b11111001;
                4'h2: sseg = 8'b10100100;
                4'h3: sseg = 8'b10110000;
                4'h4: sseg = 8'b10011001;
                4'h5: sseg = 8'b10010010;
                4'h6: sseg = 8'b10000010;
                4'h7: sseg = 8'b11111000;
                4'h8: sseg = 8'b10000000;
                4'h9: sseg = 8'b10010000;
                4'ha: sseg = 8'b10001001; // H
                4'hb: sseg = 8'b11001111; // I
                default: sseg = 8'b11111111;
            endcase
        end
endmodule
