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
    output logic INVALID_ACCESS,
    output logic SIZE_INVALID
);

    logic [7:0] data_memory_40kb [0:40959]; // 40kB
    
    logic [31:0] formatted_in;
    logic [31:0] formatted_out;
    logic [31:0] addr_offset;
    logic [31:0] addr;
    logic MMIO_ACCESS;
    logic SIZE_INVALID;
    logic write_size_invalid;

    assign addr_offset = 32'h6000;
    assign addr = ADDR - addr_offset;
    assign MMIO_ACCESS = (ADDR >= 32'h10000000) && (ADDR < 32'h20000000);

    assign INVALID_ACCESS = (ADDR < 32'h6000) || ((ADDR > 16'hFFFF) && ~MMIO_ACCESS);
    
    always_comb begin
        write_size_invalid = 1'b0;
        case(SIZE)
            2'b00: formatted_in = {{24{sign}},DATA_IN[7:0]};

            2'b01: formatted_in = {{16{sign}},DATA_IN[15:0]};

            2'b10: DATA_IN;

            default: write_size_invalid = 1'b1;
        endcase
    end
    always_ff@(posedge_clk)
        if(RD_EN && ~INVALID_ACCESS)
            DATA_OUT <= formatted_out;
        else
            DATA_OUT <= 32'h00000000;
    
    always_ff@(posedge_clk) begin
        if(WR_EN && ~INVALID_ACCESS) begin
            case(SIZE)
                2'b00: begin // byte
                    data_memory[addr] <= formatted_in[7:0];
                end
                2'b01: begin
                    data_memory[addr] <= formatted_in[7:0];
                    data_memory[addr+1] <= formatted_in[15:8];
                end
                2'b10: begin
                    data_memory[addr] <= formatted_in[7:0];
                    data_memory[addr+1] <= formatted_in[15:8];
                    data_memory[addr+1] <= formatted_in[23:16];
                    data_memory[addr+2] <= formatted_in[31:24];
                end
                default: begin
                    SIZE_INVALID <= 1'b1;
                end
            endcase
        end
        else if(RD_EN && write_size_invalid) begin
            SIZE_INVALID <= 1'b1;
        end
        else begin
            SIZE_INVALID <= 0;
        end
    end

endmodule

