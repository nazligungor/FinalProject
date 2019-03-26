module mult_shifter(in, out);
	input [64:0] in;
	output [64:0] out;
	wire [64:0] after_shift;
	wire [64:0] logically_shifted;
	assign logically_shifted = in >> 2;
	assign out[64] = in[64];
	assign out[63] = in[64];
	assign out[62:0] = logically_shifted[62:0];
endmodule
