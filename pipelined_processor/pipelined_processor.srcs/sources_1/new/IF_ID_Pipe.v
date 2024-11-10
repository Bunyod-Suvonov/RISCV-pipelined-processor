`timescale 1ns / 1ps

module IF_ID_Pipe(
    input                   clk,
    input       [31:0]      pc,
    input       [31:0]      instr,
    output reg  [31:0]      pc_out,
    output reg  [31:0]      instr_out
  );

  initial
  begin
    pc_out = 0;
    instr_out = 0;
  end

  always @ (posedge clk)
  begin
    pc_out      <= pc;
    instr_out   <= instr;
  end

endmodule
