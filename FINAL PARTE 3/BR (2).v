// ALU.v
// Unidad Aritmetico-Logica para MIPS Tipo R
// Operaciones: ADD=010, SUB=110, AND=000, OR=001, SLT=111

module ALU (
    input  [31:0] A,
    input  [31:0] B,
    input  [2:0]  ALUCtrl,
    output reg [31:0] Result,
    output Zero
);

    assign Zero = (Result == 32'd0) ? 1'b1 : 1'b0;

    always @* begin
        case (ALUCtrl)
            3'b000: Result = A & B;
            3'b001: Result = A | B;
            3'b010: Result = A + B;
            3'b110: Result = A - B;
            3'b111: Result = ($signed(A) < $signed(B)) ? 32'd1 : 32'd0;
            default: Result = 32'd0;
        endcase
    end

endmodule
