module vga_controller(iRST_n,
                      iVGA_CLK,
                      oBLANK_n,
                      oHS,
                      oVS,
                      b_data,
                      g_data,
                      r_data,
							 control);

	
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
wire [7:0] index;
wire [23:0] bgr_data_raw;
wire cBLANK_n,cHS,cVS,rst;
wire[9:0] addr_x, addr_y;
wire x_in_s, y_in_s;
reg[9:0] y_bird;
wire [9:0] x_bird;
assign x_bird = 10'b0001100100; //bird's x fixed at 100
reg [40:0] counter;
wire [9:0] acceleration;
assign acceleration = 10'b1;
reg[9:0] velocity;
//pipes

reg[9:0] x_lowerpipe1, x_lowerpipe2, x_lowerpipe3, x_lowerpipe4;
wire[9:0]  y_lowerpipe1,  y_lowerpipe2,  y_lowerpipe3,  y_lowerpipe4;
reg[9:0] x_upperpipe1, x_upperpipe2, x_upperpipe3, x_upperpipe4;
wire[9:0] y_upperpipe1, y_upperpipe2, y_upperpipe3, y_upperpipe4;

wire[18:0] addr_lowerpipe1_x, addr_lowerpipe1_y, addr_lowerpipe2_x, addr_lowerpipe2_y, addr_lowerpipe3_x, addr_lowerpipe3_y, addr_lowerpipe4_x, addr_lowerpipe4_y;
wire[18:0] addr_upperpipe1_x, addr_upperpipe1_y, addr_upperpipe2_x, addr_upperpipe2_y, addr_upperpipe3_x, addr_upperpipe3_y, addr_upperpipe4_x, addr_upperpipe4_y;

wire x_lpipe1_in, y_lpipe1_in, x_lpipe2_in, y_lpipe2_in, x_lpipe3_in, y_lpipe3_in, x_lpipe4_in, y_lpipe4_in;
wire x_upipe1_in, y_upipe1_in, x_upipe2_in, y_upipe2_in, x_upipe3_in, y_upipe3_in, x_upipe4_in, y_upipe4_in;


reg[9:0] pipe_velocity = 10'd5;
reg[9:0] pipe_gap = 10'd100;
wire[9:0] pipe_width = 10'd80;
reg[9:0] pipe_height = 10'd190;

wire[9:0] screen_height = 10'd480;

assign y_lowerpipe1 = pipe_height + pipe_gap;
assign y_lowerpipe2 = pipe_height + pipe_gap;
assign y_lowerpipe3 = pipe_height + pipe_gap;
assign y_lowerpipe4 = pipe_height + pipe_gap;

assign y_upperpipe1 = 10'd0;
assign y_upperpipe2 = 10'd0;
assign y_upperpipe3 = 10'd0;
assign y_upperpipe4 = 10'd0;

initial x_lowerpipe1 = 10'd120;
initial x_lowerpipe2 = 10'd220;
initial x_lowerpipe3 = 10'd320;
initial x_lowerpipe4 = 10'd420;

initial x_upperpipe1 = 10'd120;
initial x_upperpipe2 = 10'd220;
initial x_upperpipe3 = 10'd320;
initial x_upperpipe4 = 10'd420;



////
assign rst = ~iRST_n;
video_sync_generator LTM_ins (.vga_clk(iVGA_CLK),
                              .reset(rst),
                              .blank_n(cBLANK_n),
                              .HS(cHS),
                              .VS(cVS));

