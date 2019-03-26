//module takes in the current pc, clock and reset. Sets the address to be read from imem to the current pc, and then calculates the potential next pc
module fetch_stage (curr_pc, clock, reset, next_pc_f, address_imem);
	input clock, reset;
	input [11:0] curr_pc;
	output [11:0] next_pc_f, address_imem;
	
	
	wire [31:0] enabled_next_pc;
	//curr_pc is 11 bits, so the MSBs will become 0
	alu ALU(curr_pc, 32'd1, 5'b00000, 5'd0, enabled_next_pc);
	//determine if the next PC should be 0 or current pc + 1
	assign next_pc_f = reset ? 11'd0 : enabled_next_pc; 
	assign address_imem = curr_pc;

endmodule



