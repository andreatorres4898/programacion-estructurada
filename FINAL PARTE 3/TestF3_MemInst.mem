`timescale 1ns/1ps
// TB_DPTR.v
// Testbench para MIPS Datapath – Fase 3 (Instrucciones Tipo J)

module TB_DPTR;
    reg clk;
    reg reset;

    // Instancia del Datapath principal
    DPTR dut (
        .clk(clk),
        .reset(reset)
    );

    // Generador de reloj: periodo de 10 ns
    always #5 clk = ~clk;

    initial begin
        clk   = 0;
        reset = 1;

        $display("====================================================================================================================");
        $display(" TESTBENCH - MIPS DATAPATH FASE 3 (Instrucciones Tipo J: J y JAL)");
        $display("====================================================================================================================");
        $display("Time | PC   | Instruccion                      | Jump | JAL | AW(Reg) | DW(Data)   | RS(D1) | RT(D2) | ALURes");
        $display("--------------------------------------------------------------------------------------------------------------------");

        // Liberar reset después de 1 ciclo
        #10 reset = 0;
        
        // 3000 ns de simulación para dar tiempo a que el bucle de la raíz termine
        #3000;
        
        $display("========================================== FIN DE LA SIMULACION ====================================================");
        $finish;
    end

    // Monitor en flanco de bajada (señales ya estabilizadas)
    always @(negedge clk) begin
        if (!reset) begin
            $display("%4t | %-4d | %b |   %b  |  %b  |   %-2d    | %-10d | %-6d | %-6d | %-6d",
                $time,
                dut.pc_out,
                dut.instruction,
                dut.Jump,               // Demuestra el salto
                dut.JumpLink,           // Demuestra la llamada a subrutina
                dut.write_register,     // FASE 3: Demuestra si escribe en reg 31
                $signed(dut.write_data),// FASE 3: Muestra si está guardando PC+4
                $signed(dut.read_data_1),
                $signed(dut.read_data_2),
                $signed(dut.alu_result)
            );
        end
    end

endmodule
