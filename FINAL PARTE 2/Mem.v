module InstructionMemory (
    input [31:0] address,
    output [31:0] instruction
);
    // Declaración de la matriz de memoria ROM: 64 palabras de 32 bits cada una
    reg [31:0] mem [0:63]; 

    initial begin
        
        $readmemb("C:/Users/Usuario/Downloads/Ractualizado/TestF2_MemInst.txt", mem);
    end

    // Asignación continua con conversión de alineación de bytes a palabras
    assign instruction = mem[address[7:2]];
endmodule