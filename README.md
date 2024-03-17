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

**ERROR Response**

PSLVERR can be used to indicate an error condition on an APB transfer. Error conditions can occur on both read and write transactions.

PSLVERR is only considered valid during the last cycle of an APB transfer, when PSEL, PENABLE, and PREADY are all HIGH.

NOTE: Error response is recommended, but not required, that PSLVERR is driven LOW when PSEL, PENABLE, or PREADY are LOW.

# Operating States 

<img width="303" alt="Screenshot 2024-03-17 160142" src="https://github.com/asimkhan8107/APB/assets/110652576/b5ca7586-d2de-4d16-92be-9e51ec45265d">

The state machine operates through the following states:

**IDLE**    This is the default state of thr APB iterface.

**SETUP**   When a transfer is required, the interface moves into the SETUP state, where the appropriate select signal, PSEL is asserted. The interface only remains in the SETUP state for one clock cycle and always moves to the ACCESS state on the next rising edge of the clock.

**ACCESS**  The enable signal, PENABLE is asserted in the ACCESS state. The following signal must not change in the transition between SETUP and ACCESS and between cycles in the ACCESS state:

                  - PADDR
                  - PPROT
                  - PWRITE
                  - PWDATA, only for write transaction
                  - PSTRB

EXIT from ACCESS state is controlled by the PREADY signal from the completer.
- If the PREADY is held LOW by the Completer, then the interface remains in thr ACCESS state.
- If the PREADY is driven HIGH by the Completer, then the ACCESS state is exited and the bus returns to the IDLE state if no more transaction are required. Alternatively, the bus moves directlt to the SETUP state if another transfer follows.

# Transfer

# Write Transfer
APB interface consist of two types of write transfer:
- With no wait states
- With wait states

**With no wait states**

<img width="500" alt="Screenshot 2024-03-17 160509" src="https://github.com/asimkhan8107/APB/assets/110652576/9497d293-5c3c-4c43-86c0-a675d00b0935">

The setup phase of the write transfer occurs at T1. The select signal, PSEL, is asserted, which means that PADDR, PWRITE, and PWDATA must be valid.

The access phase of the write transfer occurs at T2, where PENABLE is asserted. PREADY is asserted by the Completer at the rising edge of PCLK to indicate that the write data will be accepted at T3. PADDR, PWDATA, and any other control signals, must be stable until the transfer completes.

At the end of the transfer, PENABLE is deasserted. PSEL is also deasserted, unless there is another transfer to the same peripheral.

**With wait states**

<img width="401" alt="image" src="https://github.com/asimkhan8107/APB/assets/110652576/ab2bf006-affc-4b2a-8868-58bbf31ec331">

during an access phase, when PENABLE is HIGH, the Completer extends the transfer by driving PREADY LOW. And the other signals (PADDR, PWRITE, PSEL, PENABLE, PWDATA, PSTRB, PPROT) must be unchanged while PREADY remains LOW.

PREADY can take any value when PENABLE is LOW. This ensures that peripherals that have a fixed two cycle access can tie PREADY HIGH.

# READ Transfer
APB interface consist of two types of read transfer:
- With no wait states
- With wait states

**With no wait states**

The timing of the address, write, select, and enable signals are the same as described in WRITE Transfer. The Completer must provide the data before the end of the READ Transfer. 

**With wait state**

The transfer is extended if PREADY is driven LOW during an access phase. And other signals(PADDR, PWRITE, PSEL, PENABLE, PPROT) remain unchanged while PREADY remains LOW.

NOTE: Any number of cycles can be added from zero to upwards. 

# WRITE Transfer with Error

When a write transaction receive an error, this does not mean that the register within the peripheral has not been updated.

# READ Transfer with Error

Read transaction that receive an error can return invalid data. There is no requirement for the peripheral to drive te data bus to all 0s for a read error. A Requester which receives an error response to a read transfer might still use the data.

A read transfer can also complete with an error response, indicating that there is no valid read data available.






                  




