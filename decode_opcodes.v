module decode_opcodes(opcode, alu_op, isR, isI, isJI, isJII,isAdd, isAddi, isSub, isMul, isDiv, isSW, isLW, isJ, isBNE, isJAL, isBLT, isBex, isSetx);

	input [4:0] opcode, alu_op;
	output isR, isI, isJI, isJII,isAdd, isAddi, isSub, isMul, isDiv, isSW, isLW, isJ, isBNE, isJAL, isBLT, isBex, isSetx;
	
	
	//R instructions with specific behavior
	assign isR = ~(opcode[4] || opcode[3] || opcode [2] || opcode[1] || opcode[0]);
	assign isAdd = isR ? ~(alu_op[4] || alu_op[3] || alu_op[2] || alu_op[1] || alu_op[0]):1'b0;
	assign isSub = isR ? ~alu_op[4] && ~alu_op[3] && ~alu_op[2] && ~alu_op[1] && alu_op[0] :1'b0;
	assign isMul = isR ? ~alu_op[4] && ~alu_op[3] && alu_op[2] && alu_op[1] && ~alu_op[0] : 1'b0;
	assign isDiv = isR ? ~alu_op[4] && ~alu_op[3] && alu_op[2] && alu_op[1] && alu_op[0] :1'b0;
	
	// I instructions
	assign isAddi = ~opcode[4] && ~opcode[3] && opcode[2] && ~opcode[1] && opcode[0];
	assign isSW = ~opcode[4] && ~opcode[3] && opcode[2] && opcode[1] && opcode[0];
	assign isLW = ~opcode[4] && opcode[3] && ~opcode[2] && ~opcode[1] && ~opcode[0];
	assign isBNE = ~opcode[4] && ~opcode[3] && ~opcode[2] && opcode[1] && ~opcode[0];
	assign isBLT = ~opcode[4] && ~opcode[3] && opcode[2] && opcode[1] && ~opcode[0];
	assign isI = isAddi || isSW || isLW | isBNE || isBLT;
	
	//JI instructions
	assign isJ = ~opcode[4] && ~opcode[3] && ~opcode[2] && ~opcode[1] && opcode[0];
	assign isJAL = ~opcode[4] && ~opcode[3] && ~opcode[2] && opcode[1] && opcode[0];
	assign isBex = opcode[4] && ~opcode[3] && opcode[2] && opcode[1] && ~opcode[0];
	assign isSetx = opcode[4] && ~opcode[3] && opcode[2] && ~opcode[1] && opcode[0];
	assign isJI = isJ || isJAL || isBex || isSetx;
	
	assign isJII =  ~opcode[4] && ~opcode[3] && opcode[2] && ~opcode[1] && ~opcode[0];
endmodule


	