module ID_EX(
    input clock,
    // Control signals
    input ID_Branch, ID_MemRead, ID_MemtoReg, ID_MemWrite, ID_ALUSrc, 
          ID_RegWrite, ID_Jump, ID_return, ID_PCsel, ID_ins30,
    input [1:0] ID_ALUop,
    // Data signals
    input [31:0] ID_PC_4, ID_PC, ID_readdata1, ID_readdata2, ID_immediate,
    input [4:0] ID_rd, ID_rs1, ID_rs2,
    input [2:0] ID_funct3,
    // Outputs
    output reg EX_Branch, EX_MemRead, EX_MemtoReg, EX_MemWrite, EX_ALUSrc, 
               EX_RegWrite, EX_Jump, EX_return, EX_PCsel, EX_ins30,
    output reg [1:0] EX_ALUop,
    output reg [31:0] EX_PC_4, EX_PC, EX_readdata1, EX_readdata2, EX_immediate,
    output reg [4:0] EX_rd, EX_rs1, EX_rs2,
    output reg [2:0] EX_funct3
);

    // Initialize outputs
    initial begin
        {EX_Branch, EX_MemRead, EX_MemtoReg, EX_MemWrite, EX_ALUSrc, 
         EX_RegWrite, EX_Jump, EX_return, EX_PCsel, EX_ins30} = 0;
        EX_ALUop = 2'b0;
        {EX_PC_4, EX_PC, EX_readdata1, EX_readdata2, EX_immediate} = 32'b0;
        {EX_rd, EX_rs1, EX_rs2} = 5'b0;
        EX_funct3 = 3'b0;
    end

    // Sequential logic for updating outputs
    always @(posedge clock) begin
        // Control signals
        {EX_Branch, EX_MemRead, EX_MemtoReg, EX_MemWrite, EX_ALUSrc, 
         EX_RegWrite, EX_Jump, EX_return, EX_PCsel, EX_ins30} <= 
        {ID_Branch, ID_MemRead, ID_MemtoReg, ID_MemWrite, ID_ALUSrc, 
         ID_RegWrite, ID_Jump, ID_return, ID_PCsel, ID_ins30};

        EX_ALUop <= ID_ALUop;

        // Data signals
        {EX_PC_4, EX_PC, EX_readdata1, EX_readdata2, EX_immediate} <= 
        {ID_PC_4, ID_PC, ID_readdata1, ID_readdata2, ID_immediate};

        {EX_rd, EX_rs1, EX_rs2} <= {ID_rd, ID_rs1, ID_rs2};
        EX_funct3 <= ID_funct3;
    end

endmodule
