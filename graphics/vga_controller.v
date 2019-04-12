module vga_controller(iRST_n,
                      iVGA_CLK,
                      oBLANK_n,
                      oHS,
                      oVS,
                      b_data,
                      g_data,
                      r_data,
							 control,
							 y_bird,
							 x_lowerpipe1,
							 x_lowerpipe2,
							 x_lowerpipe3,
							 x_lowerpipe4,
							 x_upperpipe1,
							 x_upperpipe2,
							 x_upperpipe3,
							 x_upperpipe4, 
							 c_flag, 
							 screen_state);

	
input iRST_n, control;
input iVGA_CLK;
output reg oBLANK_n;
output reg oHS;
output reg oVS;
output [7:0] b_data;
output [7:0] g_data;  
output [7:0] r_data;  
wire isin_pipe;                      
///////// ////                     
reg [18:0] ADDR;
reg [23:0] bgr_data;
wire VGA_CLK_n;
wire [7:0] index, index_bird;
wire [23:0] bgr_data_raw, bird_data_raw;
wire cBLANK_n,cHS,cVS,rst;
wire[9:0] addr_x, addr_y;
wire x_in_s, y_in_s;
input[9:0] y_bird;
wire [9:0] x_bird;
assign x_bird = 10'b0001000000; //bird's x fixed at 100
//reg [40:0] counter;
//wire [9:0] acceleration;
//assign acceleration = 10'b1;
//reg[9:0] velocity;
//pipes

input[9:0] x_lowerpipe1, x_lowerpipe2, x_lowerpipe3, x_lowerpipe4;
wire[9:0]  y_lowerpipe1,  y_lowerpipe2,  y_lowerpipe3,  y_lowerpipe4;
input[9:0] x_upperpipe1, x_upperpipe2, x_upperpipe3, x_upperpipe4;
wire[9:0] y_upperpipe1, y_upperpipe2, y_upperpipe3, y_upperpipe4;

wire[18:0] addr_lowerpipe1_x, addr_lowerpipe1_y, addr_lowerpipe2_x, addr_lowerpipe2_y, addr_lowerpipe3_x, addr_lowerpipe3_y, addr_lowerpipe4_x, addr_lowerpipe4_y;
wire[18:0] addr_upperpipe1_x, addr_upperpipe1_y, addr_upperpipe2_x, addr_upperpipe2_y, addr_upperpipe3_x, addr_upperpipe3_y, addr_upperpipe4_x, addr_upperpipe4_y;

wire x_lpipe1_in, y_lpipe1_in, x_lpipe2_in, y_lpipe2_in, x_lpipe3_in, y_lpipe3_in, x_lpipe4_in, y_lpipe4_in;
wire x_upipe1_in, y_upipe1_in, x_upipe2_in, y_upipe2_in, x_upipe3_in, y_upipe3_in, x_upipe4_in, y_upipe4_in;


reg[9:0] pipe_velocity = 10'd5;

wire[31:0] rand_val, rand_val1, rand_val2, rand_val3;
reg[31:0] rand_gap, rand_gap1, rand_gap2, rand_gap3;
reg[9:0] pipe_gap, pipe_gap1, pipe_gap2, pipe_gap3;

//move this part to skeleton but how? 

wire[9:0] bird_size = 10'd20;
wire[9:0] screen_height = 10'd480;
wire[9:0] screen_width = 10'd640;
wire[9:0] pipe_width = 10'd120;

wire[9:0] pipe_height, pipe_height1, pipe_height2, pipe_height3;
assign pipe_height = screen_height/2 - pipe_gap/2;
assign pipe_height1 = screen_height/2 - pipe_gap1/2;
assign pipe_height2 = screen_height/2 - pipe_gap2/2;
assign pipe_height3 = screen_height/2 - pipe_gap3/2;

initial pipe_gap = 10'd80;
initial pipe_gap1 = 10'd100;
initial pipe_gap2 = 10'd70;
initial pipe_gap3 = 10'd120;

