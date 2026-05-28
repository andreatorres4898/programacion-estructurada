// InstructionMemory.v
// Memoria ROM de instrucciones MIPS (64 palabras x 32 bits)

module InstructionMemory #(
    parameter MEM_FILE = "TestF3_MemInst.mem"
)(
    input  [31:0] address,
    output [31:0] instruction
);
    reg [31:0] mem [0:63];

    initial begin
    
        $readmemb("C:/Users/Usuario/Downloads/fase3ac/fase 3/TestF3_MemInst.mem", mem);
    end

    // Conversión de dirección de bytes a dirección de palabras
    assign instruction = mem[address[7:2]];

endmodule