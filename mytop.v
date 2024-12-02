`include "Adder.v"
`include "ALUcontrol.v"
`include "BranchControl.v"
`include "Comparator.v"
`include "Control.v"
`include "ControlMux.v"
`include "DataMem.v"
`include "ALU.v"
`include "immGen.v"
`include "InstMem.v"
`include "MUX.v"
`include "PC.v"
`include "IF_ID.v"
`include "ID_EX.v"
`include "EX_MEM.v"
`include "MEM_WB.v"
`include "RegFile.v"
`include "Shifter.v"
`include "ForwardingUnit.v"
`include "ThreeToOneMux.v"
`include "HazardDetectionUnit.v"

module pipelinedProcessor(
    input clk
);

// Wires for IF stage
wire PCSrc, IF_Flush, IF_ID_Write, EX_control, PCWrite;
wire [31:0] IF_PC, IF_PC_4, PCMux1, IF_instruction;

// Wires for ID stage
wire ID_Branch, ID_Jump, ID_MemRead, ID_MemtoReg, ID_MemWrite, ID_ALUSrc, ID_RegWrite, WB_regWrite, ID_return, ID_PCsel;
wire branch, jump, MemRead, MemtoReg, MemWrite, ALUSrc, RegWrite, return, PCsel, CompareResult;
wire [1:0] ID_ALUOp, ALUOp;
wire [4:0] WB_WriteReg, ID_rs1, ID_rs2;
wire [6:0] ID_Opcode;
wire [31:0] ID_PC, ID_PC_4, ID_instruction, ID_ReadData1, ID_ReadData2, ID_immediate, WB_RegWriteData, ID_FinalWriteData, ID_Jumpbase, ImmShifted;

// Wires for EX stage
wire EX_instruction_30, EX_Branch, EX_MemRead, EX_MemtoReg, EX_MemWrite, EX_ALUSrc, EX_RegWrite, EX_Jump, EX_return, EX_PCsel;
wire [1:0] EX_ALUOp, ALUForwardA, ALUForwardB;
wire [2:0] EX_funct3;
wire [3:0] ALUControlSignal;
wire [4:0] EX_rd, EX_rs1, EX_rs2;
wire [31:0] EX_PC, EX_PC_4, EX_immediate, EX_PC_imm, EX_registerReadData1, EX_registerReadData2, ALUInput1, ALUInput2Hazard, ALUInput2, EX_ALUResult;

// Wires for MEM stage
wire MEM_MemtoReg, MEM_RegWrite, MEM_Branch, MEM_Jump, MEM_return, MEM_PCsel, MEM_MemRead, MEM_MemWrite, MemSrc;
wire [2:0] MEM_funct3;
wire [4:0] MEM_rd, MEM_rs2;
wire [31:0] MEM_PC_imm, MEM_PC_4, MEM_Address, MEM_registerReadData2, MEM_dataMemoryReadData, MEM_WriteInput;

// Wires for WB stage
wire WB_MemtoReg, WB_return, WB_MemRead;
wire [31:0] WB_ReadData, WB_PC_4, WB_Address;

// IF stage
PC pc(IF_PC, PCSrc, PCMux1, clk, PCWrite);
Adder adder(IF_PC, 32'h00000004, IF_PC_4);
InstMem inst_Mem(IF_PC, IF_instruction);

// ID stage
IF_ID IF_ID_reg(
    .clock(clk),
    .IF_PC_4(IF_PC_4),
    .IF_PC(IF_PC),
    .IF_instruction(IF_instruction),
    .IF_ID_Write(IF_ID_Write),
    .IF_Flush(IF_Flush),
    .ID_PC_4(ID_PC_4),
    .ID_PC(ID_PC),
    .ID_instruction(ID_instruction),
    .ID_rs1(ID_rs1),
    .ID_rs2(ID_rs2),
    .ID_Opcode(ID_Opcode)
);
Mux WB_data(WB_RegWriteData, WB_PC_4, WB_return, ID_FinalWriteData);
RegFile reg_file(clk, ID_instruction[19:15], ID_instruction[24:20], WB_WriteReg, ID_FinalWriteData, WB_RegWrite, ID_ReadData1, ID_ReadData2);
Mux JumpBase(ID_PC, ID_ReadData1, ID_PCsel, ID_Jumpbase);
immGen imm_gen(ID_instruction, ID_immediate);
Shifter shifter(ID_immediate, ImmShifted);
Adder adder_jump(ID_Jumpbase, ImmShifted, PCMux1);
Control control_instance(
    .opcode(ID_instruction[6:0]),
    .branch(branch),
    .jump(jump),
    .MemRead(MemRead),
    .MemtoReg(MemtoReg),
    .MemWrite(MemWrite),
    .ALUSrc(ALUSrc),
    .RegWrite(RegWrite),
    .ALUOp(ALUOp),
    .return(return),
    .PCsel(PCsel)
);
ControlMux controlMux(
    branch, jump, MemRead, MemtoReg, MemWrite, ALUSrc, RegWrite, return, PCsel, ALUOp,
    EX_control, ID_Branch, ID_Jump, ID_MemRead, ID_MemtoReg, ID_MemWrite, ID_ALUSrc, ID_RegWrite, ID_return, ID_PCsel, ID_ALUOp
);
HazardDetectionUnit hazarddetectionunit(
    EX_MemRead, EX_RegWrite, EX_rd, MEM_RegWrite, MEM_rd, ID_rs1, ID_rs2, ID_Opcode, IF_ID_Write, EX_control, PCWrite
);
BranchControl branch_control(CompareResult, ID_Jump, ID_Branch, PCSrc, IF_Flush);
Comparator comparator(ID_ReadData1, ID_ReadData2, ID_instruction[14:12], CompareResult);

// EX stage
ID_EX ID_EX_reg(
    clk, ID_Branch, ID_MemRead, ID_MemtoReg, ID_MemWrite, ID_ALUSrc, ID_RegWrite, ID_Jump, ID_return, ID_PCsel,
    ID_instruction[30], ID_ALUOp, ID_PC_4, ID_PC, ID_ReadData1, ID_ReadData2, ID_immediate, ID_instruction[11:7],
    ID_instruction[19:15], ID_instruction[24:20], ID_instruction[14:12],
    EX_Branch, EX_MemRead, EX_MemtoReg, EX_MemWrite, EX_ALUSrc, EX_RegWrite, EX_Jump, EX_return, EX_PCsel,
    EX_instruction_30, EX_ALUOp, EX_PC_4, EX_PC, EX_registerReadData1, EX_registerReadData2, EX_immediate, EX_rd, EX_rs1, EX_rs2, EX_funct3
);
ThreeToOneMux ALU_mux1(EX_registerReadData1, WB_RegWriteData, MEM_Address, ALUForwardA, ALUInput1);
ThreeToOneMux ALU_mux2(EX_registerReadData2, WB_RegWriteData, MEM_Address, ALUForwardB, ALUInput2Hazard);
Mux ALUin_mux(ALUInput2Hazard, EX_immediate, EX_ALUSrc, ALUInput2);
ALUControl ALU_control(EX_instruction_30, EX_funct3, EX_ALUOp, ALUControlSignal);
ALU ALU(ALUInput1, ALUInput2, ALUControlSignal, EX_ALUResult);

// MEM stage
EX_MEM EX_MEM_reg(
    clk, EX_MemtoReg, EX_RegWrite, EX_Branch, EX_Jump, EX_MemRead, EX_MemWrite, EX_return, EX_PCsel,
    EX_PC_4, EX_PC_imm, EX_ALUResult, ALUInput2Hazard, EX_rd, EX_rs2, EX_funct3,
    MEM_MemtoReg, MEM_RegWrite, MEM_Branch, MEM_Jump, MEM_MemRead, MEM_MemWrite, MEM_return, MEM_PCsel,
    MEM_PC_4, MEM_PC_imm, MEM_Address, MEM_registerReadData2, MEM_rd, MEM_rs2, MEM_funct3
);
Mux write_data_mux(MEM_registerReadData2, WB_ReadData, MemSrc, MEM_WriteInput);
DataMem data_mem(MEM_MemRead, MEM_MemWrite, MEM_Address, MEM_WriteInput, MEM_dataMemoryReadData, MEM_funct3);

// WB stage
MEM_WB MEM_WB_reg(
    clk, MEM_RegWrite, MEM_MemtoReg, MEM_return, MEM_MemRead, MEM_PC_4, MEM_dataMemoryReadData,
    MEM_Address, MEM_rd, WB_RegWrite, WB_MemtoReg, WB_return, WB_MemRead, WB_PC_4, WB_ReadData, WB_Address, WB_WriteReg
);
Mux toReg_mux(WB_Address, WB_ReadData, WB_MemtoReg, WB_RegWriteData);
ForwardingUnit forwarding_unit(
    MEM_RegWrite, MEM_rd, EX_rs1, EX_rs2, WB_RegWrite, WB_MemRead, WB_WriteReg,
    MEM_MemWrite, MEM_MemRead, MEM_rs2, MEM_rd, ID_rs1, ID_rs2, ID_Opcode, ALUForwardA, ALUForwardB, MemSrc
);

endmodule
