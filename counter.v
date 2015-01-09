// Licznik dwukierunkowy z flagami pozyczki i przeniesienia, modulo N

// Uzycie: 
// counter #(N, clog2(N) ) NAME ( INC, DEC, Q, CARRY, BORROW);

module counter (
	INC, // zwieksza Q o 1
	DEC, // zmniejsza Q o 1
	Q,   // aktualny stan Q, wartosci 0..N-1
	CARRY, // przeniesienie, przy inkrementacji z N-1 na 0
	BORROW // pozyczka, przy dekrementacji z 0 na N-1
);

parameter N = 10;
parameter SIZE = 4;

input INC;
input DEC;
output reg [SIZE-1:0] Q;
output reg CARRY;
output reg BORROW;


wire CLK = INC || DEC;
always @(posedge CLK) begin
if (INC) begin
	if (Q == N-1) begin
		CARRY <= 1; BORROW <= 0;
		Q <= 0;
	end
	else begin
		CARRY <= 0; BORROW <= 0;
		Q <= Q+1;
	end
end
else if (DEC) begin
	if (Q==0) begin
		BORROW <= 1; CARRY <= 0; 
		Q <= N-1;
	end
	else begin
		BORROW <= 0; CARRY <= 0; 
		Q <= Q-1;
	end
end
end

endmodule