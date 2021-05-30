`timescale 1ns / 10ps

module core_tb;

integer i;

reg clk = 0;

wire RW;
wire [15:0] AD;
wire [7:0]  D_in;
wire [7:0]  D_out;

wire [15:0] A;

core CPU (
	.clk   (clk),
	.RW    (RW),
	.AD    (AD),
	.D_in  (D_in),
	.D_out (D_out)
);

// only wire up the low 10-bits of AD
assign A = {6'b0, AD[9:0]};

ram RAM (
	.clk   (clk),
	.RW    (RW),
	.A     (A),
	.D_in  (D_out),
	.D_out (D_in)
);


always #5 clk = ~clk;

initial begin
	$dumpfile("core_tb.vcd");
	$dumpvars(0, core_tb);

	// zero ram
	for (i = 0; i < 1024; i++)
		RAM.mem[i] = 8'b0;

	// write some test data into ram
	RAM.mem[0] = 8'hCE; // NOP
	RAM.mem[1] = 8'hA9; // LDA #55
	RAM.mem[2] = 8'h55;
	RAM.mem[3] = 8'h69; // ADC #03
	RAM.mem[4] = 8'h03;
	RAM.mem[5] = 8'h29; // AND #F0
	RAM.mem[6] = 8'hF0;

	#1000 $finish;
end

endmodule
