module UP2_TOP
(
	MCLK,
	
	FLEX_DIGIT_1, FLEX_DIGIT_1_DP,
	FLEX_DIGIT_2, FLEX_DIGIT_2_DP,
	
	FLEX_MOUSE_CLK,
	FLEX_MOUSE_DATA,
	
	VGA_RED,
	VGA_BLUE,
	VGA_GREEN,
	VGA_HSYNC,
	VGA_VSYNC,
	
	LED,
	SW,
	BT,
	
	DISP1, DISP1_DP,
	DISP2, DISP2_DP,
	DISP3, DISP3_DP,
	DISP4, DISP4_DP,
	
	PS2_DATA,
	PS2_CLK,
	
	RS232_RX,
	RS232_TX,
	RS232_RTS,
	RS232_CTS,
	
	MATRIX_ROW,
	MATRIX_COL
);

/*
	==== interface description ====
*/

input MCLK;	//main clock input

output [6:0] FLEX_DIGIT_1; output FLEX_DIGIT_1_DP;
output [6:0] FLEX_DIGIT_2; output FLEX_DIGIT_2_DP;

output VGA_RED;
output VGA_GREEN;
output VGA_BLUE;
output VGA_HSYNC;
output VGA_VSYNC;

output [15:0] LED;
input [7:0] SW;
input [3:0] BT;

output [6:0] DISP1; output DISP1_DP;
output [6:0] DISP2; output DISP2_DP;
output [6:0] DISP3; output DISP3_DP;
output [6:0] DISP4; output DISP4_DP;

inout PS2_DATA;
inout PS2_CLK;
inout FLEX_MOUSE_DATA;
inout FLEX_MOUSE_CLK;

input RS232_RX;
output RS232_TX;
output RS232_RTS;
input RS232_CTS;

output [7:0] MATRIX_ROW;
output [15:0] MATRIX_COL;


/*
	==== functionality ====
*/

//energy saving
assign FLEX_DIGIT_1 = 7'b1111111;
assign FLEX_DIGIT_2 = 7'b1111111;
assign FLEX_DIGIT_1_DP = 1;
assign FLEX_DIGIT_2_DP = 1;
assign MATRIX_ROW = 8'hFF;
assign MATRIX_COL = 16'hFFFF;

//debouncing buttons
wire [3:0] BTD; // 0 if pressed
debouncer d0 ( MCLK, BT[0], BTD[0] );
debouncer d1 ( MCLK, BT[1], BTD[1] );
debouncer d2 ( MCLK, BT[2], BTD[2] );
debouncer d3 ( MCLK, BT[3], BTD[3] );

//LEDs for pressed buttons; ON when pressed
assign LED[15:12] = ~BTD[3:0];

// LED toggled with button
wire CLK_0 = ~BTD[0];
t_ff T0 ( .clk(CLK_0), .out(LED[0]) );

// Test of UP/DOWN counter.
wire [3:0] Q_SEC_0;

wire INC = ~BTD[2]; assign LED[7] = INC;
wire DEC = ~BTD[0]; assign LED[6] = DEC;

counter #(10,4) SEC_0 ( 
	.INC(INC), .DEC(DEC), .Q(Q_SEC_0),
	.CARRY(LED[11]), .BORROW(LED[10])
);
bcd_to_7seg DISP_SEC_0 (Q_SEC_0, DISP4);

endmodule
