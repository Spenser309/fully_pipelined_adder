/* file: fully_pipelined_adder.v
 * Engineer: Spenser Gilliland <Spenser309@gmail.com>
 * Company: IIT ECASP Lab
 * Date: 10/20/2011
 */

module dff(q,d,clk);
    parameter integer WIDTH = 1;
    output reg [WIDTH-1:0] q;
    input wire [WIDTH-1:0] d;
    input wire clk;
    
    always @(posedge clk)
        q <= d;
        
endmodule

module fulladder(c,s,a,b,cin);
    output wire c, s;
    input wire a, b, cin;
    wire t;
    
    /* Prevent additional logic from being instantitated */
    assign t = a^b;
    assign c = (cin & t) | (a & b);
    assign s = t^cin;
    
endmodule

module fully_pipelined_adder(s,c,a,b,cin,clk);
    parameter integer WIDTH = 4;   /* Width of Operands */

    output wire [WIDTH-1:0] s; /* Sum of operands valid after #(latency) cycles */
    output wire c;             /* Carry out */
    
    input wire [WIDTH-1:0] a, b; /* Operands */
    input wire cin;              /* Carry in */
    input wire clk;
    
    wire [WIDTH-1:0] a_d [WIDTH:0]; /* The WIDTH array element is the results at the end of the pipeline */
    wire [WIDTH-1:0] b_d [WIDTH-1:0]; /* Not all of the bits are used */
    wire             c_d [WIDTH:0]; /* The WIDTH array element is the results at the end of the pipeline */ 
    
    
    
    /* Input to the pipeline */
    assign a_d[0] = a;
    assign b_d[0] = b;
    assign c_d[0] = cin;
    
    genvar i, j;
    generate
        for(i = 0; i < WIDTH; i = i+1) begin: comp_gen
            /* For each pipeline stage in a pipelined adder */
            wire [WIDTH-1:0] a_q;
            wire [WIDTH-1:i] b_q;
            wire c_q;
            wire s_i;
            
            /* A total of 2*WIDTH-i+1 Registers are needed per stage*/
            dff #(WIDTH)   a_dff(a_q, a_d[i], clk);
            dff #(WIDTH-i) b_dff(b_q, b_d[i][WIDTH-1:i], clk);
            dff #(1)       c_dff(c_q, c_d[i], clk);
            
            /* And a Full Adder */
            fulladder u_add(c_d[i+1], s_i, a_q[i], b_q[i], c_q);
            
            /* For all other bits of A except the current bit copy from a_q */
            for(j=0; j < WIDTH; j = j+1) begin: comp_a_d
                if(j == i)
                    assign a_d[i+1][j] = s_i;
                else
                    assign a_d[i+1][j] = a_q[j];
            end
            
            if( i != WIDTH-1)
                assign b_d[i+1][WIDTH-1:i+1] = b_q[WIDTH-1:i+1]; /* Don't copy the current bit */
        end
    endgenerate
    
    /* Output of the pipeline */
    assign s = a_d[WIDTH];
    assign c = c_d[WIDTH];
endmodule

