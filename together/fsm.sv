module fsm (
	input logic clk,
	input logic tick,
	input trigger,
	input time_out,
	input logic key,
	output logic start_delay,
	output logic en_lfsr,
	output logic[15:0] reaction,
	output [9:0] ledr

); 
logic [3:0]  count;
logic [9:0] led;
typedef enum {IDLE, LED, TIMEOUT, REACTION} my_state;
my_state current_state, next_state;
	
always_comb begin
	case (current_state)
		IDLE: if(trigger) next_state = LED;
				else next_state = current_state;
		LED: if(count > 10) next_state = TIMEOUT;
				else next_state = current_state;
		TIMEOUT: if(time_out ==1) next_state = REACTION;
					 else next_state= current_state;
		REACTION: if(~key) next_state = IDLE;
						else next_state = current_state;
		default: next_state =IDLE; 
	endcase
end
	
always_ff @(posedge clk)
	current_state <= next_state;
always_ff @(posedge tick) begin
	if(next_state == LED) begin
		led <= ~(10'b1111111111>> count);
		count <= count+4'd1;
	end
	else begin
		led <= 10'b0;
		count <= 4'd0;
	end
end
	
	counter#(.WIDTH(16))(.clk(clk),.rst(rst_counter),.en(en_counter),.count(reaction));
always_comb begin
	ledr = 10'b0;
	start_delay = 1'b0;
	en_lfsr = 1'b1;
	rst_counter = 1'b0;
				en_counter = 1'b0;
	case (current_state)
		IDLE: begin
			ledr = 10'b0;
				rst_counter = 1'b0;
				en_counter = 1'b0;
				end
		LED : begin
				ledr = led;
				en_lfsr = 1'b1;
				if ( ledr == 10'b1111111111) begin
					start_delay =1;
					en_lfsr = 1'b0;
				end
				rst_counter = 1'b0;
				en_counter = 1'b0;
		end
		TIMEOUT : begin
					ledr = 10'b1111111111;
					 en_lfsr = 1'b0;
					 start_delay =0;
					 rst_counter = 1'b1;
					 en_counter = 1'b0;
		end
		REACTION: begin
						ledr = 10'b0;
						 en_lfsr = 1'b0;
						rst_counter = 1'b0;
						en_counter = 1'b1;
		end
		
		default: begin
			ledr = 10'b0;
			en_lfsr = 1'b1;
			rst_counter = 1'b0;
			en_counter = 1'b0;
		end
	endcase
end

endmodule
	