vlib work
vlog FIFO.sv FIFO_tb.sv FIFO_top.sv FIFO_transaction.sv FIFO_coverage.sv FIFO_interface.sv FIFO_scoreboard.sv FIFO_monitor.sv shared_package.sv +cover -covercells +define+SIM
vsim -voptargs=+acc work.FIFO_top -cover
add wave *
coverage save FIFO_top.ucdb -onexit
run -all