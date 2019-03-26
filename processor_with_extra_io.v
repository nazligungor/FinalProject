/**
 * READ THIS DESCRIPTION!
 *
 * The processor takes in several inputs from a skeleton file.
 *
 * Inputs
 * clock: this is the clock for your processor at 50 MHz
 * reset: we should be able to assert a reset to start your pc from 0 (sync or
 * async is fine)
 *
 * Imem: input data from imem
 * Dmem: input data from dmem
 * Regfile: input data from regfile
 *
 * Outputs
 * Imem: output control signals to interface with imem
 * Dmem: output control signals and data to interface with dmem
 * Regfile: output control signals and data to interface with regfile
 *
 * Notes
 *
 * Ultimately, your processor will be tested by subsituting a master skeleton, imem, dmem, so the
 * testbench can see which controls signal you active when. Therefore, there needs to be a way to
 * "inject" imem, dmem, and regfile interfaces from some external controller module. The skeleton
 * file acts as a small wrapper around your processor for this purpose.
 *
 * You will need to figure out how to instantiate two memory elements, called
 * "syncram," in Quartus: one for imem and one for dmem. Each should take in a
 * 12-bit address and allow for storing a 32-bit value at each address. Each
 * should have a single clock.
 *
 * Each memory element should have a corresponding .mif file that initializes
 * the memory element to certain value on start up. These should be named
 * imem.mif and dmem.mif respectively.
 *
 * Importantly, these .mif files should be placed at the top level, i.e. there
 * should be an imem.mif and a dmem.mif at the same level as process.v. You
 * should figure out how to point your generated imem.v and dmem.v files at
 * these MIF files.
 *
 * imem
 * Inputs:  12-bit address, 1-bit clock enable, and a clock
 * Outputs: 32-bit instruction
 *
 * dmem
 * Inputs:  12-bit address, 1-bit clock, 32-bit data, 1-bit write enable
 * Outputs: 32-bit data at the given address
 *
 */
