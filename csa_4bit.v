module csa_4bit(a, b, cout0, cout1, sum0, sum1);
	input [3:0] a, b;
	output cout0, cout1;
	output [3:0] sum0, sum1;
	// o is 1'b0 1 is 1'b1
	my_rca rca0(a, b, 1'b0, cout0, sum0);
	my_rca rca1(a, b, 1'b1, cout1, sum1);
endmodule
