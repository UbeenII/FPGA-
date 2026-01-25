module processor(
	input logic [9:0] sw,
	input logic clk,
	output logic [9:0] data_out,
	input logic data_valid,
	input logic [9:0] data_in,
	output logic [6:0]hex0,hex1,hex2
		
);
logic [3:0] BCD0,BCD1,BCD2;
logic [19:0] delay;
logic [12:0] wdaddr,rdaddr;
logic [12:0] switch;
logic enable;
logic [8:0] q;
logic[9:0] y,x;

assign x = data_in - 10'd512;
assign data_out = y + 10'd512;
assign switch = {sw,3'b0};
assign delay = sw * 10'd819;
bin2bcd_16 BIN(.BCD0(BCD0),.BCD1(BCD1),.BCD2(BCD2),.x({2'b0,delay[19:10]}));
hexto7seg SEG0(.out(hex0),
							.in(BCD0)
							);
							
hexto7seg SEG1(.out(hex1),
							.in(BCD1)
							);
				
hexto7seg SEG2(.out(hex2),
							.in(BCD2)
							);
							
counter #(.WIDTH(13)) CTR13(
	.clk(~data_valid),
	.rst(0),
	.en(1),
	.count(rdaddr)
);	
assign wdaddr = switch + rdaddr;
pulse_gen  PULSE (.clk(clk), .rst(1'b0), .in(data_valid), .pulse(enable));

ram (.wren(enable),
		.rden(enable),
		.wraddress(wdaddr),
		.rdaddress(rdaddr),
		.data(y[9:1]),
		.clock(clk),
		.q(q)
	  );

	 assign y = x - {q[8], q};

endmodule		
							




