module lcd_read_name(clock, name, ascii_data, lcd_we, lcd_reset);
	input clock;
	input[15:0] name;
	reg [15:0] old_name;
	
	output [7:0] ascii_data;
	output lcd_we, lcd_reset;
	reg start;
	reg[1:0] letter;
	reg writing;
	reg [7:0] curr_letter;
	
	always @(posedge clock) begin 
		start = name != old_name;
		if(start) begin 
			letter = 1;
			old_name = name;
		end
		else begin 
			letter = letter + 1;
		end
		
	end
	
	always @(negedge clock) begin
		if(start) begin 
			writing = 1;
		end
		if(letter == 3) begin 
			writing = 0;
		end
		
		if(letter == 1) begin 
			curr_letter = name[15:8] + 33;
		end
		else begin 
			curr_letter = name[7:0] + 34;
		end
		
	end
	
	assign lcd_we = writing;
	assign lcd_reset = start;
	assign ascii_data = curr_letter;



endmodule
