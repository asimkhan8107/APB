# AMBA-APB
The APB(Advanced Peripheral Bus) protocol is a low-cost interface, optimized for minimal power consumption and reduced interface complexity.
- The APB interface is not pipelined and is a simple synchronous protocol (clock requires for transaction).
- Every transfer takes at least two cycles to complete.

The APB interface is designed for accessing the programmable control registers of peripheral devices. 
- APB peripherals are typically connected to the main memory system using an APB bridge. 
- Example => A bridge from AXI to APB could be used to connect a number of APB peripherals to an AXI memory system.

APB transfer are initiated by an APB bridge. 
- APB bridge can also be referred to as a Requester. A peripheral interface responds to requests. 
- APB bridge can also be referred to as a Requester. A peripheral interface responds to requests.
- APB peripherals can also be referred to as a Completer. 
- In this project, we will use Requester and Completer.

# APB Signal Description
![APB-signal-description_page-0001](https://github.com/asimkhan8107/APB/assets/110652576/5a9a5e22-5355-42f9-bd31-2aec87d0cebd)

**Address Bus**

An APB interface has a single address bus, PADDR for read and write transfer. PADDR indiates a byte address, and PADDR is permitted to be unaligned with respect to the data width, but in this case result is UNPRIDICTABLE. 
Example -> A completer might use the unaligned address, aligned address, or signal an error response.

**DATA Buses**   

The APB protocol has two independent data buses, PRDATA for read data and PWDATA for write data. The buses can be 8, 16, or 32 bits wide. 
WARNING: The read and write data buses must have the same width.

NOTE: Data transfer can not occur concurrently because the read data and write data buses do not have their own individual handshake signals.

# Operating States 
The state machine operates through the following states:
**IDLE**    This is the default state of thr APB iterface.
**SETUP**   When a transfer is required, the interface moves into the SETUP state, where the appropriate select signal, PSEL is asserted. The interface only remains in the SETUP state for one clock cycle and always moves to the ACCESS state on the next rising edge of the clock.
**ACCESS**  The enable signal, PENABLE is asserted in the ACCESS state. The following signal must not change in the transition between SETUP and ACCESS and between cycles in the ACCESS state:
                  - PADDR
                  - PPROT
                  - PWRITE
                  - PWDATA, only for write transaction
                  - PSTRB
                  




