
// Sequence Item

class apb_seq_item extends uvm_sequence_item;

    // DUT Input signals 
    oper_mode              op;
    logic                  PWRITE;
    logic [DATA_WIDTH-1:0] PWDATA;
    logic [ADDR_WIDTH-1:0] PADDR;

    // DUT Output Signals
    logic		               PREADY;
    logic 		             PSLVERR;
    logic [DATA_WIDTH-1:0] PRDATA;

    `uvm_object_utils_begin(apb_seq_item)
      `uvm_field_int (PWRITE,UVM_ALL_ON)
      `uvm_field_int (PWDATA,UVM_ALL_ON)
      `uvm_field_int (PADDR,UVM_ALL_ON)
      `uvm_field_int (PREADY,UVM_ALL_ON)
      `uvm_field_int (PSLVERR,UVM_ALL_ON)
      `uvm_field_int (PRDATA,UVM_ALL_ON)
      `uvm_field_enum(oper_mode, op, UVM_DEFAULT)
    `uvm_object_utils_end

  //constraint addr_c     { PADDR <= 31; }
  //constraint addr_c_err { PADDR > 31; }

  function new(string name = "apb_seq_item");
    super.new(name);
    `uvm_info("SEQ_ITEM", "CONSTRUCTOR", UVM_NONE);
  endfunction

endclass : apb_seq_item

