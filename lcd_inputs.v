module lcd_inputs(clock, name, score, ascii_data, lcd_we, lcd_reset, screen_state, winner_name, winner_score);
	input clock;
	input[15:0] name, winner_name;
	input [7:0] score, winner_score;
	input [31:0] screen_state;
	output [7:0] ascii_data;
	output lcd_we, lcd_reset;
//	output start_out;
	
	reg [15:0] old_name;
	reg[7:0] old_score;
	reg start_name;
	reg start_score;
	reg start;
	reg[31:0] old_screen_state;
	reg start_leaderboard;
	
	initial begin 
		old_score = 0;
		old_name = 0;
		old_screen_state = 0;
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
		start_leaderboard = screen_state != old_screen_state;
		if(start_leaderboard) begin 
			old_screen_state = screen_state;
		end
		
		start = start_name || start_score || start_leaderboard;
		
		
	end
	
	wire name_done, winner_name_done;
	wire num_done, winner_num_done;
	wire [7:0] name_data, num_data, winner_name_data, winner_num_data;
	wire name_we, num_we, winner_name_we, winner_num_we;
	
	lcd_read_name print_name(clock, start, name, name_data, name_we, name_done);
	lcd_data_generator print_numbers(clock, name_done && ~start_name, score, num_data, num_we, num_done);
	
	lcd_read_name print_name_winner(clock, num_done && screen_state == 32'd4, winner_name, winner_name_data, winner_name_we, winner_name_done);
	lcd_data_generator print_numbers_winner(clock, winner_name_done, winner_score, winner_num_data, winner_num_we, winner_num_done);

	wire [7:0] winner_data;
	wire [7:0] regular_data;
	assign regular_data = name_we ? name_data : num_data;
	assign winner_data = winner_name_we ? winner_name_data : winner_num_data;
	assign ascii_data = (name_we || num_we) ? regular_data : winner_data;
	assign lcd_we = name_we || num_we || winner_name_we || winner_num_we;
	assign lcd_reset = start; 
//	assign start_out = start;


endmodule





















