module DataMem(MemRead, MemWrite, address, writeData, readData, funct3);
input wire MemRead, MemWrite;
input wire[2:0] funct3;
input wire[31:0] address;
input wire[31:0] writeData;
output reg[31:0] readData;
reg[7:0] memory[0:31];
integer i;
initial begin
for (i=0;i<32;i=i+1) 
    memory[i]=0;
end
initial begin
    readData=0;
end
always @ (*) begin
    if (MemWrite) begin
        case (funct3)
            3'b010: begin //save word
                memory[address] <= writeData[7:0]; 
                memory[address+1] <= writeData[15:8]; 
                memory[address+2] <= writeData[23:16]; 
                memory[address+3] <= writeData[31:24]; 
            end
             
            3'b000: begin //save byte
                memory[address] <= writeData[7:0];
            end
            default: memory[address] <= memory[address];
        endcase
    end
end

always @ (*) begin    
    if (MemRead) begin
        case (funct3)
            3'b010: begin //load word
                readData <= {memory[address+3], memory[address+2], memory[address+1], memory[address]};
            end
            
            3'b000: begin //load byte
                readData <= {{24{memory[address][7]}}, memory[address]};
            end
            3'b100: begin //load byte unsigned
                readData <= {{24{1'b0}}, memory[address]};
            end
            default: readData <= 0;
        endcase
    end
end

endmodule
