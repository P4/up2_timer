// Licznik dwukierunkowy z flagami pozyczki i przeniesienia, modulo N

// Uzycie: 
// counter #(N, clog2(N) ) NAME ( INC, DEC, Q, CARRY, BORROW);

module counter_10 (
	INC, // zwieksza Q o 1
	DEC, // zmniejsza Q o 1
	CLR,
	Q,   // aktualny stan Q, wartosci 0..N-1
	CARRY, // przeniesienie, przy inkrementacji z N-1 na 0
	BORROW // pozyczka, przy dekrementacji z 0 na N-1
);

input INC;
input DEC;
input CLR;
output reg [3:0] Q;

wire [3:0] T; 
wire U = ~INC;
wire D = ~DEC;
wire X = Q[1] | Q[2] | Q[3]; 

assign T[0] = ~( &U + &D );
assign T[1] = ~( 
	(Q[0] & ~Q[3] & U ) +  
	(~Q[0] & X & D)
);

assign T[2] = ~ (
	( U & Q[0] & Q[1] ) + 
	( D & X & ~Q[0] & ~Q[1] )
);
assign T[3] = ~ (
	( U & Q[0] & Q[1] & Q[2] ) +
	( U & Q[0] & Q[3] ) +
	( D & ~Q[0] & ~Q[1] & ~Q[2]) 
);

output CARRY = ~( U & Q[0] & Q[3] );
output BORROW = ~( &{D,~Q} );

always @(posedge T[0], posedge CLR) Q[0] <= (CLR) ? 0 : ~Q[0];
always @(posedge T[1], posedge CLR) Q[1] <= (CLR) ? 0 : ~Q[1];
always @(posedge T[2], posedge CLR) Q[2] <= (CLR) ? 0 : ~Q[2];
always @(posedge T[3], posedge CLR) Q[3] <= (CLR) ? 0 : ~Q[3];

//always @(negedge CLK) begin
//	CARRY <= 0;
//	BORROW <= 0;
//end

endmodule