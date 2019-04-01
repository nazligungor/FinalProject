module my_reg(clock, write_enable, in, clear, out);
	input clock, write_enable, clear;
	input[31:0] in;
	output[31:0] out;
	genvar c;
	generate
		for(c = 0; c < 32; c = c +1) begin: loop1
			dflipflop dff_call(in[c], clock, 1'b1, clear, write_enable, out[c]);
		end
	endgenerate
endmodule
