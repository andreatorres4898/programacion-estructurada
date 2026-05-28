module spi_system_top (
    input clk,          // Reloj global (ej. 50MHz)
    input reset,
    input start,        // Pulso para iniciar la transferencia
    
    // Datos a enviar
    input [7:0] master_data_to_send,
    input [7:0] slave_data_to_send,
    
    // Datos recibidos (para observar en simulación o LEDs)
    output [7:0] master_data_received,
    output [7:0] slave_data_received,
    
    output master_busy,
    output slave_done
);

    // --- Cables Internos (El "Cableado" del Bus SPI) ---
    wire spi_sclk;
    wire spi_mosi;
    wire spi_miso;
    wire spi_cs_n;

    // --- Instancia del Maestro ---
    spi_master u_master (
        .clk(clk),
        .reset(reset),
        .start(start),
        .tx_data(master_data_to_send),
        .rx_data(master_data_received),
        .mosi(spi_mosi),    // Sale del maestro
        .miso(spi_miso),    // Entra al maestro
        .sclk(spi_sclk),    // Sale del maestro
        .cs_n(spi_cs_n),    // Sale del maestro
        .busy(master_busy)
    );

    // --- Instancia del Esclavo ---
    spi_slave u_slave (
        .clk(clk),          // El esclavo también usa el reloj rápido para sincronizar
        .sclk(spi_sclk),    // Entra desde el maestro
        .mosi(spi_mosi),    // Entra desde el maestro
        .miso(spi_miso),    // Sale hacia el maestro
        .cs_n(spi_cs_n),    // Entra desde el maestro
        .tx_data(slave_data_to_send),
        .rx_data(slave_data_received),
        .done_pulse(slave_done)
    );

endmodule
