`timescale 1ns/1ps

module INSTRUCTION_FEED(
    input clk,
    input hold,
    input rst
);

    logic [31:0] pc_in, pc_out, ir;
    logic inv_err;

    assign pc_in = pc_out + 4;
    
    IMEM INSTRUCTION_MEMORY(
        .CLK(clk),
        .IR_RD_EN(1'b1), 
        .IR_ADDR(pc_out[14:2]), // ADDR = 2^10 (6144 words)
        .IR_OUT(ir),
        .INVALID_ACCESS(inv_err)
    );

    PROG_CNTR #(.XLEN(32))
    PROGRAM_COUNTER(
        .CLK(clk),
        .RST(rst),
        .LOAD(~hold),
        .PC_IN(pc_in),
        .PC_OUT(pc_out)
    );
endmodule