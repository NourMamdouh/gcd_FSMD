module flip_flop #(parameter op_sz=8)(input clk,
                                      input rst,
                                      input load,
                                      input [op_sz-1 : 0] data,
                                      output reg [op_sz-1 : 0] out);
  always @(posedge clk) begin
    if(rst) begin
      out <= 0;
    end
    else begin
      if(load) begin
        out <= data;
      end
      else begin
        out <= out;
      end
    end
  end
endmodule

/////////////////////////////////////
module gcd_datapath #(parameter op_sz=8)(input clk,
                                         input rst,
                                         input [op_sz-1 : 0] A,
                                         input [op_sz-1 : 0] B,
                                         input A_sel,
                                         input B_sel,
                                         input A_ld,
                                         input B_ld,
                                         input out_ld,
                                         output reg A_eq_B,
                                         output reg A_gt_B,
                                         output reg [op_sz-1 : 0] res);
  reg [op_sz-1 : 0] reg_A, reg_B;
  wire [op_sz-1 : 0] in_A, in_B;
     
  flip_flop #(op_sz) ff_A(.clk(clk), .rst(rst), .load(A_ld), .data(in_A), .out(reg_A));     //// reg_A
  flip_flop #(op_sz) ff_B(.clk(clk), .rst(rst), .load(B_ld), .data(in_B), .out(reg_B));     ///// reg_B
  flip_flop #(op_sz) ff_out(.clk(clk), .rst(rst), .load(out_ld), .data(reg_A), .out(res));  ///// res
  
  assign in_A = (A_sel == 0)? A : (reg_A-reg_B);    /////// data at reg_A input port
  assign in_B = (B_sel == 0)? B : (reg_B-reg_A);    /////// data at reg_B input port
  
  //////////////  control signals  as output of datapath ////////////
  assign A_eq_B = (reg_A == reg_B)? 1 : 0;
  assign A_gt_B = (reg_A > reg_B)? 1 : 0;
  
endmodule