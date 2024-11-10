`timescale 1ns/1ps

module PC(
    input wire clk,
    input wire reset,
    input wire [31:0] pc_next,
    input wire [31:0] jump_addr,
    input wire jump,
    output reg [31:0] pc
  );

  always @(posedge clk or posedge reset)
  begin
    if (reset)
    begin
      pc <= 32'b0;
    end
    else if (jump)
    begin
      pc <= jump_addr;
    end
    else
    begin
      pc <= pc_next;
    end
  end

endmodule
