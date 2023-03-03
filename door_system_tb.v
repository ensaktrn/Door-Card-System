`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04.01.2023 18:17:37
// Design Name: 
// Module Name: door_system_tb
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


module door_system_tb;

// inputs
reg clk;
reg reset;
reg sensor_entrance;
reg card_valid;

// outputs
wire GREEN_LED;
wire RED_LED;
wire YELLOW_LED;
wire ALARM;
wire door_status;


door_system UUT(.clk(clk),.reset(reset),.sensor_entrance(sensor_entrance),.card_valid(card_valid),.GREEN_LED(GREEN_LED),.RED_LED(RED_LED),.YELLOW_LED(YELLOW_LED),.door_status(door_status),.ALARM(ALARM));


always begin
    //set clock
    #5 clk = ~clk;
end
initial begin
    // init input
    reset = 1;
    sensor_entrance = 0;
    card_valid = 0;
    clk = 0;

    //test
    #100 reset = 0;
        
    #50 sensor_entrance = 1;
        card_valid=0;
    #55 sensor_entrance = 0;
    
    
    #45 sensor_entrance = 1;   
    #25 card_valid = 1;
    #30 sensor_entrance = 0;
    #10 card_valid=0;     
    
    
    #150 sensor_entrance = 1;
    #100 card_valid = 0;
    #50 sensor_entrance = 0;
    
    
    #100 sensor_entrance = 1;card_valid = 1;

    #50 sensor_entrance = 0;#5card_valid=0;
end
  
endmodule