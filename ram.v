module ram
#(
	parameter SIZE = 1024
)
(
	input  wire        clk,
	input  wire        RW,
// only wire up the low 10-bits of AD
	input  wire [9:0]  A,
	input  wire [7:0]  D_in,
	output reg  [7:0]  D_out
);

reg [7:0] mem [SIZE-1:0];

always @(posedge clk)
	if (RW)
		D_out  <= mem[A];
	else
		mem[A] <= D_in;

endmodule
