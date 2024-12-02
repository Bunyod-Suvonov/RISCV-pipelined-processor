module Shifter(in, out);
    input wire[31:0] in;
    output wire[31:0] out;
    assign out={in[30:0],1'b0};
endmodule
