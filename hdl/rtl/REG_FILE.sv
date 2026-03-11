/* 
    Module REG_FILE: simple XLEN x XWID register file
    Instantiation Template:

    // START: REG_FILE
    REG_FILE #(.XLEN(32),.XWID(32))
    REGISTER_FILE(
        .CLK(),
        .RST(),
        .LOAD(),
        .PC_IN(),
        .PC_OUT()
    );
    // END: REG_FILE
*/

`timescale 1ns/1ps

module REG_FILE
#(
    parameter XWID = 32,
    parameter XLEN = 32
)(
    input CLK,
    input [$clog2(XWID)-1:0] ADDR1,
    input [$clog2(XWID)-1:0] ADDR2,
    input WEN,
    input [$clog2(XWID)-1:0] WADDR,
    input [XLEN:0] WDATA,
    output logic [XLEN:0] RS1,
    output logic [XLEN:0] RS2
);

    logic [XLEN:0] reg_file [0:XWID];

    always_ff@(posedge CLK)
        if(WEN)
            reg_file[WADDR] <= WDATA;
    
    assign RS1 = reg_file[ADDR1];
    assign RS2 = reg_file[ADDR2];

endmodule