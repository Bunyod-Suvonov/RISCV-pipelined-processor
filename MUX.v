module Mux(input0, input1, sel,out);
    input wire[31:0] input0, input1;
    input wire sel;
    output wire[31:0] out;
    assign out=(sel==1)? input1:input0;
endmodule
