`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 11/10/2024 01:33:36 PM
// Design Name:
// Module Name: Adder
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


module Adder(
    input      [31:0]  first, second,
    output reg [31:0]  out
  );

  always @ (*)
  begin
    out = first + second;
  end

endmodule
