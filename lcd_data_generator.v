module lcd_data_generator(clock, start, score, data_bit, write_enable, done);
	input [7:0] score;
	input clock;
	input start;

	output[7:0] data_bit;
	output write_enable;
	output done;
	
	reg done_reg;
	
	initial begin 
		divisor = 1;
		done_reg = 1;
	end
	
	
	reg[7:0] curr_db;
	reg curr_we;
	reg[3:0] count, c;
	reg[10:0] divisor;
	reg found_first;

	
	always @(posedge clock) begin 
		if(start) begin
			count = 3;
		end
		else begin
			if(~done_reg) begin 
				count = count - 1;
			end
			
		end
	end
	
	
	always @(negedge clock) begin
		if(start ==1) begin 
			found_first = 0;
			done_reg = 0;
		end
		if(count == 4'b1111) begin 
				done_reg = 1;
		end
		divisor = 1;
		for(c = 0; c < count && c < 3; c = c + 1) begin
			divisor = divisor * 10;
		end
		curr_db = score/divisor % 10 + 48;
		found_first = found_first || score/divisor != 0;
	end
	
	assign write_enable = (found_first || score == 0) &&  ~done_reg;
	assign data_bit = curr_db;
	assign done = done_reg;

	
endmodule
