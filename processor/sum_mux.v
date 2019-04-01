module sum_mux(a, b, cin0, cin1, select, out, cout);
	input [3:0] a, b;
	input cin0, cin1;
	input select;
	output [3:0] out;
	output cout;
	genvar c;
	generate
		for(c = 0; c < 4; c = c +1) begin: loop1
			my_mux mux(a[c], b[c], select, out[c]);
		end
	endgenerate
	my_mux coutmux(cin0, cin1, select, cout);
	
endmodule
	