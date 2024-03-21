`define IDLE 2'b00
`define SETUP 2'b01
`define ACCESS 2'b10

module APB(
    // Global signal
    input pclk,
    input presetn,
    
    // Requester
    input [31:0] paddr,
    //input [2:0] pprot,
    input psel,
    input penable,
    input pwrite,
    input [31:0] pwdata,
    //input [3:0] pstrb,
    
    // Completer
    output reg pready,
    output reg [31:0] prdata,
    output reg pslverr
    );
    
    // Memory declaration
    reg [31:0] mem [0:31];  // 32 bit memory -> each bit consists of 32 bit locations
    
    // Register for state declaration
    reg [1:0] state;
    
       
    always @(posedge pclk)
    begin : fsm_block
        if(!presetn)
        begin
            state <= `IDLE;
            pready <= 1'b0;
            prdata <= 32'h0000_0000;
            pslverr <= 1'b0;
        end    
        else
        begin
            case(state)
                `IDLE:
                begin: idle_state
                    if((psel === 1'b1) & (penable === 1'b0))
                        state <= `SETUP;
                        // No Transfer                    
                end: idle_state
                
                `SETUP:
                begin: setup_state
                    if((penable === 1'b0) | (psel === 1'b0))
                    begin
                        state <= `IDLE;  
                        pready <= 1'b0;
                        prdata <= 32'h0000_0000;
                        pslverr <= 1'b0;                    
                    end  
                    else           
                      begin
                        state <= `ACCESS;
                        if(pwrite)
                        begin
                            mem[paddr] <= pwdata;
                            pready <= 1'b1;
                            pslverr <= 1'b0;
                        end   
                        else
                        begin
                            prdata <= mem[paddr];
                            pready <= 1'b1;
                            pslverr <= 1'b0;   
                        end
                    end     
                end: setup_state
                
                `ACCESS:
                begin: access_state
                    if((penable === 1'b0) | (psel === 1'b0))
                    begin
                        state <= `IDLE;
                        pready <= 1'b0;
                    end
                end: access_state          
            endcase
        end
    end : fsm_block
endmodule : APB