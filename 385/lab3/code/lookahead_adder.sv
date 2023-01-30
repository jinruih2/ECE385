// helper function 1 bit CLA, G = Generated, P = Propagated
module CLA_1bit(
    input logic A,B,
    input logic c_in,
    output logic S,
    output logic G,P 
);
assign S = A^B^c_in;
assign G = A & B;
assign P = A ^ B;
endmodule

// helper function 4 bits CLA
module CLA_4Bits_Adder(
    input logic [3:0]A,B,
    input logic C_in,
    output logic GG,PG,
    output logic [3:0]Sum   
);
logic [3:0]G,P;
logic [3:0]C_OUT;
CLA_1bit BIT1(.A(A[0]),.B(B[0]),.c_in(C_in),.S(Sum[0]),.G(G[0]),.P(P[0]));
assign C_OUT[0] = C_in & P[0] | G[0];
CLA_1bit BIT2(.A(A[1]),.B(B[1]),.c_in(C_OUT[0]),.S(Sum[1]),.G(G[1]),.P(P[1]));
assign C_OUT[1] = C_in & P[0] & P[1] | G[0] & P[1] | G[1];    
CLA_1bit BIT3(.A(A[2]),.B(B[2]),.c_in(C_OUT[1]),.S(Sum[2]),.G(G[2]),.P(P[2]));
assign C_OUT[2] = C_in & P[0] & P[1] & P[2] | G[0] & P[1] & P[2] | G[1] & P[2] | G[2];
CLA_1bit BIT4(.A(A[3]),.B(B[3]),.c_in(C_OUT[2]),.S(Sum[3]),.G(G[3]),.P(P[3]));
//assign C_OUT[3] = C_in & P[0] & P[1] & P[2] & P[3] | G[0] & P[1] & P[2] & P[3] | G[1] & P[2] & P[3] | G[2] & P[3] | G[3];
assign GG = G[3] | G[2] & P[3] | G[1] & P[3] & P[2] | G[0] & P[3] & P[2] & P[1];
assign PG = P[0] & P[1] & P[2] & P[3];
endmodule

// 16 bits CLA, 4X4 hierarchical
module lookahead_adder (
	input logic  [15:0] A, B,
	input logic        cin,
	output logic [15:0] S_LOOKAHEAD,
	output logic        cout
);
logic [3:0]GG,PG;
logic [3:0]C_OUT;
CLA_4Bits_Adder first4(.A(A[3:0]),.B(B[3:0]),.C_in(cin),.GG(GG[0]),.PG(PG[0]),.Sum(S_LOOKAHEAD[3:0]));
assign C_OUT[0] = cin & PG[0] | GG[0];
CLA_4Bits_Adder second4(.A(A[7:4]),.B(B[7:4]),.C_in(C_OUT[0]),.GG(GG[1]),.PG(PG[1]),.Sum(S_LOOKAHEAD[7:4]));
assign C_OUT[1] = cin & PG[0] & PG[1] | GG[0] & PG[1] | GG[1];  
CLA_4Bits_Adder third4(.A(A[11:8]),.B(B[11:8]),.C_in(C_OUT[1]),.GG(GG[2]),.PG(PG[2]),.Sum(S_LOOKAHEAD[11:8]));
assign C_OUT[2] = cin & PG[0] & PG[1] & PG[2] | GG[0] & PG[1] & PG[2] | GG[1] & PG[2] | GG[2];
CLA_4Bits_Adder last4(.A(A[15:12]),.B(B[15:12]),.C_in(C_OUT[2]),.GG(GG[3]),.PG(PG[3]),.Sum(S_LOOKAHEAD[15:12]));
assign cout = cin & PG[0] & PG[1] & PG[2] & PG[3] | GG[0] & PG[1] & PG[2] & PG[3] | GG[1] & PG[2] & PG[3] | GG[2] & PG[3] | GG[3];
endmodule
