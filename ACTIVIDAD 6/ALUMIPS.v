module ALUMIPS ( input [31:0] A,input [31:0]B , input [3:0] Sel,output [31:0] Resultado );
    wire [32:0] w_suma;
    wire [32:0] w_resta;
    wire [32:0] w_or;
    wire [32:0] w_and;
    wire [32:0] w_slt;
    sum_com32b mod_suma (.So1(A), .So2(B), .AC(1'b0), .R5(w_suma));
   
    R32comp mod_resta ( .Ro1(A), .Ro2(B), .RR(w_resta));
   
    OR32comp mod_or ( .Oo1(A), .Oo2(B), .RO(w_or) );

    AND32comp mod_and ( .Ao1(A), .Ao2(B), .AR(w_and) );
   
    STL32 mod_slt (.Slto1(A), .Slto2(B), .Rslt(w_slt));

    mux5a1 mi_mux (
        .SUMA(w_suma[31:0]),
        .RESTA(w_resta[31:0]),
        .OR(w_or[31:0]),
        .AND(w_and[31:0]),
        .SLT(w_slt[31:0]),
        .ALUctl(Sel),
        .R(Resultado)
    );

endmodule