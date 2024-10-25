package transaction_pkg;           //first package -- transaction

parameter FIFO_WIDTH = 16;
parameter FIFO_DEPTH = 8;

class FIFO_transaction;

rand bit [FIFO_WIDTH-1:0] data_in;						//input
rand bit rst_n, wr_en, rd_en;							//input
bit clk;
bit [FIFO_WIDTH-1:0] data_out;							//output
bit wr_ack, overflow;									//output
bit full, empty, almostfull, almostempty, underflow;	//output
integer count;

int RD_EN_ON_DIST , WR_EN_ON_DIST;


function new(int input_RD=30,int input_WR=70);

RD_EN_ON_DIST=input_RD;
WR_EN_ON_DIST=input_WR;

endfunction

constraint reset_c {rst_n dist{1:=97,0:=3};}
constraint wr_en_c {wr_en dist{1:=WR_EN_ON_DIST,0:=100-WR_EN_ON_DIST};}
constraint rd_en_c {rd_en dist{1:=RD_EN_ON_DIST,0:=100-RD_EN_ON_DIST};}

endclass

endpackage