module decode_stage(instr_data, opcode, rs, rt, shamt, alu_op, immediate, target, isR, isI, isJI, isJII,isAdd, isAddi, isSub, isMul, isDiv, isSW, isLW, isJ, isBNE, isJAL, isBLT, isBex, isSetx, rd_d);
	input [31:0] instr_data;
	output [4:0] opcode, shamt, alu_op;
	output [4:0] rs, rt, rd_d;
	output [26:0] target;
	output [16:0] immediate;
	//types
	output isR, isI, isJI, isJII,isAdd, isAddi, isSub, isMul, isDiv, isSW, isLW, isJ, isBNE, isJAL, isBLT, isBex, isSetx;
	wire [4:0] rt_temp, rd_temp, rs_temp, rd_special;
	
	decode_data data(instr_data, opcode, rd_temp, rs_temp, rt_temp, shamt, alu_op, immediate, target);
	
	decode_opcodes opcodes(opcode, alu_op, isR, isI, isJI, isJII,isAdd, isAddi, isSub, isMul, isDiv, isSW, isLW, isJ, isBNE, isJAL, isBLT, isBex, isSetx);
	//rs will read 0 for bex and setx
	assign rs = isBex || isSetx ? 5'b0 : rs_temp;
	//rd will be 31 for jal and 30 for bex and set
	assign rd_special = isJAL ? 5'b11111 : 5'b11110;
	assign rd_d = isJI ? rd_special : rd_temp;
	assign rt = isR ? rt_temp : rd_d;
//	assign isNoop = ~(|instr_data);
	
endmodule
