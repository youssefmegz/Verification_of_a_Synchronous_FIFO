module FIFO_top;


bit clk;
initial begin
	clk=0;
	forever 
	#10 clk=~clk;
end


FIFO_interface inter(clk);
FIFO_tb fifo_tb(inter);			
FIFO fifo(inter);
FIFO_monitor MONITOR(inter);	





endmodule