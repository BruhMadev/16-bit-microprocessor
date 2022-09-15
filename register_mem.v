`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02.09.2021 18:31:09
// Design Name: 
// Module Name: register_mem
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module register_mem(
input clk, rst, input reg_write_en,
input [2:0] reg_write_dest, input [15:0] reg_write_data,
input [2:0] reg_read_addr1, output [15:0] reg_read_data1,
input [2:0] reg_read_addr2, output [15:0] reg_read_data2
    );
    reg [15:0] reg_array [7:0]; // 8 registers of 16 bit each
    
    integer i;
    // reading and writing into registers
    always @(posedge clk or posedge rst)
    begin
        if(rst)
            begin
                for(i = 0; i < 8; i = i+1) begin
                reg_array[i] <= 16'b0;
                end
            end
        else if(reg_write_en) reg_array[reg_write_dest] <= reg_write_data;
    end
    assign reg_read_data1 = (reg_read_addr1 == 3'b0) ? 16'b0 : reg_array[reg_read_addr1];
    assign reg_read_data2 = (reg_read_addr2 == 3'b0) ? 16'b0 : reg_array[reg_read_addr2];
endmodule
