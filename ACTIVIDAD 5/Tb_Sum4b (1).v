`timescale 1ns/1ps
module Tb_Sum4b;

reg [3:0] A;
reg [3:0] B;
wire [4:0] S;

Sumador4bits uut (
    .A(A),
    .B(B),
    .S(S)
);

initial begin
    $display("===== SUMADOR 4 BITS =====");
    $display("A + B = Resultado");

    A=1; B=2; #10;
    $display("%d + %d = %d", A, B, S);

    A=3; B=4; #10;
    $display("%d + %d = %d", A, B, S);

    A=7; B=8; #10;
    $display("%d + %d = %d", A, B, S);

    A=5; B=6; #10;
    $display("%d + %d = %d", A, B, S);

    A=9; B=3; #10;
    $display("%d + %d = %d", A, B, S);

    $stop;
end

endmodule
