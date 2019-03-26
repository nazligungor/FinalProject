module my_subtract(a, b, cout, diff, of);
	//a - b
	input [31:0] a, b;
	output [31: 0] diff;
	output cout, of;
	wire [31:0] negb;
	genvar c;
	generate
		for(c = 0; c < 32; c = c +1) begin: loop1
			xor(negb[c], 1'b1, b[c]);
		end
	 
	my_adder add1(a, negb, 1'b1, diff, cout, of);
	
	endgenerate
	
endmodule
