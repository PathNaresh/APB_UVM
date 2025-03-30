
// DRIVER

class apb_driver extends uvm_driver #(apb_seq_item);
  `uvm_component_utils(apb_driver)

  virtual APB_INF vif;
  apb_seq_item seq_item;

  function new(input string path = "apb_driver", uvm_component parent = null);
    super.new(path,parent);
    `uvm_info("DRV", "CONSTRUCTOR", UVM_NONE);
  endfunction

 virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    `uvm_info("DRV", "BUILD PHASE", UVM_NONE);
     seq_item = apb_seq_item::type_id::create("seq_item");
      if(!uvm_config_db#(virtual APB_INF)::get(this,"","vif",vif))       //uvm_test_top.env.agent.drv.aif
      `uvm_error("drv","Unable to access Interface");
  endfunction

  // Task - DRIVE_DUT

  task drive_dut();

    forever begin
         seq_item_port.get_next_item(seq_item);

         if(seq_item.op ==  RESET) begin
	         `uvm_info("DRV", $sformatf("ENETERED THE RESET OPERATION at %0t",$time), UVM_NONE);
           vif.PRESETn   <= 1'b0;
	         vif.PSEL      <= 1'b0;
           vif.PADDR     <= 'h0;
           vif.PWDATA    <= 'h0;
           vif.PWRITE    <= 1'b0;
           vif.PENABLE   <= 1'b0;
           @(posedge vif.PCLK);
         end

         else if(seq_item.op == WRITE) begin
	         @(posedge vif.PCLK);
	         `uvm_info("DRV", $sformatf("WRITE - SETUP STATE @ %0t ns",$time), UVM_NONE);
           vif.PSEL    <= 1'b1;
	         vif.PWRITE  <= 1'b1;
           vif.PADDR   <= seq_item.PADDR;
           vif.PWDATA  <= seq_item.PWDATA;
           @(posedge vif.PCLK);
           vif.PENABLE <= 1'b1;
           `uvm_info("DRV", $sformatf("INITIATED WRITE PACKET @ %0t ns :: mode:%0s, addr:%0d, wdata:%0d, rdata:%0d, slverr:%0d", $time, seq_item.op.name(), seq_item.PADDR, seq_item.PWDATA, seq_item.PRDATA, seq_item.PSLVERR), UVM_NONE);
           @(negedge vif.PREADY);
           vif.PENABLE <= 1'b0;
           seq_item.PSLVERR   = vif.PSLVERR;
         end

	       else if(seq_item.op ==  READ) begin
	         `uvm_info("DRV", $sformatf("READ SETUP STATE @ %0t ns",$time), UVM_NONE);
           vif.PSEL    <= 1'b1;
	         vif.PWRITE  <= 1'b0;
           vif.PADDR   <= seq_item.PADDR;
           @(posedge vif.PCLK);
           vif.PENABLE <= 1'b1;
           `uvm_info("DRV", $sformatf("INITIATED READ PACKET @ %0t ns :: mode:%0s, addr:%0d, wdata:%0d, rdata:%0d, slverr:%0d", $time, seq_item.op.name(), seq_item.PADDR, seq_item.PWDATA, seq_item.PRDATA, seq_item.PSLVERR), UVM_NONE);
           @(negedge vif.PREADY);
           vif.PENABLE <= 1'b0;
           seq_item.PRDATA     = vif.PRDATA;
           seq_item.PSLVERR    = vif.PSLVERR;
         end
	       #1;
         seq_item_port.item_done();
   end

  endtask

  virtual task run_phase(uvm_phase phase);
    `uvm_info("DRV", "RUN PHASE", UVM_NONE);
    drive_dut();
  endtask

endclass

