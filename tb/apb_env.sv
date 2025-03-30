
// ENVIRONMENT

class apb_env extends uvm_env;
`uvm_component_utils(apb_env)

  function new(input string inst = "apb_env", uvm_component c);
    super.new(inst,c);
    `uvm_info("ENV", "CONSTRUCTOR", UVM_NONE);
  endfunction

  apb_agent agt;
  apb_sco sco;

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    `uvm_info("ENV", "BUILD PHASE", UVM_NONE);
    agt = apb_agent::type_id::create("agt",this);
    sco = apb_sco::type_id::create("sco", this);
  endfunction

  virtual function void connect_phase(uvm_phase phase);
    `uvm_info("ENV", "CONNECT PHASE", UVM_NONE);
    super.connect_phase(phase);
    agt.mon.send.connect(sco.recv);
  endfunction

endclass

