`timescale 1ns / 1ps

module ALUControl
  (
    input       [1:0]         alu_op,
    input       [2:0]         funct3,
    input                     i30,
    output reg  [3:0]         alu_ctrl
  );

  wire [3:0] instr;
  assign instr = {i30, funct3};

  always @ (*)
  begin
    case (alu_op)
      2'b00:
      begin
        alu_ctrl = 4'b0010; //Addition
      end
      2'b01:
      begin
        if (instr[2:0] == 3'b101)
        begin
          alu_ctrl = 4'b1110;
        end //bge
        else
        begin
          alu_ctrl = {1'b1, instr[2:0]};
        end //beq,bne,blt
      end
      2'b10:
      begin
        if (instr == 0)
        begin
          alu_ctrl = 4'b0010;
        end //add
        else
        begin
          alu_ctrl = instr;
        end //aub,and,or,xor,sll,srl,sra
      end
      2'b11:
      begin
        if (instr[2:0] == 0)
        begin
          alu_ctrl = 4'b0010;
        end //addi
        else
        begin
          alu_ctrl = {1'b0, instr[2:0]};
        end //andi,slli,srli
      end
      default:
        alu_ctrl = 4'b0000;
    endcase
  end
endmodule
