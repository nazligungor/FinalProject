module collision_detection(x_bird, y_bird, bird_size, pipe_width, x_lowerpipe1, x_lowerpipe2, x_lowerpipe3, x_lowerpipe4,  y_lowerpipe1, 
 y_lowerpipe2,  y_lowerpipe3,  y_lowerpipe4, upperpipe1_bottom, upperpipe2_bottom, upperpipe3_bottom, upperpipe4_bottom, c_flag_out);
 
 input[9:0] x_bird, y_bird, bird_size, pipe_width, x_lowerpipe1, x_lowerpipe2, x_lowerpipe3, x_lowerpipe4,  y_lowerpipe1, 
 y_lowerpipe2,  y_lowerpipe3,  y_lowerpipe4, upperpipe1_bottom, upperpipe2_bottom, upperpipe3_bottom, upperpipe4_bottom;
 output [2:0] c_flag_out;
 reg [2:0] c_flag;
 
 wire birdinbetween_1, birdinbetween_2, birdinbetween_3, birdinbetween_4;
 wire birdinpipe1, birdinpipe2, birdinpipe3, birdinpipe4;
 wire birdatboundry;
 wire[9:0] screen_height = 10'd480;
 wire[9:0] screen_width = 10'd640;
 wire[9:0] bird_right, bird_left, bird_top, bird_bottom;
 
 assign bird_right = x_bird + bird_size;
 assign bird_left = x_bird;
 assign bird_top = y_bird;
 assign bird_bottom = y_bird + bird_size;
 
 assign birdinbetween_1 = (bird_left <= x_lowerpipe1 + pipe_width) && (bird_right >= x_lowerpipe1);
 assign birdinbetween_2 = (bird_left <= x_lowerpipe2 + pipe_width) && (bird_right >= x_lowerpipe2);
 assign birdinbetween_3 = (bird_left <= x_lowerpipe3 + pipe_width) && (bird_right >= x_lowerpipe3);
 assign birdinbetween_4 = (bird_left <= x_lowerpipe4 + pipe_width) && (bird_right >= x_lowerpipe4);
 
 assign birdinpipe1 = (bird_top <= upperpipe1_bottom) || (bird_bottom >= y_lowerpipe1);
 assign birdinpipe2 = (bird_top <= upperpipe2_bottom) || (bird_bottom >= y_lowerpipe2);
 assign birdinpipe3 = (bird_top <= upperpipe3_bottom) || (bird_bottom >= y_lowerpipe3);
 assign birdinpipe4 = (bird_top <= upperpipe4_bottom) || (bird_bottom >= y_lowerpipe4);
 
 assign birdatboundry = (bird_top <= 10'd0) || (bird_bottom >= screen_height);
 // top: 1, right: 2, bottom: 3, 4 is endgame (edges)
 always @(*) begin
	 if(bird_top <= 10'd0) begin 
		 c_flag = 4;
	 end
	 
	 else if(bird_bottom >= screen_height) begin 
		 c_flag = 4;
	 end
	 
	 else if(bird_left <= 0 ) begin 
	 
		c_flag = 4;
	 end
	 
	 else if(birdinbetween_1 && birdinpipe1) begin 
		//if like half of the bird is above the bottom, bounce left or right
		if(bird_bottom <= upperpipe1_bottom || bird_top >= y_lowerpipe1) begin 
			 c_flag = 2;
		end
		else begin 
			 c_flag = bird_top <= upperpipe1_bottom ? 1 : 3;
		end
	 end
	 
	 else if(birdinbetween_2 && birdinpipe2) begin 
		//if like half of the bird is above the bottom, bounce left or right
		if(bird_bottom <= upperpipe2_bottom || bird_top >= y_lowerpipe2) begin 
			 c_flag = 2;
		end
		else begin 
			 c_flag = bird_top <= upperpipe2_bottom ? 1 : 3;
		end
	 end
	 
	 else if(birdinbetween_3 && birdinpipe3) begin 
		//if like half of the bird is above the bottom, bounce left or right
		if(bird_bottom <= upperpipe3_bottom || bird_top >= y_lowerpipe3) begin 
			 c_flag = 2;
		end
		else begin 
			 c_flag = bird_top <= upperpipe3_bottom ? 1 : 3;
		end
	 end
	 
	 else if(birdinbetween_4 && birdinpipe4) begin 
		//if like half of the bird is above the bottom, bounce left or right
		if(bird_bottom <= upperpipe4_bottom || bird_top >= y_lowerpipe4) begin 
			c_flag = 2;
		end
		else begin 
			c_flag = bird_top <= upperpipe4_bottom ? 1 : 3;
		end
	 end
	 else begin 
		c_flag = 0;
	 end
	end
	assign c_flag_out = c_flag;
 
// assign c_flag = (birdinbetween_1 && birdinpipe1) || (birdinbetween_2 && birdinpipe2) || (birdinbetween_3 && birdinpipe3) || (birdinbetween_4 && birdinpipe4) || birdatboundry;


endmodule
