`timescale 100ns / 1ns

module alu
(
	input  wire [7:0] A,
	input  wire [7:0] B,
	output wire [7:0] C,
	input  wire op_add,
	input  wire op_and,
	input  wire op_or
);

assign C =
	op_add ? A + B :
	op_and ? A & B :
	op_or  ? A | B :
	8'b0;

endmodule
