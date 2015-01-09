// Zegar o okresie 1 sekundy, czestotliwosci 1Hz

// Uwaga: Wypelnienie nie jest rowne 50%.

module clock_sec
(
	MCLK, 	// Wejscie zegara globalnego 25.175 MHz
	CLK_SEC // Wyjscie zegara 1Hz
);

// 25.175 MHz, 25 bits
parameter FREQ = 25175000;

input MCLK;
output CLK_SEC;
reg [24:0] counter;

assign CLK_SEC = counter[24];

always @(posedge MCLK) 
	if (counter == FREQ-1) counter <= 0;
	else counter <= counter+1;

endmodule