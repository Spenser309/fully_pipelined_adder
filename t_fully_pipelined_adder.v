/* file: t_fully_pipelined_adder.v
 * Engineer: Spenser Gilliland <Spenser309@gmail.com>
 * Company: IIT ECASP Lab
 * License: GPLv3
 * Date: 10/20/2011
 */
 
module t_fully_pipelined_adder;
    parameter integer WIDTH = 4;
	
    reg             clk;
    reg [WIDTH-1:0] a;
    reg [WIDTH-1:0] b;
    reg             cin;

    wire [WIDTH-1:0] s;
    wire             c;

    integer cycle = 0;

    always begin
        #5 clk = ! clk;
    end
	
    fully_pipelined_adder #(WIDTH) uut(s,c,a,b,cin,clk);

    initial begin
        $monitor("s=%b,c=%b,a=%b, b=%b,cin=%b %t\n",s,c,a,b,cin,$time);
        $dumpfile("t_fully_pipelined_adder.lxt");
        $dumpvars(0, t_fully_pipelined_adder);
        clk = 0;
        a = 0;
        b = 0;
        cin = 0;
    #10 a = 4;
        b = 5;
        cin = 1;
    #10 a = 15;
        b = 4;
        cin = 0;
    #10 a = 8;
        b = 8;
        cin = 1;	
    #50 $finish;
    end
endmodule
