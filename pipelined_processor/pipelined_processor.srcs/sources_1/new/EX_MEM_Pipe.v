`timescale 1ns / 1ps

module EX_MEM_Pipe(
    input                   clk,
    input                   ex_mem_to_reg,
    input                   ex_reg_write,
    input                   ex_mem_read,
    input                   ex_mem_write,
    input                   ex_branch,
    input                   ex_zero,
    input                   ex_jump,
    input       [31:0]      ex_alu_result,
    input       [31:0]      ex_pc_sum,
    input       [31:0]      ex_rd2,
    input       [31:0]      ex_instruction,

    output reg              mem_mem_to_reg,
    output reg              mem_reg_write,
    output reg              mem_mem_read,
    output reg              mem_mem_write,
    output reg              mem_branch,
    output reg              mem_zero,
    output reg  [31:0]      mem_alu_result,
    output reg  [31:0]      mem_pc_sum,
    output reg  [31:0]      mem_rd2,
    output reg  [31:0]      mem_instruction
  );

  initial
  begin
    mem_mem_to_reg = 0;
    mem_reg_write = 0;
    mem_mem_read = 0;
    mem_mem_write = 0;
    mem_branch = 0;
    mem_zero = 0;
    mem_alu_result = 0;
    mem_pc_sum = 0;
    mem_rd2 = 0;
    mem_instruction = 0;
  end

  always @ (posedge clk)
  begin
    mem_mem_to_reg   <= ex_mem_to_reg;
    mem_reg_write    <= ex_reg_write;
    mem_mem_read     <= ex_mem_read;
    mem_mem_write    <= ex_mem_write;
    mem_branch       <= ex_branch;
    mem_zero         <= ex_zero;
    mem_alu_result   <= ex_alu_result;
    mem_pc_sum       <= ex_pc_sum;
    mem_rd2          <= ex_rd2;
    mem_instruction  <= ex_instruction;
  end

endmodule
