module mode
(
	input btn,
	input end_,
	output reg running,
	output reg ended
);

always @(posedge btn, negedge end_)
	if (~end_) begin
		{running,ended} <= (running) ? 2'b01 : {running,ended};
	end
	else begin
		running <= (ended) ? 1'b0 : ~running;
		ended <= 1'b0;
	end

endmodule