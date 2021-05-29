module core
(
	input  wire        clk,
	output wire        RW,
	output reg  [15:0] AD,
	input  wire [7:0]  D_in,
	output wire [7:0]  D_out
);

reg [15:0] PC = 0;

reg  [7:0] A;
reg  [7:0] X;
reg  [7:0] Y;

wire [7:0] PCL = PC[7:0];
wire [7:0] PCH = PC[15:8];

wire [7:0] ADL = AD[7:0];
wire [7:0] ADH = AD[15:8];

reg D_rdy = 0;

always @(posedge clk) begin
	AD    <= PC;
	D_rdy <= 1;
	PC    <= PC+1;
end

endmodule
