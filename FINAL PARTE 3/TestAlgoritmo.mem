// soporte.v
// Módulos de apoyo compartidos del Datapath MIPS
// Contenido: Adder, SignExtend, ShiftLeft2, Mux2_1_5

// ─────────────────────────────────────────────
// Sumador genérico de 32 bits
// ─────────────────────────────────────────────
module Adder (
    input  [31:0] a,
    input  [31:0] b,
    output [31:0] result
);
    assign result = a + b;
endmodule

// ─────────────────────────────────────────────
// Extensor de signo: 16 bits → 32 bits
// ─────────────────────────────────────────────
module SignExtend (
    input  [15:0] in,
    output [31:0] out
);
    assign out = {{16{in[15]}}, in};
endmodule

// ─────────────────────────────────────────────
// Desplazador lógico a la izquierda 2 bits
// Usado para calcular dirección de branch
// ─────────────────────────────────────────────
module ShiftLeft2 (
    input  [31:0] in,
    output [31:0] out
);
    assign out = in << 2;
endmodule

// ─────────────────────────────────────────────
// Multiplexor 2:1 de 5 bits
// Usado para selección de registro destino (RegDst) y JAL ($ra)
// ─────────────────────────────────────────────
module Mux2_1_5 (
    input  [4:0] In0,
    input  [4:0] In1,
    input        Sel,
    output [4:0] Out
);
    assign Out = (Sel == 1'b1) ? In1 : In0;
endmodule
