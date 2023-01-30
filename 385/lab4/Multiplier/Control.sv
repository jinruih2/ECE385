//Two-always example for state machine

module control (input  logic Clk, Reset_Load_Clear, Run, M,
                output logic Shift_XAB, Add, Sub, Clear);

    // Declare signals curr_state, next_state of type enum
    // with enum values of A, B, ..., F as the state values
    // Note that the length implies a max of 8 states, so you will need to bump this up for 8-bits
    enum logic [4:0] {reset_state, 
                      add_1, shift_1, 
                      add_2, shift_2, 
                      add_3, shift_3, 
                      add_4, shift_4, 
                      add_5, shift_5, 
                      add_6, shift_6, 
                      add_7, shift_7, 
                      sub_8, shift_8,
                      hold_state}   curr_state, next_state; 

	//updates flip flop, current state is the only one
    always_ff @ (posedge Clk)  
    begin
        if (Reset_Load_Clear)
            curr_state <= reset_state;
        else 
            curr_state <= next_state;
    end

    // Assign outputs based on state
	always_comb
    begin
        
        next_state = curr_state;
        unique case (curr_state) 

            reset_state : if (Run)
                next_state = add_1;
            add_1	: next_state = shift_1;
            shift_1	: next_state = add_2;
            add_2	: next_state = shift_2;
            shift_2	: next_state = add_3;
            add_3	: next_state = shift_3;
            shift_3	: next_state = add_4;
            add_4	: next_state = shift_4;
            shift_4	: next_state = add_5;
            add_5	: next_state = shift_5;
            shift_5	: next_state = add_6;
            add_6	: next_state = shift_6;
            shift_6	: next_state = add_7;
            add_7	: next_state = shift_7;
            shift_7	: next_state = sub_8;
            sub_8	: next_state = shift_8;
            shift_8	: next_state = hold_state;
            hold_state: if (~Run)
                next_state = reset_state;				  
        endcase
    end

    always_comb
    begin
        case (curr_state)
            add_1, add_2, add_3, add_4, add_5, add_6, add_7:
                begin
                    Shift_XAB = 1'b0;
                    if (M)
                        Add = 1'b1;
                    else
                        Add = 1'b0;
                    Sub = 1'b0;
                end
            shift_1, shift_2, shift_3, shift_4, shift_5, shift_6, shift_7, shift_8:
                begin
                    Shift_XAB = 1'b1;
                    Add = 1'b0;
                    Sub = 1'b0;
                end
            sub_8:
                begin
                    Shift_XAB = 1'b0;
                    Add = 1'b0;
                    if (M)
                        Sub = 1'b1;
                    else
                        Sub = 1'b0;
                end
            reset_state, hold_state:
                begin
                    Shift_XAB = 1'b0;
                    Add = 1'b0;
                    Sub = 1'b0;
                end
        endcase
		if ((curr_state==reset_state) & (Reset_Load_Clear | Run))
			Clear = 1'b1;
		else
			Clear = 1'b0;
    end

endmodule
