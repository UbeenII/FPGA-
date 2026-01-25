module delay (
	input logic [13:0] N,
	input logic trigger,
	input logic clk,
	output logic time_out,
	output [13:0] cnt
);		
		logic [13:0] count;

		always_ff @ (posedge clk) begin
				if (trigger) count <=  N;
				else begin
					count <= count - 1;
					if (count == 13'b0) time_out <= 1'b1;
					else time_out <= 1'b0;
				end

		end
			
	
endmodule