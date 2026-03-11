/*
    Module: 2 to 1 MUX

    Instantiation Template: 

    // START: MUX2T1
    MUX2T1 
    #(.N(32)) 
    mux2 (
        .SEL(),
        .D0(),
        .D1(),
        .DOUT()
    );
    // END: MUX2T1

    Author: Ryan Cramer
    Date: March 4th, 2026

    Description: 

    Module selects DOUT from D0 or D1 
    based on if SEL is low/high. 

    If SEL = 0, DOUT = D0
    If SEL = 1, DOUT = D1

*/ 

`timescale 1ns/1ps 

module MUX2T1
#(parameter N = 32)
(
    input SEL,
    input [N-1:0] D0,
    input [N-1:0] D1,
    output [N-1:0] DOUT
);

    assign DOUT = SEL ? D1 : D0; 

endmodule
