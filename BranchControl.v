module BranchControl(
    input wire CompareResult,
    input wire ID_Jump,
    input wire ID_Branch,
    output reg PCSrc,
    output reg IF_Flush
);

    always @(*) begin
        PCSrc = (CompareResult & ID_Branch) | ID_Jump;
        IF_Flush = PCSrc;
    end

endmodule
