`timescale 1ns / 1ps

module ID_EX_Pipe(
    input                   clk,
    input                   id_mem_to_reg,
    input                   id_reg_write,
    input                   id_mem_read,
    input                   id_mem_write,
    input                   id_branch,
    input       [1:0]       id_alu_op,
    input                   id_alu_src,
    input                   id_zero,
    input                   id_jump,
    input       [31:0]      id_pc,
    input       [31:0]      id_rd1,
    input       [31:0]      id_rd2,
    input       [31:0]      id_imm,
    input       [31:0]      id_instruction,

    output reg              ex_mem_to_reg,
    output reg              ex_reg_write,
    output reg              ex_mem_read,
    output reg              ex_mem_write,
    output reg              ex_branch,
    output reg              ex_alu_src,
    output reg              ex_zero,
    output reg  [31:0]      ex_jump,
    output reg  [31:0]      ex_pc,
    output reg  [31:0]      ex_rd1,
    output reg  [31:0]      ex_rd2,
    output reg  [31:0]      ex_imm,
    output reg  [31:0]      ex_instruction,
    output reg  [1:0]       ex_alu_op
  );

  initial
  begin
    ex_mem_to_reg = 0;
    ex_reg_write = 0;
    ex_mem_read = 0;
    ex_mem_write = 0;
    ex_branch = 0;
    ex_alu_src = 0;
    ex_zero = 0;
    ex_jump = 0;
    ex_pc = 0;
    ex_rd1 = 0;
    ex_rd2 = 0;
    ex_imm = 0;
    ex_instruction = 0;
    ex_alu_op = 0;
  end

  always @ (posedge clk)
  begin
    ex_mem_to_reg   <= id_mem_to_reg;
    ex_reg_write    <= id_reg_write;
    ex_mem_read     <= id_mem_read;
    ex_mem_write    <= id_mem_write;
    ex_branch       <= id_branch;
    ex_alu_op       <= id_alu_op;
    ex_alu_src      <= id_alu_src;
    ex_zero         <= id_zero;
    ex_jump         <= id_jump;
    ex_pc           <= id_pc;
    ex_rd1          <= id_rd1;
    ex_rd2          <= id_rd2;
    ex_imm          <= id_imm;
    ex_instruction  <= id_instruction;
  end

endmodule
