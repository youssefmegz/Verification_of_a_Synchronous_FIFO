////////////////////////////////////////////////////////////////////////////////
// Author: Kareem Waseem
// Course: Digital Verification using SV & UVM
//
// Description: FIFO Design 
// 
////////////////////////////////////////////////////////////////////////////////
module FIFO(FIFO_interface.DUT inter);
parameter FIFO_WIDTH = 16;
parameter FIFO_DEPTH = 8;

localparam max_fifo_addr = $clog2(FIFO_DEPTH);

reg [FIFO_WIDTH-1:0] mem [FIFO_DEPTH-1:0];

reg [max_fifo_addr-1:0] wr_ptr, rd_ptr;



`ifdef SIM

property acknowledge;
@(posedge inter.clk) disable iff(inter.rst_n==0)(inter.wr_en && inter.count < FIFO_DEPTH) |=> inter.wr_ack==1;
endproperty

acknowledge_assert:assert property(acknowledge) else $display("ERROR : acknowledge assert FAIL");
cover property(acknowledge);


property over_flow;
@(posedge inter.clk) disable iff(inter.rst_n==0)(inter.full && inter.wr_en) |=> inter.overflow==1;
endproperty

overflow_assert:assert property(over_flow) else $display("ERROR : overflow assert FAIL");
cover property(over_flow);		

property under_flow;
@(posedge inter.clk)disable iff(inter.rst_n==0) (inter.empty && inter.rd_en) |=> inter.underflow==1;
endproperty

underflow_assert:assert property(under_flow) else $display("ERROR : underflow assert FAIL");
cover property(under_flow);


always_comb begin

if(!inter.rst_n) 
begin
				R1: assert final(inter.full == 0);
				R2: assert final(inter.empty == 1);
				R3: assert final (inter.almostfull == 0);
				R4: assert final (inter.almostempty == 0);
				R5: assert final (inter.overflow == 0);
				R6: assert final (inter.underflow == 0);
				R7: assert final (inter.wr_ack ==0 );
end

if(inter.count==FIFO_DEPTH)
full_assert:assert final(inter.full==1);

if(inter.count==0)
empty_assert:assert final(inter.empty==1);

if(inter.count == FIFO_DEPTH-1)
almostfull_assert:assert final(inter.almostfull==1);

if(inter.count == 1)
almostempty_assert:assert final(inter.almostempty==1);

end

`endif



always @(posedge inter.clk or negedge inter.rst_n) begin
	if (!inter.rst_n) begin
		wr_ptr <= 0;
		inter.wr_ack <= 0;								//reset acknowledge
		inter.overflow<=0;								//reset overflow
	end
	else if (inter.wr_en && inter.count < FIFO_DEPTH) begin
		mem[wr_ptr] <= inter.data_in;
		inter.wr_ack <= 1;
		wr_ptr <= wr_ptr + 1;
		inter.overflow<=0;
	end
	else begin 
		inter.wr_ack <= 0; 
		if (inter.full & inter.wr_en)
			inter.overflow <= 1;
		else
			inter.overflow <= 0;
	end
end

always @(posedge inter.clk or negedge inter.rst_n) begin
	if (!inter.rst_n) begin
		rd_ptr <= 0;							
		inter.underflow<=0;											//reset underflow

	end
	else if (inter.rd_en && inter.count != 0) begin
		inter.data_out <= mem[rd_ptr];
		rd_ptr <= rd_ptr + 1;
		inter.underflow<=0;
	end
	else 
		inter.underflow <= (inter.empty && inter.rd_en)? 1 : 0;		//sequential output

end

always @(posedge inter.clk or negedge inter.rst_n) begin
	if (!inter.rst_n) begin
		inter.count <= 0;
	end
	else begin
		if	( ({inter.wr_en, inter.rd_en} == 2'b11) && !inter.full && !inter.empty)		//done at the same time 
			inter.count <= inter.count ;
		else if ( ({inter.wr_en, inter.rd_en} == 2'b11) && inter.empty)					//write is done firstly when empty
			inter.count <= inter.count + 1;
		else if ( ({inter.wr_en, inter.rd_en} == 2'b11) && inter.full)					//read is done firstly when full
			inter.count <= inter.count - 1;
		else if ( inter.wr_en == 1 && !inter.full)
			inter.count <= inter.count + 1;
		else if ( inter.rd_en == 1 && !inter.empty)
			inter.count <= inter.count - 1;
	end

end

assign inter.full = (inter.count == FIFO_DEPTH)? 1 : 0;
assign inter.empty = (inter.count == 0)? 1 : 0; 
assign inter.almostfull = (inter.count == FIFO_DEPTH-1)? 1 : 0; 						// minus one
assign inter.almostempty = (inter.count == 1)? 1 : 0;

endmodule