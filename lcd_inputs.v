module lcd_inputs(clock, name, score, ascii_data, lcd_we, lcd_reset);
	input clock;
	input[15:0] name;
	input [7:0] score;
	
	output [7:0] ascii_data;
	output lcd_we, lcd_reset;
//	output start_out;
	
	reg [15:0] old_name;
	reg[7:0] old_score;
	reg start_name;
	reg start_score;
	reg start;
	
	initial begin 
		old_score = 0;
		old_name = 0;
	
	end
	
	always @(posedge clock) begin 
		start_name = name != old_name;
		if(start_name) begin 
			old_name = name;
		end
		start_score = score != old_score;
		if(start_score) begin 
			old_score = score;
		end
		start = start_name || start_score;
	end
	
	wire name_done;
	wire num_done;
	wire [7:0] name_data, num_data;
	wire name_we, num_we;
	
	lcd_read_name print_name(clock, start, name, name_data, name_we, name_done);
	lcd_data_generator print_numbers(clock, name_done && ~start_name, score, num_data, num_we, num_done);
	
	assign ascii_data = name_we ? name_data : num_data;
	assign lcd_we = name_we || num_we;
	assign lcd_reset = start_name || start_score; 
//	assign start_out = start;


endmodule
