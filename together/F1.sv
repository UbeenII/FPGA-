module F1 (
	input logic[0:1] KEY,
	input  logic  MAX10_CLK1_50,
	output logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4,
	output logic [3:0] BCD0, BCD1, BCD2, BCD3, BCD4,
	output logic [9:0] LEDR,
	input logic[9:0] SW
);

logic  tick_ms, tick_halfs;
logic[13:0] prbs;
logic[13:0] postcount;
logic[15:0] count;
logic time_out, start_delay, ledr, en;
logic[15:0] reaction;


clktick ms(.clk(MAX10_CLK1_50),	
					.rst(1'b0),	
					.en(1'b1),
					.N(16'd50000),
					.tick(tick_ms)
					);
					
clktick halfs(.clk(MAX10_CLK1_50),	
					.rst(1'b0),	
					.en(tick_ms),
					.N(16'd500),
					.tick(tick_halfs)
					);

fsm(.clk(tick_ms),
		.tick(tick_halfs),
		.trigger(~KEY[1]),
		.time_out(time_out),
		.en_lfsr(en),
		.start_delay(start_delay),
		.ledr(LEDR),
		.key(KEY[0]),
		.reaction(reaction)
		);



lsfr (
.clk(tick_ms),
.en(en),
.prbs(prbs) 
);

delay (
.clk(tick_ms),
.trigger(start_delay),
.N(prbs),
.time_out(time_out),

);


bin2bcd_16 BIN(.BCD0(BCD0),
							.BCD1(BCD1),
							.BCD2(BCD2),
							.BCD3(BCD3),
							.BCD4(BCD4),
							.x(reaction)
							); 

		hexto7seg SEG0(.out(HEX0),
							.in(BCD0)
							);
							
		hexto7seg SEG1(.out(HEX1),
							.in(BCD1)
							);
				
		hexto7seg SEG2(.out(HEX2),
							.in(BCD2)
							);
					
			
		hexto7seg SEG3(.out(HEX3),
							.in(BCD3)
							);	
							
		hexto7seg SEG4(.out(HEX4),
							.in(BCD4)
							);
		

endmodule
