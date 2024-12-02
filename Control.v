module Control(
    input wire [6:0] opcode,
    output reg branch, jump, MemRead, MemtoReg, MemWrite, ALUSrc, RegWrite, return, PCsel,
    output reg [1:0] ALUOp
);

    always @(*) begin
        // Default values for control signals
        branch   = 0;
        jump     = 0;
        MemRead  = 0;
        MemtoReg = 0;
        MemWrite = 0;
        ALUSrc   = 0;
        RegWrite = 0;
        return   = 0;
        PCsel    = 0;
        ALUOp    = 2'b00;

        // Control logic based on opcode
        case (opcode)
            7'b0110011: begin // R-type (add, sub, etc.)
                ALUOp    = 2'b10;
                RegWrite = 1;
            end
            7'b0000011: begin // I-type (lb, lw, lbu)
                MemRead  = 1;
                MemtoReg = 1;
                ALUSrc   = 1;
                RegWrite = 1;
            end
            7'b0100011: begin // S-type (sb, sw)
                MemWrite = 1;
                ALUSrc   = 1;
            end
            7'b1100011: begin // B-type (beq, bne, etc.)
                branch = 1;
                ALUOp  = 2'b01;
            end
            7'b0010011: begin // I-type (addi, slli, srli, andi)
                ALUSrc   = 1;
                ALUOp    = 2'b11;
                RegWrite = 1;
            end
            7'b1100111: begin // I-type (jalr)
                PCsel    = 1;
                jump     = 1;
                ALUSrc   = 1;
                RegWrite = 1;
            end
            7'b1101111: begin // J-type (jal)
                return   = 1;
                jump     = 1;
                ALUSrc   = 1;
                RegWrite = 1;
            end
            default: begin
                // Default case: all signals remain at their default values
            end
        endcase
    end

endmodule
