/*
    Module: 8 to 1 MUX

    Instantiation Template: 

    // START: MUX8T1
    MUX8T1 
    #(.N(32)) 
    mux8 (
        .SEL(),
        .D0(),
        .D1(),
        .D2(),
        .D3(),
        .D4(),
        .D5(),
        .D6(),
        .D7(),
        .DOUT()
    );
    // END: MUX8T1
    
    Author: Ryan Cramer
    Date: March 4th, 2026

    Description: 

    Module selects DOUT from D0, D1, D2, D3,
    D4, D5, D6, or D7 based on if SEL is low/high. 

    If SEL = 0, DOUT = D0
    If SEL = 1, DOUT = D1
    If SEL = 2, DOUT = D2
    If SEL = 3, DOUT = D3
    If SEL = 4, DOUT = D4
    If SEL = 5, DOUT = D5
    If SEL = 6, DOUT = D6
    If SEL = 7, DOUT = D7
*/ 

`timescale 1ns/1ps 
/* verilator lint_off MULTITOP */
module MUX8T1
#(parameter N = 32)
(
    input [2:0] SEL,
    input [N-1:0] D0,
    input [N-1:0] D1,
    input [N-1:0] D2,
    input [N-1:0] D3,
    input [N-1:0] D4,
    input [N-1:0] D5,
    input [N-1:0] D6,
    input [N-1:0] D7,
    output [N-1:0] DOUT
);

    assign DOUT = SEL[2] ? (SEL[1] ? (SEL[0] ? D7 : D6) : (SEL[0] ? D5 : D4)) : 
                           (SEL[1] ? (SEL[0] ? D3 : D2) : (SEL[0] ? D1 : D0)); 

endmodule
