module debouncer 
(
	input clk, // zegar (np. globalny 25,175MHz)
	input btn,
	output reg out
);

// licznik N-bitowy
parameter N = 18;
reg [N-1:0] counter;

// przerzutnik D synchronizujacy stan przycisku z zegarem
reg d; always@(posedge clk) d <= btn;

// flaga: wszystkie bity licznika == 1
wire counter_max = &counter;

// przelaczamy sie gdy przycisk spedzi zadana ilosc cykli zegara
// w stanie przeciwnym do obecnego
always@(posedge clk)
if(d==out) // stan stabilny lub bounce
	counter <= 0; // zeruj licznik
else begin // przejscie miedzy stanami
	counter <= counter+1; //inkrementuj
	if(counter_max) out <= ~out; //przelacz
end

endmodule
