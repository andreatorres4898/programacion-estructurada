// DPTR.v
// Datapath Principal MIPS 32-bit – Fase 3
// Soporta instrucciones Tipo R, Tipo I y Tipo J (j, jal)
//
// Nuevos componentes respecto a Fase 2:
//   - Señales Jump y JumpLink desde UnidadDeControl
//   - Cálculo de dirección de salto: {PC+4[31:28], instr[25:0], 2'b00}
//   - MUX final de PC: pc_plus_4 → branch → jump
//   - MUX JAL registro destino: write_register normal o $ra (reg 31)
//   - MUX JAL dato de escritura: resultado normal o PC+4

module DPTR (
    input clk,
    input reset
);
    // ── Buses principales ──────────────────────────────────────────────
    wire [31:0] pc_in, pc_out, pc_plus_4;
    wire [31:0] instruction;

    // ── Señales de control ─────────────────────────────────────────────
    wire        RegDst, Branch, MemRead, MemToReg;
    wire        MemWrite, ALUSrc, RegWrite;
    wire        Jump, JumpLink;          // FASE 3
    wire [2:0]  ALUOp;

    // ── Banco de registros ─────────────────────────────────────────────
    wire [4:0]  write_reg_pre;   // Salida MUX RegDst (RT vs RD)
    wire [4:0]  write_register;  // Salida MUX JAL    (write_reg_pre vs 31)
    wire [31:0] read_data_1, read_data_2;
    wire [31:0] write_data_pre;  // Salida MUX MemToReg
    wire [31:0] write_data;      // Salida MUX JAL data (write_data_pre vs PC+4)

    // ── ALU ────────────────────────────────────────────────────────────
    wire [31:0] sign_ext_out, shift_left_out;
    wire [2:0]  ALUCtrl;
    wire [31:0] alu_in_2, alu_result;
    wire        Zero;

    // ── Memoria de datos ───────────────────────────────────────────────
    wire [31:0] mem_read_data;

    // ── Lógica de PC ───────────────────────────────────────────────────
    wire [31:0] branch_target;
    wire [31:0] jump_addr;        // FASE 3: dirección de salto J
    wire        pc_src;           // Branch AND Zero
    wire [31:0] pc_after_branch;  // Resultado tras MUX de branch
    // pc_in se asigna al final tras MUX de jump

    // ══════════════════════════════════════════════════════════════════
    // 1. Program Counter
    // ══════════════════════════════════════════════════════════════════
    PC pc_inst (
        .clk(clk), .reset(reset),
        .pc_in(pc_in), .pc_out(pc_out)
    );

    // ══════════════════════════════════════════════════════════════════
    // 2. Sumador  PC + 4
    // ══════════════════════════════════════════════════════════════════
    Adder add_pc_4 (
        .a(pc_out), .b(32'd4), .result(pc_plus_4)
    );

    // ══════════════════════════════════════════════════════════════════
    // 3. Memoria de Instrucciones
    // ══════════════════════════════════════════════════════════════════
    InstructionMemory inst_mem (
        .address(pc_out), .instruction(instruction)
    );

    // ══════════════════════════════════════════════════════════════════
    // 4. Unidad de Control  (ahora incluye Jump y JumpLink)
    // ══════════════════════════════════════════════════════════════════
    UnidadDeControl uc (
        .OpCode    (instruction[31:26]),
        .RegDst    (RegDst),
        .Branch    (Branch),
        .MemRead   (MemRead),
        .MemToReg  (MemToReg),
        .ALUOp     (ALUOp),
        .MemWrite  (MemWrite),
        .ALUSrc    (ALUSrc),
        .RegWrite  (RegWrite),
        .Jump      (Jump),
        .JumpLink  (JumpLink)
    );

    // ══════════════════════════════════════════════════════════════════
    // 5. MUX Registro Destino: RT (I-type) vs RD (R-type)
    // ══════════════════════════════════════════════════════════════════
    Mux2_1_5 mux_reg_dst (
        .In0(instruction[20:16]),  // RT
        .In1(instruction[15:11]),  // RD
        .Sel(RegDst),
        .Out(write_reg_pre)
    );

    // ══════════════════════════════════════════════════════════════════
    // 5b. MUX JAL: registro destino normal vs $ra (31)   [FASE 3]
    // ══════════════════════════════════════════════════════════════════
    Mux2_1_5 mux_jal_reg (
        .In0(write_reg_pre),
        .In1(5'd31),           // $ra
        .Sel(JumpLink),
        .Out(write_register)
    );

    // ══════════════════════════════════════════════════════════════════
    // 6. Banco de Registros
    // ══════════════════════════════════════════════════════════════════
    BR registros (
        .clk(clk),
        .W  (RegWrite),
        .AR1(instruction[25:21]),
        .AR2(instruction[20:16]),
        .AW (write_register),
        .DW (write_data),
        .DR1(read_data_1),
        .DR2(read_data_2)
    );

    // ══════════════════════════════════════════════════════════════════
    // 7. Extensor de Signo (16 → 32 bits)
    // ══════════════════════════════════════════════════════════════════
    SignExtend sign_ext (
        .in(instruction[15:0]), .out(sign_ext_out)
    );

    // ══════════════════════════════════════════════════════════════════
    // 8. MUX Fuente ALU: dato de registro vs inmediato extendido
    // ══════════════════════════════════════════════════════════════════
    Mux2_1_32 mux_alu_src (
        .In0(read_data_2),
        .In1(sign_ext_out),
        .Sel(ALUSrc),
        .Out(alu_in_2)
    );

    // ══════════════════════════════════════════════════════════════════
    // 9. Control de ALU
    // ══════════════════════════════════════════════════════════════════
    ALuControl alu_ctrl (
        .Funct  (instruction[5:0]),
        .ALUOp  (ALUOp),
        .ALUCtrl(ALUCtrl)
    );

    // ══════════════════════════════════════════════════════════════════
    // 10. ALU Principal
    // ══════════════════════════════════════════════════════════════════
    ALU alu_inst (
        .A      (read_data_1),
        .B      (alu_in_2),
        .ALUCtrl(ALUCtrl),
        .Result (alu_result),
        .Zero   (Zero)
    );

    // ══════════════════════════════════════════════════════════════════
    // 11. Memoria de Datos
    // ══════════════════════════════════════════════════════════════════
    Mem data_mem (
        .clk     (clk),
        .MemWrite(MemWrite),
        .MemRead (MemRead),
        .Addr    (alu_result),
        .DW      (read_data_2),
        .DR      (mem_read_data)
    );

    // ══════════════════════════════════════════════════════════════════
    // 12. MUX Write-Back: resultado ALU vs dato de memoria
    // ══════════════════════════════════════════════════════════════════
    Mux2_1_32 mux_mem_to_reg (
        .In0(alu_result),
        .In1(mem_read_data),
        .Sel(MemToReg),
        .Out(write_data_pre)
    );

    // ══════════════════════════════════════════════════════════════════
    // 12b. MUX JAL Write-Back: normal vs PC+4 (retorno)   [FASE 3]
    // ══════════════════════════════════════════════════════════════════
    Mux2_1_32 mux_jal_data (
        .In0(write_data_pre),
        .In1(pc_plus_4),       // Dirección de retorno para JAL
        .Sel(JumpLink),
        .Out(write_data)
    );

    // ══════════════════════════════════════════════════════════════════
    // 13. Lógica de Branch (BEQ)
    // ══════════════════════════════════════════════════════════════════
    ShiftLeft2 sl2 (
        .in(sign_ext_out), .out(shift_left_out)
    );
    Adder add_branch (
        .a(pc_plus_4), .b(shift_left_out), .result(branch_target)
    );
    assign pc_src = Branch & Zero;

    // MUX Branch: PC+4 vs Branch Target
    Mux2_1_32 mux_pc_branch (
        .In0(pc_plus_4),
        .In1(branch_target),
        .Sel(pc_src),
        .Out(pc_after_branch)
    );

    // ══════════════════════════════════════════════════════════════════
    // 14. Cálculo de dirección de salto J  [FASE 3]
    //     jump_addr = { PC+4[31:28], instr[25:0], 2'b00 }
    // ══════════════════════════════════════════════════════════════════
    assign jump_addr = {pc_plus_4[31:28], instruction[25:0], 2'b00};

    // ══════════════════════════════════════════════════════════════════
    // 15. MUX Final PC: secuencial/branch  vs  Jump Address  [FASE 3]
    // ══════════════════════════════════════════════════════════════════
    Mux2_1_32 mux_jump (
        .In0(pc_after_branch),
        .In1(jump_addr),
        .Sel(Jump),
        .Out(pc_in)
    );

endmodule
