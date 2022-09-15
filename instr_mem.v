`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01.09.2021 13:07:20
// Design Name: 
// Module Name: instr_mem
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
// 2^16 - 16 bit instructions memsize = 128kB ROM
// Since the program counter is 16 bit, input mem_addr is 16 bit
module instr_mem(
input [15:0] mem_addr, output [15:0] instr
    );
    wire [3:0] rom_addr = mem_addr[4:1];
    reg [15:0] instr_ROM [15:0]; // can store upto 16 instructions of 16 bits
                                // But if all address lines are used 2^15 instructions can be stored
    
    // below we add instructions to be carries out
    initial  
      begin  
            instr_ROM[0] = 16'b1110010100000001;  
            instr_ROM[1] = 16'b1010010100000010;  
            instr_ROM[2] = 16'b0000010100110000;  
            instr_ROM[3] = 16'b1010010110000011;  
            instr_ROM[4] = 16'b0000100111000000;  
            instr_ROM[5] = 16'b1010011000000100; 
            instr_ROM[6] = 16'b0000111001010000;  
            instr_ROM[7] = 16'b1010011010000101;  
            instr_ROM[8] = 16'b0001001011100000;  
            instr_ROM[9] = 16'b0000000000000000;  
            instr_ROM[10] = 16'b0000000000000000;  
            instr_ROM[11] = 16'b0000000000000000;  
            instr_ROM[12] = 16'b0000000000000000;  
            instr_ROM[13] = 16'b0000000000000000;  
            instr_ROM[14] = 16'b0000000000000000;  
            instr_ROM[15] = 16'b0000000000000000;  
      end  
      assign instr = (mem_addr <= 32) ? instr_ROM[rom_addr] : 16'b0;
endmodule
