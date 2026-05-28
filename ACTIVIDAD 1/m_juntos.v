module m_juntos (input a,input b,output and_g,output nand_g,output or_g,output nor_g,output not_g,output xor_g,output xnor_g);

    // AND
    assign and_g  = a & b;

    // NAND
    assign nand_g = ~(a & b);

    // OR
    assign or_g   = a | b;

    // NOR
    assign nor_g  = ~(a | b);

    // NOT 
    assign not_g  = ~a;

    // XOR
    assign xor_g  = a ^ b;

    // XNOR
    assign xnor_g = ~(a ^ b);

endmodule