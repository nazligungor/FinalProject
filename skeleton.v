module skeleton(resetn, 
	ps2_clock, ps2_data, 										// ps2 related I/O
//	debug_data_in, debug_addr, leds, 						// extra debugging ports
//	lcd_data, lcd_rw, lcd_en, lcd_rs, lcd_on, lcd_blon,// LCD info
//	seg1, seg2, seg3, seg4, seg5, seg6, seg7, seg8,		// seven segements
	VGA_CLK,   														//	VGA Clock
	VGA_HS,															//	VGA H_SYNC
	VGA_VS,															//	VGA V_SYNC
	VGA_BLANK,														//	VGA BLANK
	VGA_SYNC,														//	VGA SYNC
	VGA_R,   														//	VGA Red[9:0]
	VGA_G,	 														//	VGA Green[9:0]
	VGA_B,															//	VGA Blue[9:0]
	CLOCK_50,
	control
//	address_imem,
//	reg0, reg1, reg2, reg3, reg4, reg5, reg6, reg7, reg8, reg9, reg10, reg11, reg12, reg13, reg14, reg15, reg16, reg17, reg18, reg19, reg20, reg21, reg22, reg23, reg24, reg25, reg26, reg27, reg28, reg29, reg30, reg31
//	
	);  									// 50 MHz clock
		
	////////////////////////	VGA	////////////////////////////
	output			VGA_CLK;   				//	VGA Clock
	output			VGA_HS;					//	VGA H_SYNC
	output			VGA_VS;					//	VGA V_SYNC
	output			VGA_BLANK;				//	VGA BLANK
	output			VGA_SYNC;				//	VGA SYNC
	output	[7:0]	VGA_R;   				//	VGA Red[9:0]
	output	[7:0]	VGA_G;	 				//	VGA Green[9:0]
	output	[7:0]	VGA_B;   				//	VGA Blue[9:0]
	input				CLOCK_50;
	//output         isin_pipe;
	////////////////////////	PS2	////////////////////////////
	input 			resetn,control;
	input 			ps2_data, ps2_clock;
	
	////////////////////////	LCD and Seven Segment	////////////////////////////
