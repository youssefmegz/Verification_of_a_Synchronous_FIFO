interface FIFO_interface (clk);

	parameter FIFO_WIDTH = 16;
	parameter FIFO_DEPTH = 8;
	localparam max_fifo_addr = $clog2(FIFO_DEPTH);
	input bit clk;


bit [FIFO_WIDTH-1:0] data_in;							//input
bit rst_n, wr_en, rd_en;								//input
bit [FIFO_WIDTH-1:0] data_out;							//output
bit wr_ack, overflow;									//output
bit full, empty, almostfull, almostempty, underflow;	//output
bit [max_fifo_addr:0] count;


modport DUT (input data_in, clk, rst_n, wr_en, rd_en, output data_out, wr_ack, overflow, full, empty, almostfull, almostempty, underflow, count);
modport TEST (output data_in, rst_n, wr_en, rd_en, input clk,data_out, wr_ack, overflow, full, empty, almostfull, almostempty, underflow);
modport MONITOR (input data_in, rst_n, wr_en, rd_en, clk, data_out, wr_ack, overflow, full, empty, almostfull, almostempty, underflow,count);


	
endinterface : FIFO_interface