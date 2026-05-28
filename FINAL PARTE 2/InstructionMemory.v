module DPTR (
    input clk,
    input reset
);
    // Wires internos de interconexión
    wire [31:0] pc_in, pc_out, pc_plus_4;
    wire [31:0] instruction;
    
    wire RegDst, Branch, MemRead, MemToReg, MemWrite, ALUSrc, RegWrite;
    wire [2:0] ALUOp;
    
    wire [4:0] write_register;
    wire [31:0] read_data_1, read_data_2, write_data;
    
    wire [31:0] sign_ext_out, shift_left_out;
    wire [2:0] ALUCtrl;
    wire [31:0] alu_in_2, alu_result;
    wire Zero;
    
    wire [31:0] mem_read_data;
    wire [31:0] branch_target;
    wire pc_src;

    // 1. Program Counter
    PC pc_inst (.clk(clk), .reset(reset), .pc_in(pc_in), .pc_out(pc_out));

    // 2. Sumador PC + 4
    Adder add_pc_4 (.a(pc_out), .b(32'd4), .result(pc_plus_4));

    // 3. Memoria de Instrucciones
    InstructionMemory inst_mem (.address(pc_out), .instruction(instruction));

    // 4. Unidad de Control
    UnidadDeControl uc (
        .OpCode(instruction[31:26]),
        .RegDst(RegDst),
        .Branch(Branch),
        .MemRead(MemRead),
        .MemToReg(MemToReg),
        .ALUOp(ALUOp),
        .MemWrite(MemWrite),
        .ALUSrc(ALUSrc),
        .RegWrite(RegWrite)
    );

    // 5. MUX: Selección de registro destino
    Mux2_1_5 mux_reg_dst (
        .In0(instruction[20:16]),
        .In1(instruction[15:11]),
        .Sel(RegDst),
        .Out(write_register)
    );

    // 6. Banco de Registros
    BR registros (
        .clk(clk),
        .W(RegWrite),
        .AR1(instruction[25:21]),
        .AR2(instruction[20:16]),
        .AW(write_register),
        .DW(write_data),
        .DR1(read_data_1),
        .DR2(read_data_2)
    );

    // 7. Extensor de Signo
    SignExtend sign_ext (.in(instruction[15:0]), .out(sign_ext_out));

    // 8. MUX: Selección de fuente para ALU
    Mux2_1_32 mux_alu_src (
        .In0(read_data_2),
        .In1(sign_ext_out),
        .Sel(ALUSrc),
        .Out(alu_in_2)
    );

    // 9. Control de ALU
    ALuControl alu_ctrl (
        .Funct(instruction[5:0]),
        .ALUOp(ALUOp), // Ahora pasa los 3 bits completos directos de la UC
        .ALUCtrl(ALUCtrl)
    );

    // 10. ALU principal
    ALU alu_inst (
        .A(read_data_1),
        .B(alu_in_2),
        .ALUCtrl(ALUCtrl),
        .Result(alu_result),
        .Zero(Zero)
    );

    // 11. Memoria de Datos
    Mem data_mem (
        .clk(clk),
        .MemWrite(MemWrite),
        .MemRead(MemRead),
        .Addr(alu_result),
        .DW(read_data_2),
        .DR(mem_read_data)
    );

    // 12. MUX: Write back hacia el banco de registros
    Mux2_1_32 mux_mem_to_reg (
        .In0(alu_result),
        .In1(mem_read_data),
        .Sel(MemToReg),
        .Out(write_data)
    );

    // 13. Desplazamiento a la izquierda para Branching
    ShiftLeft2 sl2 (.in(sign_ext_out), .out(shift_left_out));

    // 14. Sumador para el cálculo de la dirección Branch Target
    Adder add_branch (.a(pc_plus_4), .b(shift_left_out), .result(branch_target));

    // 15. Compuerta AND y MUX para actualización de PC 
    assign pc_src = Branch & Zero;

    Mux2_1_32 mux_pc_src (
        .In0(pc_plus_4),
        .In1(branch_target),
        .Sel(pc_src),
        .Out(pc_in)
    );

endmodule
