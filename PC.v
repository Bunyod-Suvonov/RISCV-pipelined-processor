

module PC(PC, PCSrc, PCMux, clk, PCWrite);
    input wire[31:0] PCMux;
    input clk, PCSrc, PCWrite;
    output reg[31:0] PC;

    parameter normal = 4;
    initial begin
        PC = 32'b0;
        end
    always @(posedge clk) begin 
        if (PCWrite == 1'b1) begin 
            if (PCSrc == 1'b1)
            begin
                PC <= PCMux;
            end 
            else 
            begin
                PC <= PC +normal;
            end
            end
        end

endmodule
