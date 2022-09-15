`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02.09.2021 10:50:24
// Design Name: 
// Module Name: ALU
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


module ALU(
input [2:0] ALU_control_in, input [15:0] rs, // source 1
input [15:0] rt, // source 2
output reg [15:0] alu_result, // 
output zero
    );
    always @(*)
    begin
    case(ALU_control_in)
    3'b000: alu_result = rs + rt;
    3'b001: alu_result = rs - rt;
    3'b010: alu_result = rs & rt;
    3'b011: alu_result = rs | rt;
    3'b100: 
    begin
    alu_result = (rs < rt) ? 16'd1 : 16'd0;
    end
    default: alu_result = rs + rt;
    endcase
    end
    
    assign zero = (alu_result == 16'b0) ? 1'b1 : 1'b0;
endmodule
