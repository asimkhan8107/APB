`timescale 1ns / 1ps

`define CLOCK_Period 10 // 10ns -> 100Mhz operating frequency

module tb_APB();
    reg pclk;
    reg presetn;
    
    // Requester
    reg [31:0] paddr;
    //reg [2:0] pprot;
    reg psel;
    reg penable;
    reg pwrite;
    reg [31:0] pwdata;
    //reg [3:0] pstrb;
    
    // Completer
    wire pready;
    wire [31:0] prdata;
    wire pslverr;
    
    APB DUT(.pclk(pclk),
            .presetn(presetn),
            .paddr(paddr),
            .psel(psel),
            .penable(penable),
            .pwrite(pwrite),
            .pwdata(pwdata),
            .pready(pready),
            .prdata(prdata),
            .pslverr(pslverr)
            );
            
    // clock generation
    always #((`CLOCK_Period)/2) pclk = ~pclk;   
    
    initial 
    begin
        initialization;
        reset;
        read_write;
        @(posedge pclk); 
        $finish();
    end
    
    // initializing all signal values as 0
    task initialization;
        begin
          pclk = 1'b0;
          presetn = 1'b0;
          paddr = 32'h0000_0000;
          psel = 1'b0;
          penable = 1'b0;
          pwrite = 1'b0;
        end
    endtask
    
    // reset the system to initial state
    task reset;
        begin 
          presetn = 1'b0;
          @(negedge pclk);    
          presetn = 1'b1;
        end
    endtask
    
    // write operation testcases
    task write();
        begin
          @(posedge pclk);
          psel = 1'b1;
          pwrite = 1'b1;
          pwdata = $random;
          paddr = paddr + 1;
         
          @(posedge pclk);
          penable = 1'b1;
          psel = 1'b1;
          @(posedge pclk);
          penable = 1'b0;
          psel = 1'b0;
          
          @(posedge pclk);
        end
    endtask
     
    // read operation testcases  
    task read();
        begin
          @(posedge pclk);
          pwrite = 1'b0;
          psel = 1'b1;
          penable = 1'b0;
          @(posedge pclk); 
          penable = 1'b1;
          psel = 1'b1;
          paddr = paddr + 1;
          @(posedge pclk); 
          penable = 1'b0;
          psel = 1'b0;
          
          @(posedge pclk);
        end
    endtask
    
    // read write
    task read_write;
        begin 
            repeat(2) 
            begin 
              write();
            end
            
            @(posedge pclk);
            paddr = 0;
            
            repeat(3) 
            begin 
              read();
            end
        end
    endtask
    
endmodule