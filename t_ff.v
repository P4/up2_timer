//przerzutnik T wyzw. zboczem narastającym
module t_ff
(
	input clk,
	input clr,
	output reg out
);

always @(posedge clk) out <= (clr) ? 1'b0 : ~out;

endmodule