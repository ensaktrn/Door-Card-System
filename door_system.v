`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04.01.2023 18:17:21
// Design Name: 
// Module Name: door_system
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


module door_system(clk,reset,sensor_entrance,card_valid,GREEN_LED,RED_LED,YELLOW_LED,door_status,ALARM);

input clk,reset,sensor_entrance,card_valid;
output wire GREEN_LED,RED_LED,YELLOW_LED,door_status,ALARM;

parameter IDLE = 3'b000, 
          SCAN_CARD = 3'b001, 
          WRONG_CARD = 3'b010, 
          RIGHT_CARD = 3'b011;
          
          
reg[2:0] current_state, 
         next_state;
          
reg[3:0] counter_wait,counter_wrong;
 
reg red_tmp,
    green_tmp,
    yellow_tmp,
    alarm_tmp,
    door_status_tmp;
    
initial begin
    red_tmp=0;
    green_tmp=0;
    yellow_tmp=0;
    alarm_tmp=0;
    door_status_tmp=0;
end 
     
    
always @(posedge clk or posedge reset) begin
     
    //change state to next on every clock
    if(reset) begin
        current_state = IDLE;
        counter_wrong=0;   
    end else
        current_state = next_state;

    //counter wait for card
    if(current_state == SCAN_CARD && (clk ||~clk)) 
        counter_wait <= counter_wait + 1;
    else 
        counter_wait <= 0;

    //counter for wrong card entry
    if(current_state == WRONG_CARD &&(clk ||~clk))
        counter_wrong <= counter_wrong+1; 
    else if(current_state == RIGHT_CARD)
        counter_wrong <= 0; 
 
 end
 
always @(posedge clk) begin 
    case(current_state)
        IDLE: begin
            green_tmp = 0;
            red_tmp = 0;
            yellow_tmp=0;
            door_status_tmp = 0;
        end
        SCAN_CARD: begin
            green_tmp = 0;
            red_tmp = 0;
            yellow_tmp=1;
            door_status_tmp = 0;
        end
        WRONG_CARD: begin
            green_tmp = 0;
            red_tmp = 1;
            yellow_tmp=0;
            door_status_tmp = 0;
        end
        RIGHT_CARD: begin
            green_tmp = 1;
            red_tmp = 0;
            yellow_tmp=0;
            alarm_tmp=0;
            door_status_tmp = 1;
        end
    endcase
end

always @(*) begin
    case(current_state)
        IDLE: begin 
            if(sensor_entrance == 1 ) 
                next_state = SCAN_CARD;
            else 
                next_state = IDLE;
            end
        SCAN_CARD: begin 
            if(counter_wait <= 3) 
                next_state = SCAN_CARD;
            else if(card_valid == 1) 
                next_state = RIGHT_CARD;
            else 
                next_state = WRONG_CARD;
        end
        WRONG_CARD: begin
            if(counter_wrong>=3)
                alarm_tmp=1;
            else
                alarm_tmp=0;     
            if(sensor_entrance==1) 
                next_state = SCAN_CARD;
            else 
                next_state = IDLE;
        end
        RIGHT_CARD: begin 
            if(sensor_entrance==1)  
                next_state = SCAN_CARD;
            else
                next_state = IDLE;
        end 
        default: next_state = IDLE;  
    endcase
end

 
assign RED_LED = red_tmp;
assign GREEN_LED = green_tmp;
assign YELLOW_LED = yellow_tmp;
assign ALARM = alarm_tmp;
assign door_status = door_status_tmp;

endmodule
