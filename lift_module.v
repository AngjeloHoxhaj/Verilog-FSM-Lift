`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/09/2025 08:55:03 PM
// Design Name: 
// Module Name: liftmodule
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

// Angjelo Hoxhaj
// it2024104

module elevator(
    input clk,
    input reset, 
    input call_0,
    input call_1,
    input call_2,
    output reg Up,
    output reg Down,
    output reg doors,
    output reg [2:0] katastash);

    parameter S0 = 3'b000; //ground floor.
    parameter S1 = 3'b001; //1st floor.
    parameter S2 = 3'b010; //2nd floor.
    parameter S3 = 3'b011; //move up.
    parameter S4 = 3'b100; //move down.
    parameter S5 = 3'b101; //open doors.
    
    reg flag; // variable used to indicate that the lift has arrived at the desired floor
    reg [2:0] state;
    reg [2:0] next_state;
    reg [3:0] timer; // timer for the door
    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            flag <= 0; // reset flag
            state <= S0;
            timer <= 0;
        end else begin
            if (state == S5) begin
                if (timer < 2)
                    timer <= timer + 1; // Increment timer while doors are open
                else begin
                    flag <= 0;
                    timer <= 0; // Reset timer after delay
                    state <= next_state; // Move to next state after door delay
                end
            end else begin
                flag <= 0;
                state <= next_state; // Normal state transition
                timer <= 0;          // Reset timer when not in S5
            end
        end
        if (state == S3 || state == S4)
            flag <= 1; // Set flag when the elevator arrives at the correct floor
    end

    always @(*) begin
        next_state = state; // Default to holding state
        case (state)
            S0: begin
                if (call_1 || call_2) 
                    next_state = S3; // Move up
                else if (flag)
                    next_state = S5; // open doors upon arrival
                else
                    next_state = S0; // idle state
            end
            S1: begin
                if (call_0) 
                    next_state = S4; // Move down
                else if (call_2) 
                    next_state = S3; // Move up
                else if (flag)
                    next_state = S5; // open doors upon arrival
                else
                    next_state = S1; // idle state
            end
            S2: begin
                if (call_1 || call_0) 
                    next_state = S4; // Move down
                else if (flag)
                    next_state = S5; // open doors upon arrival
                else 
                    next_state = S2; // idle state
            end
            S3: begin
                if (call_1) 
                    next_state = S1; // arrived
                else if (call_2)
                    next_state = S2; // arrived
                else
                    next_state = S3; // idle state
            end
            S4: begin
                if (call_1) 
                    next_state = S1; // arrived
                else if (call_0) 
                    next_state = S0; // arrived
                else 
                    next_state = S4; // idle state
            end
            S5: begin
                if (timer >= 2) begin // after the doors close stay at the destination
                    if (call_0)
                        next_state = S0; 
                    else if (call_1)
                        next_state = S1;
                    else if (call_2)
                        next_state = S2;
                    else
                        next_state = state; // idle state
                end
            end
            default: next_state = state;
        endcase
    end
    
    always @(*) begin
        case (state)
            S0: begin
                katastash=3'b000;
                Up=1'b0;
                Down=1'b0;
                doors=1'b0;
            end
            S1: begin
                katastash=3'b001;
                Up=1'b0;
                Down=1'b0;
                doors=1'b0;
            end
            S2: begin
                katastash=3'b010;
                Up=1'b0;
                Down=1'b0;
                doors=1'b0;     
            end
            S3: begin
                katastash=3'b011;
                Up=1'b1;
                Down=1'b0;
                doors=1'b0;
            end
            S4: begin
                katastash=3'b100;
                Up=1'b0;
                Down=1'b1;
                doors=1'b0;
            end
            S5: begin
                katastash=3'b101;
                Up=1'b0;
                Down=1'b0;
                doors=1'b1;
            end
            default: begin
                katastash=3'b000;
                Up=1'b0;
                Down=1'b0;
                doors=1'b0;
            end
        endcase
    end
endmodule