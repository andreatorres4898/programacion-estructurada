module ALuControl (
    input  [5:0] Funct,
    input  [2:0] ALUOp,
    output reg [2:0] ALUCtrl
);
    always @* begin
        case (ALUOp)
            3'b000: ALUCtrl = 3'b010; // lw, sw, addi -> Fuerzan Suma (ADD)
            3'b001: ALUCtrl = 3'b110; // beq -> Fuerza Resta (SUB) para comparar
            3'b011: ALUCtrl = 3'b111; // slti -> Fuerza SLT
            3'b100: ALUCtrl = 3'b000; // andi -> Fuerza AND
            3'b101: ALUCtrl = 3'b001; // ori -> Fuerza OR
            3'b010: begin // Tipo R -> Depende completamente del campo Funct
                case (Funct)
                    6'b100000: ALUCtrl = 3'b010; // ADD
                    6'b100010: ALUCtrl = 3'b110; // SUB
                    6'b100100: ALUCtrl = 3'b000; // AND
                    6'b100101: ALUCtrl = 3'b001; // OR
                    6'b101010: ALUCtrl = 3'b111; // SLT
                    default:   ALUCtrl = 3'b010;
                endcase
            end
            default: ALUCtrl = 3'b010;
        endcase
    end
endmodule