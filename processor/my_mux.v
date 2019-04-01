module my_mux(in0, in1, select, out);
//if select is 1 you get in1
	input in0, in1, select;
	output out;
	assign out = select ? in1 : in0;
endmodule


