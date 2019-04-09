module x_bypassing(rd_w, rd_m, r_x, alu_in_a_select);
	input [5:0] rd_w, rd_m, r_x;
	output [1:0] alu_in_a_select;
	
	wire ine_xm, ine_mw, ilt_xm, ilt_mw, of_xm, of_mw;
	wire [31:0] data_xm, data_mw;
	alu testequalxm(rd_m, r_x, 5'b1, 0, data_xm, ine_xm, ilt_xm, of_xm);
	alu testequalmw(rd_w, r_x, 5'b1, 0, data_mw, ine_mw, ilt_mw, of_mw);
	
	
	assign alu_in_a_select[0] = ~ine_mw && ine_xm && r_x != 0;
	assign alu_in_a_select[1] = (ine_xm && ine_mw) || r_x == 0;
	
endmodule
