module ram
#(
	parameter SIZE = 1024
)
(
	input  wire        clk,
	input  wire        RW,
	input  wire [15:0] A,
	input  wire [7:0]  D_in,
	output reg  [7:0]  D_out
);

reg [7:0] mem [1023:0];

always @(posedge clk)
	if (RW)
		D_out  <= mem[A];
	else
		mem[A] <= D_in;

endmodule
