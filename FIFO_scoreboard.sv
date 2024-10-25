package pkg3;			                //scoreboard -- third package
import transaction_pkg::*;	      //first package -- transaction
import shared_package::*;

class FIFO_scoreboard;
parameter FIFO_WIDTH = 16;
parameter FIFO_DEPTH = 8;
localparam max_fifo_addr = $clog2(FIFO_DEPTH);
bit [max_fifo_addr-1:0] wr_ptr_ref, rd_ptr_ref;
bit [max_fifo_addr:0] count_ref;

bit [FIFO_WIDTH-1:0] data_out_ref; 
bit full_ref, empty_ref, almostfull_ref, almostempty_ref, underflow_ref, wr_ack_ref, overflow_ref;
bit [FIFO_WIDTH-1:0] fifo_queue[$];           // Dynamically-sized queue



function void check_data(FIFO_transaction transaction_check);
reference_model(transaction_check);

if(data_out_ref != transaction_check.data_out)
begin
	error_count = error_count+1;
	$display("ERROR: AT TIME = %0t  THE DATA OUT IS EXPECTED TO BE 0d%0d BUT IT IS 0d%0d ",$time(),data_out_ref,transaction_check.data_out); 
end
else
	correct_count = correct_count+1;

if(full_ref!==transaction_check.full || empty_ref!==transaction_check.empty 
        || almostfull_ref!==transaction_check.almostfull ||overflow_ref!==transaction_check.overflow
        ||underflow_ref!==transaction_check.underflow ||wr_ack_ref!==transaction_check.wr_ack) begin

        if(full_ref!==transaction_check.full)begin
          $display("ERROR IN FULL FLAG AT TIME:%0t ---EXPECTED: %0b ---ACTUAL:%0b",$time,full_ref,transaction_check.full);
          error_count=error_count+1;
        end
        if(empty_ref!==transaction_check.empty)begin
          $display("ERROR IN EMPTY FLAG AT TIME:%0t ---EXPECTED: %0b ---ACTUAL:%0b",$time,empty_ref,transaction_check.empty);
          error_count=error_count+1;
        end 
        if(almostfull_ref!==transaction_check.almostfull)begin
          $display("ERROR IN ALMOST FULL FLAG AT TIME:%0t ---EXPECTED: %0b ---ACTUAL:%0b",$time,almostfull_ref,transaction_check.almostfull);
          error_count=error_count+1;
        end
        if(almostempty_ref!==transaction_check.almostempty)begin
          $display("ERROR IN ALMOST EMPTY FLAG AT TIME:%0t ---EXPECTED: %0b ---ACTUAL:%0b",$time,almostempty_ref,transaction_check.almostempty);
          error_count=error_count+1;
        end
        if(overflow_ref!==transaction_check.overflow)begin
          $display("ERROR IN OVERFLOW FLAG AT TIME:%0t ---EXPECTED: %0b ---ACTUAL:%0b",$time,overflow_ref,transaction_check.overflow);
          error_count=error_count+1;
        end
        if(underflow_ref!==transaction_check.underflow)begin
          $display("ERROR IN UNDERFLOW FLAG AT TIME:%0t ---EXPECTED: %0b ---ACTUAL:%0b",$time,underflow_ref,transaction_check.underflow);
          error_count=error_count+1;
        end
        if(wr_ack_ref!==transaction_check.wr_ack)begin
          $display("ERROR IN WR_ACK FLAG AT TIME:%0t ---EXPECTED: %0b ---ACTUAL:%0b",$time,wr_ack_ref,transaction_check.wr_ack);
          error_count=error_count+1;
        end
      end
      else
        correct_count=correct_count+1;

endfunction



function void reference_model(FIFO_transaction transaction_ref);

 if (!transaction_ref.rst_n) begin
      // Reset state
      fifo_queue.delete();         // Clear the queue on reset
      wr_ack_ref=0;
      wr_ptr_ref=0;
      rd_ptr_ref=0;
      overflow_ref=0;
      underflow_ref=0;
      count_ref=0;
    end else begin

        // Write operation
        if (transaction_ref.wr_en) begin
          if(count_ref<FIFO_DEPTH)begin
            fifo_queue.push_back(transaction_ref.data_in);           // Push data into the queue
            wr_ack_ref=1;
            wr_ptr_ref = wr_ptr_ref+1;
            overflow_ref=0;
          end
        else begin
          wr_ack_ref=0;
          overflow_ref=1;
        end
        end
        else begin
          overflow_ref=0;
          wr_ack_ref=0;
        end

      // Read operation
      if (transaction_ref.rd_en) begin
        if(count_ref>0)begin
        data_out_ref = fifo_queue.pop_front();   // Pop data from the queue
        rd_ptr_ref=rd_ptr_ref+1;
        underflow_ref=0;  
      end
      else 
          underflow_ref=1;
        end
        else begin
          underflow_ref=0;
      end


case({transaction_ref.wr_en ,transaction_ref.rd_en})

              2'b01 : if(!empty_ref)
                count_ref=count_ref-1;
              2'b10 : if(!full_ref)
                count_ref=count_ref+1;
              2'b11: if(full_ref)
                count_ref=count_ref-1;
                  else if(empty_ref)
                count_ref=count_ref+1;

            endcase

    end

          // Update status signals based on queue size
      full_ref = (count_ref == FIFO_DEPTH);
      empty_ref = (count_ref== 0);
      almostfull_ref = (count_ref == FIFO_DEPTH - 1);
      almostempty_ref = (count_ref == 1);

endfunction


function new() ;
			error_count =0;
			correct_count =0 ;
endfunction



endclass

endpackage