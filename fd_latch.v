module fd_latch(next_pc_f, reset, q_imem, clock, hazard, next_pc_d, instr_data);
	input [11:0] next_pc_f;
	input [31:0] q_imem;
	input clock, hazard, reset;
	output [11:0] next_pc_d;
	output [31:0] instr_data;
	
	wire[31:0] next_instr;
	assign next_instr = hazard ? 32'b0 : q_imem;
	dflipflop pc_reg_rd [11:0] (next_pc_f, clock, ~reset, 1'b1, ~hazard, next_pc_d);
	dflipflop instr_reg [31:0] (next_instr, clock, ~reset, 1'b1, 1'b1, instr_data);
	
endmodule
