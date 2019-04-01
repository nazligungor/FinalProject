module mult_control(first, control, iter_in, op, shift, act, iter_out, done);
	input first;
	input [2:0] control;
	input[3:0] iter_in;
	output op, act, shift, done;
	output [3:0] iter_out;

	wire ctrl_2_not, ctrl_1_not, ctrl_0_not, actand1, actand2, actor1;
	not n2(ctrl_2_not, control[2]);
	not n1(ctrl_1_not, control[1]);
	not n0(ctrl_0_not, control[0]);
	
	wire rca_cout;
	//iterate the iter by 1 (start from 0, go to 16), if iter_in is 16, set to be done
	my_rca increment(iter_in, 4'b1, 1'b0, rca_cout, iter_out);
	assign done = ~iter_in[3] && ~iter_in[2] && ~iter_in[1] && ~iter_in[0];
	
	//calculate act
	and and1(actand1, ctrl_2_not, ctrl_1_not, ctrl_0_not);
	and and2(actand2, control[2], control[1], control[0]);
	
	or or1(actor1, actand1, actand2);
	not final(act, actor1);
	
	//calculate shift
	wire shiftand1, shiftand2;
	and sand1(shiftand1, control[2], ctrl_1_not, ctrl_0_not);
	and sand2(shiftand2, ctrl_2_not, control[1], control[0]);
	or finalor(shift, shiftand1, shiftand2);
	
	//calculate op
	assign op = control[2];
	
endmodule


	