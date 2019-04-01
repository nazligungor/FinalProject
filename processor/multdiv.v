module multdiv(data_operandA, data_operandB, ctrl_MULT, ctrl_DIV, clock, data_result, data_exception, data_resultRDY);
    input [31:0] data_operandA, data_operandB;
    input ctrl_MULT, ctrl_DIV, clock;

    output [31:0] data_result;
    output data_exception, data_resultRDY;
	 wire isMult, isDiv;
	 wire calculate_mult;
	 wire calculate_div;
	 assign calculate_mult = ctrl_MULT || (isMult && !ctrl_DIV && !isDiv);
	 assign calculate_div = ctrl_DIV || (isDiv && !ctrl_MULT && !isMult);

	 dflipflop setisMult(calculate_mult, clock, 1'b1, 1'b0, 1'b1, isMult);
	 dflipflop setisDiv(calculate_div, clock, 1'b1, 1'b0, 1'b1, isDiv);
	 
	 wire mult_ready, div_ready, mult_exception, div_exception;
	 wire [31:0] mult_result, div_result;

	 my_mult multiply(data_operandA, data_operandB, clock, ctrl_MULT, mult_result, mult_exception, mult_ready);
	 my_div divide(data_operandA, data_operandB, clock, ctrl_DIV, div_result, div_exception, div_ready);
	 
	 assign data_resultRDY = isDiv ? div_ready : mult_ready;
	 assign data_exception = isDiv ? div_exception : mult_exception;
	 assign data_result = isDiv ? div_result : mult_result;
	 
endmodule
