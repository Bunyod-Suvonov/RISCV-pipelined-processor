`timescale 1ns / 1ps

`include "mytop.v"
module sim;

    reg clk;
	pipelinedProcessor test (
		clk
	);
    initial begin
        $dumpfile("sim.vcd");
        $dumpvars(0, sim);
  end

	initial begin
		clk = 0; // Initialize Inputs
	end

    initial begin
        while ($time < 60) @(posedge clk)begin
            $display("===============================================");
            $display("Time: %d, CLK = %d, PC = %H", $time/2, clk, test.IF_PC);
            $display("[ra] = %H, [$t0] = %H, [$t1] = %H", test.reg_file.x_reg[1], test.reg_file.x_reg[5], test.reg_file.x_reg[6]);
            $display("[$t2] = %H, [$t3] = %H, [$t4] = %H", test.reg_file.x_reg[7], test.reg_file.x_reg[28], test.reg_file.x_reg[29]);
            $display("===============================================");
        end
        $finish();
    end
    always #1 clk = ~clk;
    
endmodule