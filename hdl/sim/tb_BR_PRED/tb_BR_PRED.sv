`timescale 1ns/1ps
module tb_BR_PRED;

    logic clk;
    logic rst;
    logic taken;
    logic active;

    BR_PRED DUT(
        .CLK(clk),
        .RST(rst),
        .ACT(active),
        .BR_TAKEN(taken),
        .TAKE_BR()
    );

    initial begin
        $dumpfile("tb_BR_PRED.vcd");
        $dumpvars(0, tb_BR_PRED);
    end

    initial begin
        rst = 1'b1;
        taken = 1'b0;
        active = 1'b0;
    end

    initial begin
        clk = 1'b0;
        forever #5 clk = ~clk;
    end

    task automatic take_branch;
        input branch_taken;
        input branch_active;
        taken <= branch_taken;
        active <= branch_active;
        #10;
        $display($stime,,,"state = %s", DUT.PS.name());
        $display($stime,,,"next state = %s", DUT.NS.name());
        taken <= 0;
        active <= 0;
        #10;
        $display($stime,,,"state = %s", DUT.PS.name());
        $display($stime,,,"next state = %s", DUT.NS.name());
    endtask

    int i;

    always begin
        #10 rst <= 1'b0;
        
        for(i = 0; i < 8; i++) begin
            take_branch(0, 0);
            take_branch(1, 0);
            take_branch(0, 1);
            take_branch(1, 1);
            take_branch(1, 1);
            take_branch(0, 1);
            take_branch(0, 1);
        end
        #10;
        $finish;
    end



endmodule
