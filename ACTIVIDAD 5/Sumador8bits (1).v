module Sumador8bits(
    input [7:0] A,
    input [7:0] B,
    output [8:0] S
);

wire c1,c2,c3,c4,c5,c6,c7;

FA fa0(A[0],B[0],1'b0,S[0],c1);
FA fa1(A[1],B[1],c1,S[1],c2);
FA fa2(A[2],B[2],c2,S[2],c3);
FA fa3(A[3],B[3],c3,S[3],c4);
FA fa4(A[4],B[4],c4,S[4],c5);
FA fa5(A[5],B[5],c5,S[5],c6);
FA fa6(A[6],B[6],c6,S[6],c7);
FA fa7(A[7],B[7],c7,S[7],S[8]);

endmodule


