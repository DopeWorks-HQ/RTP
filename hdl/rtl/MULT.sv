`timescale 1ns/1ps

module MULT(
    input CLK
    input SEL,
    input SIGN,
    input [31:0] OP_A,
    input [31:0] OP_B,
    output logic [31:0] RESULT
)

    logic [63:0] product;
    logic [63:0] product_signed;

    logic mult_sel_reg;
    logic sign_reg;

    always_ff@(posedge clk) begin
        product <= $unsigned(OP_A) * $unsigned(OP_B);
        product_signed <= $signed(OP_A) * $signed(OP_B);
        mult_sel_reg <= SEL;
        sign_reg <= SIGN;
    end

    always_comb begin
        case(mult_sel_reg)
            1'b0: begin
                if(sign_reg)
                    RESULT = product_signed[31:0];
                else
                    RESULT = product[31:0];
            end
            1'b1: begin
                if(sign_reg)
                    RESULT = product_signed[63:32];
                else
                    RESULT = product[63:32];
            end
        endcase
    end


endmodule