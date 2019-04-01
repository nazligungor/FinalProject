module csa_4bit_highest(a, b, cout0, cout1, sum0, sum1, of0, of1);
	input [3:0] a, b;
	output cout0, cout1, of0, of1;
	output [3:0] sum0, sum1;
	// o is 1'b0 1 is 1'b1
	my_rca_highest rca0(a, b, 1'b0, cout0, sum0, of0);
	my_rca_highest rca1(a, b, 1'b1, cout1, sum1, of1);
endmodule