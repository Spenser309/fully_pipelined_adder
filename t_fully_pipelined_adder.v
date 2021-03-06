/* file: t_fully_pipelined_adder.v
 * Engineer: Spenser Gilliland <Spenser309@gmail.com>
 * Company: IIT ECASP Lab
 * License: GPLv3
 * Date: 10/20/2011
 */
 
module t_fully_pipelined_adder;
   parameter integer WIDTH = 3;
   parameter integer ain[WIDTH-1:0] = '{4,4,7};
   parameter integer bin[WIDTH-1:0] = '{2,3,7};
   parameter reg     cin[WIDTH-1:0] = '{1,1,1};

   reg             clk;
   reg [WIDTH-1:0] a;
   reg [WIDTH-1:0] b;
   reg             c;
   reg             en;
   reg             rst;

   wire [WIDTH-1:0] s;
   wire             carry;

   integer clk_period = 10;
   integer sout [WIDTH-1:0];
   reg     cout [WIDTH-1:0];
   
   integer i;
   
   task automatic load_adder;//(ain,bin,cin,sout,cout);
      input integer ain;
      input integer bin;
      input         cin;
      output integer sout;
      output         cout;
      
      begin
         //#(clk_period)
         @(negedge clk)
         a = ain;
         b = bin;
         c = cin;
         
         #(clk_period*WIDTH)
         sout = {1'b0,s};
         cout = {1'b0,carry};
         $display("%g %d + %d = %d (cin = %d, cout = %d)", $time, ain, bin, sout, cin, cout);
         
         if ( sout == a + b + c) 
            $display("Passed");
         else
            $display("Failed");
      end
   endtask

   always begin
      #(clk_period/2) clk = ! clk;
   end
	
   fully_pipelined_adder #(WIDTH) uut(s,carry,a,b,c,en,rst,clk);

   initial begin
      //$dumpfile("t_fully_pipelined_adder.lxt");
      $dumpvars(0, t_fully_pipelined_adder);
      rst = 1'b1;
      en = 1'b0;
      /* Hold the clock at zero initially */
      clk = 1'b0;
      a = 'b0;
      b = 'b0;
      c = 1'b0;
      #(17) 
      rst = 1'b0;
      en = 1'b1;
      
      for(i = 0; i < WIDTH; i = i + 1) 
      fork : GEN_LOADS
         automatic integer thread_id = i;
         begin
         $display("%g Thread ID = %d",$time, thread_id);
         #(clk_period*thread_id+17) load_adder(ain[thread_id],bin[thread_id],cin[thread_id],sout[0],cout[0]);
         end
      join_none
      
      wait fork;
      
      $display("%g Run in !en mode for %d cycles", $time, WIDTH);
      en = 1'b0;
      #(clk_period*WIDTH)
      
      $display("%g Done", $time);
      $finish;
   end
endmodule
