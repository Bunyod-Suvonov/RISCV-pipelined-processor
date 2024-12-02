module ALUControl(
    input wire ins30,
    input wire [2:0] funct3,
    input wire [1:0] ALUOp,
    output reg [3:0] ALUcontrol
);
    always @(*) begin
        ALUcontrol = 4'b0010; 
        case (ALUOp)
            2'b00: ALUcontrol = 4'b0010; // Load, Store, J-type
            2'b01: begin
                case (funct3)
                    3'b000: ALUcontrol = 4'b1100; // beq
                    3'b001: ALUcontrol = 4'b1101; // bne
                    3'b101: ALUcontrol = 4'b1110; // bge
                    3'b100: ALUcontrol = 4'b1111; // blt
                endcase
            end
            2'b10: begin
                case (funct3)
                    3'b000: ALUcontrol = ins30 ? 4'b0110 : 4'b0010; // sub / add
                    3'b001: ALUcontrol = 4'b1000; // sll
                    3'b101: ALUcontrol = ins30 ? 4'b1011 : 4'b1001; // sra / srl
                    3'b110: ALUcontrol = 4'b0001; // or
                    3'b111: ALUcontrol = 4'b0000; // and
                endcase
            end
            2'b11: begin
                case (funct3)
                    3'b000: ALUcontrol = 4'b0010; // addi
                    3'b001: ALUcontrol = 4'b1000; // slli
                    3'b101: ALUcontrol = ins30 ? 4'b1011 : 4'b1001; // srai / srli
                    3'b111: ALUcontrol = 4'b0000; // andi
                endcase
            end
        endcase
    end
endmodule
