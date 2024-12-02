module ThreeToOneMux(
    input wire [31:0] in00, in01, in10, 
    input wire [1:0] sel,
    output reg [31:0] out
);

    always @(*) begin
        case (sel)
            2'b00: out = in00;
            2'b01: out = in01;
            2'b10: out = in10;
            default: out = 32'b0; // Default case: output is zero
        endcase
    end

endmodule
