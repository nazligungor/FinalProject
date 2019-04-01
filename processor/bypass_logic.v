module bypass_logic(rd_w, rd_m, rs_d, rt_d, rs_x, rt_x, alu_in_a_select, alu_in_b_select, m_select, decode_a_select, decode_b_select);
	input [5:0] rd_w, rd_m, rs_x, rt_x, rs_d, rt_d;
	output [1:0] alu_in_a_select, alu_in_b_select;
	output m_select, decode_a_select, decode_b_select;
	
	x_bypassing aluInA(rd_w, rd_m, rs_x,alu_in_a_select);
	x_bypassing aluInB(rd_w, rd_m, rt_x,alu_in_b_select);
	m_bypassing dataIn(rd_w, rd_m, m_select);
	m_bypassing decodeA(rd_w, rs_d, decode_a_select);
	m_bypassing decodeB(rd_w, rt_d, decode_b_select);

endmodule
