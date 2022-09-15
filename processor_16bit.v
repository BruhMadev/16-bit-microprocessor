`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02.09.2021 14:14:48
// Design Name: 
// Module Name: processor_16bit
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


module processor_16bit(
input rst, clk,
output [15:0] pc_out, ALU_result
//output [15:0] reg_read_data1, [15:0] read_data2, [15:0] imm_ext
// output [2:0] ALU_control, output mem_write
    );
    reg [15:0] pc_current;
    wire signed [15:0] pc_next, pc2;
    
    wire [15:0] instr; // Instruction read from instruction memory
    
    // Control signals
    wire [1:0] reg_dst, mem_to_reg, ALU_op;
    wire jump, branch, mem_read, mem_write, alu_src, reg_write;
    wire sign_or_zero;
    
    // Wires for storing read address and data
    wire [2:0] reg_write_dest;
    wire [15:0] reg_write_data;
    wire [2:0] reg_read_addr1;
    wire [15:0] reg_read_data1;
    wire [2:0] reg_read_addr2;
    wire [15:0] reg_read_data2;
    
    wire [15:0] sign_ext_im;
    wire [15:0] zero_ext_im; // temporary variables for extending imm to 16 bits
    wire [15:0] read_data2; // temporary variable to choose from rd or immediate
    wire [15:0] imm_ext;
    
    wire JRcontrol; // if jump to reg instruction hould take place
    wire [2:0] ALU_control;
    wire [15:0] ALU_out;
    wire zero_flag;
    wire signed [15:0] im_shift_1, PC_j, PC_beq, PC_4beq, PC_4beqj, PC_jr;
    wire beq_control;
    wire [14:0] jump_shift_1;
    wire [15:0] mem_read_data;
    wire [15:0] no_sign_ext;
    
    
    // Executing the instructions
    // Incrementing the PC
    always @(posedge clk or posedge rst)
    begin
    if(rst) pc_current <= 16'b0;
    else pc_current <= pc_next;
    end
    //PC +2
    assign pc2 = pc_current + 16'd2;
    // reading instruction memory
    instr_mem instruction_memory(.mem_addr(pc_current), .instr(instr));
    
    // jump shift left 1  
    assign jump_shift_1 = {instr[13:0],1'b0}; 
    
    // sending opcode to control unit
    control_unit Control_unit_signals(.rst(rst), .opcode(instr[15:13]), .reg_dst(reg_dst), .mem_to_reg(mem_to_reg),
     .alu_op(ALU_op), .jump(jump), .branch(branch), .mem_read(mem_read), 
     .mem_write(mem_write), .alu_src(alu_src), .reg_write(reg_write), 
     .sign_or_zero(sign_or_zero));
    
    // Setting Destination register 
    assign reg_write_dest = (reg_dst == 2'b10) ? 3'b111 : // for JAL
    ((reg_dst == 2'b01) ? instr[6:4] // For R-type instruction
     : instr[9:7]); // for I-type instruction 
     
     // Setting Source registers
     assign reg_read_addr1 = instr[12:10];
     assign reg_read_addr2 = instr[9:7];
     
     // Writing and reading data from registers
     register_mem Register_Mem(.clk(clk), .rst(rst), .reg_write_en(reg_write), 
     .reg_write_dest(reg_write_dest), .reg_write_data(reg_write_data),
     .reg_read_addr1(reg_read_addr1), .reg_read_data1(reg_read_data1),
     .reg_read_addr2(reg_read_addr2), .reg_read_data2(reg_read_data2));
     
     // Making 7 bit immediate 16 bit for ALU operation
     assign sign_ext_im = {{9{instr[6]}}, instr[6:0]};
     assign zero_ext_im = {{9{1'b0}}, instr[6:0]};
     assign imm_ext = (sign_or_zero == 1'b1) // 1 -> sign extended, 0 -> zero extended
     ? sign_ext_im : zero_ext_im; 
     
     // ALU control
     alu_control_unit ALU_control_unit(.alu_op(ALU_op), .funct(instr[3:0]), .ALU_control(ALU_control), 
     .JR_control(JRcontrol));
     
     // assigning data2 as imm for I-type and reading from reg file for R-type
     assign read_data2 = (alu_src == 1'b1) ? imm_ext : reg_read_data2;
     
     // ALU operation
     ALU alu_unit(.rs(reg_read_data1),.rt(read_data2),.ALU_control_in(ALU_Control),
     .alu_result(ALU_out),.zero(zero_flag));
     
     // Executing the BEQ and J instruction and changing the PC accordingly
     assign im_shift_1 = {imm_ext[14:0], 1'b0};
     assign no_sign_ext = ~(im_shift_1) + 1'b1;
     assign PC_beq = (im_shift_1[15] == 1'b1) ? (pc2 - no_sign_ext) : (pc2 + im_shift_1);
     assign beq_control = branch & zero_flag;
     assign PC_4beq = (beq_control == 1'b1) ? PC_beq : pc2; // chooses between BEQ or incrementing the PC by 2
     
     assign PC_j = {pc2[15], jump_shift_1};
     assign PC_4beqj = (jump == 1'b1) ? PC_j : PC_4beq;
     assign PC_jr = reg_read_data1;
     assign pc_next = (JRcontrol == 1'b1) ? PC_jr : PC_4beqj; // choosing between jump to reg and beqj
     // Reading and Writing into Datamemory ( instr LW, SW )
     data_memory data_mem(.clk(clk), .mem_write_data(reg_read_data2),
     .mem_access_addr(ALU_out), // ALU output gives SignExtImm + R[rs] 
     .mem_write_en(mem_write), .mem_read(mem_read), .mem_read_data(mem_read_data));
     
     // JAL instr (writing next PC to register)
     assign reg_write_data = (mem_to_reg == 2'b10) ? pc2 : ((mem_to_reg == 2'b01) ?
     mem_read_data : ALU_out);
     
     // output
     assign pc_out = pc_current;
     assign ALU_result = ALU_out;
     
endmodule
