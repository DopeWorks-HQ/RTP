`timescale 1ns/1ps
module tb_MUX8T1;


	MUX8T1 dut (

	);

	initial begin
		$dumpfile("tb_MUX8T1.vcd");
		$dumpvars(0, tb_MUX8T1);
	end

	initial begin
		#200;
		$finish;
	end

endmodule
