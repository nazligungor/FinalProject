module my_rca_highest(a, b, cin, cout, sum, of);
	input [3:0] a, b;
	input cin;
	output cout, of;
	output [3:0] sum;

	wire cout0, cout1, cout2;

	full_adder add0(a[0], b[0], cin, cout0, sum[0]);
	full_adder add1(a[1], b[1], cout0, cout1, sum[1]);
	full_adder add2(a[2], b[2], cout1, cout2, sum[2]);
	full_adder add3(a[3], b[3], cout2, cout, sum[3]);
	wire sameb, diffc;
	
	xnor samebits(sameb, a[3], b[3]);
	
	xor diffcarry(diffc, cout2, cout);
	and and1(of, sameb, diffc);

endmodule