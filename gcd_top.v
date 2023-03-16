module gcd_top #(parameter op_sz=8)(input clk,
                                   input rst,
                                   input start,
                                   input [op_sz -1 : 0] A,
                                   input [op_sz -1 : 0] B,
                                   output reg [op_sz -1 : 0] res,
                                   output done_sig);
  wire A_eq_B, A_gt_B, A_sel, B_sel, A_ld, B_ld, out_ld ;
  
  gcd_controller controller(.clk(clk),
                            .rst(rst),
                                 .A_eq_B(A_eq_B),
                                 .A_gt_B(A_gt_B),
                                 .start(start),
                                 .A_sel(A_sel),
                                 .B_sel(B_sel),
                                 .A_ld(A_ld),
                                 .B_ld(B_ld),
                                 .out_ld(out_ld));
  
  gcd_datapath #(op_sz) datapath(.clk(clk),
                                 .rst(rst),
                                 .A(A),
                                 .B(B),
                                 .A_sel(A_sel),
                                 .B_sel(B_sel),
                                 .A_ld(A_ld),
                                 .B_ld(B_ld),
                                 .out_ld(out_ld),
                                 .A_eq_B(A_eq_B),
                                 .A_gt_B(A_gt_B),
                                 .res(res));
  assign done_sig = out_ld;
endmodule

/////////////////////////////////////////////////////////////
