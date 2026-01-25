`timescale 1ns / 100ps
module reaction #(
	parameter WIDTH=16
)(
 input logic clk,
 input logic time_out,
 input logic key,
 output logic [WIDTH- 1:0] count
 );
 
	logic running;
	
	always_ff @ (posedge clk or posedge time_out)
		if(time_out) begin
			running <= 1;
			count <= 1'b0;
		end
		else if (key) begin
			running <= 0;
		end
		else if (running) begin
			count <= count + 1;
		end
endmodule