`timescale 1ns/1ps
module tb_BR_PRED;
    // START: BR_PRED
    BR_PRED(
        .CLK(),
        .RST(),
        .TAKEN(),
        .NOT_TAKEN(),
        .TAKE_BR()
    );
    // END: BR_PRED
endmodule
