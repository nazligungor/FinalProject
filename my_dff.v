module my_dff(data, clock, enable, clear, q);
	input data, clock, enable, clear;
	output q;
	reg q;
	
	initial begin
		q = 1'b0;
	end
	
	always @(posedge clock or posedge clear) begin
		if(clear) begin
			q = 1'b0;
		end
		else if(enable) begin
			q = data;
		end
	end
endmodule
