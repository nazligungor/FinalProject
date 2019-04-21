
module DE2_Audio(
	// Inputs
	CLOCK_50,
	CLOCK_27,
	KEY,
	c_flag,
	screen_state,

	AUD_ADCDAT,

	// Bidirectionals
	AUD_BCLK,
	AUD_ADCLRCK,
	AUD_DACLRCK,

	I2C_SDAT,

	// Outputs
	AUD_XCK,
	AUD_DACDAT,

	I2C_SCLK,
	SW
);

/*****************************************************************************
 *                           Parameter Declarations                          *
 *****************************************************************************/


/*****************************************************************************
 *                             Port Declarations                             *
 *****************************************************************************/
// Inputs
input				CLOCK_50;
input				CLOCK_27;
input		[3:0]	KEY;
input		[3:0]	SW;
input		[2:0]		c_flag;
input		[1:0]    screen_state;

input				AUD_ADCDAT;

// Bidirectionals
inout				AUD_BCLK;
inout				AUD_ADCLRCK;
inout				AUD_DACLRCK;

inout				I2C_SDAT;

// Outputs
output				AUD_XCK;
output				AUD_DACDAT;

output				I2C_SCLK;

/*****************************************************************************
 *                 Internal Wires and Registers Declarations                 *
 *****************************************************************************/
// Internal Wires
wire				audio_in_available;
wire		[31:0]	left_channel_audio_in;
wire		[31:0]	right_channel_audio_in;
wire				read_audio_in;

wire				audio_out_allowed;
wire		[31:0]	left_channel_audio_out;
wire		[31:0]	right_channel_audio_out;
wire				write_audio_out;

// Internal Registers

// State Machine Registers

/*****************************************************************************
 *                         Finite State Machine(s)                           *
 *****************************************************************************/
 
 /*****************************************************************************
 *                         LAB 6 SOUNDS GO HERE                               *
 *****************************************************************************/
                                                                                                                                     
 
 /*****************************************************************************
 *                         LAB 6 SOUNDS END HERE                              *
 *****************************************************************************/
reg [31:0] temp_add, counter;
wire [31:0] data, q_out;

always @(posedge CLOCK_50)begin
	if(counter == 32'd44000000 ) begin
		counter <= 32'b0;
		temp_add <= temp_add + 1;
	end
		counter <= counter + 1;
end

audio_rom audio_inst(temp_add, CLOCK_50, q_out); 

assign audio_in_available = (c_flag != 3'b0)  ? 1'b1 : 'bz;
assign audio_out_allowed = (c_flag != 3'b0) ? 1'b1 : 'bz;

//assign left_channel_audio_in = q_out;
//assign right_channel_audio_in = q_out;

assign read_audio_in			= (c_flag != 3'b0)  ? 1'b1 : 'bz; //audio_in_available & audio_out_allowed;

wire [31:0] left_in, right_in, left_out, right_out;
assign left_out = q_out;
assign right_out = q_out;


assign left_channel_audio_out	= left_out;
assign right_channel_audio_out	= right_out;
assign write_audio_out			= (c_flag != 3'b0) ? 1'b1 : 'bz;//audio_in_available & audio_out_allowed;

/*****************************************************************************
 *                              Internal Modules                             *
 *****************************************************************************/

Audio_Controller Audio_Controller (
	// Inputs
	.CLOCK_50						(CLOCK_50),
	.reset						(~KEY[0]),

	.clear_audio_in_memory		(),
	.read_audio_in				(read_audio_in),
	
	.clear_audio_out_memory		(),
	.left_channel_audio_out		(left_channel_audio_out),
	.right_channel_audio_out	(right_channel_audio_out),
	.write_audio_out			(write_audio_out),

	.AUD_ADCDAT					(AUD_ADCDAT),

	// Bidirectionals
	.AUD_BCLK					(AUD_BCLK),
	.AUD_ADCLRCK				(AUD_ADCLRCK),
	.AUD_DACLRCK				(AUD_DACLRCK),


	// Outputs
	.audio_in_available			(audio_in_available),
	.left_channel_audio_in		(left_channel_audio_in),
	.right_channel_audio_in		(right_channel_audio_in),

	.audio_out_allowed			(audio_out_allowed),

	.AUD_XCK					(AUD_XCK),
	.AUD_DACDAT					(AUD_DACDAT),

);

avconf #(.USE_MIC_INPUT(1)) avc (
	.I2C_SCLK					(I2C_SCLK),
	.I2C_SDAT					(I2C_SDAT),
	.CLOCK_50					(CLOCK_50),
	.reset						(~KEY[0]),
	.key1							(KEY[1]),
	.key2							(KEY[2])
);

endmodule

