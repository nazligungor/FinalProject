module collision_detection(x_bird, y_bird, bird_size, pipe_width, x_lowerpipe1, x_lowerpipe2, x_lowerpipe3, x_lowerpipe4,  y_lowerpipe1, 
 y_lowerpipe2,  y_lowerpipe3,  y_lowerpipe4, upperpipe1_bottom, upperpipe2_bottom, upperpipe3_bottom, upperpipe4_bottom, c_flag);
 
 input[9:0] x_bird, y_bird, bird_size, pipe_width, x_lowerpipe1, x_lowerpipe2, x_lowerpipe3, x_lowerpipe4,  y_lowerpipe1, 
 y_lowerpipe2,  y_lowerpipe3,  y_lowerpipe4, upperpipe1_bottom, upperpipe2_bottom, upperpipe3_bottom, upperpipe4_bottom;
 output c_flag;
 
 wire birdinbetween_1, birdinbetween_2, birdinbetween_3, birdinbetween_4;
 wire birdinpipe1, birdinpipe2, birdinpipe3, birdinpipe4;
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
 
 assign c_flag = (birdinbetween_1 && birdinpipe1) || (birdinbetween_2 && birdinpipe2) || (birdinbetween_3 && birdinpipe3) || (birdinbetween_4 && birdinpipe4);


endmodule 