module processor_with_extra_io(
    // Control signals
    clock,                          // I: The master clock
    reset,                          // I: A reset signal

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
    data_readRegB,                  // I: Data from port B of regfile
	 rd_d, rd_x, rd_m, rd_w, 
	 data_a_x, data_b_x, data_o_x,
	 data_bx_x, data_o_m, data_b_m, data_o_w, data_d_w
	 
);
    // Control signals
    input clock, reset;

    // Imem
    output [11:0] address_imem;
    input [31:0] q_imem;

    // Dmem
    output [11:0] address_dmem;
    output [31:0] data;
    output wren;
    input [31:0] q_dmem;

    // Regfile
    output ctrl_writeEnable;
    output [4:0] ctrl_writeReg, ctrl_readRegA, ctrl_readRegB;
    output [31:0] data_writeReg;
    input [31:0] data_readRegA, data_readRegB;
	 
	 //stall logic
	 wire hazard;
	 assign hazard = 1'b0; //for now, will determine these later
	 
	 //PC
	 wire [11:0] next_pc; //will be calculated depending on whether or not there is a jump, for now will just be determined by fetch
	 assign next_pc = pc_mux_select ? next_pc_j_x : next_pc_f;
	 wire [11:0] curr_pc; //output of the PC register
	 pc program_counter(.in(next_pc), .clock(~clock), .clr(reset), .hazard(hazard), .out(curr_pc));
	 
	 //fetch stage
	 wire [11:0] next_pc_f;
	 fetch_stage fetch(.curr_pc(curr_pc), .clock(~clock), .reset(reset), .next_pc_f(next_pc_f), .address_imem(address_imem));
	 
	 
	 //f/d latch
	 wire [31:0] instr_data;
	 wire [11:0] next_pc_d;
	 fd_latch(.next_pc_f(next_pc_f), .reset(reset), .q_imem(q_imem), .clock(~clock), .hazard(hazard), .next_pc_d(next_pc_d), .instr_data(instr_data));
	 
	 //decode stage
	wire [4:0] opcode_d, shamt_d, alu_op_d;
	output [4:0] rd_d;
	wire [26:0] target_d;
	wire [16:0] immediate_d;
				//types
	wire isR_d, isI_d, isJI_d, isJII_d,isAdd_d, isAddi_d, isSub_d, isMul_d, isDiv_d, isSW_d, isLW_d, isJ_d, isBNE_d, isJAL_d, isBLT_d, isBex_d, isSetx_d;

	 decode_stage decode(.instr_data(instr_data), .opcode(opcode_d), .rd_d(rd_d), .rs(ctrl_readRegA), .rt(ctrl_readRegB), .shamt(shamt_d), .alu_op(alu_op_d), .immediate(immediate_d), .target(target_d), .isR(isR_d), .isI(isI_d), .isJI(isJI_d), .isJII(isJII_d),.isAdd(isAdd_d), .isAddi(isAddi_d), .isSub(isSub_d), .isMul(isMul_d), .isDiv(isDiv_d), .isSW(isSW_d), .isLW(isLW_d), .isJ(isJ_d), .isBNE(isBNE_d), .isJAL(isJAL_d), .isBLT(isBLT_d), .isBex(isBex_d), .isSetx(isSetx_d));
	 
	 //d/x latch, will need to put bypassing and stall logic here.
	wire [11:0] next_pc_x;
	wire [4:0] opcode_x, shamt_x, alu_op_x;
	output [4:0] rd_x;
	wire [26:0] target_x;
	wire [16:0] immediate_x;
	output [31:0] data_b_x, data_a_x;

	wire isR_x, isI_x, isJI_x, isJII_x,isAdd_x, isAddi_x, isSub_x, isMul_x, isDiv_x, isSW_x, isLW_x, isJ_x, isBNE_x, isJAL_x, isBLT_x, isBex_x, isSetx_x;
	
	dx_latch dx(
		.clock(~clock),
		.reset(reset),
		.next_pc_d(next_pc_d),
		.data_a_d(data_readRegA),
		.data_b_d(data_readRegB),
		.rd_d(rd_d),
		.opcode_d(opcode_d),
		.shamt_d(shamt_d),
		.alu_op_d(alu_op_d),
		.target_d(target_d),
		.immediate_d(immediate_d),
		.isR_d(isR_d),
		.isI_d(isI_d),
		.isJI_d(isJI_d),
		.isJII_d(isJII_d),
		.isAdd_d(isAdd_d),
		.isAddi_d(isAddi_d),
		.isSub_d(isSub_d),
		.isMul_d(isMul_d),
		.isDiv_d(isDiv_d),
		.isSW_d(isSW_d),
		.isLW_d(isLW_d),
		.isJ_d(isJ_d),
		.isBNE_d(isBNE_d),
		.isJAL_d(isJAL_d),
		.isBLT_d(isBLT_d),
		.isBex_d(isBex_d),
		.isSetx_d(isSetx_d),
				//outputs
		.next_pc_x(next_pc_x),
		.data_a_x(data_a_x),
		.data_b_x(data_b_x),
		.rd_x(rd_x),
		.opcode_x(opcode_x),
		.shamt_x(shamt_x),
		.alu_op_x(alu_op_x),
		.target_x(target_x),
		.immediate_x(immediate_x),
		.isR_x(isR_x),
		.isI_x(isI_x),
		.isJI_x(isJI_x),
		.isJII_x(isJII_x),
		.isAdd_x(isAdd_x),
		.isAddi_x(isAddi_x),
		.isSub_x(isSub_x),
		.isMul_x(isMul_x),
		.isDiv_x(isDiv_x),
		.isSW_x(isSW_x),
		.isLW_x(isLW_x),
		.isJ_x(isJ_x),
		.isBNE_x(isBNE_x),
		.isJAL_x(isJAL_x),
		.isBLT_x(isBLT_x),
		.isBex_x(isBex_x),
		.isSetx_x(isSetx_x)
		);
				
	//execute stage
	output [31:0] data_o_x;
	output [31:0] data_bx_x;
	wire exception_x, pc_mux_select;
	wire next_pc_j_x;
	
	execute_stage execute(.data_a(data_a_x), .data_b(data_b_x), .alu_op(alu_op_x), .shamt(shamt_x), .target(target_x), .next_pc(next_pc_x), .immediate(immediate_x),.isR(isR_x), .isI(isI_x), .isJI(isJI_x), .isJII(isJII_x),.isAdd(isAdd_x), .isAddi(isAddi_x), .isSub(isSub_x), .isMul(isMul_x), .isDiv(isDiv_x), .isSW(isSW_x), .isLW(isLW_x), .isJ(isJ_x), .isBNE(isBNE_x), .isJAL(isJAL_x), .isBLT(isBLT_x), .isBex(isBex_x), .isSetx(isSetx_x), .data_o_x(data_o_x), .data_b_x(data_bx_x), .exception(exception_x), .pc_mux_select(pc_mux_select), .next_pc_j_x(next_pc_j_x));

   //xm latch
	output [31:0] data_o_m, data_b_m;
	output [4:0] rd_m;
	wire isLW_m, isSW_m, isR_m, isAddi_m;
	xm_latch xm(~clock, reset, data_o_x, data_bx_x, rd_x, isLW_x, isSW_x,isR_x, isAddi_x, data_o_m, data_b_m, rd_m, isLW_m, isSW_m, isR_m, isAddi_m);
	
	//memory stage
	memory_stage memory(.data_o(data_o_m), .data_b(data_b_m), .isLW(isLW_m), .isSW(isSW_m),.address_dmem(address_dmem),.data_mem(data), .wren(wren));
	
	//mw latch
	output [31:0] data_o_w, data_d_w;
	output [4:0] rd_w;
	wire isLW_w, isR_w, isAddi_w;
	mw_latch mw(.clock(~clock), .reset(reset), .data_o_m(data_o_m), .data_d_m(q_dmem), .rd_m(rd_m), .isLW_m(isLW_m), .isR_m(isR_m), .data_o_w(data_o_w), .data_d_w(data_d_w), .rd_w(rd_w), .isLW_w(isLW_w), .isR_w(isR_w), .isAddi_m(isAddi_m), .isAddi_w(isAddi_w));
	
	//writeback stage
	writeback_stage writeback(data_o_w, data_d_w, isLW_w, isR_w, isAddi_w, rd_w, ctrl_writeEnable, ctrl_writeReg, data_writeReg);
	

endmodule
