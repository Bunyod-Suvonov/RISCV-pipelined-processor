module RegFile (
    input wire clk,        // Clock input   
    input wire [4:0] rd_r1,  // Input data to be stored in the register
    input wire [4:0] rd_r2,
    input wire [4:0] wt_reg,
    input wire [31:0] wt_d,
    input wire RegWrite,
    output [31:0] rd_d1,  // Output data from the register
    output [31:0] rd_d2
);
    reg [31:0] x_reg [31:0]; // register x0-x31
    integer i;
    initial //intialization
        begin
        for(i=0; i<32; i= i+1) begin x_reg[i] = 0;end
        end
    
    assign    rd_d1 = x_reg[rd_r1];
    assign    rd_d2 = x_reg[rd_r2];
    
    always @ (*) begin
        if (RegWrite && wt_reg!=0) begin
            x_reg[wt_reg] <= wt_d; 
        end 
    end
    
endmodule