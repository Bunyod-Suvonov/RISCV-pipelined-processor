module PC (
    input wire clk,
    input wire reset,
    input wire [31:0] pc_next,
    output reg [31:0] pc
);
    always @(posedge clk or posedge reset) begin
        if (reset)
            pc <= 32'b0;  // Reset PC to 0
        else
            pc <= pc_next;
    end
endmodule