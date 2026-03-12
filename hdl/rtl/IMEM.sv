/*
    Module: Instruction Memory 24kb

    Instantiation Template: 

        // START: IMEM
        IMEM INSTRUCTION_MEMORY(
            .CLK(),
            .IR_RD_EN(), 
            .IR_ADDR(), // ADDR = 2^10 (6144 words)
            .IR_OUT(),
            .INVALID_ACCESS()
        );

*/

`timescale 1ns/1ps

module IMEM
(
    input CLK,
    input IR_RD_EN,
    input [13:0] IR_ADDR,
    output logic [31:0] IR_OUT,
    output logic INVALID_ACCESS
);

    logic EACCESS;
    logic [31:0] instruction_memory_24kb [0:6143];

    initial begin 
        $readmemh("program.mem", instruction_memory_24kb);
    end
    
    assign EACCESS = (IR_ADDR > 14'd6143); // (24kb / 4 bytes) = 6144 words

    always_ff@(posedge CLK) begin
        if(IR_RD_EN) begin
            if(EACCESS) begin
                IR_OUT <= 32'hdeadbeef;
                INVALID_ACCESS <= 1;
            end else begin
                IR_OUT <= instruction_memory_24kb[IR_ADDR];
                INVALID_ACCESS <= 0;
            end
        end
    end

endmodule
