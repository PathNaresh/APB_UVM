
// AGENT

class apb_agent extends uvm_agent;
`uvm_component_utils(apb_agent)

  abp_config cfg;

  function new(input string inst = "apb_agent", uvm_component parent = null);
    super.new(inst,parent);
    `uvm_info("AGT", "CONSTRUCTOR", UVM_NONE);
  endfunction

  apb_driver drv;
  uvm_sequencer#(apb_seq_item) seqr;
  apb_mon mon;

  virtual function void build_phase(uvm_phase phase);
    `uvm_info("AGT", "BUILD PHASE", UVM_NONE);
    super.build_phase(phase);
    cfg = abp_config::type_id::create("cfg");
    mon = apb_mon::type_id::create("mon",this);

    if(cfg.is_active == UVM_ACTIVE) begin
     drv  = apb_driver::type_id::create("drv",this);
     seqr = uvm_sequencer#(apb_seq_item)::type_id::create("seqr", this);
    end

  endfunction

  virtual function void connect_phase(uvm_phase phase);
    `uvm_info("AGT", "CONNECT PHASE", UVM_NONE);
    super.connect_phase(phase);
    if(cfg.is_active == UVM_ACTIVE) begin
      drv.seq_item_port.connect(seqr.seq_item_export);
    end
  endfunction

endclass

