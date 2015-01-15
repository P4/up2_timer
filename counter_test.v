module counter_test (
	input inc,
	input dec,
	output [3:0] q,
	output Carry,
	output Borrow
);

counter #(10,4) C0 (.INC(inc), .DEC(dec), .Q(q), .CARRY(Carry), .BORROW(Borrow) );

endmodule