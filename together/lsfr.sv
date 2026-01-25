module lsfr #(parameter WIDTH = 14) (
	input logic clk,
	input logic en,
	output logic [13:0] prbs
);

	logic [13:0] rg;
	logic [13:0] prbs_old;
	
	initial rg = {{WIDTH-1{1'b0}}, 1'b1};
	
	
	// 1. THE SAMPLING LOGIC
    // We use 'en' to control the shifting.
    // When en = 1, it shuffles (spins).
    // When en = 0, it stops updating (freezes). THIS IS THE SAMPLE.
    always_ff @(posedge clk) begin
        if (en) begin
            rg <= {rg[12:0], rg[13]^rg[12]^rg[10]^rg[8]};
				
        end
        // If 'else' is missing, Verilog automatically holds the previous value.
    end
    
    // 2. THE OUTPUT LOGIC
    // We just perform the math on the current value of 'rg'.
    // Since 'rg' freezes when en=0, 'prbs' will also freeze automatically.
    always_comb begin
        if (rg > 14'd16000) 
            prbs = rg - 14'd384;
        else if (rg < 14'd250)
            prbs = rg + 14'd250; 
        else
            prbs = rg;
    end
endmodule	
