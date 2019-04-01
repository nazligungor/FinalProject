module alu(data_operandA, data_operandB, ctrl_ALUopcode, ctrl_shiftamt, data_result, isNotEqual, isLessThan, overflow);

	input [31:0] data_operandA, data_operandB;
	input [4:0] ctrl_ALUopcode, ctrl_shiftamt;
	output [31:0] data_result;
	output isNotEqual, isLessThan, overflow;

	wire [5:0] decoded;
	wire [31:0] subout, addout, andout, orout, sllout, sraout;
	wire addcout, subcout, addof, subof;
	my_decoder decode1(ctrl_ALUopcode, decoded);
	my_adder add1(data_operandA, data_operandB, 1'b0, addout, addcout, addof);
	my_subtract sub1(data_operandA, data_operandB, subcout, subout, subof);
	bitwise_and and1(data_operandA, data_operandB, andout);
	bitwise_or or1(data_operandA, data_operandB, orout);
	my_left_shifter sll1(data_operandA, ctrl_shiftamt, sllout);
	my_right_shifter sra(data_operandA, ctrl_shiftamt, sraout);
	
	my_tristate triadd(addout, decoded[0], data_result);
	my_tristate trisub(subout, decoded[1], data_result);

	my_tristate triand1(andout, decoded[2], data_result);
	my_tristate trior1(orout, decoded[3], data_result);
	my_tristate trisll(sllout, decoded[4], data_result);
	my_tristate trisra(sraout, decoded[5], data_result);
	 
	assign overflow = decoded[1] ? subof : addof;
	
	wire [31:0] notsubbout;
	genvar c;
	generate
		for(c = 0; c < 32; c = c +1) begin: loop1
			not(notsubbout[c], subout[c]);
		end
	endgenerate
	
	wire notof, notequal, notMSB;
	not(notof, overflow);
	not(notMSB, subout[31]);
	
	nand checkequal(isNotEqual, notsubbout[0], notsubbout[1], notsubbout[2], notsubbout[3], notsubbout[4], notsubbout[5], notsubbout[6], notsubbout[7], notsubbout[8], notsubbout[9], notsubbout[10], notsubbout[11], notsubbout[12], notsubbout[13], notsubbout[14], notsubbout[15], notsubbout[16], notsubbout[17], notsubbout[18], notsubbout[19], notsubbout[20], notsubbout[21], notsubbout[22], notsubbout[23], notsubbout[24], notsubbout[25], notsubbout[26], notsubbout[27], notsubbout[28], notsubbout[29], notsubbout[30], notsubbout[31]);
	wire opt1, opt2;
	
	and lessThan(opt1, subout[31], 1'b1, notof); 
	and lessThan2(opt2, notMSB, 1'b1, overflow);
	or finalor(isLessThan, opt1, opt2);
	
	


endmodule
