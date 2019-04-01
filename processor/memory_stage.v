module memory_stage(data_o, data_b, isLW, isSW,address_dmem, data_mem, wren);
	input [31:0] data_o, data_b;
	input isLW, isSW;
	output [11:0] address_dmem;
   output [31:0] data_mem;
   output wren;
	
	assign wren = isSW;
	assign address_dmem = data_o;
	assign data_mem = data_b;

endmodule 
