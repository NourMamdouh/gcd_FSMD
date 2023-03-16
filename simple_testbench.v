module gcd_tb;
  parameter op_sz= 8;
  parameter clk_period=10ns;
  reg clk_tb=0;
  always #(clk_period/2) clk_tb=~clk_tb;
  
  //////////////////////////
  
  reg rst,start,done_sig;
  reg [op_sz-1 : 0] A,B,res;
  gcd_top #(op_sz) top(.clk(clk_tb), .rst(rst),.start(start),.A(A),.B(B),.res(res),.done_sig(done_sig));
  
  /////////////////////////////////
  task test_gcd(input [op_sz-1 :0] X,
                input [op_sz-1 :0] Y);
    rst=0;
    start = 1;
    A=X; B=Y;
    while(done_sig == 0) begin
      #(clk_period);
    end
    start=0;
    $display("-------------------------------------------");
    $display("done_sig = %d",done_sig);
    #(clk_period);
    $display("GCD value is %d",res);
  endtask
  
  /////////////////////////////////////////////////////////////////////
  task reset_gcd();
    rst=1;
    #(clk_period);
  endtask
  
  ///////////////////////////////////////
  
  initial begin
    reset_gcd();
    test_gcd(60,48);
    test_gcd(24,48);
    test_gcd(10,10);
    $display("-------------------------------------------");
    
   $finish();
  end
  
endmodule