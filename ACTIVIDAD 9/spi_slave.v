module SLAVE (
    input clk, // Reloj rápido de la FPGA para sincronizar
    input sclk,
    input mosi,
    output reg miso,
    input cs_n,
    input [7:0] tx_data, // Dato que el esclavo enviará al maestro
    output reg [7:0] rx_data,
    output reg done_pulse
);

    reg [2:0] sclk_sync; // Para detectar flancos
    reg [3:0] bit_cnt;
    reg [7:0] shift_reg;

    // Detectores de flanco para sclk
    wire sclk_posedge = (sclk_sync[2:1] == 2'b01);
    wire sclk_negedge = (sclk_sync[2:1] == 2'b10);

    always @(posedge clk) begin
        sclk_sync <= {sclk_sync[1:0], sclk};
        
        if (cs_n) begin
            bit_cnt <= 0;
            done_pulse <= 0;
            miso <= 0;
        end else begin
            // En flanco de subida: El esclavo LEE del Maestro
            if (sclk_posedge) begin
                shift_reg <= {shift_reg[6:0], mosi};
                if (bit_cnt == 7) begin
                    rx_data <= {shift_reg[6:0], mosi};
                    done_pulse <= 1;
                end else begin
                    bit_cnt <= bit_cnt + 1;
                    done_pulse <= 0;
                end
            end
            
            // En flanco de bajada: El esclavo PONE su dato para el Maestro
            if (sclk_negedge) begin
                // Si acabamos de empezar, cargamos el dato a enviar
                if (bit_cnt == 0) shift_reg <= tx_data; 
                miso <= shift_reg[7];
            end
        end
    end
endmodule
