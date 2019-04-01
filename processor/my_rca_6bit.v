module my_rca_6bit(a, b, cin, cout, sum);
	input [5:0] a, b;
	input cin;
	output cout;
	output [5:0] sum;

	wire cout0, cout1, cout2, cout3, cout4, cout5;

	full_adder add0(a[0], b[0], cin, cout0, sum[0]);
	full_adder add1(a[1], b[1], cout0, cout1, sum[1]);
	full_adder add2(a[2], b[2], cout1, cout2, sum[2]);
	full_adder add3(a[3], b[3], cout2, cout3, sum[3]);
	full_adder add4(a[4], b[4], cout3, cout4, sum[4]);
	full_adder add5(a[5], b[5], cout4, cout, sum[5]);

endmodule
