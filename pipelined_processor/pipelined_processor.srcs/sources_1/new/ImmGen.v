`timescale 1ns/1ps

module ImmediateGen
  (
    input       [31:0]          instr,
    output reg  [31:0]          imm
  );

  always @ (*)
  begin
    case (instr[6:0])
      7'b0000011:
      begin
        imm = {{20{instr[31]}}, instr[31:20]};
      end //I-type: lw
      7'b0001111:
      begin
        imm = {{20{instr[31]}}, instr[31:20]};
      end //I-type: fence
      7'b0010011:
      begin
        imm = {{20{instr[31]}}, instr[31:20]};
      end //I-type: addi
      7'b0010111:
      begin
        imm = {instr[31:12], {12{1'b0}}};
      end //U-type: auipc
      7'b0100011:
      begin
        imm = {{20{instr[31]}}, instr[31:25], instr[11:7]};
      end //S-type: sw
      7'b0110111:
      begin
        imm = {instr[31:12], {12{1'b0}}};
      end //U-type: lui
      7'b1100011:
      begin
        imm = {{21{instr[31]}}, instr[7], instr[30:25], instr[11:8]};
      end //B-type: beq, bne
      7'b1100111:
      begin
        imm = {{20{instr[31]}}, instr[31:20]};
      end //I-type: jalr
      7'b1101111:
      begin
        imm = {{21{instr[31]}}, instr[19:12], instr[20], instr[30:21]};
      end //J-type: jal
      7'b1110011:
      begin
        imm = {{20{instr[31]}}, instr[31:20]};
      end //I-type: ecall
      default:
      begin
        imm[31:0]  = 0;
      end
    endcase
  end
endmodule
