
// Sequence

class apb_sequence extends uvm_sequence#(apb_seq_item);
  `uvm_object_utils(apb_sequence)

  apb_seq_item seq_item;

  function new(string name = "apb_sequence");
    super.new(name);
    `uvm_info("SEQ", "CONSTRUCTOR", UVM_NONE);
  endfunction

  virtual task body();

      seq_item = apb_seq_item::type_id::create("seq_item");

      start_item(seq_item);
      `uvm_info("SEQ", $sformatf("ISSUED WRITE @ %0t ns",$time), UVM_NONE);
      seq_item.op     = WRITE;
      seq_item.PADDR  = 31'd10;
      seq_item.PWDATA = 31'd12;
      finish_item(seq_item);

      start_item(seq_item);
      `uvm_info("SEQ", $sformatf("ISSUED READ @ %0t ns",$time), UVM_NONE);
      seq_item.op     = READ;
      seq_item.PADDR  = 31'd10;
      finish_item(seq_item);

  endtask

endclass

