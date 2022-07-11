module execute(
    input   wire            rst_i,
    input   wire            alub_sel_i,
    input   wire    [5:0]   alu_op_i,
    input   wire    [31:0]  A_i,
    input   wire    [31:0]  rD2_i,
    input   wire    [31:0]  ext_i,
    output  wire    [31:0]  C_o,
    output  wire            eq_o, // A == B (use A-B)
    output  wire            lt_o  // A < B  (use A-B)
    );
    
alu execute_alu (
    .rst_i      (rst_i),
    .alu_op_i   (alu_op_i),
    .A_i        (A_i),
    .B_i        (alub_sel_i ? ext_i : rD2_i),
    .C_o        (C_o),
    .eq_o       (eq_o),
    .lt_o       (lt_o)
);
endmodule
