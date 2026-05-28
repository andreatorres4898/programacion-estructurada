// Mux2_1_32.v
// Multiplexor 2:1 de 32 bits

module Mux2_1_32 (
    input  [31:0] In0,
    input  [31:0] In1,
    input         Sel,
    output [31:0] Out
);

    assign Out = (Sel == 1'b1) ? In1 : In0;

endmodule
