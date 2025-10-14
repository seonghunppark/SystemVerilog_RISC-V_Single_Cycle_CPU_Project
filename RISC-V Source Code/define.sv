`timescale 1ns / 1ps

// ALU COMMAND
`define ADD 4'b0000
`define SUB 4'b1000
`define SLL 4'b0001
`define SRL 4'b0101
`define SRA 4'b1101
`define SLT 4'b0010
`define SLTU 4'b0011
`define XOR 4'b0100
`define OR 4'b0110
`define AND 4'b0111

`define BEQ 3'b000
`define BNE 3'b001
`define BLT 3'b100
`define BGE 3'b101
`define BLTU 3'b110
`define BGEU 3'b111


// OPCODE
`define OP_R_TYPE 7'b0110011 // RD = RS2 + RS1
`define OP_S_TYPE 7'b0100011 // SW, SH, SB
`define OP_IL_TYPE 7'b0000011 // LW, LB, LH, LB(U), LH(U)
`define OP_I_TYPE 7'b0010011 // RD = RS1 + imm
`define OP_B_TYPE 7'b1100011 // brench : BEQ, BNE, BLT, BGE, BLTU, BGEU   
`define OP_UL_TYPE 7'b0110111 //Load Upper Imm
`define OP_UA_TYPE 7'b0010111 // Add Upper Imm to PC
`define OP_J_TYPE 7'b1101111 // jal : rd = pc + 4, pc += imm
`define OP_JA_TYPE 7'b1100111 // jalr : rd = pc + 4, pc = rs1 + imm   

//
