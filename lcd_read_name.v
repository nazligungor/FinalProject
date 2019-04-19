module lcd_read_name(clock, start, name, ascii_data, lcd_we, done);
	input clock;
	input[15:0] name;
	reg [15:0] old_name;
	
	output [7:0] ascii_data;
	output lcd_we;
	output done;
	input start;
	reg[1:0] letter;
	reg writing, done_reg;
	reg [7:0] curr_letter;
	
	always @(posedge clock) begin 
		if(start) begin 
			letter = 1;
		end
		else begin
			if(writing) begin
				letter = letter + 1;
			end
			else begin 
				letter = 0;
			end
		end
		
	end
	
	always @(negedge clock) begin
		if(start == 1) begin 
			writing = 1;
			done_reg = 0;
		end
		else if(letter == 3) begin 
			writing = 0;
			done_reg = 1;
		end
		else begin
			done_reg = 0;
		end
		
		if(letter == 1) begin 
			curr_letter = name[15:8] + 32;
		end

		else begin 
			curr_letter = name[7:0] + 32;
		end
		
	end
	assign done = done_reg;
	assign lcd_we = writing;
	assign ascii_data = curr_letter;
endmodule
