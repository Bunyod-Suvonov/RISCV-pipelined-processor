module immGen(
    input wire [31:0] instr,
    output reg [31:0] imm
);

integer i;

initial begin
    imm = 32'b0;
end

always @(*) begin
    case (instr[6:0])
        7'b0100011: begin // S-type
            imm[4:0] <= instr[11:7];
            imm[11:5] <= instr[31:25];
            for (i = 12; i < 32; i = i + 1) begin
                imm[i] <= instr[31];
            end
        end

        7'b1100011: begin // B-type
            imm[11] <= instr[31];
            imm[10] <= instr[7];
            imm[3:0] <= instr[11:8];
            imm[9:4] <= instr[30:25];
            for (i = 12; i < 32; i = i + 1) begin
                imm[i] <= instr[31];
            end
        end

        7'b1101111: begin // J-type
            imm[19] <= instr[31];
            imm[9:0] <= instr[30:21];
            imm[10] <= instr[20];
            imm[18:11] <= instr[19:12];
            for (i = 20; i < 32; i = i + 1) begin
                imm[i] <= instr[31];
            end
        end

        7'b0000011, 7'b0010011, 7'b1100111: begin // I-type
            imm[11:0] <= instr[31:20];
            for (i = 12; i < 32; i = i + 1) begin
                imm[i] <= instr[31];
            end
        end

        7'b0010111, 7'b0110111: begin // U-type
            imm[19:0] <= instr[31:12];
            for (i = 20; i < 32; i = i + 1) begin
                imm[i] <= instr[31];
            end
        end

        7'b0010011: begin // nop
            imm <= 32'b0;
        end

        default: begin
            imm <= 32'b0;
        end
    endcase
end

endmodule
