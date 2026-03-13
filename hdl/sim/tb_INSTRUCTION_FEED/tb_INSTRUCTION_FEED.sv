`timescale 1ns/1ps

module tb_INSTRUCTION_FEED;

    logic tb_clk;
    logic tb_rst;
    logic tb_hold;

    INSTRUCTION_FEED DUT(
        .clk(tb_clk),
        .hold(tb_hold),
        .rst(tb_rst)
    );

    initial begin
        $dumpfile("tb_INSTRUCTION_FEED.vcd");
        $dumpvars(0, tb_INSTRUCTION_FEED);
    end

    initial begin
        tb_clk = 1'b0;
        forever #5 tb_clk = ~tb_clk;
    end

    initial begin
        tb_rst = 1'b1;
        tb_hold = 1'b0;
    end

    initial begin
        #10;
        tb_rst = 1'b0;
        #20;
        tb_hold = 1'b1;
        #10;
        tb_hold = 1'b0;
        #1000;
        $finish;
    end



endmodule