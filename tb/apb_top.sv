
// Test Bench - TOP

 typedef enum bit [1:0]   {READ = 0, WRITE = 1, RESET = 2} oper_mode;

 parameter ADDR_WIDTH = 32;
 parameter DATA_WIDTH = 32;

module apb_top;

  APB_INF vif();

  APB_RAM dut (.PCLK(vif.PCLK),
               .PRESETn(vif.PRESETn),
	       .PSEL(vif.PSEL),
	       .PWRITE(vif.PWRITE),
	       .PADDR(vif.PADDR),
	       .PWDATA(vif.PWDATA),
	       .PENABLE(vif.PENABLE),
	       .PREADY(vif.PREADY),
	       .PRDATA(vif.PRDATA),
	       .PSLVERR(vif.PSLVERR)
	       );

  initial begin
    vif.PCLK    <= 1'b1;
    forever #1 vif.PCLK = ~vif.PCLK;
  end

  initial begin
    vif.PRESETn <= 1'b0;
    #1;
    vif.PRESETn <= 1'b1;
  end

  initial begin
    uvm_config_db#(virtual APB_INF)::set(null, "*", "vif", vif);
    run_test("apb_test");
  end

  initial begin
    $dumpfile("dump.vcd");
    $dumpvars;
  end

endmodule

