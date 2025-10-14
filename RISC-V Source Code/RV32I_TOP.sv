`timescale 1ns / 1ps
module RV32I_TOP (
    input logic clk,
    input logic reset
);
    logic [31:0] instr_code, instr_rAddr;
    logic [31:0] dAddr, dWdata, rdata;
    logic d_wr_en;
    logic [1:0] byte_en;
    logic [2:0] funct3_wire;

    RV32I_Core U_RV23I_CPU (
        .*,
        .rdata(rdata),
        .funct3_out(funct3_wire)
    );
    instr_mem U_Instr_Mem (.*);
    data_mem U_Data_Mem (
        .clk(clk),
        .d_wr_en(d_wr_en),
        .dAddr(dAddr),
        .dWdata(dWdata),
        .byte_en(byte_en),
        .dRdata(rdata),
        .funct3_in(funct3_wire)
    );


endmodule

module RV32I_Core (
    input  logic        clk,
    input  logic        reset,
    input  logic [31:0] instr_code,
    input  logic [31:0] rdata,
    output logic [31:0] instr_rAddr,
    output logic        d_wr_en,
    output logic [31:0] dAddr,
    output logic [31:0] dWdata,
    output logic [ 2:0] funct3_out,
    output logic [ 1:0] byte_en
);
    logic [3:0] alu_controls;
    logic reg_wr_en, w_aluSrcMux,  mux2waddr_sel;
    logic [2:0] w_reg_wdata_sel;
    logic branch;
    logic jal, jalr_jal_mux_sel;


    control_unit U_Control_Unit (
        .instr_code   (instr_code),
        .alu_controls (alu_controls),
        .aluSrcMuxSel (w_aluSrcMux),
        .reg_wr_en    (reg_wr_en),
        .d_wr_en      (d_wr_en),
        .byte_en      (byte_en),
        .funct3_out   (funct3_out),
        .reg_wdata_sel(w_reg_wdata_sel),
        .branch       (branch),
        .jal(jal),
        .jalr_jal_mux_sel(jalr_jal_mux_sel)




    );
    datapath U_Data_Path (
        .clk          (clk),
        .reset        (reset),
        .instr_code   (instr_code),
        .alu_controls (alu_controls),
        .reg_wr_en    (reg_wr_en),
        .aluSrcMuxSel (w_aluSrcMux),
        .instr_rAddr  (instr_rAddr),
        .reg_wdata_sel(w_reg_wdata_sel),
        .jal(jal),
        .jalr_jal_mux_sel(jalr_jal_mux_sel),
        .rdata        (rdata),
        .dWdata       (dWdata),
        .dAddr        (dAddr),
        .branch       (branch)

    );
endmodule
