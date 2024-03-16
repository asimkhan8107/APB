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




