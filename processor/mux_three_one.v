module mux_three_one (in0, in1, in2, select, out);
	input [31:0] in0, in1, in2;
	input [1:0] select;
	output [31:0] out;
	wire[31:0] level_one;
	assign level_one = select[0] ? in1 : in0;
	assign out = select[1] ? in2 : level_one;
	
endmodule


	