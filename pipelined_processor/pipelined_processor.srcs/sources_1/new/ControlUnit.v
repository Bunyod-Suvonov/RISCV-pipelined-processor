`timescale 1ns / 1ps

module ControlUnit (
    input wire [6:0] opcode,
    output reg mem_to_reg,
    output reg reg_write,
    output reg mem_read,
    output reg mem_write,
    output reg branch,
    output reg alu_src,
    output reg [1:0] alu_op
);
    always @(opcode) begin
        case (opcode)
            7'b1100011: begin  // Branch (e.g., beq, bne)
                alu_src = 0;
                mem_to_reg = 0;  // Not used for branch
                reg_write = 0;
                mem_read = 0;
                mem_write = 0;
                branch = 1;
                alu_op = 2'b01;  // ALU operation set to subtraction for branch comparison
            end
            7'b0110011: begin  // R-type (e.g., add, sub, and, or)
                alu_src = 0;
                mem_to_reg = 0;
                reg_write = 1;
                mem_read = 0;
                mem_write = 0;
                branch = 0;
                alu_op = 2'b10;  // ALU operation based on funct3/funct7
            end
            7'b0010011: begin  // I-type (e.g., addi)
                alu_src = 1;
                mem_to_reg = 0;
                reg_write = 1;
                mem_read = 0;
                mem_write = 0;
                branch = 0;
                alu_op = 2'b00;  // Immediate ALU operation (addi)
            end
            7'b0000011: begin  // Load (e.g., lw)
                alu_src = 1;
                mem_to_reg = 1;
                reg_write = 1;  
                mem_read = 1;
                mem_write = 0;
                branch = 0;
                alu_op = 2'b00;  // Use ALU to calculate address
                
                // Debugging message
            end
            7'b0100011: begin  // Store (e.g., sw)
                alu_src = 1;
                mem_to_reg = 0;  // Not used for store
                reg_write = 0;
                mem_read = 0;
                mem_write = 1;
                branch = 0;
                alu_op = 2'b00;  // Use ALU to calculate address
            end
            default: begin  // Default case for unsupported opcodes
                alu_src = 0;
                mem_to_reg = 0;
                reg_write = 0;
                mem_read = 0;
                mem_write = 0;
                branch = 0;
                alu_op = 2'b00;
            end
        endcase
    end
endmodule
