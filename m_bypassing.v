module m_bypassing(rd_m, rd_w, m_select);
	input [4:0] rd_m, rd_w;
	output m_select;
	wire ine, ilt, of;
	wire [31:0] data;
	alu testequalxm(rd_m, rd_w, 5'b1, 0, data, ine, ilt, of);
	
	assign m_select = ~ine;

endmodule
