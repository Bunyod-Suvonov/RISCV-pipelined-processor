`timescale 1ns / 1ps

module Control
  (
    input       [6:0]           opcode,
    output reg  [1:0]           alu_op, mem_to_reg, //mem_to_reg to select among ALUResult, DataMemo, and PC+4.
    output reg                  branch, mem_read, mem_write, alu_src, jump, reg_write // jump for jalr.
  );
  initial
  begin
    alu_op = 0;
    mem_to_reg = 0;
    branch = 0;
    mem_read = 0;
    mem_write = 0;
    alu_src = 0;
    jump = 0;
    reg_write = 0;
  end

  always @ (opcode)
  begin
    case (opcode)
      //I-type,load
      7'b0000011:
      begin
        branch <= 0;
        alu_src <= 1;
        alu_op <= 2'b00;
        mem_write <= 0;
        mem_read <= 1;
        mem_to_reg <= 2'b01;
        jump <= 0;
        reg_write <= 1;
      end
      //          7'b0001111:
      //I-type,Imm
      7'b0010011:
      begin
        branch <= 0;
        alu_src <= 1;
        alu_op <= 2'b11;
        mem_write <= 0;
        mem_read <= 0;
        mem_to_reg <= 2'b00;
        jump <= 0;
        reg_write <= 1;
      end
      //          7'b0010111:
      //S-type,save
      7'b0100011:
      begin
        branch <= 0;
        alu_src <= 1;
        alu_op <= 2'b00;
        mem_write <= 1;
        mem_read <= 0;
        mem_to_reg <= 2'b00;
        jump <= 0;
        reg_write <= 0;
      end
      //          7'b0110111:
      //B-type,brnch
      7'b1100011:
      begin
        branch <= 1;
        alu_src <= 0;
        alu_op <= 2'b01;
        mem_write <= 0;
        mem_read <= 0;
        mem_to_reg <= 2'b00;
        jump <= 0;
        reg_write <= 0;
      end
      //I-type,jalr
      7'b1100111:
      begin
        branch <= 1;
        alu_src <= 1;
        alu_op <= 2'b00;
        mem_write <= 0;
        mem_read <= 0;
        mem_to_reg <= 2'b10;
        jump <= 1;
        reg_write <= 1;
      end
      //J-type,jal
      7'b1101111:
      begin
        branch <= 1;
        alu_src <= 1;
        alu_op <= 2'b00;
        mem_write <= 0;
        mem_read <= 0;
        mem_to_reg <= 2'b10;
        jump <= 0;
        reg_write <= 1;
      end
      //          7'b1110011:
      //R-type,calc
      7'b0110011:
      begin
        branch <= 0;
        alu_src <= 0;
        alu_op <= 2'b10;
        mem_write <= 0;
        mem_read <= 0;
        mem_to_reg <= 2'b00;
        jump <= 0;
        reg_write <= 1;
      end
      default:
      begin
        branch <= 0;
        alu_src <= 0;
        alu_op <= 2'b00;
        mem_write <= 0;
        mem_read <= 0;
        mem_to_reg <= 2'b00;
        jump <= 0;
        reg_write <= 0;
      end
    endcase
  end
endmodule
