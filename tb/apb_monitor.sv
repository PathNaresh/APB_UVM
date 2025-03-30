
// MONITOR

class apb_mon extends uvm_monitor;
`uvm_component_utils(apb_mon)

    uvm_analysis_port#(apb_seq_item) send;
    apb_seq_item seq_item;
    virtual APB_INF vif;

    function new(input string inst = "apb_mon", uvm_component parent = null);
      super.new(inst,parent);
      `uvm_info("MON", "CONSTRUCTOR", UVM_NONE);
    endfunction

    virtual function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      `uvm_info("MON", "BUILD PHASE", UVM_NONE);
      seq_item = apb_seq_item::type_id::create("seq_item");
      send = new("send", this);
      if(!uvm_config_db#(virtual APB_INF)::get(this,"","vif",vif))  //uvm_test_top.env.agent.drv.aif
        `uvm_error("MON","Unable to access Interface");
    endfunction

    virtual task run_phase(uvm_phase phase);
      `uvm_info("MON", "RUN PHASE", UVM_NONE);

      forever begin
	    #5;
        @(posedge vif.PCLK);

        if(!vif.PRESETn) begin
          seq_item.op = RESET;
          `uvm_info("MON", $sformatf("RESET @ %0t",$time), UVM_NONE);
          send.write(seq_item);
        end

        else if (vif.PRESETn && vif.PWRITE) begin
          @(negedge vif.PREADY);
          seq_item.op      = WRITE;
          seq_item.PWDATA  = vif.PWDATA;
          seq_item.PADDR   = vif.PADDR;
          seq_item.PSLVERR = vif.PSLVERR;
          `uvm_info("MON", $sformatf("WRITE PACKET CAPTURED @ %0t :: ADDR = %0d WRITE_DATA = %0d SLVERR = %0d", $time, seq_item.PADDR, seq_item.PWDATA, seq_item.PSLVERR), UVM_NONE);
          send.write(seq_item);
        end

        else if (vif.PRESETn && !vif.PWRITE) begin
          @(negedge vif.PREADY);
          seq_item.op      = READ;
          seq_item.PADDR   = vif.PADDR;
          seq_item.PRDATA  = vif.PRDATA;
          seq_item.PSLVERR = vif.PSLVERR;
          `uvm_info("MON", $sformatf("READ PACKET CAPTURED @ %0t :: ADDR = %0d READ_DATA = %0d SLVERR = %0d", $time, seq_item.PADDR, seq_item.PRDATA,seq_item.PSLVERR), UVM_NONE);
          send.write(seq_item);
        end
      end

    endtask

endclass

