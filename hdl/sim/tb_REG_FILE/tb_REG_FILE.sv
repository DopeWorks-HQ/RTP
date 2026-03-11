`timescale 1ns/1ps
module tb_REG_FILE;

	parameter XWID = 32;
	parameter XLEN = 32;

	logic CLK;
	logic [$clog2(XWID)-1:0] ADDR1;
	logic [$clog2(XWID)-1:0] ADDR2;
	logic WEN;
	logic [$clog2(XWID)-1:0] WADDR;
	logic [XLEN:0] WDATA;
	logic [XLEN:0] RS1;
	logic [XLEN:0] RS2;

	logic [31:0] sp;
	logic [31:0] gp;

	assign sp = dut.reg_file[2];
	assign gp = dut.reg_file[3];

	REG_FILE dut (
		.CLK(CLK),
		.ADDR1(ADDR1),
		.ADDR2(ADDR2),
		.WEN(WEN),
		.WADDR(WADDR),
		.WDATA(WDATA),
		.RS1(RS1),
		.RS2(RS2)
	);

	initial begin
		$dumpfile("tb_REG_FILE.vcd");
		$dumpvars(0, tb_REG_FILE);
	end

	initial begin
		CLK = 1'b0;
		forever #5 CLK = ~CLK;
	end
	
	int i = 0;
	initial begin
		ADDR1 <= 5'd0;
		ADDR2 <= 5'd0;
		WADDR <= 0;
		WDATA <= 0;

		@(posedge CLK);
		WDATA <= $urandom_range(32'hFFFF_FFFF, 0);
		WEN <= 1'b1;
		@(posedge CLK);
		$display("\nWriting a number to x0: wen = %h, wdata = %h", WEN, WDATA);
		WEN <= 1'b0;
		@(posedge CLK);
		$display("x0 after 1 clock period = %h\n", dut.reg_file[0]);
		repeat (2) @(posedge CLK);
		$display("starting off:\ngp = %h, sp = %h", gp, sp);

		for(i = 0; i < 20; i++) begin
			WDATA <= $urandom_range(32'hFFFF_FFFF, 0);
			WADDR <= i + 2;
			WEN <= 1'b1;
			if(i < 3) begin
				$display("\nwriting to x%0d", i+2);
				repeat (2) @(posedge CLK);
				$display("gp = %h, sp = %h", gp, sp);
			end
			else if(i == 3) begin
				$display("\n");
			end
			else begin
				repeat (2) @(posedge CLK);
			end
		end

		WEN <= 1'b1;
		ADDR1 <= 5'd0;
		WDATA <= $urandom_range(32'hFFFF_FFFF, 0);
		$display("\nwriting to x0 again, just to make sure");
		@(posedge CLK);
		WEN <= 1'b0;
			assert(RS1 == 32'd0)
				$display("Passed, x0 is truly zero\n");
			else
				$display("failed, x0 is not truly zero\n");
		@(posedge CLK);

		$finish;
	end

endmodule
