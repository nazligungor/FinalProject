module my_left_shifter(in, shift, out);
input [31:0] in;
	input [4:0] shift;
	wire [31:0] intm1, intm2, intm3, intm4;
	output [31:0] out;
	//first shift
	genvar c;
	generate
		for(c = 31; c > 0; c = c - 1) begin: loop1
			my_mux mux(in[c], in[c-1], shift[0], intm1[c]);
		end
	endgenerate
	
	my_mux mux1(in[0], 1'b0, shift[0], intm1[0]);
	
	//second shift
	genvar c2;
	generate
		for(c2 = 31; c2 > 1; c2 = c2 - 1) begin: loop2
			my_mux mux2(intm1[c2], intm1[c2 - 2], shift[1], intm2[c2]);
		end
	endgenerate
	
	genvar c22;
	generate
		for(c22 = 1; c22 >= 0; c22 = c22 - 1) begin: loop2b
			my_mux mux2(intm1[c22], 1'b0, shift[1], intm2[c22]);
		end
	endgenerate
	
	//third shift
	genvar c3;
	generate
		for(c3 = 31; c3 > 3 ; c3 = c3 - 1) begin: loop3
			my_mux mux5(intm2[c3], intm2[c3-4], shift[2], intm3[c3]);
		end
	endgenerate
	
	genvar c32;
	generate
		for(c32 = 3; c32 >= 0 ; c32 = c32 - 1) begin: loop3b
			my_mux mux6(intm2[c32], 1'b0, shift[2], intm3[c32]);
		end
	endgenerate

	
	
	//fourth shift
	genvar c4;
	generate
		for(c4 = 31; c4 > 7; c4 = c4 - 1) begin: loop4
			my_mux mux10(intm3[c4], intm3[c4 - 8], shift[3], intm4[c4]);
		end
	endgenerate
	
	genvar c42;
	generate
		for(c42 = 7; c42 >= 0; c42 = c42 - 1) begin: loop4b
			my_mux mux11(intm3[c42], 1'b0, shift[3], intm4[c42]);
		end
	endgenerate
	
	//fifth shift
	genvar c5;
	generate
		for(c5 = 31; c5 > 15; c5 = c5 - 1) begin: loop5
			my_mux mux19(intm4[c5], intm4[c5 - 16], shift[4], out[c5]);
		end
	endgenerate
	
	genvar c52;
	generate
		for(c52 = 15; c52 >= 0; c52 = c52 - 1) begin: loop5b
			my_mux mux20(intm4[c52], 1'b0, shift[4], out[c52]);
		end
	endgenerate
	
endmodule
