module Sumador4bits(
    input [3:0] A,
    input [3:0] B,
    output [4:0] S
);

wire c1,c2,c3;

// FA(bitA, bitB, Cin, Suma, Cout)

FA fa0(A[0], B[0], 1'b0, S[0], c1);
FA fa1(A[1], B[1], c1,   S[1], c2);
FA fa2(A[2], B[2], c2,   S[2], c3);
FA fa3(A[3], B[3], c3,   S[3], S[4]);

endmodule


