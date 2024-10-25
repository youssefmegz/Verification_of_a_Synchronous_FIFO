# Verification_of_a_Synchronous_FIFO
# FIFO Design Verification using SystemVerilog

## Project Overview
This project is dedicated to verifying a Synchronous FIFO Design using **System Verilog (SV)**. A FIFO (First-In, First-Out) buffer is pivotal in digital systems to manage sequential data, ensuring data is read in the order it was written. This is crucial for timing-sensitive applications like data pipelines, communication protocols, and buffering systems. The aim is to verify the correctness, functionality, and robustness of the FIFO design, addressing and resolving potential bugs.

## Key Features of the FIFO Design
- **FIFO_WIDTH**: 16-bit (default)
- **FIFO_DEPTH**: 8 entries (default)

### Signals Verified
- `data_in`: Input data bus
- `wr_en`: Write enable signal
- `rd_en`: Read enable signal
- `clk`: Clock signal for synchronization
- `rst_n`: Asynchronous reset
- `data_out`: Output data bus
- `full`, `almostfull`: FIFO status indicators (full/near full)
- `empty`, `almostempty`: FIFO status indicators (empty/near empty)
- `overflow`, `underflow`: Error handling for invalid write/read operations
- `wr_ack`: Acknowledge successful write operations

## UVM-based Verification Flow
The verification environment is structured using UVM methodology, leveraging constrained random stimulus and coverage-driven techniques to ensure thorough testing.

## Functional Coverage
Key operational scenarios monitored during the verification process include:
- **Overflow/Underflow Conditions**: Ensuring correct handling of invalid writes and reads when FIFO is full or empty.
- **Almost Full/Almost Empty States**: Verifying system responses when nearing capacity or emptiness.
- **Read/Write Command Operation**: Testing the FIFO's correct response to read and write operations under various conditions.

## Results
The verification environment thoroughly tested the FIFO design, identifying and resolving bugs related to data flow and control signals. The design was confirmed to be robust and ready for real-world applications such as data pipelines and communication protocols.

## Special Thanks
A big thank you to **Eng. Kareem Waseem** for his invaluable guidance throughout this project.



