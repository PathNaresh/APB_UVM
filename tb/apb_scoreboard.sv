
// SCOREBOARD

class apb_sco extends uvm_scoreboard;
`uvm_component_utils(apb_sco)

    uvm_analysis_imp#(apb_seq_item,apb_sco) recv;

    bit [31:0] arr[32] = '{default:0};
    bit [31:0] addr    = 0;
    bit [31:0] data_rd = 0;

    function new(input string inst = "apb_sco", uvm_component parent = null);
      super.new(inst,parent);
      `uvm_info("SCO", "CONSTRUCTOR", UVM_NONE);
    endfunction

    virtual function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      `uvm_info("SCO", "BUILD PHASE", UVM_NONE);
      recv = new("recv", this);
    endfunction

    virtual function void write(apb_seq_item seq_item);
      `uvm_info("SCO", "WRITE FUNC", UVM_NONE);

      if(seq_item.op == RESET) begin
        `uvm_info("SCO", "SYSTEM RESET DETECTED", UVM_NONE);
      end

      else if (seq_item.op == WRITE) begin
        if(seq_item.PSLVERR == 1'b1) begin
          `uvm_info("SCO", "SLV ERROR during WRITE OP", UVM_NONE);
        end
        else begin
          arr[seq_item.PADDR] = seq_item.PWDATA;
          `uvm_info("SCO", $sformatf("@[%0t] DATA WRITE OPERATION SUCCESSFUL :: addr:%0d, wdata:%0d arr_wr:%0d",$time, seq_item.PADDR, seq_item.PWDATA, arr[seq_item.PADDR]), UVM_NONE);
        end
      end

      else if (seq_item.op == READ) begin
        if(seq_item.PSLVERR == 1'b1) begin
          `uvm_info("SCO", "SLV ERROR during READ OP", UVM_NONE);
        end
        else begin
          data_rd = arr[seq_item.PADDR];
          if (data_rd == seq_item.PRDATA) begin
            `uvm_info("SCO", $sformatf("DATA MATCHED READ OPERATION SUCCESSFUL :: addr:%0d, rdata:%0d",seq_item.PADDR,seq_item.PRDATA), UVM_NONE)
          end
	        else begin
            `uvm_info("SCO",$sformatf("TEST FAILED : addr:%0d, rdata:%0d data_rd_arr:%0d",seq_item.PADDR,seq_item.PRDATA,data_rd), UVM_NONE)
          end
        end
      end

    $display("------------------------ TRANSACTION COMPLETED ----------------------------------------\n");

  endfunction

endclass

