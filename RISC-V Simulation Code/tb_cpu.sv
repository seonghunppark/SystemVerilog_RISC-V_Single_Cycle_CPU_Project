`timescale 1ns / 1ps



module tb_cpu ();

    logic clk = 0, reset = 1; 

    RV32I_TOP dut (.*);

    always #5 clk = ~clk;

    initial begin
        #30;
        reset = 0;
        #1000;
        $stop;
    end
endmodule
