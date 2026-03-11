`timescale 1ns/1ps

module REG_FILE(
    input clk,
    input [4:0] addr1,
    input [4:0] addr2,
    input wen,
    input [4:0] waddr,
    input [31:0] wdata,
    output logic [31:0] rs1,
    output logic [31:0] rs2
);

    logic [31:0] reg_file [0:31];

    always_ff@(posedge clk)
        if(wen)
            reg_file[waddr] <= wdata;
    
    assign rs1 = reg_file[addr1];
    assign rs2 = reg_file[addr2];

endmodule