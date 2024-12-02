module IF_ID (
    input clock,
    input [31:0] IF_PC_4, IF_PC, IF_instruction,
    input wire IF_ID_Write, IF_Flush, // Control signals
    output reg [31:0] ID_PC_4, ID_PC, ID_instruction,
    output reg [4:0] ID_rs1, ID_rs2,
    output reg [6:0] ID_Opcode
);

    // Initialize outputs
    initial begin
        ID_PC_4 = 32'b0;
        ID_PC = 32'b0;
        ID_instruction = 32'b0;
        ID_rs1 = 5'b0;
        ID_rs2 = 5'b0;
        ID_Opcode = 7'b0;
    end

    // Sequential logic with flush and write control
    always @(posedge clock) begin
        if (IF_ID_Write) begin
            if (IF_Flush) begin
                // Handle flush: set instruction to NOP (addi x0, x0, 0)
                ID_PC_4 <= IF_PC_4;
                ID_PC <= IF_PC;
                ID_instruction <= 32'b00000000000000000000000000010011; // NOP
                ID_rs1 <= 5'b0;
                ID_rs2 <= 5'b0;
                ID_Opcode <= 7'b0010011;
            end else begin
                // Normal operation: propagate instruction and PC values
                ID_PC_4 <= IF_PC_4;
                ID_PC <= IF_PC;
                ID_instruction <= IF_instruction;
                ID_rs1 <= IF_instruction[19:15];
                ID_rs2 <= IF_instruction[24:20];
                ID_Opcode <= IF_instruction[6:0];
            end
        end
    end

endmodule
