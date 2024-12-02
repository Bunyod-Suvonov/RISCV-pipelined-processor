module ALU(
    input [31:0] input1,
    input [31:0] input2,
    input [3:0] ALUcontrol,
    output reg [31:0] ALUresult
);
    initial ALUresult=0;
    always@(input1, input2, ALUcontrol)begin
    case (ALUcontrol)
        4'b0010:begin ALUresult=input1+input2;//add,addi,lw,sw,lb,lbu,sb,jalr
       
        end
        4'b0110:begin ALUresult=input1-input2;//sub
       
        end
        4'b0000:begin ALUresult=input1&input2;//and,andi
       
        end
        4'b0001:begin ALUresult=input1|input2;//or
        
        end
        4'b1000:begin ALUresult=input1<<input2;//sll,slli
       
        end
        4'b1001:begin ALUresult=input1>>input2;//srl,srli
        
        end
        4'b1011:begin ALUresult=($signed(input1))>>>input2;//sra
        
        end
        4'b1100:begin ALUresult=input1-input2;//beq
        
        end
        4'b1101:begin ALUresult=input1-input2;//bne
        
        end
        4'b1110:begin ALUresult=0;//bge
        
        end
        4'b1111:begin ALUresult=0;//blt
        
        end    
        default:begin ALUresult=0;end //jal doesn't use ALU
    endcase
    end
endmodule