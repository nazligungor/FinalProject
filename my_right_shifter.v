module my_right_shifter(in, shift, out);
	input [31:0] in;
	input [4:0] shift;
	wire [31:0] intm1, intm2, intm3, intm4;
	output [31:0] out;
	//first shift
	genvar c;
	generate
		for(c = 0; c < 31; c = c +1) begin: loop1
			my_mux mux(in[c], in[c+1], shift[0], intm1[c]);
		end
	endgenerate
	my_mux mux1(in[31], in[31], shift[0], intm1[31]);
	
	//second shift
	genvar c2;
	generate
		for(c2 = 0; c2 < 30; c2 = c2 + 1) begin: loop2
			my_mux mux2(intm1[c2], intm1[c2+2], shift[1], intm2[c2]);
		end
	endgenerate
	my_mux mux3(intm1[30], intm1[31], shift[1], intm2[30]);
	my_mux mux4(intm1[31], intm1[31], shift[1], intm2[31]);
	
	//third shift
	genvar c3;
	generate
		for(c3 = 0; c3 < 28; c3 = c3 + 1) begin: loop3
			my_mux mux5(intm2[c3], intm2[c3+4], shift[2], intm3[c3]);
		end
	endgenerate
	my_mux mux6(intm2[28], intm2[31], shift[2], intm3[28]);
	my_mux mux7(intm2[29], intm2[31], shift[2], intm3[29]);
	my_mux mux8(intm2[30], intm2[31], shift[2], intm3[30]);
	my_mux mux9(intm2[31], intm2[31], shift[2], intm3[31]);
	
	
	//fourth shift
	genvar c4;
	generate
		for(c4 = 0; c4 < 24; c4 = c4 + 1) begin: loop4
			my_mux mux10(intm3[c4], intm3[c4+8], shift[3], intm4[c4]);
		end
	endgenerate
	my_mux mux11(intm3[24], intm3[31], shift[3], intm4[24]);
	my_mux mux12(intm3[25], intm3[31], shift[3], intm4[25]);
	my_mux mux13(intm3[26], intm3[31], shift[3], intm4[26]);
	my_mux mux14(intm3[27], intm3[31], shift[3], intm4[27]);
	my_mux mux15(intm3[28], intm3[31], shift[3], intm4[28]);
	my_mux mux16(intm3[29], intm3[31], shift[3], intm4[29]);
	my_mux mux17(intm3[30], intm3[31], shift[3], intm4[30]);
	my_mux mux18(intm3[31], intm3[31], shift[3], intm4[31]);
	
	//fifth shift
	genvar c5;
	generate
		for(c5 = 0; c5 < 16; c5 = c5 + 1) begin: loop5
			my_mux mux19(intm4[c5], intm4[c5+16], shift[4], out[c5]);
		end
	endgenerate
	my_mux mux20(intm4[16], intm4[31], shift[4], out[16]);
	my_mux mux21(intm4[17], intm4[31], shift[4], out[17]);
	my_mux mux22(intm4[18], intm4[31], shift[4], out[18]);
	my_mux mux23(intm4[19], intm4[31], shift[4], out[19]);
	my_mux mux24(intm4[20], intm4[31], shift[4], out[20]);
	my_mux mux25(intm4[21], intm4[31], shift[4], out[21]);
	my_mux mux26(intm4[22], intm4[31], shift[4], out[22]);
	my_mux mux27(intm4[23], intm4[31], shift[4], out[23]);
	my_mux mux28(intm4[24], intm4[31], shift[4], out[24]);
	my_mux mux29(intm4[25], intm4[31], shift[4], out[25]);
	my_mux mux30(intm4[26], intm4[31], shift[4], out[26]);
	my_mux mux31(intm4[27], intm4[31], shift[4], out[27]);
	my_mux mux32(intm4[28], intm4[31], shift[4], out[28]);
	my_mux mux33(intm4[29], intm4[31], shift[4], out[29]);
	my_mux mux34(intm4[30], intm4[31], shift[4], out[30]);
	my_mux mux35(intm4[31], intm4[31], shift[4], out[31]);
	
endmodule

	