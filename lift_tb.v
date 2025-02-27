`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/09/2025 08:57:44 PM
// Design Name: 
// Module Name: elevator_tb
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

module elevator_tb;

  // Inputs
  reg clk;
  reg reset;
  reg call_0;
  reg call_1;
  reg call_2;

  // Outputs
  wire Up;
  wire Down;
  wire doors;
  wire [2:0] katastash;

  // Instantiate the elevator module
  elevator uut (
    .clk(clk),
    .reset(reset),
    .call_0(call_0),
    .call_1(call_1),
    .call_2(call_2),
    .Up(Up),
    .Down(Down),
    .doors(doors),
    .katastash(katastash)
  );
  
// Clock generation
initial begin
    clk = 0;
    forever #5 clk = ~clk;
end

initial begin
    $monitor("Time = %0d, Up = %b, Down = %b, doors = %b, Katastash = %b", 
             $time, Up, Down, doors, katastash);
end

// Simulation
initial begin
    reset = 1; call_0 = 0; call_1 = 0; call_2 = 0;
    #10 reset = 0; // remove reset after 10 time units
    // First Case: Going from ground floor to first floor
    #10 call_1 = 1;    
    #80 call_1 = 0;
    // Second Case: Going from first floor to second floor
    #20 call_2 = 1;
    #80 call_2 = 0;
    // Third Case: Going from second floor to ground floor
    #20 call_0 = 1;
    #80 call_0 = 0;
    // Fourth Case: Going from ground floor to second floor
    #20 call_2 = 1;
    #80 call_2 = 0;
    // Fifth Case: Going from second floor to first floor
    #20 call_1 = 1;
    #80 call_1 = 0;
    // Sixth Case: Going from first floor to ground floor
    #20 call_0 = 1;
    #80 call_0 = 0;
    // End of simulation
    #100 $stop; // Terminate simulation
  end

endmodule

