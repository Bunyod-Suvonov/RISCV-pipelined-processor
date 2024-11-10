`timescale 1ns / 1ps

module ALU #
  (
    parameter N = 32
  ) (
    input       [N-1:0]  rd1,
    input       [N-1:0]  imm,
    input       [3:0]    alu_ctrl,
    output reg  [N-1:0]  alu_result,
    output reg           zero
  );

  parameter ADD = 4'b0010;
  parameter SUB = 4'b1000;
  parameter SUB_NEQ = 4'b1001;
  parameter XOR = 4'b0100;
  parameter  OR = 4'b0110;
  parameter AND = 4'b0111;
  parameter SUB_BLT = 4'b1100;
  parameter SLL = 4'b0001;
  parameter SRL = 4'b0101;
  parameter SRA = 4'b1101;
  parameter SUB_BGE = 4'b1110;

  always @ (*)
  begin
    case (alu_ctrl)
      ADD:
      begin
        alu_result =  rd1 + imm; // add
        zero = 1'b1; // jal & jalr
      end
      SUB, SUB_NEQ:
      begin
        if (rd1 == imm)
        begin
          zero = ~alu_ctrl[0];
          alu_result =  0;
        end
        else
        begin
          zero =  alu_ctrl[0];
          alu_result =  rd1 - imm; // sub
        end
      end
      SUB_BLT, SUB_BGE:
      begin
        if ($signed(rd1) < $signed(imm))
        begin
          zero = ~alu_ctrl[1];
          alu_result =  0;
        end
        else
        begin
          zero =  alu_ctrl[1];
          alu_result =  0;
        end
      end
      XOR:
        alu_result =  rd1 ^ imm; // xor
      OR:
        alu_result =  rd1 | imm; // or
      AND:
        alu_result =  rd1 & imm; // and
      SLL:
        alu_result =  rd1 << imm; // sll
      SRL:
        alu_result =  rd1 >> imm; // srl
      SRA:
        alu_result =  $signed($signed(rd1) >>> imm); // sra
      default:
      begin
        alu_result = 0;
        zero = 0;
      end
    endcase
  end

endmodule
