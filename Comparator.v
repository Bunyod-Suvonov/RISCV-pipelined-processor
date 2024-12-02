module Comparator(
    input [31:0] ID_readdata1,
    input [31:0] ID_readdata2,
    input [2:0] ID_funct3,
    output reg CompareResult
);

    // Initialize CompareResult to 0
    initial begin
        CompareResult = 0;
    end

    // Compare based on funct3
    always @(*) begin
        case (ID_funct3)
            3'b000: CompareResult = (ID_readdata1 == ID_readdata2);          // Equal (beq)
            3'b001: CompareResult = (ID_readdata1 != ID_readdata2);          // Not equal (bne)
            3'b100: CompareResult = ($signed(ID_readdata1) < $signed(ID_readdata2)); // Less than (blt)
            3'b101: CompareResult = ($signed(ID_readdata1) >= $signed(ID_readdata2)); // Greater or equal (bge)
            default: CompareResult = 0;                                      // Default case
        endcase
    end

endmodule
