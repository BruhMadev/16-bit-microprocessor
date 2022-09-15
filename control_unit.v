`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01.09.2021 14:58:08
// Design Name: 
// Module Name: control_unit
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


module control_unit(
input [2:0] opcode,
input rst,
output reg [1:0] reg_dst,    // 1 for R-type instruction and 2 for JAL (Jump after storing the
                             // next instruction's memory address into register) instruction
output reg [1:0] mem_to_reg, // 1 for LW (Load to register from memory) and 2 for JAL instruction
output reg [1:0] alu_op,     // 00 for R-type and J-type instructions (operation is given by Funct)
                             // 11 for LW, SW, ADDI instructions
                             // 01 for BEQ (Branch if equal to)
                             // 10 for SLTI (Source less than immediate)
output reg jump,             // 1 for J-type instruction
output reg branch,           // 1 for BEQ
output reg mem_read,         // 1 for LW
output reg mem_write,        // 1 for SW
output reg alu_src,          //Selects the second source operand for the ALU (rt or sign-extended immediate field)
                             // 1 for LW, SW, ADDI, SLTI
output reg reg_write,        // Enables a write to one of the registers
                  // 1 for R-type, LW, addi, slti, JAL 
output reg sign_or_zero // 0 for slti and 1 for all else (extended bits are sign in slti and zero in rest ig?)
    );
    
    always@(*)
    begin
        if(rst==1'b1)
        begin
            reg_dst = 2'b00;
            mem_to_reg = 2'b00;
            alu_op = 2'b00;
            jump = 1'b0;
            branch = 1'b0;
            mem_read = 1'b0;
            mem_write = 1'b0;
            alu_src = 1'b0;
            reg_write = 1'b0;
            sign_or_zero = 1'b1;
        end
        else begin 
        case(opcode)
        3'b000: // R-type 
        begin
            reg_dst = 2'b01;
            mem_to_reg = 2'b00;
            alu_op = 2'b00;
            jump = 1'b0;
            branch = 1'b0;
            mem_read = 1'b0;
            mem_write = 1'b0;
            alu_src = 1'b0;
            reg_write = 1'b1;
            sign_or_zero = 1'b1;
        end
        3'b001: // slti
        begin
            reg_dst = 2'b00;
            mem_to_reg = 2'b00;
            alu_op = 2'b10;
            jump = 1'b0;
            branch = 1'b0;
            mem_read = 1'b0;
            mem_write = 1'b0;
            alu_src = 1'b1;
            reg_write = 1'b1;
            sign_or_zero = 1'b0;
        end
        3'b010: // J
        begin
            reg_dst = 2'b00;
            mem_to_reg = 2'b00;
            alu_op = 2'b00;
            jump = 1'b1;
            branch = 1'b0;
            mem_read = 1'b0;
            mem_write = 1'b0;
            alu_src = 1'b0;
            reg_write = 1'b0;
            sign_or_zero = 1'b1;
        end
        3'b011: // JAL
        begin
            reg_dst = 2'b10;
            mem_to_reg = 2'b10;
            alu_op = 2'b00;
            jump = 1'b1;
            branch = 1'b0;
            mem_read = 1'b0;
            mem_write = 1'b0;
            alu_src = 1'b0;
            reg_write = 1'b1;
            sign_or_zero = 1'b1;
        end
        3'b100: // LW
        begin
            reg_dst = 2'b00;
            mem_to_reg = 2'b01;
            alu_op = 2'b11;
            jump = 1'b0;
            branch = 1'b0;
            mem_read = 1'b1;
            mem_write = 1'b0;
            alu_src = 1'b1;
            reg_write = 1'b1;
            sign_or_zero = 1'b1;
        end
        3'b101: // SW
        begin
            reg_dst = 2'b00;
            mem_to_reg = 2'b00;
            alu_op = 2'b11;
            jump = 1'b0;
            branch = 1'b0;
            mem_read = 1'b0;
            mem_write = 1'b1;
            alu_src = 1'b1;
            reg_write = 1'b0;
            sign_or_zero = 1'b1;
        end
        3'b110: // BEQ
        begin
            reg_dst = 2'b00;
            mem_to_reg = 2'b00;
            alu_op = 2'b01;
            jump = 1'b0;
            branch = 1'b1;
            mem_read = 1'b0;
            mem_write = 1'b0;
            alu_src = 1'b0;
            reg_write = 1'b0;
            sign_or_zero = 1'b1;
        end
        3'b111: // addi
        begin
            reg_dst = 2'b00;
            mem_to_reg = 2'b00;
            alu_op = 2'b11;
            jump = 1'b0;
            branch = 1'b0;
            mem_read = 1'b0;
            mem_write = 1'b0;
            alu_src = 1'b1;
            reg_write = 1'b1;
            sign_or_zero = 1'b1;
        end
        default: // R-type (add)
        begin
            reg_dst = 2'b01;
            mem_to_reg = 2'b00;
            alu_op = 2'b00;
            jump = 1'b0;
            branch = 1'b0;
            mem_read = 1'b0;
            mem_write = 1'b0;
            alu_src = 1'b0;
            reg_write = 1'b1;
            sign_or_zero = 1'b1;
        end
        endcase
    end
    end
endmodule
