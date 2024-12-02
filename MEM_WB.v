module MEM_WB(
input clock,
input MEM_RegWrite,MEM_MemtoReg,MEM_return,MEM_MemRead,
input [31:0] MEM_PC_4,MEM_Readdata,MEM_Address,
input [4:0] MEM_rd,
output reg WB_RegWrite,WB_MemtoReg,WB_return, WB_MemRead,
output reg [31:0] WB_PC_4,WB_Readdata,WB_Address,
output reg [4:0]WB_rd
        );
        initial begin
        WB_RegWrite = 0;
        WB_MemtoReg = 0;
        WB_return = 0;
        WB_MemRead = 0;
        WB_PC_4 = 0;
        WB_Readdata = 0;
        WB_Address = 0;
        WB_rd = 0;
end
        always@(posedge clock)
        begin
        WB_RegWrite<=MEM_RegWrite;
        WB_MemtoReg<=MEM_MemtoReg;
        WB_return<=MEM_return;
        WB_MemRead<=MEM_MemRead;
        WB_PC_4<=MEM_PC_4;
        WB_Readdata<=MEM_Readdata;
        WB_Address<=MEM_Address;
        WB_rd<=MEM_rd;
        end
endmodule