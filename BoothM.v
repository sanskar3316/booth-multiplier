module BoothMul (clk,rst,start,x,y,valid,z);

input clk;
input rst;
input start;
input signed [3:0]x,y;
output signed [7:0]z;
output valid;

reg signed[7:0]z,next_z,z_temp;
reg next_state,pres_state;
reg [1:0]temp,next_temp;
reg [1:0] count, next_count;
reg valid, next_valid;

parameter IDLE = 1'b0;
parameter START = 1'b1;

always @(posedge clk or negedge rst) 
   begin
    
    if(!rst)
        begin
            z <= 8'd0;
            valid <= 1'b0;
            pres_state <= 1'b0;
            temp <= 2'd0;
            count <= 2'd0;
        end
   else 
        begin
            z <= next_z;
            valid <= next_valid;
            pres_state <= next_state;
            temp <= next_temp;
            count <= next_count;
        end
end

always @(*) begin
    case(pres_state)
        IDLE:
        begin
           next_count = 2'b0;
           next_valid = 1'b0;
           if(start) 
                begin
                    next_state = START;
                    next_temp = {x[0],1'b0};
                    next_z = {4'd0,x};
                end
            else 
            begin
                next_state = pres_state;
                next_temp = 2'd0;
                next_z = 8'd0;
            end    
        end
        START:
        begin
            case(temp)
                2'b10:
                    z_temp = {z[7:4]-y,z[3:0]};
                2'b01:
                    z_temp = {z[7:4]+y,z[3:0]};
                default:
                    z_temp = {z[7:4],z[3:0]};
            endcase
            next_temp = {x[count+1],x[count]};
            next_count = count + 1'b1;
            next_z = z_temp >>> 1;
            next_valid = (&count)?1'b1:1'b0;
            next_state = (&count)?IDLE:pres_state;
        end
    endcase
end

endmodule