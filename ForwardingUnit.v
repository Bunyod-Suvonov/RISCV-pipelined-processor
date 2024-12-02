module ForwardingUnit(
    input wire MEM_RegWrite,
    input wire [4:0] MEM_RegisterRd, EX_RegisterRs1, EX_RegisterRs2, // EX hazard
    input wire WB_RegWrite, WB_MemRead,
    input wire [4:0] WB_RegisterRd, // MEM hazard
    input wire MEM_MemWrite, MEM_MemRead,
    input wire [4:0] MEM_rs2, MEM_rd, ID_RegisterRs1, ID_RegisterRs2,
    input wire [6:0] ID_Opcode,
    output reg [1:0] ForwardA, ForwardB,
    output reg MemSrc
);

    // Initialize outputs to avoid unknown states
    initial begin
        ForwardA = 2'b00;
        ForwardB = 2'b00;
        MemSrc = 1'b0;
    end

    // Combinational logic for forwarding and MemSrc hazard resolution
    always @(*) begin
        // ForwardA: Determine forwarding for source register Rs1
        if (MEM_RegWrite && (MEM_RegisterRd != 5'b0) && (MEM_RegisterRd == EX_RegisterRs1)) begin
            ForwardA = 2'b10; // Forward from MEM stage
        end else if (WB_RegWrite && (WB_RegisterRd != 5'b0) && (WB_RegisterRd == EX_RegisterRs1) &&
                     !(MEM_RegWrite && (MEM_RegisterRd != 5'b0) && (MEM_RegisterRd == EX_RegisterRs1))) begin
            ForwardA = 2'b01; // Forward from WB stage
        end else begin
            ForwardA = 2'b00; // No forwarding
        end

        // ForwardB: Determine forwarding for source register Rs2
        if (MEM_RegWrite && (MEM_RegisterRd != 5'b0) && (MEM_RegisterRd == EX_RegisterRs2)) begin
            ForwardB = 2'b10; // Forward from MEM stage
        end else if (WB_RegWrite && (WB_RegisterRd != 5'b0) && (WB_RegisterRd == EX_RegisterRs2) &&
                     !(MEM_RegWrite && (MEM_RegisterRd != 5'b0) && (MEM_RegisterRd == EX_RegisterRs2))) begin
            ForwardB = 2'b01; // Forward from WB stage
        end else begin
            ForwardB = 2'b00; // No forwarding
        end

        // MemSrc: Resolve hazard for memory write data source
        if ((WB_RegisterRd == MEM_rs2) && WB_MemRead && MEM_MemWrite) begin
            MemSrc = 1'b1; // Hazard detected, forward data
        end else begin
            MemSrc = 1'b0; // No hazard
        end
    end

endmodule
