module Mem (
    input clk,
    input MemWrite,
    input MemRead,
    input [31:0] Addr,
    input [31:0] DW,
    output [31:0] DR
);
    reg [31:0] mem [0:63];
    integer i;
    
    initial begin
        for (i = 0; i < 64; i = i + 1) mem[i] = 32'd0;
    end

    assign DR = (MemRead) ? mem[Addr[7:2]] : 32'd0;

    always @(posedge clk) begin
        if (MemWrite) mem[Addr[7:2]] <= DW;
    end
endmodule