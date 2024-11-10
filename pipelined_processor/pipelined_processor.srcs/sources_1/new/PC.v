module PC(
    input wire clk,
    input wire reset,
    input wire [31:0] pc_next,
    output reg [31:0] pc
  );

  always @(posedge clk or posedge reset)
  begin
    if (reset)
    begin
      pc <= 32'b0; // reset PC to zero
    end
    else
    begin
      pc <= pc_next; // Update PC
    end
  end

endmodule
