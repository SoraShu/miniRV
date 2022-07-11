module idecode(
    input   wire            clk_i,
    input   wire            rst_i,
    input   wire            rf_we_i,
    input   wire    [2:0]   sext_op_i,
    input   wire    [2:0]   wd_sel_i,
    input   wire    [31:0]  inst_i,
    input   wire    [31:0]  pc4_i,
    input   wire    [31:0]  alu_c_i,
    input   wire    [31:0]  dram_rd_i,
    input   wire    [31:0]  pcimm_i,
    output  wire    [31:0]  ext_o,
    output  wire    [31:0]  rD1_o,
    output  wire    [31:0]  rD2_o,
    output  wire    [31:0]  debug_wb_value // WB阶段写入寄存器的值 (若wb_ena或wb_have_inst=0，此项可为任意值)
    );
    
    wire    [31:0]  wD_wire;
    assign  debug_wb_value = wD_wire;

    sext idecode_sext(
        .rst_i      (rst_i),
        .sext_op_i  (sext_op_i),
        .din        (inst_i),
        .ext_o      (ext_o)
    );
    
    rf idecode_rf(
        .rst_i  (rst_i),
        .clk_i  (clk_i), 
        .rf_we_i(rf_we_i),
        .rR1_i  (inst_i[19:15]),
        .rR2_i  (inst_i[24:20]),
        .wR_i   (inst_i[11:7]),
        .wD_i   (wD_wire),
        .rD1_o  (rD1_o),
        .rD2_o  (rD2_o)
    );
    
    mux_5_1 idecode_mux_5_1(
        .op_i   (wd_sel_i),
        .a_i    (alu_c_i),
        .b_i    (pc4_i),
        .c_i    (dram_rd_i),
        .d_i    (ext_o), 
        .e_i    (pcimm_i),
        .f_o    (wD_wire)
    );
    
endmodule

module  mux_5_1(
    input   wire    [2:0]   op_i,
    input   wire    [31:0]  a_i,
    input   wire    [31:0]  b_i,
    input   wire    [31:0]  c_i,
    input   wire    [31:0]  d_i,
    input   wire    [31:0]  e_i,
    output  wire    [31:0]  f_o
);

assign f_o = op_i[2] ? e_i : (op_i[1] ? (op_i[0] ? d_i : c_i) : (op_i[0] ? b_i : a_i));

endmodule
