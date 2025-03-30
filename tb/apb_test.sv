
// TEST

class apb_test extends uvm_test;
`uvm_component_utils(apb_test)

  function new(input string inst = "apb_test", uvm_component c);
    super.new(inst,c);
    `uvm_info("TST", "CONSTRUCTOR", UVM_NONE);
  endfunction

  apb_env env;
  apb_sequence seq;

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    `uvm_info("TST", "BUILD PHASE", UVM_NONE);
    env = apb_env::type_id::create("env",this);
    seq = apb_sequence::type_id::create("seq");
  endfunction

  virtual task run_phase(uvm_phase phase);
    `uvm_info("TST", "RUN PHASE", UVM_NONE);

    phase.raise_objection(this);
    seq.start(env.agt.seqr);
    #2;
    phase.drop_objection(this);

  endtask

endclass

