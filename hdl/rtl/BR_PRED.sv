/*
    Module: 2-Bit Saturated Branch Predictor 

    Instantiation Template:

    // START: BR_PRED
    BR_PRED(
        .CLK(),
        .RST(),
        .TAKEN(),
        .NOT_TAKEN(),
        .TAKE_BR()
    );
    // END: BR_PRED

*/

module BR_PRED(
    input CLK,
    input RST,
    input TAKEN,
    input NOT_TAKEN,
    output logic TAKE_BR
);

    typedef enum logic { 
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
                if(NOT_TAKEN & ~TAKEN)
                    NS = STRONGLY_NOT_TAKEN;
                else if(TAKEN & ~NOT_TAKEN)
                    NS = WEAKLY_NOT_TAKEN;
                else
                    NS = STRONGLY_NOT_TAKEN;
            end

            WEAKLY_NOT_TAKEN: begin
                if(NOT_TAKEN & ~TAKEN)
                    NS = STRONGLY_NOT_TAKEN;
                else if(TAKEN & ~NOT_TAKEN)
                    NS = WEAKLY_TAKEN;
                else
                    NS = WEAKLY_NOT_TAKEN;
            end

            WEAKLY_TAKEN: begin
                if(NOT_TAKEN & ~TAKEN)
                    NS = WEAKLY_NOT_TAKEN;
                else if(TAKEN & ~NOT_TAKEN)
                    NS = STRONGLY_TAKEN;
                else
                    NS = WEAKLY_TAKEN;
            end

            STRONGLY_TAKEN: begin
                if(NOT_TAKEN & ~TAKEN)
                    NS = WEAKLY_TAKEN;
                else if(~NOT_TAKEN & TAKEN)
                    NS = STRONGLY_TAKEN;
                else
                    NS = STRONGLY_TAKEN;
            end

        endcase
    end

endmodule