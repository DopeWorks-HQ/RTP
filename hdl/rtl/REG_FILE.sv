/* 
    Module REG_FILE: simple XLEN x XWID register file
    Instantiation Template:

    // START: REG_FILE
    REG_FILE #(.XLEN(32),.XWID(32))
    REGISTER_FILE(
        .CLK(),
        .ADDR1(),
        .ADDR2(),
        .WEN(),
        .WADDR(),
        .WDATA(),
        .RS1(),
        .RS2()
    );
    // END: REG_FILE
*/

`timescale 1ns/1ps

module REG_FILE
#(
    parameter XWID = 32,
    parameter XLEN = 32
)(
    input  logic                    CLK,
    input  logic [$clog2(XWID)-1:0] ADDR1,
    input  logic [$clog2(XWID)-1:0] ADDR2,
    input  logic                    WEN,
    input  logic [$clog2(XWID)-1:0] WADDR,
    input  logic [XLEN:0]           WDATA,
    output logic [XLEN:0]           RS1,
    output logic [XLEN:0]           RS2
);

    logic [XLEN:0] reg_file [0:XWID];

    initial begin
        reg_file[0] = '0;
        reg_file[2] = 32'h0000_FFFF;
        reg_file[3] = 32'h0000_8000;
    end

    always_ff @(posedge CLK) begin
        if (WEN && (WADDR != '0))
            reg_file[WADDR] <= WDATA;

        reg_file[0] <= '0;
    end

    assign RS1 = (ADDR1 == '0) ? '0 : reg_file[ADDR1];
    assign RS2 = (ADDR2 == '0) ? '0 : reg_file[ADDR2];
    
/* verilator lint_off EOFNEWLINE */
endmodule
