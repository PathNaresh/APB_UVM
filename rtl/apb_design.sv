
// Design - APB Slave Memory

module APB_RAM #(
  parameter ADDR_WIDTH = 32,
  parameter DATA_WIDTH = 32,
  parameter MEM_DEPTH  = 32
  )(

  input                       PCLK,
  input                       PRESETn,
  input                       PSEL,
  input                       PWRITE,
  input      [ADDR_WIDTH-1:0] PADDR,
  input      [DATA_WIDTH-1:0] PWDATA,
  input                       PENABLE,
  output reg                  PREADY,
  output reg [DATA_WIDTH-1:0] PRDATA,
  output reg                  PSLVERR

);

  reg [DATA_WIDTH-1:0] mem [0:MEM_DEPTH-1];

  typedef enum {IDLE = 0, SETUP = 1, ACCESS = 2, TRANSFER = 3} state_type;
  state_type STATE = IDLE;

  always@(posedge PCLK) begin

    if(PRESETn == 1'b0) begin  // {
      PRDATA  <= 32'hxxxxxxxx;
      PREADY  <= 1'b0;
      PSLVERR <= 1'b0;
      STATE   <= IDLE;
      
      for(int i = 0; i < MEM_DEPTH; i++) begin
        mem[i] <= 32'h00000000;
      end
    end  // }

    else begin  // {

      case(STATE)

      IDLE : begin        // IDLE STATE
        PRDATA  <= 32'hxxxxxxxx;
        PREADY  <= 1'b0;
        PSLVERR <= 1'b0;
        STATE   <= SETUP;
      end

      SETUP : begin      // SETUP STATE
        if(PSEL == 1'b1)
          STATE <= ACCESS;
        else
          STATE <= SETUP;
      end

      ACCESS : begin    // ACCESS STATE  // {

        if(PWRITE && PENABLE) begin  // WRITE OPERATION
          if(PADDR < MEM_DEPTH) begin
	          PREADY     <= 1'b1;
            mem[PADDR] <= PWDATA;
            PSLVERR    <= 1'b0;
	          STATE      <= TRANSFER;
          end
          else begin
            PSLVERR <= 1'b1;
            PREADY  <= 1'b1;
            STATE   <= TRANSFER;
          end
        end

        else if (!PWRITE && PENABLE) begin // READ OPERATION
          if(PADDR < MEM_DEPTH) begin
            PREADY  <= 1'b1;
            PRDATA  <= mem[PADDR];
            PSLVERR <= 1'b0;
            STATE   <= TRANSFER;
          end
          else begin
            PSLVERR <= 1'b1;
            PREADY  <= 1'b1;
            PRDATA  <= 32'hxxxxxxxx;
            STATE   <= TRANSFER;
          end
        end
        
        else
           STATE <= SETUP;
       end  //}

      TRANSFER: begin    // TRANSFER STATE
        STATE   <= SETUP;
        PREADY  <= 1'b0;
        PSLVERR <= 1'b0;
      end

      default : STATE <= IDLE;

      endcase
      
    end  // }
  end

endmodule : APB_RAM
