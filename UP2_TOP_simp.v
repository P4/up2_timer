module UP2_TOP
(
	MCLK,
	
	//...
	
	BT,
	
	DISP1, DISP1_DP,
	DISP2, DISP2_DP,
	DISP3, DISP3_DP,
	DISP4, DISP4_DP,
	
	//...
);

/*
	==== interface description ====
*/

input MCLK;	//main clock input

//...

input [3:0] BT;

output [6:0] DISP1; output DISP1_DP;
output [6:0] DISP2; output DISP2_DP;
output [6:0] DISP3; output DISP3_DP;
output [6:0] DISP4; output DISP4_DP;

//...

/*
	==== functionality ====
*/

//...

// === Buttons ===
// --- mapping controls ---
wire RESET, START_STOP, ADD_SEC, ADD_MIN;
// --- debouncing ---
debouncer d0 ( MCLK, BT[0], START_STOP );
debouncer d1 ( MCLK, BT[1], RESET );
debouncer d2 ( MCLK, BT[2], ADD_SEC );
debouncer d3 ( MCLK, BT[3], ADD_MIN );

// === 1Hz clock ===
wire CLK_SEC; 
clock_sec CLOCK_SEC (MCLK, CLK_SEC);

//control wires
/*t_ff Toggle (
	.clk(START_STOP),
	.clr(END),
	.out(ENABLE)
	);
*/
wire ENABLE, END, ENDED;
// low when counting ends
assign END = ~ENABLE | |{SEC_0_OUT,SEC_1_OUT,MIN_0_OUT,MIN_1_OUT};

// mode switch
mode Mode (
	.btn(START_STOP),
	.end_(END),
	.running(ENABLE),
	.ended(ENDED),
);

wire ADD_1_SEC, ADD_10_SEC, SUB_1_SEC, SUB_10_SEC;
wire ADD_1_MIN, ADD_10_MIN, SUB_1_MIN, SUB_10_MIN;
// can increment only while stopped
// keep high while running
assign ADD_1_SEC = ENABLE | ADD_SEC;
assign ADD_1_MIN = ENABLE | ADD_MIN;
// can reset only while stopped
// keep high while running
assign RST = ENABLE | RESET;
// cut off clock while stopped
assign SUB_1_SEC = ~ENABLE | CLK_SEC;

// === Timer outputs ===
// BCD, decoded to 7 segment display
wire [2:0] MIN_1_OUT; wire [6:0] MIN_1_SEG; bcd_to_7seg Dec_MIN_1 ({1'b0,MIN_1_OUT}, MIN_1_SEG);
wire [3:0] MIN_0_OUT; wire [6:0] MIN_0_SEG; bcd_to_7seg Dec_MIN_0 (MIN_0_OUT, MIN_0_SEG);
wire [2:0] SEC_1_OUT; wire [6:0] SEC_1_SEG; bcd_to_7seg Dec_SEC_1 ({1'b0,SEC_1_OUT}, SEC_1_SEG);
wire [3:0] SEC_0_OUT; wire [6:0] SEC_0_SEG; bcd_to_7seg Dec_SEC_0 (SEC_0_OUT, SEC_0_SEG);

// gated behind blinker
wire BLINK = CLK_SEC & ENDED;
assign {DISP4,DISP3,DISP2,DISP1} = {28{BLINK}} & {MIN_1_SEG,MIN_0_SEG,SEC_1_SEG,SEC_0_SEG};
// separate minutes from seconds
assign DISP3_DP = 1'b1;

// === Counters ===
// --- minutes ---
counter_6 MIN_1 ( 
	.INC(ADD_10_MIN), 
	.DEC(SUB_10_MIN),
	.CLR(RST), 
	.Q(MIN_1_OUT) 
	);
counter_10 MIN_0 ( 
	.INC(ADD_1_MIN), .CARRY(ADD_10_MIN), 
	.DEC(SUB_1_MIN), .BORROW(SUB_10_MIN),
	.CLR(RST),
	.Q(MIN_0_OUT)
	);
// --- seconds ---
counter_6 SEC_1 ( 
	.INC(ADD_10_SEC), //.CARRY(ADD_1_MIN), //set manually
	.DEC(SUB_10_SEC), .BORROW(SUB_1_MIN),
	.CLR(RST),
	.Q(SEC_1_OUT)
	);
counter_10 SEC_0 ( 
	.INC(ADD_1_SEC), .CARRY(ADD_10_SEC), 
	.DEC(SUB_1_SEC), .BORROW(SUB_10_SEC),
	.CLR(RST),
	.Q(SEC_0_OUT)
	);

endmodule
