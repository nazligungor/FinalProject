module my_mult(multiplicand, multiplier, clock, reset_mult, out, overflow, mult_done);
	input [31:0] multiplicand, multiplier;
	input clock;
	input reset_mult;
	output [31:0] out;
	output overflow, mult_done;
	wire [64:0] partial_prod, initial_prod, reg_read, prod;
	wire [31:0] shifted_mcd;
	wire[3:0] iter;
	wire addition_overflow, mult_overflow;
	wire test_done;
	

	// read from the register for the previous partial_prod, or the new initialized one
//	reg_65_bit read_partial(clock, 1'b0, 64'b0, reset_mult, reg_read_prod);
	
	assign initial_prod[64:33] =  32'b0;
	assign initial_prod[32:1] = multiplier[31:0];
	assign initial_prod[0] = 1'b0;
	assign prod = reset_mult ? initial_prod: partial_prod;

	//shift the multiplicand
	assign shifted_mcd = multiplicand << 1;
	
	//get the right control bits
	wire op, shift, act;
	wire [3:0] next_iter;
	
//	always @(clock) begin
//		$display("mult_iter %b", iter);
//	end
	mult_control mc(reset_mult, prod[2:0] , iter, op, shift, act, next_iter, test_done);
	
	//add the first 32 bits to the correct input
	wire[31:0] alu_sum;
	wire [31:0] add_to;
	wire ine, ilt;
	wire [4:0] operation;
	assign operation[0] = op;
	assign operation[4:1] = 4'b0;
	
	assign add_to	= shift ? shifted_mcd: multiplicand;
	
	alu completeAddition(prod[64:33], add_to, operation, 5'b0, alu_sum, ine, ilt, addition_overflow);

	wire [64:0] prod_before_shift;
	wire [64:0] prod_after_shift;
	assign prod_before_shift[64:33] = act ? alu_sum: prod[64:33];
	assign prod_before_shift [32:0] = prod[32:0];
	
	mult_shifter ms(prod_before_shift, prod_after_shift);
	//check if MSBs are not all 1s or all 0s
	// if all 1s, check if lowest is negative
	// if all 0s check if lowest is positive;
	
	wire neg_overflow, pos_overflow;
	assign neg_overflow = ~prod_after_shift[64] && ~prod_after_shift[63] && ~prod_after_shift[62] && ~prod_after_shift[61] && ~prod_after_shift[60] && ~prod_after_shift[59] && ~prod_after_shift[58] && ~prod_after_shift[57] && ~prod_after_shift[56] && ~prod_after_shift[55] && ~prod_after_shift[54] && ~prod_after_shift[53] && ~prod_after_shift[52] && ~prod_after_shift[51] && ~prod_after_shift[50] && ~prod_after_shift[49] && ~prod_after_shift[48] && ~prod_after_shift[47] && ~prod_after_shift[46] && ~prod_after_shift[45] && ~prod_after_shift[44] && ~prod_after_shift[43] && ~prod_after_shift[42] && ~prod_after_shift[41] && ~prod_after_shift[40] && ~prod_after_shift[39] && ~prod_after_shift[38] && ~prod_after_shift[37] && ~prod_after_shift[36] && ~prod_after_shift[35] && ~prod_after_shift[34] && ~prod_after_shift[33] && prod_after_shift[32];
	
	assign pos_overflow = prod_after_shift[64] && prod_after_shift[63] && prod_after_shift[62] && prod_after_shift[61] && prod_after_shift[60] && prod_after_shift[59] && prod_after_shift[58] && prod_after_shift[57] && prod_after_shift[56] && prod_after_shift[55] && prod_after_shift[54] && prod_after_shift[53] && prod_after_shift[52] && prod_after_shift[51] && prod_after_shift[50] && prod_after_shift[49] && prod_after_shift[48] && prod_after_shift[47] && prod_after_shift[46] && prod_after_shift[45] && prod_after_shift[44] && prod_after_shift[43] && prod_after_shift[42] && prod_after_shift[41] && prod_after_shift[40] && prod_after_shift[39] && prod_after_shift[38] && prod_after_shift[37] && prod_after_shift[36] && prod_after_shift[35] && prod_after_shift[34] && prod_after_shift[33] && ~prod_after_shift[32];
	
	assign mult_overflow = neg_overflow || pos_overflow;
	
	assign overflow = addition_overflow || mult_overflow;
	
	//write to partial product and output, won't read output unless mult_done was set
	reg_65_bit write_partial(clock, 1'b1, prod_after_shift, 1'b0, partial_prod);
	reg_4_bit write_iter(clock, 1'b1, next_iter, 1'b0, iter);
	dflipflop setdonet(test_done, ~clock, 1'b1, 1'b0, 1'b1, mult_done);
//	dflipflop setout[31:0](prod_after_shift[32:1], clock, 1'b1, 1'b0, 1'b1, out);
	assign out = prod_after_shift[32:1];
//	dflipflop write_done(test_done, clock, 1'b0, 1'b0, 1'b1, mult_done);
	 
endmodule

	