/*
    Module: 4 to 1 MUX

    Instantiation Template: 

    // START: MUX4T1
    MUX4T1 
    #(.N(32)) 
    mux4 (
        .SEL(),
        .D0(),
        .D1(),
        .D2(),
        .D3(),
        .DOUT()
    );
    // END: MUX4T1

    Author: Ryan Cramer
    Date: March 4th, 2026

    Description: 

    Module selects DOUT from D0, D1, D2, or D3 
    based on if SEL is low/high. 

    If SEL = 0, DOUT = D0
    If SEL = 1, DOUT = D1
    If SEL = 2, DOUT = D2
    If SEL = 3, DOUT = D3

*/ 

`timescale 1ns/1ps 
/* verilator lint_off MULTITOP */
module MUX4T1
#(parameter N = 32)
(
    input [1:0] SEL,
    input [N-1:0] D0,
    input [N-1:0] D1,
    input [N-1:0] D2,
    input [N-1:0] D3,
    output [N-1:0] DOUT
);

    assign DOUT = SEL[1] ? (SEL[0] ? D3 : D1) : (SEL[0] ? D2 : D0); 

endmodule
