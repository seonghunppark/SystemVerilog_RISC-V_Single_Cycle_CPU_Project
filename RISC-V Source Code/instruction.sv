// Code



`timescale 1ns / 1ps

module instr_mem (
    input  logic [31:0] instr_rAddr,
    output logic [31:0] instr_code
);
    logic [31:0] rom[0:399];

    initial begin
        // for(int i = 0; i<64; i++) begin
            // rom[i] = 32'hffff_0000 + i;
        // end

        // $readmemb("code_B_J_type.txt",rom);
        // $readmemb("code_S_IL_type.txt",rom);
        // $readmemb("code_U_type.txt",rom);
        // $readmemb("code_I_type.txt",rom);
        //$readmemb("code_R_type.txt",rom);
        // $readmemh("code_sum.txt",rom);
        $readmemh("code_sort.txt",rom);
        

    


    end

    assign instr_code = rom[instr_rAddr[31:2]];

endmodule



