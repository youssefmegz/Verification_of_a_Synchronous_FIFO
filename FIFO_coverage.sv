package pkg2;				//second package -- coverage package
import transaction_pkg::*;	//first package -- transaction

class FIFO_coverage;

FIFO_transaction F_cvg_txn=new; 


covergroup all_comb;
				write: coverpoint F_cvg_txn.wr_en ;
				read:  coverpoint F_cvg_txn.rd_en ;
				Full_flag: coverpoint F_cvg_txn.full ;
				Overflow_flag: coverpoint F_cvg_txn.overflow ;
				Empty_flag: coverpoint F_cvg_txn.empty ;
				Underflow_flag: coverpoint F_cvg_txn.underflow ;
				Write_ack: coverpoint F_cvg_txn.wr_ack ;
full_cp :cross write,read,Full_flag 
				{
					ignore_bins imp_case_1 = binsof(Full_flag ) intersect {1} &&binsof(read) intersect {1};
				}

empty_cp: cross write, read,Empty_flag 
				{
					ignore_bins imp_case_2 = binsof(Empty_flag ) intersect {1} &&binsof(write) intersect {1};
				}


almostfull_cp: cross write,read,F_cvg_txn.almostfull ;

almost_empty_cp: cross write, read ,F_cvg_txn.almostempty ;

overflow_cp: cross write,read,Overflow_flag 
				{
					ignore_bins imp_case_3 = binsof(Overflow_flag) intersect {1} &&binsof(write) intersect {0} ;
				}	
			 			
underflow_cp: cross write, read,Underflow_flag			
			 	{
					ignore_bins imp_case_4 = binsof(Underflow_flag ) intersect {1} &&binsof(read) intersect {0} ;
				}	

wr_ack_cp: cross write,read,Write_ack 
			 	{
					ignore_bins imp_case_5 = binsof(Write_ack ) intersect {1} &&binsof(write) intersect {0} ;
				}	

endgroup : all_comb


function new();

all_comb=new();

endfunction

function void sample_data ( FIFO_transaction F_txn);

F_cvg_txn = F_txn;
if(F_cvg_txn.rst_n)
all_comb.sample();


endfunction : sample_data

endclass

endpackage