`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/12/2023 07:27:01 PM
// Design Name: 
// Module Name: StateMachine
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


module StateMachine (
    input logic clk, stop, start, clear,
    input logic [3:0] d0, d1, d2, d3,
    input logic [3:0] rnd,
    output logic [3:0] hex0_out, hex1_out, hex2_out, hex3_out,
    output logic led, 
    output logic count_start, count_clear
);
    
    typedef enum {initial_state, random_state, led_state, state, stop_state, miss, error} state_type;
    
    state_type state_reg, state_next;
    logic [3:0] delay_reg, delay_next;
    logic [3:0] prev_d3;
    logic count_clear_reg, count_clear_next;
    logic count_start_reg, count_start_next;
    
    always_ff @(posedge clk, posedge clear)
        if (clear)
            begin
                state_reg <= initial_state;
                delay_reg <= 0;
                count_start_reg <= 0;
                count_clear_reg <= 0;
            end
        else 
            begin
                state_reg <= state_next;
                delay_reg <= delay_next;
                count_start_reg <= count_start_next;
                count_clear_reg <= count_clear_next;
            end
            
    always_comb
        begin
            state_next = state_reg;
            delay_next = delay_reg;
            count_start_next = count_start_reg;
            count_clear_next = count_clear_reg;
            led = 1'b0;
            prev_d3 = 4'b0;
 
            case(state_reg)
                initial_state:
                    begin
                        hex3_out = 4'ha; // H
                        hex2_out = 4'hb; // I
                        hex1_out = 4'hc; // all off
                        hex0_out = 4'hc; // all off
                        
                        if(start)
                            begin
                                state_next = random_state;
                                count_start_next = 1'b1;
                            end
                    end
                    
                random_state:
                    begin
                        hex3_out = 4'hc; // all off
                        hex2_out = 4'hc; // all off
                        hex1_out = 4'hc; // all off
                        hex0_out = 4'hc; // all off
                        if (stop)
                            begin
                                state_next = error;
                            end
                            
                        else if (d3 != prev_d3)
                            begin
                                delay_next = delay_reg + 1'b1;
                                prev_d3 = d3;
                            end
                        else if ((delay_reg == rnd) && (rnd >= 2) && (rnd <= 15))
                            begin
                                state_next = led_state;
                                count_clear_next = 1'b1; 
                            end   
                    end
                    
                led_state:
                    begin
                        hex3_out = 4'hc; // all off
                        hex2_out = 4'hc; // all off
                        hex1_out = 4'hc; // all off
                        hex0_out = 4'hc; // all off
                        count_clear_next = 1'b0;
                        led = 1'b1;
                        count_start_next = 1'b1;
                        
                        if( d0 == 1 && d1 == 0 && d2 == 0 && d3 == 1)
                            begin
                                state_next = miss;
                            end
                        else if (stop)
                            begin
                                count_start_next = 1'b0;
                                state_next = stop_state;
                            end
                    end
                    
                stop_state:
                    begin
                        led = 1'b0;
                        hex3_out = d3;
                        hex2_out = d2;
                        hex1_out = d1;
                        hex0_out = d0;
                        if (clear)
                            begin
                                state_next = initial_state;
                            end
                    end
                miss:
                    begin
                        led = 1'b0;
                        hex3_out = 4'h1;
                        hex2_out = 4'h0;
                        hex1_out = 4'h0;
                        hex0_out = 4'h0;
                        
                        if(clear)
                            begin
                                state_next = initial_state;
                            end
                    end
                error:
                    begin
                        led = 1'b0;
                        hex3_out = 4'h9;
                        hex2_out = 4'h9;
                        hex1_out = 4'h9; 
                        hex0_out = 4'h9; 
                        
                        if(clear)
                            begin
                                state_next = initial_state;
                            end
                    end
                default: 
                    begin
                        state_next = initial_state;
                    end
            endcase
        end
        
        assign count_start = count_start_reg;
        assign count_clear = count_clear_reg;
        
endmodule
