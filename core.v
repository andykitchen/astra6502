module core
(
	input  wire        clk,
	output wire        RW,
	output wire [15:0] AD,
	input  wire [7:0]  D_in,
	output wire [7:0]  D_out
);

// program registers

reg [15:0] PC = 0;

reg  [7:0] A;
reg  [7:0] X;
reg  [7:0] Y;

reg  [7:0] S;
reg  [7:0] P;

wire [7:0] PCL = PC[7:0];
wire [7:0] PCH = PC[15:8];


// ALU

wire [7:0] ALU_A;
wire [7:0] ALU_B;
wire [7:0] ALU_C;

reg ALU_add = 0;
reg ALU_and = 0;

alu ALU (
	.A (ALU_A),
	.B (ALU_B),
	.C (ALU_C),
	.op_add (ALU_add),
	.op_and (ALU_and)
);


// stage registers (one hot)

reg fetch  = 1; // instruction fetch
reg decode = 0; // instruction decode
reg exec   = 0; // execution

wire bork  = !(fetch || decode || exec); // for debug


// control signals

reg  A_from_D   = 0; // load A from D
reg  A_from_ALU = 0; // load A from ALU

wire AD_from_PC = fetch || (decode && im_addr);
wire PC_inc     = AD_from_PC;


// decode logic

wire [7:0] op = decode ? D_in : 8'bX;

wire NOP     = (op == 8'hCE);
wire LDA_im  = (op == 8'hA9);
wire ADC_im  = (op == 8'h69);
wire AND_im  = (op == 8'h29);

wire im_addr = (op[3:0] == 4'h9 && !op[4]); // immediate addressing?


// routing logic

wire [7:0] A_mux, PC_mux, X_mux, Y_mux;

assign PC_mux =
	PC_inc ? PC+1 :
	PC;

assign RW = 1;
assign AD =
	AD_from_PC ? PC :
	16'bX;

assign A_mux =
	A_from_D   ? D_in  :
	A_from_ALU ? ALU_C :
	A;

// The following are placeholders
assign X_mux = X;
assign Y_mux = Y;

assign D_out = A;

assign ALU_A = A;
assign ALU_B = D_in;


always @(posedge clk) begin
	PC <= PC_mux;
	A  <= A_mux;
	X  <= X_mux;
	Y  <= Y_mux;

	S  <= S;
	P  <= P;

	fetch  <= 0;
	decode <= 0;
	exec   <= 0;

	A_from_D   <= 0;
	A_from_ALU <= 0;

	ALU_add    <= 0;
	ALU_and    <= 0;

	if (fetch)
		decode <= 1;

	if (decode) begin
		exec <= 1;

		if (NOP) begin
			exec  <= 0;
			fetch <= 1;
		end

		if (LDA_im)
			A_from_D <= 1;

		if (ADC_im) begin
			A_from_ALU <= 1;
			ALU_add    <= 1;
		end

		if (AND_im) begin
			A_from_ALU <= 1;
			ALU_and    <= 1;
		end
	end

	if (exec)
		fetch <= 1;
end

endmodule
