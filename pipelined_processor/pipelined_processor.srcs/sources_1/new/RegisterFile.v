`timescale 1ns / 1ps

module RegisterFile(rs1, rs2, rd, wd, we, clk, rd1, rd2);

  input [4:0] rs1, rs2, rd;
  input [31:0] wd;
  input we, clk;
  output [31:0] rd1, rd2;

  reg [31:0] rd1, rd2;
  reg [31:0] regfile [31:0];

  integer cnt;

  initial
  begin
    for(cnt = 0; cnt < 32; cnt = cnt + 1)
      regfile[cnt] <= 0;
  end

  // synchronous write
  always @(posedge clk)
  begin
    if (we)
    begin
      if (rd != 0)
        regfile[rd] <= wd;
    end
  end

  // asynchronous read
  always @(*)
  begin
    rd1 = regfile[rs1];
    rd2 = regfile[rs2];
  end
endmodule