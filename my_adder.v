module my_adder(a, b, cin, sum, cout, overflow);
	input [31:0] a, b;
	input cin;
	output [31:0] sum;
	output cout, overflow;

	wire [3:0] s1, s2, s3, s4, s5, s6, s7, s8, s9, s10, s11, s12, s13, s14;
	wire cout1, cout2, cout3, cout4, cout5, cout6, cout7, cout8, cout9, cout10, cout11, cout12, cout13, cout14;
	wire cr0, cr1, cr2, cr3, cr4, cr5, cr6;
	
	//rca 0-3
	my_rca rca0(a[3:0],b[3:0], cin, cr0, sum[3:0]);
	
	//4-7
	csa_4bit csa1(a[7:4], b[7:4], cout1, cout2, s1, s2);
	sum_mux m1(s1, s2, cout1, cout2, cr0, sum[7:4], cr1);
	
	//8-11
	csa_4bit csa2(a[11:8], b[11:8], cout3, cout4, s3, s4);
	sum_mux m2(s3, s4, cout3, cout4, cr1, sum[11:8], cr2);
	
	//12-15
	csa_4bit csa3(a[15:12], b[15:12], cout5, cout6, s5, s6);
	sum_mux m3(s5, s6, cout5, cout6, cr2, sum[15:12], cr3);
	
	//16-19
	csa_4bit csa4(a[19:16], b[19:16], cout7, cout8, s7, s8);
	sum_mux m4(s7, s8, cout7, cout8, cr3, sum[19:16], cr4);
	
	//20-23
	csa_4bit csa5(a[23:20], b[23:20], cout9, cout10, s9, s10);
	sum_mux m5(s9, s10, cout9, cout10, cr4, sum[23:20], cr5);
	
	//24-27
	csa_4bit csa6(a[27:24], b[27:24], cout11, cout12, s11, s12);
	sum_mux m6(s11, s12, cout11, cout12, cr5, sum[27:24], cr6);
	
	//28-31
	wire of1, of2;
	
	csa_4bit_highest csa7(a[31:28], b[31:28], cout13, cout14, s13, s14, of1, of2);
	
	sum_mux m7(s13, s14, cout13, cout14, cr6, sum[31:28], cout);
	
	my_mux muxfinal(of1, of2, cr6, overflow);

endmodule