lfsr lfsr_1(iVGA_CLK, iRST_n, rand_val, 32'hf0f0f0f0);
lfsr lfsr_2(iVGA_CLK, iRST_n, rand_val1, 32'hf0f0f0f0);
lfsr lfsr_3(iVGA_CLK, iRST_n, rand_val2, 32'hf0f0f0f0);
lfsr lfsr_4(iVGA_CLK, iRST_n, rand_val3, 32'hf0f0f0f0);

assign y_lowerpipe1 = pipe_height + pipe_gap;
assign y_lowerpipe2 = pipe_height1 + pipe_gap1;
assign y_lowerpipe3 = pipe_height2 + pipe_gap2;
assign y_lowerpipe4 = pipe_height3 + pipe_gap3;

assign y_upperpipe1 = 10'd0;
assign y_upperpipe2 = 10'd0;
assign y_upperpipe3 = 10'd0;
assign y_upperpipe4 = 10'd0;

wire[9:0] upperpipe1_bottom, upperpipe2_bottom, upperpipe3_bottom, upperpipe4_bottom;
assign upperpipe1_bottom = y_upperpipe1 + pipe_height;
assign upperpipe2_bottom = y_upperpipe2 + pipe_height1;
assign upperpipe3_bottom = y_upperpipe3 + pipe_height2;
assign upperpipe4_bottom = y_upperpipe4 + pipe_height3;
//
//initial x_lowerpipe1 = 10'd120;
//initial x_lowerpipe2 = 10'd240;
//initial x_lowerpipe3 = 10'd340;
//initial x_lowerpipe4 = 10'd440;
//
//initial x_upperpipe1 = 10'd120;
//initial x_upperpipe2 = 10'd240;
//initial x_upperpipe3 = 10'd340;
//initial x_upperpipe4 = 10'd440;


////
assign rst = ~iRST_n;
video_sync_generator LTM_ins (.vga_clk(iVGA_CLK),
                              .reset(rst),
                              .blank_n(cBLANK_n),
                              .HS(cHS),
                              .VS(cVS));

//this is our object control
reg counter;
always @(posedge VGA_CLK_n) begin
	counter <= counter + 1;
	if(counter >  1000000) begin
		if(x_lowerpipe1 > screen_width) begin
			rand_gap <= (rand_val % 50) + 200;
			pipe_gap <= rand_gap[9:0];
		end
		
		if(x_lowerpipe2 > screen_width) begin
			rand_gap1 <= (rand_val1 % 50) + 200;
			pipe_gap1 <= rand_gap1[9:0];
		end
		
		if(x_lowerpipe3 > screen_width) begin
			rand_gap2 <= (rand_val2 % 50) + 200;
			pipe_gap2 <= rand_gap2[9:0];
		end
		
		if(x_lowerpipe4 > screen_width) begin
			rand_gap3 <= (rand_val3 % 50) + 200;
			pipe_gap3 <= rand_gap3[9:0];
		end
		
		counter <= 0;
	end
end
////Addresss generator
always@(posedge iVGA_CLK,negedge iRST_n)
begin
  if (!iRST_n)
     ADDR<=19'd0;
  else if (cHS==1'b0 && cVS==1'b0)
     ADDR<=19'd0;
  else if (cBLANK_n==1'b1)
     ADDR<=ADDR+1;
end
//////////////////////////
//////INDEX addr.
assign VGA_CLK_n = ~iVGA_CLK;
img_data	img_data_inst (
	.address ( ADDR ),
	.clock ( VGA_CLK_n ),
	.q ( index )
	);
	
/////////////////////////
//////Add switch-input logic here
	
//////Color table output
img_index	img_index_inst (
	.address ( index ),
	.clock ( iVGA_CLK ),
	.q ( bgr_data_raw)
	);	
//////

bird_data	bird_data_inst (
	.address ( ADDR ),
	.clock ( VGA_CLK_n ),
	.q ( index_bird )
	);
	
bird_index	bird_index_inst (
	.address ( index_bird ),
	.clock ( iVGA_CLK ),
	.q ( bird_data_raw)
	);	

 assign addr_x = ADDR % 640;
 assign addr_y = ADDR/640;
 assign addr_lowerpipe1_x = ADDR % 640; 
 assign addr_lowerpipe1_y = (ADDR/640) % screen_height;
 assign addr_lowerpipe2_x = ADDR % 640; 
 assign addr_lowerpipe2_y = (ADDR/640) % screen_height;
 assign addr_lowerpipe3_x = ADDR % 640; 
 assign addr_lowerpipe3_y = ADDR/640;
 assign addr_lowerpipe4_x = ADDR % 640; 
 assign addr_lowerpipe4_y = ADDR/640;
 
 assign addr_upperpipe1_x = ADDR % 640; 
 assign addr_upperpipe1_y = (ADDR/640) % screen_height;
 assign addr_upperpipe2_x = ADDR % 640; 
 assign addr_upperpipe2_y = ADDR/640;
 assign addr_upperpipe3_x = ADDR % 640; 
 assign addr_upperpipe3_y = ADDR/640;
 assign addr_upperpipe4_x = ADDR % 640; 
 assign addr_upperpipe4_y = ADDR/640;
 
 
 assign y_in_s = (addr_y < (y_bird + 20)) && (addr_y > y_bird);
 assign x_in_s = (addr_x < (x_bird + 20)) && (addr_x > x_bird);
 
 assign x_lpipe1_in = (addr_lowerpipe1_x < (x_lowerpipe1 + pipe_width)) && (addr_lowerpipe1_x > x_lowerpipe1);
 assign y_lpipe1_in = (addr_lowerpipe1_y < (screen_height)) && (addr_lowerpipe1_y > y_lowerpipe1);
 
 assign x_lpipe2_in = (addr_lowerpipe2_x < (x_lowerpipe2 + pipe_width)) && (addr_lowerpipe2_x > x_lowerpipe2);
 assign y_lpipe2_in = (addr_lowerpipe2_y < (screen_height)) && (addr_lowerpipe2_y > y_lowerpipe2);
 
 assign x_lpipe3_in = (addr_lowerpipe3_x < (x_lowerpipe3 + pipe_width)) && (addr_lowerpipe3_x > x_lowerpipe3);
 assign y_lpipe3_in = (addr_lowerpipe3_y < (screen_height)) && (addr_lowerpipe3_y > y_lowerpipe3);
 
 assign x_lpipe4_in = (addr_lowerpipe4_x < (x_lowerpipe4 + pipe_width)) && (addr_lowerpipe4_x > x_lowerpipe4);
 assign y_lpipe4_in = (addr_lowerpipe4_y < (screen_height)) && (addr_lowerpipe4_y > y_lowerpipe4);
 
 wire lpipe1_in, lpipe2_in, lpipe3_in, lpipe4_in;
 assign lpipe1_in = x_lpipe1_in && y_lpipe1_in; // && x_lpipe3_in && y_lpipe3_in && x_lpipe4_in && y_lpipe4_in;
 assign lpipe2_in = x_lpipe2_in && y_lpipe2_in;
 assign lpipe3_in = x_lpipe3_in && y_lpipe3_in;
 assign lpipe4_in = x_lpipe4_in && y_lpipe4_in;
 
 assign x_upipe1_in = (addr_upperpipe1_x < (x_upperpipe1 + pipe_width)) && (addr_upperpipe1_x > x_upperpipe1);
 assign y_upipe1_in = (addr_upperpipe1_y < (y_upperpipe1 + pipe_height)) && (addr_upperpipe1_y > y_upperpipe1);

 assign x_upipe2_in = (addr_upperpipe2_x < (x_upperpipe2 + pipe_width)) && (addr_upperpipe2_x > x_upperpipe2);
 assign y_upipe2_in = (addr_upperpipe2_y < (y_upperpipe2 + pipe_height1)) && (addr_upperpipe2_y > y_upperpipe2);
 assign x_upipe3_in = (addr_upperpipe3_x < (x_upperpipe3 + pipe_width)) && (addr_upperpipe3_x > x_upperpipe3);
 assign y_upipe3_in = (addr_upperpipe3_y < (y_upperpipe3 + pipe_height2)) && (addr_upperpipe3_y > y_upperpipe3);
 assign x_upipe4_in = (addr_upperpipe4_x < (x_upperpipe4 + pipe_width)) && (addr_upperpipe4_x > x_upperpipe4);
 assign y_upipe4_in = (addr_upperpipe4_y < (y_upperpipe4 + pipe_height3)) && (addr_upperpipe4_y > y_upperpipe4);
 
 wire upipe_in;
 assign upipe_in = (x_upipe1_in && y_upipe1_in) || (x_upipe2_in && y_upipe2_in) || (x_upipe3_in && y_upipe3_in) || (x_upipe4_in && y_upipe4_in);
 
 wire isin_square;
 assign isin_square = y_in_s && x_in_s;
 
 //wire isin_pipe;
 assign isin_pipe = lpipe1_in || upipe_in || lpipe2_in || lpipe3_in || lpipe4_in;
 
 output c_flag;
 
 collision_detection col_1(x_bird, y_bird, bird_size, pipe_width, x_lowerpipe1, x_lowerpipe2, x_lowerpipe3, x_lowerpipe4,  y_lowerpipe1, 
 y_lowerpipe2,  y_lowerpipe3,  y_lowerpipe4, upperpipe1_bottom, upperpipe2_bottom, upperpipe3_bottom, upperpipe4_bottom, c_flag);
 
 
 wire [23:0] in_square_data, in_pipe_data, game_over;
 assign in_square_data = 24'b111111111000000010101111;
 assign in_pipe_data = 24'b000000001111111100000000;
 assign game_over = 24'b0;
 wire [23:0] temp_data, temp_data2;
 wire [23:0] use_data;
 assign temp_data = isin_pipe ? in_pipe_data : bird_data_raw;
 assign temp_data2 = c_flag ? game_over : temp_data;
 assign use_data= (isin_square || isin_pipe) ? temp_data2 : bgr_data_raw;

 
//////latch valid data at falling edge;
always@(posedge VGA_CLK_n) bgr_data <= use_data;

assign b_data =  bgr_data[23:16];
assign g_data = bgr_data[15:8];
assign r_data = bgr_data[7:0];
///////////////////
//////Delay the iHD, iVD,iDEN for one clock cycle;
always@(negedge iVGA_CLK)
begin
  oHS<=cHS;
  oVS<=cVS;
  oBLANK_n<=cBLANK_n;
end

endmodule
