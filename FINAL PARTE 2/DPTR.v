module BR (
    input clk,
    input W,               
    input [4:0] AR1,        
    input [4:0] AR2,       
    input [4:0] AW,        
    input [31:0] DW,        
    output [31:0] DR1,  
    output [31:0] DR2  
);
    reg [31:0] mem [0:31];
    integer i;

    initial begin
        for(i=0; i<32; i=i+1) mem[i] = 32'd0;
        // Valores de prueba iniciales
        mem[1] = 32'd10; mem[2] = 32'd20;
        mem[3] = 32'd30; mem[4] = 32'd40;
    end

    assign DR1 = mem[AR1];
    assign DR2 = mem[AR2];

    always @(posedge clk) begin
        if (W && AW != 5'd0) begin
            mem[AW] <= DW;
        end
    end
endmodule
