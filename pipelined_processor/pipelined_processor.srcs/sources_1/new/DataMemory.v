`timescale 1ns / 1ps

module DataMemory #
  (
    parameter N = 32,
    parameter LSW = 3'b010,
    parameter LSH = 3'b001,
    parameter LSB = 3'b000,
    parameter LBU = 3'b100,
    parameter reg_rows = 32'h00000010
  )(
    input                       we, re,
    input       [2:0]           funct3,
    input       [N-1:0]         addr, wd,
    output reg  [N-1:0]         rd_out
  );
  reg         [7:0]           data[reg_rows-1:0];

  // Write to Data Memory
  always @ (*)
  begin
    if (we)
    begin
      case (funct3)
        LSW:
        begin //save word
          data[addr] <= wd[7:0];
          data[addr+1] <= wd[15:8];
          data[addr+2] <= wd[23:16];
          data[addr+3] <= wd[31:24];
        end
        LSH:
        begin //save half word
          data[addr] <= wd[7:0];
          data[addr+1] <= wd[15:8];
        end
        LSB:
        begin //save byte
          data[addr] <= wd[7:0];
        end
        default:
          data[addr] <= data[addr];
      endcase
    end
  end
  //Read from Data Memory
  always @ (*)
  begin
    if (re)
    begin
      case (funct3)
        LSW:
        begin //load word
          rd_out <= {data[addr+3], data[addr+2], data[addr+1], data[addr]};
        end
        LSH:
        begin //load half word
          rd_out <= {{16{data[addr+1][7]}}, data[addr+1], data[addr]};
        end
        LSB:
        begin //load byte
          rd_out <= {{24{data[addr][7]}}, data[addr]};
        end
        LBU:
        begin //load byte unsigned
          rd_out <= {{24{1'b0}}, data[addr]};
        end
        default:
          rd_out <= rd_out;
      endcase
    end
  end
endmodule
