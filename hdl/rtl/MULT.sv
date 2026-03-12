/*
    Module: MLEN-Bit Saturated Branch Predictor 

    Instantiation Template:

    // START: MULT
    MULT MUL_32(
        .CLK(),
        .RST(),
        .MUL_EN(),
        .MULT_SEL(),
        .SIGN(),
        .OP_A(),
        .OP_B(),
        .RESULT()
    );
    // END: MULT

*/
`timescale 1ns/1ps

module MULT
#(
    parameter MLEN = 32
)
(
    input CLK,
    input RST,
    input MUL_EN,
    input MUL_SEL,
    input SIGN,
    input [MLEN-1:0] OP_A,
    input [MLEN-1:0] OP_B,
    output logic [MLEN-1:0] RESULT
)

    logic [MLEN-1:0] product;
    logic [(MLEN + MLEN)-1:0] product_signed;

    logic mult_sel_reg;
    logic mult_en_reg;
    logic sign_reg;

    always_ff@(posedge CLK) begin
        if(RST) begin
            product <= 0;
            product_signed <= 0;
            mult_sel_reg <= 0;
            mult_en_reg <= 0;
            sign_reg <= 0;
        end
        else if(MUL_EN) begin
            product <= $unsigned(A) * $unsigned(B);
            product_signed <= $signed(A) * $signed(B);
            mult_sel_reg <= MUL_SEL;
            mult_en_reg <= MUL_EN;
            sign_reg <= SIGN;
        end
    end

    always_comb begin
        if(mult_en_reg) begin
            case(mult_sel_reg)
                1'b0: begin
                    if(sign_reg)
                        RESULT = product_signed[MLEN-1:0];
                    else
                        RESULT = product[MLEN-1:0];
                end
                1'b1: begin
                    if(sign_reg)
                        RESULT = product_signed[(MLEN + MLEN)-1:MLEN];
                    else
                        RESULT = product[(MLEN + MLEN)-1:MLEN];
                end
            endcase
        end
        else begin
            RESULT = 32'd0;
        end
    end

/* verilator lint_off EOFNEWLINE */
endmodule
/* verilator lint_on EOFNEWLINE */