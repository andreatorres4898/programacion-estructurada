module STL32(input [31:0] Slto1,input [31:0] Slto2 ,output [32:0] Rslt);

assign Rslt = Slto1< Slto2 ? 1:0;


endmodule





