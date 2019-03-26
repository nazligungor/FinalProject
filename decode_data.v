	module decode_data(instr_data, opcode, rd, rs, rt, shamt, alu_op, immediate, target);
	input [31:0] instr_data;
	output [4:0] opcode, shamt, alu_op;
	output [4:0] rd, rs, rt;
	output [26:0] target;
	output [16:0] immediate;
	
	//applies to multiple
	assign opcode = instr_data[31:27];
	//decode the opcode for info about type
	
	assign rd = instr_data[26:22];
	assign rs = instr_data[21:17];
	
	//R only
	assign rt = instr_data[16:12];
	assign shamt = instr_data[11:7];
	assign alu_op = instr_data[6:2];
	
	//I only
	assign immediate = instr_data[16:0];
	
	//JI only
	assign target = instr_data[26:0];
endmodule
