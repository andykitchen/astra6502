`timescale 100ns / 1ns

module ram
#(
	parameter SIZE = 1024
)
(
	input  wire        clk,
	input  wire        RW,
	input  wire [15:0] AD,
	input  wire [7:0]  D_in,
	output reg  [7:0]  D_out
);

reg [7:0] mem [SIZE-1:0];

always @(posedge clk)
	if (RW)
		D_out  <= mem[AD[9:0]];
	else
		mem[AD[9:0]] <= D_in;

initial begin
	mem[SIZE-1] = AD[15:8];  // Stop Verilator complaining about used bits
end

endmodule
