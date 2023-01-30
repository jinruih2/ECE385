//helper function full_adder
module full_adder_forCSA
 (
    input logic x,y,z,
    output logic s,c
 );
    assign s=x^y^z;
    assign c = (x&y)|(y&z)|(x&z);
endmodule

//helper function 4 bits RCA
module RCA_4bits(
    input logic [3:0] A, B,
	input logic  cin,
	output logic [3:0] S_RIPPLE,
 	output logic cout
);
    logic c1,c2,c3;
    full_adder FA0(.x(A[0]),.y(B[0]),.z(cin),.s(S_RIPPLE[0]),.c(c1));
    full_adder FA1(.x(A[1]),.y(B[1]),.z(c1),.s(S_RIPPLE[1]),.c(c2));
    full_adder FA2(.x(A[2]),.y(B[2]),.z(c2),.s(S_RIPPLE[2]),.c(c3));
    full_adder FA3(.x(A[3]),.y(B[3]),.z(c3),.s(S_RIPPLE[3]),.c(cout));
endmodule

//helper function 4 bits CSA
module CSA_4bits(
    input logic [3:0]A,B,
    input logic cin,
    output logic [3:0]S_CSA,
    output logic cout
);
    logic [3:0] result_1,result_0;
    logic cout_1,cout_0;
    RCA_4bits cin_1(.A(A[3:0]),.B(B[3:0]),.cin(1),.S_RIPPLE(result_1[3:0]),.cout(cout_1));
    RCA_4bits cin_0(.A(A[3:0]),.B(B[3:0]),.cin(0),.S_RIPPLE(result_0[3:0]),.cout(cout_0));
    assign cout = (cin & cout_1) | cout_0;
    always_comb 
        begin: select_cin
        case(cin)
        1'b0: S_CSA = result_0;
        1'b1:  S_CSA = result_1;
        endcase
    end 
endmodule
//16 bits CSA
module select_adder (
	input  [15:0] A, B,
	input         cin,
	output [15:0] S_SELECT,
	output        cout
);
    logic c1,c2,c3;
    RCA_4bits first4(.A(A[3:0]),.B(B[3:0]),.cin(cin),.S_RIPPLE(S_SELECT[3:0]),.cout(c1));
    CSA_4bits second4(.A(A[7:4]),.B(B[7:4]),.cin(c1),.S_CSA(S_SELECT[7:4]),.cout(c2));
    CSA_4bits third4(.A(A[11:8]),.B(B[11:8]),.cin(c2),.S_CSA(S_SELECT[11:8]),.cout(c3));
    CSA_4bits last4(.A(A[15:12]),.B(B[15:12]),.cin(c3),.S_CSA(S_SELECT[15:12]),.cout(cout));
endmodule
