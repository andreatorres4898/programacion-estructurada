

module master(input clk,input mosi,output ss,output miso);
endmodule
module slave(input clk,input mosi,input ss,output miso);
endmodule
module spi_top( input CLK);
wire c1,c2,c3;
//instanciar master
master puppeter (.clk(CLK),.miso(c3),.mosi(c1),.ss(c2));
slave mupet(.clk(CLK),.mosi(c1),.miso(c3),.ss(c2));
endmodule