module stall_logic(isLW_d, opcode_f, rs_d, rt_d, rd_d, hazard);
	input isLW_d;
	input [4:0] opcode_f, rs_d, rt_d, rd_d;
	output hazard;
	
	wire isSW_f, rsine, rtine, ilt1, ilt2, of1, of2;
	wire[31:0] data1, data2;
	alu testequalrs(rd_d, rs_d, 5'b1, 0, data1, rsine, ilt1, of1);
	alu testequalrt(rd_d, rt_d, 5'b1, 0, data2, rtine, ilt2, of2);
	
	assign isSW_f = ~opcode_f[4] && ~opcode_f[3] && opcode_f[2] && opcode_f[1] && opcode_f[0];
	
	
	assign hazard = isLW_d && (~rtine || (~isSW_f && ~rsine));
	
	
endmodule






