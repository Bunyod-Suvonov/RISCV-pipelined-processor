`timescale 1ns / 1ps

module MEM_WB_Pipe(
    input                   clk,
    input                   mem_mem_to_reg,
    input                   mem_reg_write,
    input       [31:0]      mem_alu_result,
    input       [31:0]      mem_rd2,
    input       [31:0]      mem_instruction,

    output reg              wb_mem_to_reg,
    output reg              wb_reg_write,
    output reg  [31:0]      wb_alu_result,
    output reg  [31:0]      wb_rd2,
    output reg  [31:0]      wb_instruction
  );

  initial
  begin
    wb_mem_to_reg = 0;
    wb_reg_write = 0;
    wb_alu_result = 0;
    wb_rd2 = 0;
    wb_instruction = 0;
  end

  always @ (posedge clk)
  begin
    wb_mem_to_reg   <= mem_mem_to_reg;
    wb_reg_write    <= mem_reg_write;
    wb_alu_result   <= mem_alu_result;
    wb_rd2          <= mem_rd2;
    wb_instruction  <= mem_instruction;
  end

endmodule
