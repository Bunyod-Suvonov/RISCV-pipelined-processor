module HazardDetectionUnit (
    input wire EX_memRead, EX_regWrite,
    input wire [4:0] EX_rd,
    input wire MEM_regWrite,
    input wire [4:0] MEM_rd, ID_rs1, ID_rs2,
    input wire [6:0] ID_opcode,
    output reg IF_ID_Write, EX_control, PCWrite
);

    // Initialize outputs
    initial begin
        IF_ID_Write = 1'b1;
        EX_control = 1'b1;
        PCWrite = 1'b1;
    end

    always @(*) begin
        // Default state (no hazard)
        IF_ID_Write = 1'b1;
        EX_control = 1'b1;
        PCWrite = 1'b1;

        // Branch or Jump instructions
        if (ID_opcode == 7'b1100011 || ID_opcode == 7'b1100111 || ID_opcode == 7'b1101111) begin
            if ((EX_regWrite && (EX_rd != 5'b0) && ((EX_rd == ID_rs1) || (EX_rd == ID_rs2))) ||
                (MEM_regWrite && (MEM_rd != 5'b0) && ((MEM_rd == ID_rs1) || (MEM_rd == ID_rs2)))) begin
                // Jump/Branch data hazard detected
                IF_ID_Write = 1'b0;
                EX_control = 1'b0;
                PCWrite = 1'b0;
            end
        end
        // Load-use hazard detection
        else if (EX_memRead && (EX_rd != 5'b0) && ((EX_rd == ID_rs1) || (EX_rd == ID_rs2))) begin
            // Load-use hazard detected
            IF_ID_Write = 1'b0;
            EX_control = 1'b0;
            PCWrite = 1'b0;
        end
    end

endmodule
