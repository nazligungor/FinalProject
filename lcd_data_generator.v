module lcd_data_generator(clock, score, data_bit, write_enable, reset);
	input [7:0] score;
	input clock;
//	output [3:0] curr;
	output[7:0] data_bit;
//	output [10:0] div;
//	output d, s;
//	output [31:0] num;
	reg[7:0] last_score;
	output reset;
	
	initial begin 
		last_score = 0;
		divisor = 1;
	end
	
	output write_enable;
	
	reg start;
	
	reg[7:0] curr_db;
	reg curr_we;
	reg[3:0] count, c;
	reg[10:0] divisor;
	reg found_first;
	reg done;
	
	always @(posedge clock) begin 
		start = score != last_score;
		if(start) begin
			last_score = score;
			count = 3;
		end
		else begin
			if(~done) begin 
				count = count - 1;
			end
			
		end
	end
	
	
	always @(negedge clock) begin
		if(start) begin 
			found_first = 0;
			done = 0;
		end
		if(count == 4'b1111) begin 
				done = 1;
		end
		divisor = 1;
		for(c = 0; c < count && c < 3; c = c + 1) begin
			divisor = divisor * 10;
		end
		curr_db = score/divisor % 10 + 48;
		found_first = found_first || score/divisor != 0;
	end
	
	assign write_enable = (found_first || score == 0) &&  ~done;
	assign data_bit = curr_db;
	assign reset = start;

	
endmodule
