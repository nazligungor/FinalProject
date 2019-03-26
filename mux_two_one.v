module mux_two_one(in0, in1, select, out);
//if select is 1 you get in1
	input[31:0] in0, in1;
	input select;
	output[31:0] out;
	assign out = select ? in1 : in0;
endmodule