//	output 			   lcd_rw, lcd_en, lcd_rs, lcd_on, lcd_blon;
//	output 	[7:0] 	leds, lcd_data;
//	output 	[6:0] 	seg1, seg2, seg3, seg4, seg5, seg6, seg7, seg8;
	wire 	[31:0] 	debug_data_in;
	wire   [11:0]   debug_addr;
	
	wire			 clock;
	wire			 lcd_write_en;
	wire 	[31:0] lcd_write_data;
	wire	[7:0]	 ps2_key_data;
	wire			 ps2_key_pressed;
	wire	[7:0]	 ps2_out;	
	//reg          x,y;
	
	// clock divider (by 5, i.e., 10 MHz)
	pll div(CLOCK_50,inclock);
	assign clock = CLOCK_50;
	
	// UNCOMMENT FOLLOWING LINE AND COMMENT ABOVE LINE TO RUN AT 50 MHz
	//assign clock = inclock;
	
	// your processor
	wire [11:0] address_imem;
   wire [31:0] q_imem;
    imem my_imem(
        .address    (address_imem),            // address of data
        .clock      (clock),                  // you may need to invert the clock
        .q          (q_imem)                   // the raw instruction
    );

    /** DMEM **/
    // Figure out how to generate a Quartus syncram component and commit the generated verilog file.
    // Make sure you configure it correctly!
    wire [11:0] address_dmem;
    wire [31:0] data;
    wire wren;
    wire [31:0] q_dmem;
    dmem my_dmem(
        .address    (address_dmem),       // address of data
        .clock      (CLOCK_50),                  // may need to invert the clock
        .data	    (data),    // data you want to write
        .wren	    (wren),      // write enable
        .q          (q_dmem)    // data from dmem
    );

    /** REGFILE **/
    // Instantiate your regfile
    wire ctrl_writeEnable;
    wire [4:0] ctrl_writeReg;
	 wire [4:0] ctrl_readRegA, ctrl_readRegB;
    wire [31:0] data_writeReg;
    wire [31:0] data_readRegA, data_readRegB;
	 /* register information:\
	 question --> store velocity in a register or just determine which register to read from based on 
	 reg1: nop counter max
	 reg2: button pressed
	 reg3: collision flag
	 reg4: counter
	 reg5: bird y
	 reg6: bird velocity
	 reg7: lowerpipe1
	 reg8: lowerpipe2
	 reg9: lowerpipe3
	 reg10: lowerpipe4
	 reg11: upperpipe1
	 reg12: upperpipe2
	 reg13: upperpipe3
	 reg14: upperpipe
	 reg15: pipe_x_vel
	 reg29: reset
	 reg30: c_flag
	 reg31: control
	 */
	 wire [31:0] reg0, reg1, reg2, reg3, reg4, reg5, reg6, reg7, reg8, reg9, reg10, reg11, reg12, reg13, reg14, reg15, reg16, reg17, reg18, reg19, reg20, reg21, reg22, reg23, reg24, reg25, reg26, reg27, reg28, reg29, reg30, reg31;
	 wire c_flag;
    regfile my_regfile(
        clock,
        ctrl_writeEnable,
        ctrl_reset,
        ctrl_writeReg,
        ctrl_readRegA,
        ctrl_readRegB,
        data_writeReg,
        data_readRegA,
        data_readRegB,
		  reg0, reg1, reg2, reg3, reg4, reg5, reg6, reg7, reg8, reg9, reg10, reg11, reg12, reg13, reg14, reg15, reg16, reg17, reg18, reg19, reg20, reg21, reg22, reg23, reg24, reg25, reg26, reg27, reg28, reg29, reg30, reg31, 
		  control,
		  c_flag,
		  resetn
    );
	 
    /** PROCESSOR **/
    processor my_processor(
        // Control signals
        ~clock,                          // I: The master clock
        1'b0,                          // I: A reset signal

        // Imem
        address_imem,                   // O: The address of the data to get from imem
        q_imem,                         // I: The data from imem

        // Dmem
        address_dmem,                   // O: The address of the data to get or put from/to dmem
        data,                           // O: The data to write to dmem
        wren,                           // O: Write enable for dmem
        q_dmem,                         // I: The data from dmem

        // Regfile
        ctrl_writeEnable,               // O: Write enable for regfile
        ctrl_writeReg,                  // O: Register to write to in regfile
        ctrl_readRegA,                  // O: Register to read from port A of regfile
        ctrl_readRegB,                  // O: Register to read from port B of regfile
        data_writeReg,                  // O: Data to write to for regfile
        data_readRegA,                  // I: Data from port A of regfile
        data_readRegB                   // I: Data from port B of regfile
    );
	
	// keyboard controller
	PS2_Interface myps2(clock, resetn, ps2_clock, ps2_data, ps2_key_data, ps2_key_pressed, ps2_out);
	
	// lcd controller
	lcd mylcd(clock, ~resetn, 1'b1, ps2_out, lcd_data, lcd_rw, lcd_en, lcd_rs, lcd_on, lcd_blon);
	
//	// example for sending ps2 data to the first two seven segment displays
//	Hexadecimal_To_Seven_Segment hex1(ps2_out[3:0], seg1);
//	Hexadecimal_To_Seven_Segment hex2(ps2_out[7:4], seg2);
//	
//	// the other seven segment displays are currently set to 0
//	Hexadecimal_To_Seven_Segment hex3(4'b0, seg3);
//	Hexadecimal_To_Seven_Segment hex4(4'b0, seg4);
//	Hexadecimal_To_Seven_Segment hex5(4'b0, seg5);
//	Hexadecimal_To_Seven_Segment hex6(4'b0, seg6);
//	Hexadecimal_To_Seven_Segment hex7(4'b0, seg7);
//	Hexadecimal_To_Seven_Segment hex8(4'b0, seg8);
	
	// some LEDs that you could use for debugging if you wanted
//	assign leds = 8'b00101011;
	 
	// VGA
	Reset_Delay			r0	(.iCLK(CLOCK_50),.oRESET(DLY_RST)	);
	VGA_Audio_PLL 		p1	(.areset(~DLY_RST),.inclk0(CLOCK_50),.c0(VGA_CTRL_CLK),.c1(AUD_CTRL_CLK),.c2(VGA_CLK)	);
	vga_controller vga_ins(.iRST_n(DLY_RST),
								 .iVGA_CLK(VGA_CLK),
								 .oBLANK_n(VGA_BLANK),
								 .oHS(VGA_HS),
								 .oVS(VGA_VS),
								 .b_data(VGA_B),
								 .g_data(VGA_G),
								 .r_data(VGA_R),
								 .control(control),
								 .y_bird(reg5),
								 .x_lowerpipe1(reg7),
								 .x_lowerpipe2(reg8),
								 .x_lowerpipe3(reg9),
								 .x_lowerpipe4(reg10),
								 .x_upperpipe1(reg11),
								 .x_upperpipe2(reg12),
								 .x_upperpipe3(reg13),
								 .x_upperpipe4(reg14),
								 .c_flag(c_flag),
								 .screen_state(reg28)
								 );
	
endmodule








/**
 * NOTE: you should not need to change this file! This file will be swapped out for a grading
 * "skeleton" for testing. We will also remove your imem and dmem file.
 *
 * NOTE: skeleton should be your top-level module!
 *
 * This skeleton file serves as a wrapper around the processor to provide certain control signals
 * and interfaces to memory elements. This structure allows for easier testing, as it is easier to
 * inspect which signals the processor tries to assert when.
 */