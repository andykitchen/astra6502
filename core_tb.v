`timescale 1ns / 10ps

module core_tb;

integer i;

reg clk = 0;

wire RW;
wire [15:0] AD;
wire [7:0]  D_in;
wire [7:0]  D_out;

wire [15:0] A;

core UUT (
	.clk   (clk),
	.RW    (RW),
	.AD    (AD),
	.D_in  (D_in),
	.D_out (D_out)
);

// only wire up the low 10-bits of AD
assign A = {6'b0, AD[9:0]};

ram test_ram (
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
		test_ram.mem[i] = 8'b0;

	// write some test data into ram
	for (i = 0; i < 8; i++)
		test_ram.mem[i] = 8'hCE;

	#1000 $finish;
end

endmodule
