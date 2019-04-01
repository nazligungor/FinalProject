module mw_latch(clock, reset, data_o_m, data_d_m, rd_m, isLW_m, isR_m, isAddi_m, isSW_m,isJAL_m, isSetx_m, data_o_w, data_d_w, rd_w, isLW_w,isR_w, isAddi_w, isSW_w, isJAL_w, isSetx_w);
	input clock, reset;
	input [31:0] data_o_m, data_d_m;
	input [4:0] rd_m;
	input isLW_m, isSW_m, isR_m, isAddi_m, isJAL_m, isSetx_m;
	
	output [31:0] data_o_w, data_d_w;
	output [4:0] rd_w;
	output isLW_w, isR_w, isAddi_w, isSW_w, isJAL_w, isSetx_w;
	
	dflipflop rd_mw [4:0] (rd_m, clock, ~reset, 1'b1, 1'b1, rd_w);
	dflipflop isLW_mw (isLW_m, clock, ~reset, 1'b1, 1'b1, isLW_w);
	dflipflop isR_mw (isR_m, clock, ~reset, 1'b1, 1'b1, isR_w);
	dflipflop isSW_mw (isSW_m, clock, ~reset, 1'b1, 1'b1, isSW_w);
	dflipflop isAddi_mw (isAddi_m, clock, ~reset, 1'b1, 1'b1, isAddi_w);
	dflipflop isJAL_mw (isJAL_m, clock, ~reset, 1'b1, 1'b1, isJAL_w);
	dflipflop isSetx_mw (isSetx_m, clock, ~reset, 1'b1, 1'b1, isSetx_w);
	dflipflop data_o_mw [31:0] (data_o_m, clock, ~reset, 1'b1, 1'b1, data_o_w);
	dflipflop data_d_mw [31:0] (data_d_m, clock, ~reset, 1'b1, 1'b1, data_d_w);
	
endmodule

