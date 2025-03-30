
// APB Interface

interface APB_INF();

  logic                  PCLK;
  logic                  PRESETn;
  logic                  PSEL;
  logic                  PWRITE;
  logic [ADDR_WIDTH-1:0] PADDR;
  logic [DATA_WIDTH-1:0] PWDATA;
  logic                  PENABLE;
  logic                  PREADY;
  logic [DATA_WIDTH-1:0] PRDATA;
  logic                  PSLVERR;

endinterface : APB_INF

