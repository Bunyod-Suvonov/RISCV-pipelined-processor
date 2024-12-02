module EX_MEM (
    input clock,
    // Control signals
    input EX_MemtoReg, EX_RegWrite, EX_Branch,
          EX_Jump, EX_MemRead, EX_MemWrite, EX_return, EX_PCsel,
    // Data signals
    input [31:0] EX_PC_4, EX_PC_imm, ALUresult, readdata2,
    input [4:0] EX_rd, EX_rs2,
    input [2:0] EX_funct3,
    // Outputs
    output reg MEM_MemtoReg, MEM_RegWrite, MEM_Branch,
               MEM_Jump, MEM_MemRead, MEM_MemWrite, MEM_return, MEM_PCsel,
    output reg [31:0] MEM_PC_4, MEM_PC_imm, Address, Writedata,
    output reg [4:0] MEM_rd, MEM_rs2,
    output reg [2:0] MEM_funct3
);

    // Initialize all registers to 0
    initial begin
        {MEM_MemtoReg, MEM_RegWrite, MEM_Branch, MEM_Jump, MEM_MemRead, 
         MEM_MemWrite, MEM_return, MEM_PCsel} = 0;
        {MEM_PC_4, MEM_PC_imm, Address, Writedata} = 32'b0;
        {MEM_rd, MEM_rs2} = 5'b0;
        MEM_funct3 = 3'b0;
    end

    // Update registers on the rising edge of the clock
    always @(posedge clock) begin
        // Control signals
        {MEM_MemtoReg, MEM_RegWrite, MEM_Branch, MEM_Jump, MEM_MemRead, 
         MEM_MemWrite, MEM_return, MEM_PCsel} <= 
        {EX_MemtoReg, EX_RegWrite, EX_Branch, EX_Jump, EX_MemRead, 
         EX_MemWrite, EX_return, EX_PCsel};

        // Data signals
        {MEM_PC_4, MEM_PC_imm} <= {EX_PC_4, EX_PC_imm};
        {Address, Writedata} <= {ALUresult, readdata2};
        {MEM_rd, MEM_rs2} <= {EX_rd, EX_rs2};
        MEM_funct3 <= EX_funct3;
    end

endmodule
