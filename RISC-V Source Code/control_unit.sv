`timescale 1ns / 1ps

`include "define.sv"

module control_unit (
    input  logic [31:0] instr_code,
    output logic [ 3:0] alu_controls,
    output logic        aluSrcMuxSel,
    output logic        reg_wr_en,
    output logic        d_wr_en,
    output logic [ 2:0] reg_wdata_sel,
    output logic [ 1:0] byte_en,
    output logic [ 2:0] funct3_out,
    output logic        branch,
    output logic        jal,
    output logic        jalr_jal_mux_sel
);


    wire  [6:0] funct7 = instr_code[31:25];
    wire  [2:0] funct3 = instr_code[14:12];
    wire  [6:0] opcode = instr_code[6:0];


    logic [8:0] controls;

    assign funct3_out = funct3;
    assign {reg_wr_en, jal, jalr_jal_mux_sel, aluSrcMuxSel, reg_wdata_sel, d_wr_en, branch} = controls;

    always_comb begin
        case (opcode)
            `OP_R_TYPE:  controls = 9'b1_0_0_0_000_0_0;
            `OP_S_TYPE:  controls = 9'b0_0_0_1_000_1_0;
            `OP_IL_TYPE: controls = 9'b1_0_0_1_001_0_0;
            `OP_I_TYPE:  controls = 9'b1_0_0_1_000_0_0;
            `OP_B_TYPE:  controls = 9'b0_0_0_0_000_0_1;
            `OP_UL_TYPE: controls = 9'b1_0_0_0_010_0_0;
            `OP_UA_TYPE: controls = 9'b1_0_0_0_011_0_0;
            `OP_J_TYPE:  controls = 9'b1_1_0_0_100_0_0;
            `OP_JA_TYPE: controls = 9'b1_1_1_0_100_0_0;
            default:     controls = 9'b0_0_0_0_000_0_0;
        endcase
    end




    always_comb begin
        case (opcode)
            `OP_R_TYPE: alu_controls = {funct7[5], funct3};
            `OP_S_TYPE: alu_controls = `ADD;
            `OP_IL_TYPE: alu_controls = `ADD;
            `OP_I_TYPE: begin
                case (funct3)
                   3'h5 : alu_controls = {funct7[5], funct3};
                    default: alu_controls = {1'b0,funct3};
                endcase
            end
            `OP_B_TYPE: alu_controls = {1'b0,funct3}; // B-type
            `OP_UL_TYPE: alu_controls = `ADD;
            `OP_UA_TYPE: alu_controls = `ADD;
            `OP_J_TYPE : alu_controls = `ADD;
            `OP_JA_TYPE : alu_controls = `ADD;
            default:    alu_controls = 4'bx;
        endcase
    end






    always_comb begin
        if (opcode == `OP_S_TYPE && d_wr_en) begin
            case (funct3)
                3'b000: begin  // store byte
                    byte_en = 2'b01;
                end
                3'b001: begin  // store half
                    byte_en = 2'b10;
                end
                3'b010: begin  //store word
                    byte_en = 2'b11;
                end
                default: byte_en = 2'b00;
            endcase
        end else begin
            byte_en = 2'b00;
        end
    end



endmodule
