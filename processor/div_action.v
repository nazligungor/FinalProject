module div_action(aq, divisor, out,overflow);
	input [63:0] aq;
	input [31:0] divisor;
	output overflow;
	output [63:0] out;
	wire ine, ilt;
	wire [63:0] shifted_aq;
	wire [31:0] a_;
	
	assign shifted_aq = aq << 1;
	//A' = A - M
	alu completeSubtraction(shifted_aq[63:32], divisor, 5'b1, 5'b0, a_, ine, ilt, overflow);
	// if A' is negative( A is less than M), restore A, Q[0] = 0
	// if A' is positive (A is greater than M), A = A', Q[0] = 1
	wire [63:0] modified_aq;
	assign modified_aq[0] = ilt ? 1'b0 : 1'b1;
	assign modified_aq[63:32] = ilt ? shifted_aq[63:32] : a_[31:0];
	assign modified_aq[31:1] = shifted_aq[31:1];
	assign out = modified_aq;
	
	
endmodule
