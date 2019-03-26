module my_div(dividend, divisor, clock, reset_div, out, data_exception, div_done);
	//check if D(divisor) is zero, if it is then there is an exception
	
	input [31:0] dividend, divisor;
	input clock, reset_div;
	output [31:0] out;
	output data_exception, div_done;
	// counter = 0, go up until it's 32
	//counter = 0 A = [0000] (32 bits), Q is initialized to be dividend, partial_q = [A Q]
	wire[5:0] iter, prev_iter, initial_iter;
	wire[63:0] aq, partial_aq, initial_aq;
	wire [31:0] a_;
	wire [31:0] neg_dividend, neg_divisor;
	wire pof1, pof2, test_done;
	my_negate neg1(dividend, neg_dividend, pof1);
	my_negate neg2(divisor, neg_divisor, pof2);
	wire diff_signs, overflow, div_by_zero;
	xor(diff_signs, divisor[31], dividend[31]);
	
	assign div_by_zero = ~divisor[31] && ~divisor[30] && ~divisor[29] && ~divisor[28] && ~divisor[27] && ~divisor[26] && ~divisor[25] && ~divisor[24] && ~divisor[23] && ~divisor[22] && ~divisor[21] && ~divisor[20] && ~divisor[19] && ~divisor[18] && ~divisor[17] && ~divisor[16] && ~divisor[15] && ~divisor[14] && ~divisor[13] && ~divisor[12] && ~divisor[11] && ~divisor[10] && ~divisor[9] && ~divisor[8] && ~divisor[7] && ~divisor[6] && ~divisor[5] && ~divisor[4] && ~divisor[3] && ~divisor[2] && ~divisor[1] && ~divisor[0];
	
	
	assign initial_iter = 6'b000000;
	assign initial_aq[63:32] = 1'b0;
	assign initial_aq[31:0] = dividend[31] ? neg_dividend[31:0] : dividend[31:0];
	assign iter = reset_div ? initial_iter : prev_iter;
//	
//	always @(clock) begin
//		$display("div_iter %b", iter);
//	end
	
	
	assign aq = reset_div ? initial_aq : partial_aq;
	//shift left aq
	wire [63:0] aq_;
	wire [31:0] m;
	assign m = divisor[31] ? neg_divisor : divisor;
	div_action operate(aq, m, aq_, overflow);
	
	wire iter_cout;
	wire[5:0] next_iter;
	my_rca_6bit incrementcounter(iter, 6'b1, 1'b0, iter_cout, next_iter);
	//counter incremented, check if n is zero, done if it is, otherwise write to partial_q
	assign test_done = next_iter[5] && ~next_iter[4] && ~next_iter[3] && ~next_iter[2] && ~next_iter[1] && ~next_iter[0];
	
	reg_64_bit write_partial(clock, 1'b1, aq_, 1'b0, partial_aq);
	reg_6_bit write_iter(clock, 1'b1, next_iter, 1'b0, prev_iter);
	wire [31:0] neg_out, pick_out;
	wire ofn;
	my_negate neg3(aq_[31:0], neg_out, ofn);
	
	assign pick_out = diff_signs ? neg_out : aq_[31:0];
	assign data_exception = overflow || div_by_zero;
	dflipflop setdonet(test_done, clock, 1'b1, 1'b0, 1'b1, div_done);
	
	assign out = pick_out;

endmodule
