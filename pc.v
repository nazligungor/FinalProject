module pc(in, clock, clr, hazard, out);
	//in will be the input address, clear is reset, stall will determine enable and out will be the pc address
	input clock, clr, hazard;
	input [11:0] in;
	output [11:0] out;
	wire enable = ~hazard;
	dflipflop pcreg [11:0] (in, clock, ~clr, 1'b1, enable, out);

endmodule
