module xm_latch(clock, reset, data_o_x, data_b_x, rd_x, isLW_x, isSW_x, isR_x, isAddi_x, isJAL_x, isSetx_x, data_o_m, data_b_m, rd_m, isLW_m, isSW_m, isR_m, isAddi_m, isJAL_m, isSetx_m);
	input clock, reset;
	input [31:0] data_o_x, data_b_x;
	input [4:0] rd_x;
	input isLW_x, isSW_x, isR_x, isAddi_x, isJAL_x, isSetx_x;
	output [31:0] data_o_m, data_b_m;
	output [4:0] rd_m;
	output isLW_m, isSW_m, isR_m, isAddi_m, isJAL_m, isSetx_m;
	
	dflipflop rd_xm [4:0] (rd_x, clock, ~reset, 1'b1, 1'b1, rd_m);
	dflipflop data_o_xm [31:0] (data_o_x, clock, ~reset, 1'b1, 1'b1, data_o_m);
	dflipflop data_b_xm [31:0] (data_b_x, clock, ~reset, 1'b1, 1'b1, data_b_m);
	dflipflop isLW_xm (isLW_x, clock, ~reset, 1'b1, 1'b1, isLW_m);
	dflipflop isSW_xm (isSW_x, clock, ~reset, 1'b1, 1'b1, isSW_m);
	dflipflop isR_xm (isR_x, clock, ~reset, 1'b1, 1'b1, isR_m);
	dflipflop isAddi_xm (isAddi_x, clock, ~reset, 1'b1, 1'b1, isAddi_m);
	dflipflop isJAL_xm (isJAL_x, clock, ~reset, 1'b1, 1'b1, isJAL_m);
	dflipflop isSetx_xm (isSetx_x, clock, ~reset, 1'b1, 1'b1, isSetx_m);
	
endmodule


	
	