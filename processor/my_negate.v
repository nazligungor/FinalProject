module my_negate(in, neg_in, overflow);
	input [31:0] in;
	output [31:0] neg_in;
	output overflow;
	wire [31:0] flipped_bits;
	assign overflow = in[31] && ~in[30] && ~in[29] && ~in[28] && ~in[27] && ~in[26] && ~in[25] && ~in[24] && ~in[23] && ~in[22] && ~in[21] && ~in[20] && ~in[19] && ~in[18] && ~in[17] && ~in[16] && ~in[15] && ~in[14] && ~in[13] && ~in[12] && ~in[11] && ~in[10] && ~in[9] && ~in[8] && ~in[7] && ~in[6] && ~in[5] && ~in[4] && ~in[3] && ~in[2] && ~in[1] && ~in[0];
	
	genvar c;
	generate
		for(c = 0; c < 32; c = c +1) begin: loop1
			not(flipped_bits[c], in[c]);
		end
	endgenerate
	wire ine, ilt, of;
	alu add1(flipped_bits, 32'b1, 5'b0, 5'b0, neg_in, ine, ilt, of);
	
endmodule
