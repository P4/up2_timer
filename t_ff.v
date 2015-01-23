//przerzutnik T wyzw. zboczem narastającym
module t_ff
(
	input clk,
	input clr,
	output reg out
);

always @(posedge clk, negedge clr) out <= (~clr) ? 1'b0 : ~out;

endmodule