module reg_64_bit(clock, write_enable, in, clear, out);
	input clock, write_enable, clear;
	input[63:0] in;
	output[63:0] out;
	genvar c;
	generate
		for(c = 0; c < 64; c = c +1) begin: loop1
			dflipflop dff_call(in[c], clock, 1'b1, clear, write_enable, out[c]);
		end
	endgenerate
endmodule
