/*
    Module: Instruction Memory 24kb

    Instantiation Template: 

        // START: IMEM
        DMEM DATA_MEMORY(
            .CLK(),
            .IR_RD_EN(), 
            .IR_ADDR(), // ADDR = 2^10 (6144 words)
            .IR_OUT(),
            .INVALID_ACCESS()
        );

*/

`timescale 1ns/1ps

module DMEM
(
    input CLK,
    input RD_EN,
    input WR_EN,
    input SIGN,
    input [1:0] SIZE,
    input [31:0] ADDR, // Addresses 40kB of Memory)
    input [31:0] DATA_IN,
    input [31:0] IO_IN,
    output logic [XLEN:0] DATA_OUT,
    output logic IO_WR,
    output logic INVALID_ACCESS
);

    logic [7:0] data_memory_40kb [0:40959]; // 40kB
    
    logic [31:0] formatted_in;
    logic [31:0] formatted_out;
    logic [31:0] addr_offset;
    logic [31:0] addr;

    logic MMIO_ACCESS;

    assign addr_offset = 32'h6000;
    assign addr = ADDR - addr_offset;

    assign INVALID_ACCESS = (ADDR < 32'h6000) || 
            ((ADDR > 16'hFFFF) && ~MMIO_ACCESS);
    always_ff@(posedge_clk)

endmodule