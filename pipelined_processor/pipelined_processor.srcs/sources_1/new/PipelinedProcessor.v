`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 11/10/2024 01:20:25 PM
// Design Name:
// Module Name: PipelinedProcessor
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

//`include "Adder.v"
//`include "ALUControl.v"
//`include "InstructionMemory.v"
//`include "PC.v"

module PipelinedProcessor(
    input wire clk,
    input wire reset
  );
  // Internal signals
  // IF SIGNALS
  wire [31:0] if_pc, if_pc_next, if_pc_out, if_instruction;

  // ID SIGNALS
  wire [31:0] id_instruction, id_pc, id_imm;
  wire [31:0] id_rd1, id_rd2;
  wire [1:0] id_alu_op;
  wire id_jump;
  wire id_mem_to_reg, id_reg_write, id_mem_read, id_mem_write, id_branch, id_alu_src, id_zero;

  // EX SIGNALS
  wire ex_pc_src;
  wire ex_jump;
  wire [1:0] ex_alu_op;
  wire [31:0] ex_instruction, ex_pc, ex_imm, ex_pc_sum;
  wire [31:0] ex_rd1, ex_rd2, ex_alu_result;
  wire ex_mem_to_reg, ex_reg_write, ex_mem_read, ex_mem_write, ex_branch, ex_alu_src, ex_zero;
  wire [3:0] ex_alu_ctrl;

  // MEM SIGNALS
  // wire [31:0] mem_pc_sum;
  wire mem_pc_src;

  wire mem_mem_to_reg, mem_reg_write, mem_mem_read, mem_mem_write, mem_branch, mem_zero;
  wire [31:0] mem_alu_result, mem_pc_sum, mem_rd2, mem_instruction;


  // WB SIGNALS
  wire wb_mem_to_reg, wb_reg_write;
  wire [31:0] wb_write_data;


  PC pc_reg(
       .clk(clk),
       .reset(reset),
       .pc_next((ex_pc_src)? if_pc_next : mem_pc_sum),
       .jump(ex_jump),
       .jump_addr(ex_alu_result),
       .pc(if_pc) // output
     );

  Adder adder1(
          .first(if_pc),
          .second(32'h00000004),
          .out(if_pc_next)
        );

  InstructionMemory instr_mem(
                      .address(if_pc),
                      .instruction(if_instruction)
                    );

  IF_ID_Pipe if_id_pipe(
               .clk(clock),
               .pc(if_pc),
               .instr(if_instruction),
               .pc_out(id_pc),
               .instr_out(id_instruction)
             );


  RegisterFile RF1 (
                 .clk(clk),
                 .rs1(id_instruction[19:15]),
                 .rs2(id_instruction[24:20]),
                 .rd(id_instruction[11:7]),
                 .rd1(id_rd1),
                 .rd2(id_rd2),
                 .wd(wb_write_data),
                 .we(wb_reg_write)
               );



  Control ctrl(
            .opcode(id_instruction[6:0]),
            .branch(id_branch),
            .mem_read(id_mem_read),
            .mem_to_reg(id_mem_to_reg),
            .alu_op(id_alu_op),
            .mem_write(id_mem_write),
            .alu_src(id_alu_src),
            .reg_write(id_reg_write),
            .jump(id_jump)
          );

  ImmediateGen imm_gen(
                 .instr(id_instr),
                 .imm(id_imm)
               );


  ID_EX_Pipe id_ex_pipe(
               .id_mem_to_reg(id_mem_to_reg),
               .id_reg_write(id_reg_write),
               .id_mem_read(id_mem_read),
               .id_mem_write(id_mem_write),
               .id_branch(id_branch),
               .id_alu_op(id_alu_op),
               .id_alu_src(id_alu_src),
               .id_zero(id_zero),
               .id_jump(id_jump), // jal
               .id_pc(id_pc),
               .id_rd1(id_rd1),
               .id_rd2(id_rd2),
               .id_imm(id_imm),
               .id_instruction(id_instruction),

               .ex_mem_to_reg(ex_mem_to_reg),
               .ex_reg_write(ex_reg_write),
               .ex_mem_read(ex_mem_read),
               .ex_mem_write(ex_mem_write),
               .ex_branch(ex_branch),
               .ex_alu_src(ex_alu_src),
               .ex_zero(ex_zero),
               .ex_jump(ex_jump), // jal
               .ex_pc(ex_pc),
               .ex_rd1(ex_rd1),
               .ex_rd2(ex_rd2),
               .ex_imm(ex_imm),
               .ex_instruction(ex_instruction),
               .ex_alu_op(ex_alu_op)
             );


  Adder adder2(
          .first(ex_pc),
          .second(ex_imm << 1),
          .out(ex_pc_sum)
        );

  ALU alu(
        .rd1(ex_rd1),
        .imm((ex_alu_src) ? ex_imm : ex_rd2 ),
        .alu_ctrl(ex_alu_ctrl),
        .alu_result(ex_alu_result),
        .zero(ex_zero)
      );

  ALUControl alu_control(
               .alu_op(ex_alu_op),
               .funct3(ex_instruction[14:12]),
               .i30(ex_instruction[30]),
               .alu_ctrl(ex_alu_ctrl)
             );



  EX_MEM_Pipe ex_mem_pipe(
                .clk(clock),
                .ex_mem_to_reg(ex_mem_to_reg),
                .ex_reg_write(ex_reg_write),
                .ex_mem_read(ex_mem_read),
                .ex_mem_write(ex_mem_write),
                .ex_branch(ex_branch),
                .ex_zero(ex_zero),
                .ex_jump(ex_jump), // jal
                .ex_alu_result(ex_alu_result),
                .ex_pc_sum(ex_pc_sum),
                .ex_rd2(ex_rd2),
                .ex_instruction(ex_instruction),

                .mem_mem_to_reg(mem_mem_to_reg),
                .mem_reg_write(mem_reg_write),
                .mem_mem_read(mem_mem_read),
                .mem_mem_write(mem_mem_write),
                .mem_branch(mem_branch),
                .mem_zero(mem_zero),
                .mem_alu_result(mem_alu_result),
                .mem_pc_sum(mem_pc_sum),
                .mem_rd2(mem_rd2),
                .mem_instruction(mem_instruction)
              );

  assign mem_pc_src = (mem_branch && mem_zero) ? 1'b1 : 1'b0;

  MEM_WB_Pipe mem_wb_pipe(
                .clk(clock),
                .mem_mem_to_reg(mem_mem_to_reg),
                .mem_reg_write(mem_reg_write),
                .mem_alu_result(mem_alu_result),
                .mem_rd2(mem_rd2),
                .mem_instruction(mem_instruction),

                .wb_mem_to_reg(wb_mem_to_reg),
                .wb_reg_write(wb_reg_write)
                // .wb_write_data(wb_write_data)
              );

  Adder adder3(
          .first(mem_pc_sum),
          .second(mem_rd2),
          .out(mem_pc_sum)
        );

  DataMemory data_mem(
               .we(mem_mem_write),
               .re(mem_mem_read),
               .funct3(mem_instruction[14:12]),
               .addr(mem_alu_result),
               .wd(mem_rd2),
               .rd_out(mem_alu_result)
             );

  assign wb_write_data = (mem_mem_to_reg) ? mem_rd2 : mem_alu_result;

endmodule
