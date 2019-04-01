module dx_latch(
				clock, reset,
				//inputs
				next_pc_d, data_a_d, data_b_d, rd_d, opcode_d, shamt_d, alu_op_d, target_d,immediate_d,isR_d, isI_d, isJI_d, isJII_d,isAdd_d, isAddi_d, isSub_d, isMul_d, isDiv_d, isSW_d, isLW_d, isJ_d, isBNE_d, isJAL_d, isBLT_d, isBex_d, isSetx_d, rs_d, rt_d,
				//outputs
				next_pc_x, data_a_x, data_b_x, rd_x, opcode_x, shamt_x, alu_op_x, target_x,immediate_x,isR_x, isI_x, isJI_x, isJII_x,isAdd_x, isAddi_x, isSub_x, isMul_x, isDiv_x, isSW_x, isLW_x, isJ_x, isBNE_x, isJAL_x, isBLT_x, isBex_x, isSetx_x, rs_x, rt_x);
				input [31:0] data_a_d, data_b_d;
				input [11:0] next_pc_d;
				input [4:0] opcode_d, shamt_d, alu_op_d;
				input [4:0] rd_d, rt_d, rs_d;
				input [26:0] target_d;
				input [16:0] immediate_d;
				//types
				input isR_d, isI_d, isJI_d, isJII_d,isAdd_d, isAddi_d, isSub_d, isMul_d, isDiv_d, isSW_d, isLW_d, isJ_d, isBNE_d, isJAL_d, isBLT_d, isBex_d, isSetx_d, clock, reset;
				output [31:0] data_a_x, data_b_x;
				output [11:0] next_pc_x;
				output [4:0] opcode_x, shamt_x, alu_op_x;
				output [4:0] rd_x, rt_x, rs_x;
				output [26:0] target_x;
				output [16:0] immediate_x;
				//types
				output isR_x, isI_x, isJI_x, isJII_x,isAdd_x, isAddi_x, isSub_x, isMul_x, isDiv_x, isSW_x, isLW_x, isJ_x, isBNE_x, isJAL_x, isBLT_x, isBex_x, isSetx_x;
				
				dflipflop data_a_dx [31:0] (data_a_d, clock, ~reset, 1'b1, 1'b1, data_a_x);
				dflipflop data_b_dx [31:0] (data_b_d, clock, ~reset, 1'b1, 1'b1, data_b_x);
				dflipflop pc_reg_dx [11:0] (next_pc_d, clock, ~reset, 1'b1, 1'b1, next_pc_x);
				dflipflop opcode_reg_dx [4:0] (opcode_d, clock, ~reset, 1'b1, 1'b1, opcode_x);
				dflipflop shamt_reg_dx [4:0] (shamt_d, clock, ~reset, 1'b1, 1'b1, shamt_x);
				dflipflop alu_opcode_reg_dx [4:0] (alu_op_d, clock, ~reset, 1'b1, 1'b1, alu_op_x);
				dflipflop rd_dx [4:0] (rd_d, clock, ~reset, 1'b1, 1'b1, rd_x);
				dflipflop rt_dx [4:0] (rt_d, clock, ~reset, 1'b1, 1'b1, rt_x);
				dflipflop rs_dx [4:0] (rs_d, clock, ~reset, 1'b1, 1'b1, rs_x);
				dflipflop target_dx [26:0] (target_d, clock, ~reset, 1'b1, 1'b1, target_x);
				dflipflop immediate_dx [16:0] (immediate_d, clock, ~reset, 1'b1, 1'b1, immediate_x);
				dflipflop isR_dx (isR_d, clock, ~reset, 1'b1, 1'b1, isR_x);
				dflipflop isI_dx (isI_d, clock, ~reset, 1'b1, 1'b1, isI_x);
				dflipflop isJI_dx (isJI_d, clock, ~reset, 1'b1, 1'b1, isJI_x);
				dflipflop isJII_dx (isJII_d, clock, ~reset, 1'b1, 1'b1, isJII_x);
				dflipflop isAdd_dx (isAdd_d, clock, ~reset, 1'b1, 1'b1, isAdd_x);
				dflipflop isAddi_dx (isAddi_d, clock, ~reset, 1'b1, 1'b1, isAddi_x);
				dflipflop isSub_dx (isSub_d, clock, ~reset, 1'b1, 1'b1, isSub_x);
				dflipflop isMul_dx (isMul_d, clock, ~reset, 1'b1, 1'b1, isMul_x);
				dflipflop isDiv_dx (isDiv_d, clock, ~reset, 1'b1, 1'b1, isDiv_x);
				dflipflop isSW_dx (isSW_d, clock, ~reset, 1'b1, 1'b1, isSW_x);
				dflipflop isLW_dx (isLW_d, clock, ~reset, 1'b1, 1'b1, isLW_x);
				dflipflop isJ_dx (isJ_d, clock, ~reset, 1'b1, 1'b1, isJ_x);
				dflipflop isBNE_dx (isBNE_d, clock, ~reset, 1'b1, 1'b1, isBNE_x);
				dflipflop isJAL_dx (isJAL_d, clock, ~reset, 1'b1, 1'b1, isJAL_x);
				dflipflop isBLT_dx (isBLT_d, clock, ~reset, 1'b1, 1'b1, isBLT_x);
				dflipflop isBex_dx (isBex_d, clock, ~reset, 1'b1, 1'b1, isBex_x);
				dflipflop isSetx_dx (isSetx_d, clock, ~reset, 1'b1, 1'b1, isSetx_x);
				
				
endmodule
