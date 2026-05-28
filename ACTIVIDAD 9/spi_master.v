module MASTER (
    input clk,          // Reloj de la FPGA (ej. 50MHz)
    input reset,
    input start,
    input [7:0] tx_data,
    output reg [7:0] rx_data,
    output reg mosi,
    input miso,
    output reg sclk,
    output reg cs_n,
    output reg busy
);

    localparam IDLE = 0, START = 1, LOW = 2, HIGH = 3, STOP = 4;
    reg [2:0] state;
    reg [3:0] bit_cnt;
    reg [7:0] shift_reg;
    
    // Divisor de reloj simple (ajusta DIVIDER para cambiar la velocidad)
    reg [7:0] clk_div;
    localparam DIVIDER = 50; // 50MHz / 50 = 1MHz SCLK

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
            cs_n <= 1;
            busy <= 0;
            sclk <= 0;
        end else begin
            case (state)
                IDLE: begin
                    busy <= 0;
                    cs_n <= 1;
                    if (start) begin
                        shift_reg <= tx_data;
                        state <= START;
                        busy <= 1;
                    end
                end

                START: begin
                    cs_n <= 0;
                    bit_cnt <= 0;
                    clk_div <= 0;
                    state <= LOW;
                end

                LOW: begin
                    sclk <= 0;
                    mosi <= shift_reg[7]; // Enviamos MSB
                    if (clk_div == DIVIDER/2) begin
                        clk_div <= 0;
                        state <= HIGH;
                    end else clk_div <= clk_div + 1;
                end

                HIGH: begin
                    sclk <= 1;
                    if (clk_div == DIVIDER/2) begin
                        clk_div <= 0;
                        // Capturamos MISO en el flanco de subida
                        shift_reg <= {shift_reg[6:0], miso};
                        if (bit_cnt == 7) state <= STOP;
                        else begin
                            bit_cnt <= bit_cnt + 1;
                            state <= LOW;
                        end
                    end else clk_div <= clk_div + 1;
                end

                STOP: begin
                    sclk <= 0;
                    rx_data <= shift_reg;
                    state <= IDLE;
                end
            endcase
        end
    end
endmodule
