module gcd_controller (input rst,
                       input clk,
                       input A_eq_B,
                       input A_gt_B, ///////// A greater than B
                       input start,
                       output reg A_sel,
                       output reg B_sel,
                       output reg A_ld,
                       output reg B_ld,
                       output reg out_ld);
  parameter state_reg_width=3;
  parameter [state_reg_width-1 : 0] no_op =3'd0,
  operands_comp = 3'd1,
  update_A = 3'd2,
  update_B= 3'd3,
  done = 3'd4 ;
  reg [state_reg_width-1 : 0] next_state, curr_state ;
  
////////////////////////////////////// state register /////////////////
  always @(posedge clk) begin
    if(rst) begin
      curr_state = no_op;
    end
    else begin
      curr_state <= next_state;
    end
  end
  
////////////////////////////// next state and outputs logic ////////////////
  always @(*) begin
    A_sel=0;
    B_sel = 0;
    A_ld = 0;
    B_ld = 0;
    out_ld = 0;
    case(curr_state)
      no_op: begin
        A_ld = 1;
        B_ld = 1;
        if(start) begin
          next_state = operands_comp;
        end
        else begin
          next_state = no_op;
        end
      end
      operands_comp: begin
        if(A_eq_B) begin
          next_state = done;
        end
        else begin
          if(A_gt_B) begin
            next_state = update_A;
          end
          else begin
            next_state = update_B;
          end
        end
      end
      update_A: begin
        A_sel=1;
        A_ld = 1;
        next_state = operands_comp;
      end
      update_B: begin
        B_sel = 1;
        B_ld = 1;
        next_state = operands_comp;
      end
      done: begin
        out_ld = 1;
        next_state = no_op;
      end
      default: begin
        next_state = no_op;
        B_ld = 1;
        A_ld = 1;
      end     
    endcase
  end
endmodule