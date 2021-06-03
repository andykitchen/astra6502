`timescale 100ns / 1ns

module core_tb(input clk);

integer i;

// reg clk = 0;

wire RW;
wire [15:0] AD;
wire [7:0]  D_in;
wire [7:0]  D_out;

core CPU (
	.clk   (clk),
	.RW    (RW),
	.AD    (AD),
	.D_in  (D_in),
	.D_out (D_out)
);

ram RAM (
	.clk   (clk),
	.RW    (RW),
	.AD    (AD),
	.D_in  (D_out),
	.D_out (D_in)
);


// always clk = ~clk;

initial begin
	$dumpfile("core_tb.vcd");
	$dumpvars(0, core_tb);

	// zero ram
	for (i = 0; i < 1024; i++)
		RAM.mem[i] = 8'b0;

	// write some test data into ram
	RAM.mem[0] = 8'hEA; // NOP
	RAM.mem[1] = 8'hA9; // LDA #55
	RAM.mem[2] = 8'h55;
	RAM.mem[3] = 8'h69; // ADC #03
	RAM.mem[4] = 8'h03;
	RAM.mem[5] = 8'h29; // AND #F0
	RAM.mem[6] = 8'hF0;
	RAM.mem[7] = 8'h09; // ORA #05
	RAM.mem[8] = 8'h05;
end

endmodule
