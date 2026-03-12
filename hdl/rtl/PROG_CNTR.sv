/* 
    Module PROG_CNTR: 32 bit Register

    Instantiation Template:

    // START: PROG_CNTR
    PROG_CNTR #(.XLEN(32))
    PROGRAM_COUNTER(
        .CLK(),
        .RST(),
        .LOAD(),
        .PC_IN(),
        .PC_OUT()
    );
    // END: PROG_CNTR
*/

`timescale 1ns/1ps
/* verilator lint_off MULTITOP */
module PROG_CNTR
#(parameter XLEN = 32)
(
    input CLK,
    input RST,
    input LOAD,
    input [XLEN-1:0] PC_IN,
    output logic [XLEN-1:0] PC_OUT
);

    always_ff@(posedge CLK)
        if(RST)
            PC_OUT <= 0;
        else if(LOAD)
            PC_OUT <= PC_IN;
            
endmodule
