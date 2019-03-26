module vga_controller(iRST_n,
                      iVGA_CLK,
                      oBLANK_n,
                      oHS,
                      oVS,
                      b_data,
                      g_data,
                      r_data,
							 north,
							 south,
							 east,
							 west);

	
input iRST_n, north,south,east,west;
input iVGA_CLK;
output reg oBLANK_n;
output reg oHS;
output reg oVS;
output [7:0] b_data;
output [7:0] g_data;  
output [7:0] r_data;                        
///////// ////                     
reg [18:0] ADDR;
reg [23:0] bgr_data;
wire VGA_CLK_n;
wire [7:0] index;
wire [23:0] bgr_data_raw;
wire cBLANK_n,cHS,cVS,rst;
wire[9:0] addr_x, addr_y;
wire x_in_s, y_in_s;
reg[9:0] x,y;
reg [40:0] counter;
////
assign rst = ~iRST_n;
video_sync_generator LTM_ins (.vga_clk(iVGA_CLK),
                              .reset(rst),
                              .blank_n(cBLANK_n),
                              .HS(cHS),
                              .VS(cVS));

//initial begin
//	x = 10'b0;
//	y = 10'b0;
//	counter = 41'b0;
//end

always @(posedge VGA_CLK_n) begin
	counter <= counter + 1;
	if(counter >  1000000) begin
		if(north == 1) begin
			y<=y+10'b1;
		end
		else if (south == 1) begin
			y<=y-10'b1;
		end
		else if (east== 1) begin
			x<=x+10'b1;
		end
		else if (west== 1) begin
			x<=x-10'b1;
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
 assign addr_x = ADDR % 640;
 assign addr_y = ADDR/640;
 assign y_in_s = (addr_y < (y + 160)) && (addr_y > y);
 assign x_in_s = (addr_x < (x + 160)) && (addr_x > x);
wire isin;
 assign isin = y_in_s && x_in_s;
 
 wire [23:0] in_square_data;
 assign in_square_data = 24'b111111110000000000000000;
 wire [23:0] use_data;
 assign use_data = isin ? in_square_data : bgr_data_raw;
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
 	















