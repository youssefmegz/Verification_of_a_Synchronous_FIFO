import transaction_pkg::*;
import shared_package::*;

module FIFO_tb(FIFO_interface.TEST inter);


FIFO_transaction FIFO_test=new;

initial
begin

inter.rst_n=0;

repeat(10000) begin

@(negedge inter.clk);

#2;
assert(FIFO_test.randomize());
inter.rst_n = FIFO_test.rst_n;
inter.wr_en = FIFO_test.wr_en;
inter.rd_en = FIFO_test.rd_en;
inter.data_in = FIFO_test.data_in;

end

test_finished=1;


end

endmodule