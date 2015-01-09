//przerzutnik T wyzw. zboczem narastającym
module t_ff
(
	input clk,
	output reg out
);

always @(posedge clk) out <= ~out;

endmodule