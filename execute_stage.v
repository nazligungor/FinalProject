//TODO: add mul and div, handle changing the destination register if there is an exception or if there is a jal

module execute_stage(rd_original, data_a, data_b, alu_op, shamt, target, next_pc, immediate, isR, isI, isJI, isJII,isAdd, isAddi, isSub, isMul, isDiv, isSW, isLW, isJ, isBNE, isJAL, isBLT, isBex, isSetx, data_o_x, data_b_x, exception, pc_mux_select, next_pc_j_x, rd, of);

	input [31:0] data_a, data_b;
	input [4:0] alu_op, shamt, rd_original;
	input [11:0] next_pc;
	input [26:0] target;
	input [16:0] immediate;
	input isR, isI, isJI, isJII,isAdd, isAddi, isSub, isMul, isDiv, isSW, isLW, isJ, isBNE, isJAL, isBLT, isBex, isSetx;
	
	output [11:0] next_pc_j_x;
	output [4:0] rd;
	output [31:0] data_o_x, data_b_x;
	output exception, pc_mux_select;
	output of;
	
	assign data_b_x = data_b;
	
	wire [31:0] alu_main_in_a;
	wire [31:0] alu_main_in_b;
	wire [31:0] alu_main_out, alu_comp_out;
	wire [4:0] opcode;
	wire isne_main, ilt_main, of_main, isne, ilt, of_comp;
	assign alu_main_in_a = data_a;
	assign alu_main_in_b = isR ? data_b : immediate;
	assign opcode = isR ? alu_op : 5'b0;
	
	//handles all R types and the rs + N operations for I types
	alu alu_main(alu_main_in_a, alu_main_in_b, opcode, shamt, alu_main_out, isne_main, ilt_main, of);
	
	//check for exceptions, don't include mul or div yet
	assign exception = of && (isAdd || isAddi || isSub);
	//based on truth table
	wire [31:0] exception_val;
	assign exception_val[0] = isAdd || isSub || isDiv;
	assign exception_val[1] = isAddi || isSub;
	assign exception_val[2] = isMul || isDiv;
	
	
	//handles checking comparisons between rd and rs, assumes rd is in data_b bc not r type assume 0 and $rstatus for setx and bex
	alu alu_comp(data_b, data_a, 5'b1, shamt, alu_comp_out, isne, ilt, of_comp);
	
	//alu for pc calculations, sets to datab if jr, T if JI and PC + 1 + N if I
	assign pc_mux_select = isBNE && isne || isBLT && ilt || isJ || isJAL || isJII || isne && isBex;
	
	wire [31:0] alu_pc_in_a, alu_pc_in_b, pc_plus_n;
	wire isne_pc, ilt_pc, of_pc;
	//PC + 1 + N
	alu alu_pc(next_pc, immediate , 5'b0, shamt, pc_plus_n, isne_pc, ilt_pc, of_pc);
	wire [11:0] JI_or_I;
	assign JI_or_I = isJI ? target : pc_plus_n;
	assign next_pc_j_x = isJII ? data_b : JI_or_I;
	
	//data out: is it Setx? out is T, is it a JAL? then it's PC + 1, is it an exception? then it's exception_val, otherwise it's alu_main_out;
	wire[31:0] ji_out, instruction_out;
	
	assign ji_out = isSetx ? immediate : next_pc;
	assign instruction_out = isJI ? ji_out : alu_main_out;
	assign data_o_x = exception ? exception_val : instruction_out;
	

	//assumt rstatus is passed as rd for setx and that r31 is passed as rd for jal
	assign rd = exception ? 5'b1110 : rd_original;
	
endmodule
