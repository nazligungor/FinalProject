module bitwise_or(a, b, out);
	input [31:0] a, b;
	output [31:0] out;
	genvar c;
	generate
		for(c = 0; c < 32; c = c +1) begin: loop1
			or(out[c], a[c], b[c]);
		end
	endgenerate
endmodule

	