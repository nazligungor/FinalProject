module my_tristate(in, oe, out);
	input [31:0] in;
	input oe;
	output [31:0] out;
	genvar c;
	generate
		for(c = 0; c < 32; c = c +1) begin: loop1
			assign out[c] = oe ? in[c] : 1'bz;
		end
	endgenerate
endmodule
