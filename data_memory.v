`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03.09.2021 21:53:38
// Design Name: 
// Module Name: data_memory
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


module data_memory(
//  data memory (RAM) has a 256 words of 16 bit so mem_addr is 8 bit only
// with synchronous write and asynchronous read
input clk, input [15:0] mem_access_addr, // address of location to read
input [15:0] mem_write_data, input mem_write_en, // Data for writing and enable signal (SW instruction)
input mem_read, output [15:0] mem_read_data // enable signal and output of read data
    );
    integer i;
    reg [15:0] ram [255:0];
    wire [7:0] ram_addr = mem_access_addr[8:1];
    initial begin 
    for (i=0; i<256; i=i+1) ram[i] <= 16'b0;
    end
    
    always @(posedge clk) begin
    if (mem_write_en) ram[ram_addr] <= mem_write_data;
    end
    
    assign mem_read_data = (mem_read == 1'b1) ? ram[ram_addr] : 16'b0;
    
endmodule
