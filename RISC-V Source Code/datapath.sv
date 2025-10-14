`timescale 1ns / 1ps

`include "define.sv"

module datapath (
    input logic clk,
    input logic reset,
    input logic [31:0] instr_code,  // Rom에서 명령어를 받아오고
    input logic [3:0] alu_controls,
    input logic reg_wr_en,
    input logic aluSrcMuxSel,
    input logic [2:0] reg_wdata_sel,
    input logic branch,
    input logic [31:0] rdata,
    input logic jal,
    input logic jalr_jal_mux_sel,
    output logic [31:0] instr_rAddr,
    output logic [31:0] dAddr,
    output logic [31:0] dWdata
);

    logic [31:0] w_regfile_rd1, w_regfile_rd2, w_alu_result;
    logic [31:0] w_imm_Ext, w_aluSrcMux_out, w_pc_MuxOut, w_pc_Next;
    logic [31:0] reg_wdata_out;
    logic pc_Muxsel, btaken;
    logic [31:0] w_pc;
    logic [31:0] w_jal_jalr_type, w_pc_imm_adder;
    logic [31:0] w_pc_4;

    assign pc_Muxsel = (jal|(branch & btaken)); // pc += imm을 하기위해서 

    assign dAddr = w_alu_result;
    assign dWdata = w_regfile_rd2;
    assign instr_rAddr = w_pc;


    // mux_2x1 U_REG_WDATA_sel (
    // .sel(reg_wdata_sel),
    // .x0 (w_alu_result),
    // .x1 (rdata),
    // .y  (reg_wdata_out)
    // );

    mux_5x1 U_MUX_Reg_Wdata (
        .sel(reg_wdata_sel),
        .x0 (w_alu_result),     // R-Type
        .x1 (rdata),            // IL Type : Load
        .x2 (w_imm_Ext),        // U-Type : lui
        .x3 (w_jal_jalr_type),  // U-Type : auipc
        .x4 (w_pc_4),           // JL, JA-Type : pc + 4
        .y  (reg_wdata_out)
    );



    ALU U_ALU (
        .a           (w_regfile_rd1),
        .b           (w_aluSrcMux_out),
        .alu_controls(alu_controls),
        .alu_result  (w_alu_result),
        .btaken      (btaken)
    );



    mux_2x1 U_ALU_SRC_MUX (
        .sel(aluSrcMuxSel),
        .x0 (w_regfile_rd2),   // 0: regFile R2
        .x1 (w_imm_Ext),       // 1: imm [31:0]
        .y  (w_aluSrcMux_out)  // to ALU R2

    );


    extend U_EXTEND (
        .instr_code(instr_code),
        .imm_Ext   (w_imm_Ext)
    );



    mux_2x1 U_MUX_jal_jalr (
        .sel(jalr_jal_mux_sel), // jal, jalr일때는 1 아니면 0
        .x0(w_pc),   // 0: pc현재값을 내보내서
        .x1(w_regfile_rd1),   //sel 1 이면  jalr이고 Rs1
        .y(w_pc_imm_adder)     // to ALU R2
    );

    pc_adder U_jal_jalr_ADDER (
        .a  (w_imm_Ext),
        .b  (w_pc_imm_adder),
        .sum(w_jal_jalr_type)
    );
    pc_adder U_PC_ADDER (
        .a  (32'h4),
        .b  (w_pc),
        .sum(w_pc_4)
    );

    mux_2x1 U_MUX2PC (
        .sel(pc_Muxsel), // jal, jalr, b-type 일때는 1 아니면 0
        .x0(w_pc_4),   // 0: regFile R2
        .x1(w_jal_jalr_type),   // 1: J-type일때
        .y(w_pc_Next)     // to ALU R2

    );


    program_counter U_PC (
        .clk    (clk),
        .reset  (reset),
        .pc_Next(w_pc_Next),
        .pc     (w_pc)
    );


    register_file U_REG_FILE (
        .clk      (clk),
        .RA1      (instr_code[19:15]),  // read address 1
        .RA2      (instr_code[24:20]),  // read address 2
        .WA       (instr_code[11:7]),   // write address
        .reg_wr_en(reg_wr_en),          // write enable
        .WData    (reg_wdata_out),      // write data
        .RD1      (w_regfile_rd1),      // read data 1
        .RD2      (w_regfile_rd2)       // read data 2
    );



endmodule


module program_counter (
    input  logic        clk,
    input  logic        reset,
    input  logic [31:0] pc_Next,
    output logic [31:0] pc
);

    register U_PC_REG (
        .clk  (clk),
        .reset(reset),
        .d    (pc_Next),
        .q    (pc)
    );
endmodule
module register (
    input  logic        clk,
    input  logic        reset,
    input  logic [31:0] d,
    output logic [31:0] q
);

    always_ff @(posedge clk, posedge reset) begin
        if (reset) begin
            q <= 0;
        end else begin
            q <= d;
        end
    end

endmodule

module register_file (
    input  logic        clk,
    input  logic [ 4:0] RA1,        // read address 1
    input  logic [ 4:0] RA2,        // read address 2
    input  logic [ 4:0] WA,         // write address
    input  logic        reg_wr_en,  // write enable
    input  logic [31:0] WData,      // write data
    output logic [31:0] RD1,        // read data 1
    output logic [31:0] RD2         // read data 2
);

    logic [31:0] reg_file[0:31];  // 32bit 32개.

    // initial begin
        // for (int i = 0; i < 5; i++) begin
            // reg_file[i] = 32'h0 + i;
        // end
        // for (int i = 5; i < 32; i++)begin
            // reg_file[i] = 4 - i;
        // end
    // end



    always_ff @(posedge clk) begin
        if (reg_wr_en) begin
            reg_file[WA] <= WData;
        end



    end
    // register address = 0 is zero to return
    assign RD1 = (RA1 != 0) ? reg_file[RA1] : 0;
    assign RD2 = (RA2 != 0) ? reg_file[RA2] : 0;

endmodule

module ALU (
    input logic [31:0] a,
    input logic [31:0] b,
    input logic [3:0] alu_controls,
    output logic [31:0] alu_result,
    output logic btaken
);

    always_comb begin
        case (alu_controls)
            `ADD:    alu_result = a + b;
            `SUB:    alu_result = a - b;
            `SLL:    alu_result = a << b[4:0];
            `SRL:    alu_result = a >> b[4:0];  // 0으로 extend
            `SRA:    alu_result = $signed(a) >>> b[4:0];
            `SLT:    alu_result = $signed(a) < $signed(b) ? 1 : 0;
            `SLTU:   alu_result = a < b ? 1 : 0;  //Unsigned SLT
            `XOR:    alu_result = a ^ b;  // xor
            `OR:     alu_result = a | b;
            `AND:    alu_result = a & b;
            default: alu_result = 32'bx;
        endcase
    end

    //branch 
    always_comb begin
        case (alu_controls[2:0])
            `BEQ:    btaken = ($signed(a) == $signed(b));
            `BNE:    btaken = ($signed(a) != $signed(b));
            `BLT:    btaken = ($signed(a) < $signed(b));
            `BGE:    btaken = ($signed(a) >= $signed(b));
            `BLTU:   btaken = ($unsigned(a) < $unsigned(b));
            `BGEU:   btaken = ($unsigned(a) >= $unsigned(b));
            default: btaken = 1'b0;  // 기본적으로는 4씩 증가해라
        endcase
    end

endmodule

module extend (
    input  logic [31:0] instr_code,
    output logic [31:0] imm_Ext
);


    wire [6:0] opcode = instr_code[6:0];
    //wire [2:0] funct3 = instr_code[14:12];
    //wire       funct7 = instr_code[30];

    always_comb begin
        case (opcode)
            `OP_R_TYPE: imm_Ext = 32'bx;
            // 20 literal 1b'0, imm[11:5] 7bit, imm[4:0] 5bit
            `OP_S_TYPE:
            imm_Ext = {
                {20{instr_code[31]}}, instr_code[31:25], instr_code[11:7]
            };

            // IL-type format: imm[11:0](31,20) | rs1(19,15) | funct3(14,12) | rd(11,7) | opcode(6,0)
            `OP_IL_TYPE: imm_Ext = {{20{instr_code[31]}}, instr_code[31:20]};

            // 여기서 하는 건 opcode를 보고 어떤 타입인지로 가서 
            // 그에 해당하는 immediate 상수값을 imm_Ext에 할당해서 output으로 사용하는 것이다.
            // I-type format: imm[11:0](31,20) | rs1(19,15) | funct3(14,12) | rd(11,7) | opcode(6,0)
            // 문제상황 : funct3의 값과 funct7(imm[5:11])에 따라서 shift 연산이 달라지기때문에
            // 여기 Extend에서 어떻게 처리를 할지
            // 두 번째 문제상황 : shift를 할 때 하위 5비트만 사용하기 때문에 
            // extend시킬 비트 자리수가 다른 곳이랑 다르다.

            // 그래서 어떻게 구별을 할 건데

            `OP_I_TYPE: imm_Ext = {{20{instr_code[31]}}, instr_code[31:20]};

            `OP_B_TYPE:
            imm_Ext = {
                {20{instr_code[31]}},
                instr_code[7],
                instr_code[30:25],
                instr_code[11:8],
                1'b0
            };

            `OP_UL_TYPE: imm_Ext = {instr_code[31:12], {12{1'b0}}};
            `OP_UA_TYPE: imm_Ext = {instr_code[31:12], {12{1'b0}}};
            `OP_J_TYPE:
            imm_Ext = {
                {12{instr_code[31]}},
                {instr_code[19:12]},
                {instr_code[20]},
                {instr_code[30:21]},
                1'b0
            };
            `OP_JA_TYPE: imm_Ext = {{20{instr_code[31]}}, instr_code[31:20]};



            default: imm_Ext = 32'bx;
        endcase
    end
endmodule

module mux_2x1 (
    input  logic        sel,
    input  logic [31:0] x0,   // 0: regFile R2
    input  logic [31:0] x1,   // 1: imm [31:0]
    output logic [31:0] y     // to ALU R2

);


    assign y = sel ? x1 : x0;

endmodule

module mux_5x1 (
    input  logic [ 2:0] sel,
    input  logic [31:0] x0,
    input  logic [31:0] x1,
    input  logic [31:0] x2,
    input  logic [31:0] x3,
    input  logic [31:0] x4,
    output logic [31:0] y
);

    always_comb begin
        case (sel)
            3'b000:  y = x0;
            3'b001:  y = x1;
            3'b010:  y = x2;
            3'b011:  y = x3;
            3'b100:  y = x4;
            default: y = 32'h0;
        endcase
    end

endmodule

module pc_adder (
    input  logic [31:0] a,
    input  logic [31:0] b,
    output logic [31:0] sum
);

    assign sum = a + b;

endmodule
