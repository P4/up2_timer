// Dekoder BCD dla wyswietlacza 7 segmentowego

module bcd_to_7seg (

input [3:0] IN,
output reg [6:0] OUT //abcdefg

);

//  aa
// f  b
// f  b
//  gg
// e  c
// e  c
//  dd

always@(IN)
case(IN) //		 gfedcba
	0: OUT <= 7'b0111111;
	1: OUT <= 7'b0000110;
	2: OUT <= 7'b1011011;
	3: OUT <= 7'b1001111;
	4: OUT <= 7'b1100110;
	5: OUT <= 7'b1101101;
	6: OUT <= 7'b1111101;
	7: OUT <= 7'b0000111;
	8: OUT <= 7'b1111111; 
	9: OUT <= 7'b1101111;
	default: // "-"
	   OUT <= 7'b1000000;
endcase

endmodule