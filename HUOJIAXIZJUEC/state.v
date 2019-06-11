module state (clk, clk_2, clk_cnt, led_state, q0, q1, q2)

	input  clk;
	output led_state;

	reg [31:0] clk_cnt = 0;
	reg q0 = 0;
	reg q1 = 0;
	reg q2 = 0;
	reg clk_2 = 0;
	reg led;

	always @(posedge clk) begin
		if (clk_cnt == 250000000) begin
			clk_2 =~ clk_2;
			clk_cnt = 0;
		end
		else begin
			clk_cnt = clk_cnt + 1;
		end
	end //devision de frequence

	assign led_state = ~~q1;

	always @(posedge clk_2) begin
		
		q0 <= q1&q2;
		q1 <= ~q1&q2|q1&~q2;
		q2 <= ~q0&~q2

	end

	endmodule


