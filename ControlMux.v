module ControlMux(
    input branch, jump, MemRead, MemtoReg, MemWrite, ALUSrc, RegWrite, return, PCsel,
    input [1:0] ALUOp,
    input EX_control,
    output reg ID_Branch, ID_Jump, ID_MemRead, ID_MemtoReg, ID_MemWrite, ID_ALUSrc, ID_RegWrite, ID_return, ID_PCsel,
    output reg [1:0] ID_ALUOp
);

    always @(*) begin
        if (EX_control) begin
            ID_Branch = branch;
            ID_Jump = jump;
            ID_MemRead = MemRead;
            ID_MemtoReg = MemtoReg;
            ID_MemWrite = MemWrite;
            ID_ALUSrc = ALUSrc;
            ID_RegWrite = RegWrite;
            ID_return = return;
            ID_ALUOp = ALUOp;
            ID_PCsel = PCsel;
        end else begin
            ID_Branch = 0;
            ID_Jump = 0;
            ID_MemRead = 0;
            ID_MemtoReg = 0;
            ID_MemWrite = 0;
            ID_ALUSrc = 0;
            ID_RegWrite = 0;
            ID_return = 0;
            ID_ALUOp = 2'b00;
            ID_PCsel = 0;
        end
    end

endmodule
