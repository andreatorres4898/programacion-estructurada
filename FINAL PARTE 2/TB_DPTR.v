// Sumador genérico
module Adder (
    input  [31:0] a,
    input  [31:0] b,
    output [31:0] result
);
    assign result = a + b;
endmodule

// Extensor de signo (16 bits a 32 bits)
module SignExtend (
    input  [15:0] in,
    output [31:0] out
);
    assign out = {{16{in[15]}}, in};
endmodule

// Shift Left 2
module ShiftLeft2 (
    input  [31:0] in,
    output [31:0] out
);
    assign out = in << 2;
endmodule

// Multiplexor 2:1 para direcciones de 5 bits (Write Register)
module Mux2_1_5 (
    input  [4:0] In0,
    input  [4:0] In1,
    input        Sel,
    output [4:0] Out
);
    assign Out = (Sel == 1'b1) ? In1 : In0;
endmodule