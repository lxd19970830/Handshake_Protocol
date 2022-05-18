module Handshake_Protocol#(
    parameter   a = 3
)(
    input   clk, 
    input   rst_n,
    //upsteam
    input   valid_i, 
    output  ready_o, 
    //downsteam     
    output  valid_o, 
    input   ready_i, 
    //data     
    input   [a-1:0]din, 
    output  reg [a-1:0]dout
);

reg     full;
wire    wr_en;

always @(posedge clk or negedge rst_n)begin
    if(rst_n == 1'b0)begin
        dout <= 0;
        full <= 0;
    end
    else if(wr_en == 1'b1)begin
        if(valid_i == 1'b1)begin
            full <= 1;
            dout <= din;
        end
        else begin
            full <= 0;
            dout <= dout;
        end
    end
    else begin
        full <= full;
        dout <= dout;
    end
end

assign  wr_en = ~full | ready_i ;

assign  valid_o = full;
assign  ready_o = wr_en;

endmodule