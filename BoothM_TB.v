`timescale 1ns/1ns
`include "BoothM.v"

module BoothMul_TB;

reg clk, rst, start;
reg signed [3:0] x, y;
wire signed [7:0] z;
wire valid;

always #5 clk = ~clk;

BoothMul uut (
    .clk(clk),
    .rst(rst),
    .start(start),
    .x(x),
    .y(y),
    .z(z),
    .valid(valid)
);

initial 
begin
    $dumpfile("BoothMul.vcd");
    $dumpvars(0, BoothMul_TB);
    
    
    x = 3;
    y = 6;
    clk = 1'b1;
    rst = 1'b0;
    start = 1'b0;
    
   
    #10 rst = 1'b1;
    #10 start = 1'b1;
    #10 start = 1'b0;
    
    
    wait (valid);
    #10 $display("x = %d, y = %d, z = %d", x, y, z);
    
    
    #100 $finish;
end

endmodule
