import transaction_pkg::*;
import pkg2::*;
import pkg3::*;
import shared_package::*;

module FIFO_monitor(FIFO_interface.MONITOR inter);

FIFO_transaction FIFO_1 = new;
FIFO_scoreboard FIFO_2 = new;
FIFO_coverage FIFO_3 = new;

initial begin
	
forever begin
@(negedge inter.clk);
FIFO_1.data_out = inter.data_out;
FIFO_1.wr_ack = inter.wr_ack;
FIFO_1.overflow = inter.overflow;
FIFO_1.full = inter.full;
FIFO_1.empty = inter.empty;
FIFO_1.almostfull = inter.almostfull;
FIFO_1.almostempty = inter.almostempty;
FIFO_1.underflow = inter.underflow;
FIFO_1.wr_en = inter.wr_en;
FIFO_1.rd_en = inter.rd_en;
FIFO_1.rst_n = inter.rst_n;
FIFO_1.data_in = inter.data_in;

fork
	
begin
	FIFO_3.sample_data(FIFO_1);
end

begin
	FIFO_2.check_data(FIFO_1);
end

join

if(test_finished==1)
begin
	$display("Error count is = 0d%0d, Correct count is = 0d%0d",error_count,correct_count);
	$stop;
end
end
end
endmodule