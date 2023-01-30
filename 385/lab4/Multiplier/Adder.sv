module FullAdder (
	input   A, B,
	input   cin,
	output logic    S,
	output logic 	cout
);

	assign S = A ^ B ^ cin;
	assign cout = (A & B) | (B & cin) | (cin & A);
endmodule 


module RippleAdder
(
	input   [8:0] A, B,
	input   cin,
	output logic    [8:0] S,
	output logic    cout
);

	logic [7:0] c;
	
	FullAdder RA_9b [8:0] (
		.A(A), .B(B), .S(S), .cin({c, cin}), .cout({cout, c})
	);

		
endmodule


module Add_Sub_9 (
    input [8:0] A, B,
    input Add, Sub,
    output logic [8:0] S,
    output logic cout
);

	logic [8:0] A_, B_;
	logic cin;
	assign A_ = A;
	
	RippleAdder task_adder(.A(A_), .B(B_), .*);
	
	always_comb begin
		if (Sub) 
			begin
				cin = 1'b1;
				B_ = B ^ {9{cin}};
			end
		else if (Add)
			begin
                cin = 1'b0;
                B_ = B ^ {9{cin}};
			end
		else
			begin
				cin = 1'b0;
				B_ = 9'h0;
			end
	end
endmodule

