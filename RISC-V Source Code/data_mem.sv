`timescale 1ns / 1ps


module data_mem (
    input  logic        clk,
    input  logic        d_wr_en,
    input  logic [31:0] dAddr,
    input  logic [31:0] dWdata,
    input  logic [ 1:0] byte_en,
    input  logic [ 2:0] funct3_in,
    output logic [31:0] dRdata
);
    logic [31:0] data_mem[0:399];




    // initial begin
        // for (int i = 0; i < 32; i++) begin
            // data_mem[i] = i + 32'h8765_4321;
        // end
    // end

    always_ff @(posedge clk) begin
        if (d_wr_en) begin
            case (byte_en)
                2'b01:   data_mem[dAddr[31:0]][7:0] <= dWdata;
                2'b10:   data_mem[dAddr[31:0]][15:0] <= dWdata;
                2'b11:   data_mem[dAddr[31:0]][31:0] <= dWdata;
                default: data_mem[dAddr[31:0]] <= 32'h0;
            endcase
        end
    end

    always_comb begin
        if (!d_wr_en) begin
            case (funct3_in)
                3'b000:
                dRdata = {{24{data_mem[dAddr][7]}}, data_mem[dAddr][7:0]};
                3'b001:
                dRdata = {{16{data_mem[dAddr][15]}}, data_mem[dAddr][15:0]};
                3'b010: dRdata = data_mem[dAddr][31:0];
                3'b100: dRdata = {{24{1'b0}}, data_mem[dAddr][7:0]};
                3'b101: dRdata = {{16{1'b0}}, data_mem[dAddr][15:0]};
                default: dRdata = 32'h0;
            endcase
        end else begin
            dRdata = 32'h0;
        end
    end
endmodule
