module IF_ID_Pipe (
    input wire clk,
    input wire [31:0] pc,
    input wire [31:0] instr,
    output reg [31:0] pc_out,
    output reg [31:0] instr_out
);

    always @(posedge clk) begin
        pc_out <= pc;
        instr_out <= instr;
    end

endmodule