//this is our object control
always @(posedge VGA_CLK_n) begin
	counter <= counter + 1;
	if(counter >  1000000) begin
		velocity<= velocity + acceleration;
		if(control == 0) begin
			velocity <= -10'b110;
			y_bird<=y_bird+velocity;
		end
		else begin
			y_bird<=y_bird+velocity;
		end
		
		x_lowerpipe1 <= x_lowerpipe1 - pipe_velocity;
		x_lowerpipe2 <= x_lowerpipe2 - pipe_velocity;
		x_lowerpipe3 <= x_lowerpipe3 - pipe_velocity;
		x_lowerpipe4 <= x_lowerpipe4 - pipe_velocity;
		
		x_upperpipe1 <= x_upperpipe1 - pipe_velocity;
		x_upperpipe2 <= x_upperpipe2 - pipe_velocity;
		x_upperpipe3 <= x_upperpipe3 - pipe_velocity;
		x_upperpipe4 <= x_upperpipe4 - pipe_velocity;
		
		
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
 assign y_lpipe1_in = (addr_lowerpipe1_y < (y_lowerpipe1 + pipe_height)) && (addr_lowerpipe1_y > y_lowerpipe1);
 
 assign x_lpipe2_in = (addr_lowerpipe2_x < (x_lowerpipe2 + pipe_width)) && (addr_lowerpipe2_x > x_lowerpipe2);
 assign y_lpipe2_in = (addr_lowerpipe2_y < (y_lowerpipe2 + pipe_height)) && (addr_lowerpipe2_y > y_lowerpipe2);
 
 assign x_lpipe3_in = (addr_lowerpipe3_x < (x_lowerpipe3 + pipe_width)) && (addr_lowerpipe3_x > x_lowerpipe3);
 assign y_lpipe3_in = (addr_lowerpipe3_y < (y_lowerpipe3 + pipe_height)) && (addr_lowerpipe3_y > y_lowerpipe3);
 
 assign x_lpipe4_in = (addr_lowerpipe4_x < (x_lowerpipe4 + pipe_width)) && (addr_lowerpipe4_x > x_lowerpipe4);
 assign y_lpipe4_in = (addr_lowerpipe4_y < (y_lowerpipe4 + pipe_height)) && (addr_lowerpipe4_y > y_lowerpipe4);
 
 wire lpipe1_in, lpipe2_in, lpipe3_in, lpipe4_in;
 assign lpipe1_in = x_lpipe1_in && y_lpipe1_in; // && x_lpipe3_in && y_lpipe3_in && x_lpipe4_in && y_lpipe4_in;
 assign lpipe2_in = x_lpipe2_in && y_lpipe2_in;
 assign lpipe3_in = x_lpipe3_in && y_lpipe3_in;
 assign lpipe4_in = x_lpipe4_in && y_lpipe4_in;
 
 assign x_upipe1_in = (addr_upperpipe1_x < (x_upperpipe1 + pipe_width)) && (addr_upperpipe1_x > x_upperpipe1);
 assign y_upipe1_in = (addr_upperpipe1_y < (y_upperpipe1 + pipe_height)) && (addr_upperpipe1_y > y_upperpipe1);

 assign x_upipe2_in = (addr_upperpipe2_x < (x_upperpipe2 + pipe_width)) && (addr_upperpipe2_x > x_upperpipe2);
 assign y_upipe2_in = (addr_upperpipe2_y < (y_upperpipe2 + pipe_height)) && (addr_upperpipe2_y > y_upperpipe2);
 assign x_upipe3_in = (addr_upperpipe3_x < (x_upperpipe3 + pipe_width)) && (addr_upperpipe3_x > x_upperpipe3);
 assign y_upipe3_in = (addr_upperpipe3_y < (y_upperpipe3 + pipe_height)) && (addr_upperpipe3_y > y_upperpipe3);
 assign x_upipe4_in = (addr_upperpipe4_x < (x_upperpipe4 + pipe_width)) && (addr_upperpipe4_x > x_upperpipe4);
 assign y_upipe4_in = (addr_upperpipe4_y < (y_upperpipe4 + pipe_height)) && (addr_upperpipe4_y > y_upperpipe4);
 
 wire upipe_in;
 assign upipe_in = (x_upipe1_in && y_upipe1_in) || (x_upipe2_in && y_upipe2_in) || (x_upipe3_in && y_upipe3_in) || (x_upipe4_in && y_upipe4_in);
 
 wire isin_square;
 assign isin_square = y_in_s && x_in_s;
 
 //wire isin_pipe;
 assign isin_pipe = lpipe1_in || upipe_in || lpipe2_in || lpipe3_in || lpipe4_in;
 
 
 wire [23:0] in_square_data, in_pipe_data;
 assign in_square_data = 24'b111111110000000000000000;
 assign in_pipe_data = 24'b000000001111111100000000;
 wire [23:0] temp_data, temp_data2;
 wire [23:0] use_data;
 assign temp_data = isin_pipe ? in_pipe_data : in_square_data;
 //assign temp_data2 = lpipe2_in ? in_pipe_data : temp_data;
 assign use_data= (isin_square || isin_pipe) ? temp_data : bgr_data_raw;

 
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
 	















