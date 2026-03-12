/*
    Module: 2-Bit Saturated Branch Predictor 

    Instantiation Template:

    // START: BR_PRED
    BR_PRED(
        .CLK(),
        .RST(),
        .ACT(),
        .TAKEN(),
        .NOT_TAKEN(),
        .TAKE_BR()
    );
    // END: BR_PRED

*/
`timescale 1ns/1ps

/* verilator lint_off MULTITOP */
module BR_PRED(
    input CLK,
    input RST,
    input ACT,
    input BR_TAKEN,
    output logic TAKE_BR
);

    typedef enum logic [1:0] { 
        STRONGLY_NOT_TAKEN,
        WEAKLY_NOT_TAKEN,
        WEAKLY_TAKEN,
        STRONGLY_TAKEN
    } bp_state_t;

    bp_state_t NS, PS;

    always_ff@(posedge CLK)
        if(RST)
            PS <= STRONGLY_NOT_TAKEN;
        else
            PS <= NS;
    
    always_comb begin

        case(PS)

            STRONGLY_NOT_TAKEN: begin
                TAKE_BR = 1'b0;
                if(~BR_TAKEN && ACT)
                    NS = STRONGLY_NOT_TAKEN;
                else if(BR_TAKEN && ACT)
                    NS = WEAKLY_NOT_TAKEN;
                else
                    NS = STRONGLY_NOT_TAKEN;
            end

            WEAKLY_NOT_TAKEN: begin
                TAKE_BR = 1'b0;
                if(~BR_TAKEN && ACT)
                    NS = STRONGLY_NOT_TAKEN;
                else if(BR_TAKEN && ACT)
                    NS = WEAKLY_TAKEN;
                else
                    NS = WEAKLY_NOT_TAKEN;
            end

            WEAKLY_TAKEN: begin
                TAKE_BR = 1'b1;
                if(~BR_TAKEN && ACT)
                    NS = WEAKLY_NOT_TAKEN;
                else if(BR_TAKEN && ACT)
                    NS = STRONGLY_TAKEN;
                else
                    NS = WEAKLY_TAKEN;
            end

            STRONGLY_TAKEN: begin
                TAKE_BR = 1'b1;
                if(~BR_TAKEN && ACT)
                    NS = WEAKLY_TAKEN;
                else if(BR_TAKEN && ACT)
                    NS = STRONGLY_TAKEN;
                else
                    NS = STRONGLY_TAKEN;
            end

        endcase
    end

endmodule

