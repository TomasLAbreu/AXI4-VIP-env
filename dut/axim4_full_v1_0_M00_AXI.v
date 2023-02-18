
`timescale 1 ns / 1 ps

module axi4_full_v1_0_M00_AXI #
(
  // Users to add parameters here

  // User parameters ends

   parameter  C_M_TARGET_SLAVE_BASE_ADDR  = 32'h80000000,
   parameter integer C_M_AXI_BURST_LEN    = 8,
  parameter integer C_M_AXI_ID_WIDTH     = 1,
  parameter integer C_M_AXI_ADDR_WIDTH   = 32,
  parameter integer C_M_AXI_DATA_WIDTH   = 32,
  parameter integer C_M_AXI_AWUSER_WIDTH = 0,
  parameter integer C_M_AXI_ARUSER_WIDTH = 0,
  parameter integer C_M_AXI_WUSER_WIDTH  = 0,
  parameter integer C_M_AXI_RUSER_WIDTH  = 0,
  parameter integer C_M_AXI_BUSER_WIDTH  = 0
)
(
  // Users to add ports here

  // User ports ends

  input  wire                               INIT_AXI_TXN,
  output wire                               TXN_DONE,
  output reg                                ERROR,
  input  wire                               M_AXI_ACLK,
  input  wire                               M_AXI_ARESETN,

  output wire [C_M_AXI_ID_WIDTH-1 : 0]      M_AXI_AWID,
  output wire [C_M_AXI_ADDR_WIDTH-1 : 0]    M_AXI_AWADDR,
  output wire [7 : 0]                       M_AXI_AWLEN,
  output wire [2 : 0]                       M_AXI_AWSIZE,
  output wire [1 : 0]                       M_AXI_AWBURST,
  output wire                               M_AXI_AWLOCK,
  output wire [3 : 0]                       M_AXI_AWCACHE,
  output wire [2 : 0]                       M_AXI_AWPROT,
  output wire [3 : 0]                       M_AXI_AWQOS,
  output wire [C_M_AXI_AWUSER_WIDTH-1 : 0]  M_AXI_AWUSER,
  output wire                               M_AXI_AWVALID,
  input  wire                               M_AXI_AWREADY,

  output wire [C_M_AXI_DATA_WIDTH-1 : 0]    M_AXI_WDATA,
  output wire [C_M_AXI_DATA_WIDTH/8-1 : 0]  M_AXI_WSTRB,
  output wire                               M_AXI_WLAST,
  output wire [C_M_AXI_WUSER_WIDTH-1 : 0]   M_AXI_WUSER,
  output wire                               M_AXI_WVALID,
  input  wire                               M_AXI_WREADY,

  input  wire [C_M_AXI_ID_WIDTH-1 : 0]      M_AXI_BID,
  input  wire [1 : 0]                       M_AXI_BRESP,
  input  wire [C_M_AXI_BUSER_WIDTH-1 : 0]   M_AXI_BUSER,
  input  wire                               M_AXI_BVALID,
  output wire                               M_AXI_BREADY,

  output wire [C_M_AXI_ID_WIDTH-1 : 0]      M_AXI_ARID,
  output wire [C_M_AXI_ADDR_WIDTH-1 : 0]    M_AXI_ARADDR,
  output wire [7 : 0]                       M_AXI_ARLEN,
  output wire [2 : 0]                       M_AXI_ARSIZE,
  output wire [1 : 0]                       M_AXI_ARBURST,
  output wire                               M_AXI_ARLOCK,
  output wire [3 : 0]                       M_AXI_ARCACHE,
  output wire [2 : 0]                       M_AXI_ARPROT,
  output wire [3 : 0]                       M_AXI_ARQOS,
  output wire [C_M_AXI_ARUSER_WIDTH-1 : 0]  M_AXI_ARUSER,
  output wire                               M_AXI_ARVALID,
  input  wire                               M_AXI_ARREADY,

  input  wire [C_M_AXI_ID_WIDTH-1 : 0]      M_AXI_RID,
  input  wire [C_M_AXI_DATA_WIDTH-1 : 0]    M_AXI_RDATA,
  input  wire [1 : 0]                       M_AXI_RRESP,
  input  wire                               M_AXI_RLAST,
  input  wire [C_M_AXI_RUSER_WIDTH-1 : 0]   M_AXI_RUSER,
  input  wire                               M_AXI_RVALID,
  output wire                               M_AXI_RREADY
);

  // returns the value of the ceiling of the log base 2
  function integer clogb2 (input integer bit_depth);
  begin
    for(clogb2=0; bit_depth>0; clogb2=clogb2+1)
      bit_depth = bit_depth >> 1;
    end
  endfunction

  // width of the index counter for number of write or read transaction.
  localparam integer C_TRANSACTIONS_NUM = clogb2(C_M_AXI_BURST_LEN-1);
  // Burst length for transactions, in C_M_AXI_DATA_WIDTHs.
  // Non-2^n lengths will eventually cause bursts across 4K address boundaries.
  localparam integer C_MASTER_LENGTH  = 12;

  // total number of burst transfers is master length divided by burst length and burst size
  // localparam integer C_NO_BURSTS_REQ = C_MASTER_LENGTH-clogb2((C_M_AXI_BURST_LEN*C_M_AXI_DATA_WIDTH/8)-1);
  localparam integer C_NO_BURSTS_REQ = 0;

  // Master State Machine
  localparam [1:0] IDLE = 2'b00,
    INIT_WRITE         = 2'b01,
    INIT_READ          = 2'b10,
    INIT_COMPARE       = 2'b11;

  reg [1:0] mst_exec_state;

  // AXI4LITE signals
  reg [C_M_AXI_ADDR_WIDTH-1 : 0]  axi_awaddr;
  reg                             axi_awvalid;
  reg [C_M_AXI_DATA_WIDTH-1 : 0]  axi_wdata;
  reg                             axi_wlast;
  reg                             axi_wvalid;
  reg                             axi_bready;
  reg [C_M_AXI_ADDR_WIDTH-1 : 0]  axi_araddr;
  reg                             axi_arvalid;
  reg                             axi_rready;
  reg [C_TRANSACTIONS_NUM : 0]    write_index;
  reg [C_TRANSACTIONS_NUM : 0]    read_index;

  wire  [C_TRANSACTIONS_NUM+2 : 0]  burst_size_bytes;
  reg [C_NO_BURSTS_REQ : 0]         write_burst_counter;
  reg [C_NO_BURSTS_REQ : 0]         read_burst_counter;
  reg                               start_single_burst_write;
  reg                               start_single_burst_read;

  reg writes_done;
  reg reads_done;
  reg error_reg;
  reg compare_done;
  reg read_mismatch;
  reg burst_write_active;
  reg burst_read_active;

  reg [C_M_AXI_DATA_WIDTH-1 : 0]  expected_rdata;

  //Interface response error flags
  wire  write_resp_error;
  wire  read_resp_error;
  wire  wnext;
  wire  rnext;
  reg   init_txn_ff;
  reg   init_txn_ff2;
  reg   init_txn_edge;
  wire  init_txn_pulse;

  // I/O Connections assignments

  assign M_AXI_AWID    = 'b0;
  assign M_AXI_AWADDR  = C_M_TARGET_SLAVE_BASE_ADDR + axi_awaddr;
  assign M_AXI_AWLEN   = C_M_AXI_BURST_LEN - 1;
  assign M_AXI_AWSIZE  = clogb2((C_M_AXI_DATA_WIDTH/8)-1);
  assign M_AXI_AWBURST = 2'b01;
  assign M_AXI_AWLOCK  = 1'b0;
  assign M_AXI_AWCACHE = 4'b0010;
  assign M_AXI_AWPROT  = 3'h0;
  assign M_AXI_AWQOS   = 4'h0;
  assign M_AXI_AWUSER  = 'b1;
  assign M_AXI_AWVALID = axi_awvalid;

  assign M_AXI_WDATA  = axi_wdata;
  assign M_AXI_WSTRB  = {(C_M_AXI_DATA_WIDTH/8){1'b1}};
  assign M_AXI_WLAST  = axi_wlast;
  assign M_AXI_WUSER  = 'b0;
  assign M_AXI_WVALID = axi_wvalid;

  assign M_AXI_BREADY = axi_bready;

  assign M_AXI_ARID    = 'b0;
  assign M_AXI_ARADDR  = C_M_TARGET_SLAVE_BASE_ADDR + axi_araddr;
  assign M_AXI_ARLEN   = C_M_AXI_BURST_LEN - 1;
  assign M_AXI_ARSIZE  = clogb2((C_M_AXI_DATA_WIDTH/8)-1);
  assign M_AXI_ARBURST = 2'b01;
  assign M_AXI_ARLOCK  = 1'b0;
  assign M_AXI_ARCACHE = 4'b0010;
  assign M_AXI_ARPROT  = 3'h0;
  assign M_AXI_ARQOS   = 4'h0;
  assign M_AXI_ARUSER  = 'b1;
  assign M_AXI_ARVALID = axi_arvalid;

  assign M_AXI_RREADY = axi_rready;

  assign TXN_DONE         = writes_done;
  assign burst_size_bytes = C_M_AXI_BURST_LEN * C_M_AXI_DATA_WIDTH/8;
  assign init_txn_pulse   = (!init_txn_ff2) && init_txn_ff;

  //Generate a pulse to initiate AXI transaction.
  always @(posedge M_AXI_ACLK) begin
    if (M_AXI_ARESETN == 0) begin
      init_txn_ff  <= 1'b0;
      init_txn_ff2 <= 1'b0;
    end else begin
      init_txn_ff  <= INIT_AXI_TXN;
      init_txn_ff2 <= init_txn_ff;
    end
  end

  //--------------------
  //Write Address Channel
  //--------------------

  always @(posedge M_AXI_ACLK) begin
    if (M_AXI_ARESETN == 0 || init_txn_pulse == 1'b1 ) begin
      axi_awvalid <= 1'b0;
    end else begin
      if (~axi_awvalid && start_single_burst_write) begin
        axi_awvalid <= 1'b1;
      end else begin
        if (M_AXI_AWREADY && axi_awvalid) begin
          axi_awvalid <= 1'b0;
        end else begin
          axi_awvalid <= axi_awvalid;
        end
      end
    end
  end

  // The address will be incremented on each accepted address transaction,
  // by burst_size_byte to point to the next address.
  always @(posedge M_AXI_ACLK) begin
    if (M_AXI_ARESETN == 0 || init_txn_pulse == 1'b1) begin
      axi_awaddr <= 'b0;
    end else begin
      if (M_AXI_AWREADY && axi_awvalid) begin
        axi_awaddr <= axi_awaddr + burst_size_bytes;
      end else begin
        axi_awaddr <= axi_awaddr;
      end
    end
  end

  //--------------------
  //Write Data Channel
  //--------------------

  // Forward movement occurs when the write channel is valid and ready
  assign wnext = M_AXI_WREADY & axi_wvalid;

  // Write data is valid fo the entire burst
  always @(posedge M_AXI_ACLK) begin
    if (M_AXI_ARESETN == 0 || init_txn_pulse == 1'b1 ) begin
      axi_wvalid <= 1'b0;
    end else begin
      if (~axi_wvalid && start_single_burst_write) begin
        axi_wvalid <= 1'b1;
      end else begin
        if (wnext && axi_wlast) begin
          axi_wvalid <= 1'b0;
        end else begin
          axi_wvalid <= axi_wvalid;
        end
      end
    end
  end

  // WLAST generation on the MSB of a counter underflow
  always @(posedge M_AXI_ACLK) begin
    if (M_AXI_ARESETN == 0 || init_txn_pulse == 1'b1 ) begin
      axi_wlast <= 1'b0;
    end else begin
      if (((write_index == C_M_AXI_BURST_LEN-2 && C_M_AXI_BURST_LEN >= 2) && wnext) || (C_M_AXI_BURST_LEN == 1 )) begin
        axi_wlast <= 1'b1;
      end else begin
        if (wnext) begin
          axi_wlast <= 1'b0;
        end else begin
          if (axi_wlast && C_M_AXI_BURST_LEN == 1) begin
            axi_wlast <= 1'b0;
          end else begin
            axi_wlast <= axi_wlast;
          end
        end
      end
    end
  end

  // Burst length counter
  always @(posedge M_AXI_ACLK) begin
    if (M_AXI_ARESETN == 0 || init_txn_pulse == 1'b1 || start_single_burst_write == 1'b1) begin
      write_index <= 0;
    end else begin
      if (wnext && (write_index != C_M_AXI_BURST_LEN-1)) begin
        write_index <= write_index + 1;
      end else begin
        write_index <= write_index;
      end
    end
  end

  // Write Data Generator
  always @(posedge M_AXI_ACLK) begin
    if (M_AXI_ARESETN == 0 || init_txn_pulse == 1'b1) begin
      axi_wdata <= 'b0;
    end else begin
      if (wnext) begin
        axi_wdata <= axi_wdata + 1'b1;
      end else begin
        axi_wdata <= axi_wdata;
      end
    end
  end

  //----------------------------
  //Write Response (B) Channel
  //----------------------------

  always @(posedge M_AXI_ACLK) begin
    if (M_AXI_ARESETN == 0 || init_txn_pulse == 1'b1 ) begin
      axi_bready <= 1'b0;
    end
    else begin
      if (M_AXI_BVALID && ~axi_bready) begin
        axi_bready <= 1'b1;
      end
      else begin
        if (axi_bready) begin
          axi_bready <= 1'b0;
        end else begin
          axi_bready <= axi_bready;
        end
      end
    end
  end

  // BRESP[1] is used indicate any errors from the interconnect or
  // slave for the entire write burst
  assign write_resp_error = axi_bready & M_AXI_BVALID & M_AXI_BRESP[1];

  //----------------------------
  //Read Address Channel
  //----------------------------

  always @(posedge M_AXI_ACLK) begin
    if (M_AXI_ARESETN == 0 || init_txn_pulse == 1'b1 ) begin
      axi_arvalid <= 1'b0;
    end else begin
      if (~axi_arvalid && start_single_burst_read) begin
        axi_arvalid <= 1'b1;
      end else begin
        if (M_AXI_ARREADY && axi_arvalid) begin
          axi_arvalid <= 1'b0;
        end else begin
          axi_arvalid <= axi_arvalid;
        end
      end
    end
  end

  // Next address after ARREADY indicates previous address acceptance
  always @(posedge M_AXI_ACLK) begin
    if (M_AXI_ARESETN == 0 || init_txn_pulse == 1'b1) begin
      axi_araddr <= 'b0;
    end else begin
      if (M_AXI_ARREADY && axi_arvalid) begin
        axi_araddr <= axi_araddr + burst_size_bytes;
      end else begin
        axi_araddr <= axi_araddr;
      end
    end
  end

  //--------------------------------
  //Read Data (and Response) Channel
  //--------------------------------

  // Forward movement occurs when the channel is valid and ready
  assign rnext = M_AXI_RVALID && axi_rready;

  // Burst length read counter
  always @(posedge M_AXI_ACLK) begin
    if (M_AXI_ARESETN == 0 || init_txn_pulse == 1'b1 || start_single_burst_read) begin
      read_index <= 0;
    end else begin
      if (rnext && (read_index != C_M_AXI_BURST_LEN-1)) begin
        read_index <= read_index + 1;
      end else begin
        read_index <= read_index;
      end
    end
  end

  // The Read Data channel returns the results of the read request
  always @(posedge M_AXI_ACLK) begin
    if (M_AXI_ARESETN == 0 || init_txn_pulse == 1'b1 ) begin
      axi_rready <= 1'b0;
    end else begin
      if (M_AXI_RVALID) begin
          if (M_AXI_RLAST && axi_rready) begin
            axi_rready <= 1'b0;
          end else begin
            axi_rready <= 1'b1;
          end
      end
    end
    // retain the previous value
  end

  //Check received read data against data generator
  always @(posedge M_AXI_ACLK) begin
    if (M_AXI_ARESETN == 0 || init_txn_pulse == 1'b1) begin
      read_mismatch <= 1'b0;
    end else begin
      if (rnext && (M_AXI_RDATA != expected_rdata)) begin
        read_mismatch <= 1'b1;
      end else begin
        read_mismatch <= 1'b0;
      end
    end
  end

  // RRESP[1] is used indicate any errors from the interconnect or
  // slave for the entire write burst
  assign read_resp_error = axi_rready & M_AXI_RVALID & M_AXI_RRESP[1];

  //----------------------------------
  //Example design error register
  //----------------------------------

  //Register and hold any data mismatches, or read/write interface errors
  always @(posedge M_AXI_ACLK) begin
    if (M_AXI_ARESETN == 0 || init_txn_pulse == 1'b1) begin
      error_reg <= 1'b0;
    end else begin
      if (read_mismatch || write_resp_error || read_resp_error) begin
        error_reg <= 1'b1;
      end else begin
        error_reg <= error_reg;
      end
    end
  end

  //--------------------------------
  //Example design throttling
  //--------------------------------

  // For maximum port throughput, this user example code will try to allow
  // each channel to run as independently and as quickly as possible.

  // However, there are times when the flow of data needs to be throtted by
  // the user application. This example application requires that data is
  // not read before it is written and that the write channels do not
  // advance beyond an arbitrary threshold (say to prevent an
  // overrun of the current read address by the write address).

  // This example accomplishes this user application throttling through:
  // -Reads wait for writes to fully complete
  // -Address writes wait when not read + issued transaction counts pass
  // a parameterized threshold
  // -Writes wait when a not read + active data burst count pass
  // a parameterized threshold

  // write_burst_counter counter keeps track with the number of burst transaction initiated
  // against the number of burst transactions the master needs to initiate
  always @(posedge M_AXI_ACLK) begin
    if (M_AXI_ARESETN == 0 || init_txn_pulse == 1'b1 ) begin
      write_burst_counter <= 'b0;
    end else begin
      if (M_AXI_AWREADY && axi_awvalid) begin
        if (write_burst_counter[C_NO_BURSTS_REQ] == 1'b0) begin
          write_burst_counter <= write_burst_counter + 1'b1;
        end
      end else begin
        write_burst_counter <= write_burst_counter;
      end
    end
  end

  // read_burst_counter counter keeps track with the number of burst transaction initiated
  // against the number of burst transactions the master needs to initiate
  always @(posedge M_AXI_ACLK) begin
    if (M_AXI_ARESETN == 0 || init_txn_pulse == 1'b1) begin
      read_burst_counter <= 'b0;
    end else begin
      if (M_AXI_ARREADY && axi_arvalid) begin
        if (read_burst_counter[C_NO_BURSTS_REQ] == 1'b0) begin
          read_burst_counter <= read_burst_counter + 1'b1;
        end
      end else begin
        read_burst_counter <= read_burst_counter;
      end
    end
  end

  //----------------------------------------
  //Example design read check data generator
  //-----------------------------------------

  //Generate expected read data to check against actual read data
  always @(posedge M_AXI_ACLK) begin
    if (M_AXI_ARESETN == 0 || init_txn_pulse == 1'b1) begin
      expected_rdata <= 'b1;
    end else begin
      if (M_AXI_RVALID && axi_rready) begin
        expected_rdata <= expected_rdata + 1;
      end else begin
        expected_rdata <= expected_rdata;
      end
    end
  end

  //implement master command interface state machine

  always @ ( posedge M_AXI_ACLK ) begin
    if (M_AXI_ARESETN == 1'b0) begin
      // reset condition
      mst_exec_state           <= IDLE;
      start_single_burst_write <= 1'b0;
      start_single_burst_read  <= 1'b0;
      compare_done             <= 1'b0;
      ERROR                    <= 1'b0;
    end else begin
      case (mst_exec_state)
        IDLE:
          // This state is responsible to wait for user defined C_M_START_COUNT
          // number of clock cycles.
          if ( init_txn_pulse == 1'b1) begin
            mst_exec_state <= INIT_WRITE;
            ERROR          <= 1'b0;
            compare_done   <= 1'b0;
          end else begin
            mst_exec_state  <= IDLE;
          end

        INIT_WRITE:
          // write controller
          if (writes_done) begin
            mst_exec_state <= IDLE;
          end else begin
            mst_exec_state  <= INIT_WRITE;

            if (~axi_awvalid && ~start_single_burst_write && ~burst_write_active) begin
              start_single_burst_write <= 1'b1;
            end else begin
              start_single_burst_write <= 1'b0;
            end
          end

        // INIT_READ:
        //   // read controller
        //   if (reads_done) begin
        //     mst_exec_state <= IDLE;
        //   end else begin
        //     mst_exec_state  <= INIT_READ;

        //     if (~axi_arvalid && ~burst_read_active && ~start_single_burst_read) begin
        //       start_single_burst_read <= 1'b1;
        //     end else begin
        //       start_single_burst_read <= 1'b0;
        //     end
        //   end

        // INIT_COMPARE:
        //   begin
        //     ERROR          <= error_reg;
        //     mst_exec_state <= IDLE;
        //     compare_done   <= 1'b1;
        //   end

        default :
          begin
            mst_exec_state  <= IDLE;
          end

      endcase
    end
  end //MASTER_EXECUTION_PROC

  // burst_write_active signal is asserted when there is a burst write transaction
  // is initiated by the assertion of start_single_burst_write. burst_write_active
  // signal remains asserted until the burst write is accepted by the slave
  always @(posedge M_AXI_ACLK) begin
    if (M_AXI_ARESETN == 0 || init_txn_pulse == 1'b1) begin
      burst_write_active <= 1'b0;
    end else begin
      if (start_single_burst_write) begin
        burst_write_active <= 1'b1;
      end else begin
        if (M_AXI_BVALID && axi_bready) begin
          burst_write_active <= 0;
        end
      end
    end
  end

  // Check for last write completion.
  always @(posedge M_AXI_ACLK) begin
    if (M_AXI_ARESETN == 0 || init_txn_pulse == 1'b1) begin
      writes_done <= 1'b0;
    end else begin
      if (M_AXI_BVALID && (write_burst_counter[C_NO_BURSTS_REQ]) && axi_bready) begin
        writes_done <= 1'b1;
      end else begin
        writes_done <= writes_done;
      end
    end
  end

  always @(posedge M_AXI_ACLK) begin
    if (M_AXI_ARESETN == 0 || init_txn_pulse == 1'b1) begin
      burst_read_active <= 1'b0;
    end else begin
      if (start_single_burst_read) begin
        burst_read_active <= 1'b1;
      end else begin
        if (M_AXI_RVALID && axi_rready && M_AXI_RLAST) begin
          burst_read_active <= 0;
        end
      end
    end
  end

  // Check for last read completion.
  always @(posedge M_AXI_ACLK) begin
    if (M_AXI_ARESETN == 0 || init_txn_pulse == 1'b1) begin
      reads_done <= 1'b0;
    end else begin
      if (M_AXI_RVALID && axi_rready && (read_index == C_M_AXI_BURST_LEN-1) && (read_burst_counter[C_NO_BURSTS_REQ])) begin
        reads_done <= 1'b1;
      end else begin
        reads_done <= reads_done;
      end
    end
  end

  // Add user logic here

  // User logic ends

  endmodule
