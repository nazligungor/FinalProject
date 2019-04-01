module writeback_stage(data_o, data_d, isLW, isSW, isR, isAddi, rd_w, ctrl_writeEnable, ctrl_writeReg, data_writeReg, isJAL, isSetx);
	input [31:0] data_o, data_d;
	input [4:0] rd_w;
	input isLW, isSW,isR, isAddi, isJAL, isSetx;

	output ctrl_writeEnable;
   output [4:0] ctrl_writeReg;
   output [31:0] data_writeReg;
	
	assign ctrl_writeEnable = isLW || isR || isAddi || isJAL || isSetx;
	assign ctrl_writeReg = rd_w;
	assign data_writeReg = isLW || isSW ? data_d : data_o;
endmodule
