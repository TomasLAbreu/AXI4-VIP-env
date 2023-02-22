`timescale 1ns / 1ps
`include "../rtl/constants.svh"

interface dut_if #
(
  parameter integer C_M00_AXI_ID_WIDTH     = 1,
  parameter integer C_M00_AXI_ADDR_WIDTH   = 32,
  parameter integer C_M00_AXI_DATA_WIDTH   = 32,
  parameter integer C_M00_AXI_AWUSER_WIDTH = 0,
  parameter integer C_M00_AXI_ARUSER_WIDTH = 0,
  parameter integer C_M00_AXI_WUSER_WIDTH  = 0,
  parameter integer C_M00_AXI_RUSER_WIDTH  = 0,
  parameter integer C_M00_AXI_BUSER_WIDTH  = 0
)();

  // User to add input/output ports here
  logic [C_M00_AXI_ADDR_WIDTH-1 : 0]  SLV_BASE_WADDR;
  logic [C_M00_AXI_ADDR_WIDTH-1 : 0]  SLV_BASE_RADDR;
  logic [8 : 0]                       BURST_LEN;
  logic [31 : 0]                      NUM_BURST;

  logic OP_TYPE;
  logic INIT_AXI_TXN;
  logic TXN_DONE;
  logic ERROR;
  logic ACLK;
  logic ARESETN;
  // User ports end

  // AXI4Full Signals
  logic [C_M00_AXI_ID_WIDTH-1 : 0]      AWID;
  logic [C_M00_AXI_ADDR_WIDTH-1 : 0]    AWADDR;
  logic [7 : 0]                         AWLEN;
  logic [2 : 0]                         AWSIZE;
  logic [1 : 0]                         AWBURST;
  logic                                 AWLOCK;
  logic [3 : 0]                         AWCACHE;
  logic [2 : 0]                         AWPROT;
  logic [3 : 0]                         AWQOS;
  logic [C_M00_AXI_AWUSER_WIDTH-1 : 0]  AWUSER;
  logic                                 AWVALID;
  logic                                 AWREADY;
  logic [C_M00_AXI_DATA_WIDTH-1 : 0]    WDATA;
  logic [C_M00_AXI_DATA_WIDTH/8-1 : 0]  WSTRB;
  logic                                 WLAST;
  logic [C_M00_AXI_WUSER_WIDTH-1 : 0]   WUSER;
  logic                                 WVALID;
  logic                                 WREADY;
  logic [C_M00_AXI_ID_WIDTH-1 : 0]      BID;
  logic [1 : 0]                         BRESP;
  logic [C_M00_AXI_BUSER_WIDTH-1 : 0]   BUSER;
  logic                                 BVALID;
  logic                                 BREADY;
  logic [C_M00_AXI_ID_WIDTH-1 : 0]      ARID;
  logic [C_M00_AXI_ADDR_WIDTH-1 : 0]    ARADDR;
  logic [7 : 0]                         ARLEN;
  logic [2 : 0]                         ARSIZE;
  logic [1 : 0]                         ARBURST;
  logic                                 ARLOCK;
  logic [3 : 0]                         ARCACHE;
  logic [2 : 0]                         ARPROT;
  logic [3 : 0]                         ARQOS;
  logic [C_M00_AXI_ARUSER_WIDTH-1 : 0]  ARUSER;
  logic                                 ARVALID;
  logic                                 ARREADY;
  logic [C_M00_AXI_ID_WIDTH-1 : 0]      RID;
  logic [C_M00_AXI_DATA_WIDTH-1 : 0]    RDATA;
  logic [1 : 0]                         RRESP;
  logic                                 RLAST;
  logic [C_M00_AXI_RUSER_WIDTH-1 : 0]   RUSER;
  logic                                 RVALID;
  logic                                 RREADY;

  // User to add internal inst variables
  logic [8:0] write_index;
  logic [8:0] read_index;
  logic [8+3:0] burst_size_bytes;
  // User variables end

  // User to assign dut_if variables to DUT variables
  assign write_index      = `DUT_PATH.write_index;
  assign read_index       = `DUT_PATH.read_index;
  assign burst_size_bytes = `DUT_PATH.burst_size_bytes;

  // User assigns end

  // assign SLV_BASE_WADDR = `DUT_PATH.SLV_BASE_WADDR;
  // assign SLV_BASE_RADDR = `DUT_PATH.SLV_BASE_RADDR;
  // assign BURST_LEN      = `DUT_PATH.BURST_LEN;
  // assign NUM_BURST      = `DUT_PATH.NUM_BURST;
  // assign OP_TYPE        = `DUT_PATH.OP_TYPE;

  assign INIT_AXI_TXN   = `DUT_PATH.INIT_AXI_TXN;
  assign TXN_DONE       = `DUT_PATH.TXN_DONE;
  assign ERROR          = `DUT_PATH.ERROR;
  assign ACLK           = `DUT_PATH.M_AXI_ACLK;
  assign ARESETN        = `DUT_PATH.M_AXI_ARESETN;

  assign AWID    = `DUT_PATH.M_AXI_AWID;
  assign AWADDR  = `DUT_PATH.M_AXI_AWADDR;
  assign AWLEN   = `DUT_PATH.M_AXI_AWLEN;
  assign AWSIZE  = `DUT_PATH.M_AXI_AWSIZE;
  assign AWBURST = `DUT_PATH.M_AXI_AWBURST;
  assign AWLOCK  = `DUT_PATH.M_AXI_AWLOCK;
  assign AWCACHE = `DUT_PATH.M_AXI_AWCACHE;
  assign AWPROT  = `DUT_PATH.M_AXI_AWPROT;
  assign AWQOS   = `DUT_PATH.M_AXI_AWQOS;
  assign AWUSER  = `DUT_PATH.M_AXI_AWUSER;
  assign AWVALID = `DUT_PATH.M_AXI_AWVALID;
  assign AWREADY = `DUT_PATH.M_AXI_AWREADY;
  assign WDATA   = `DUT_PATH.M_AXI_WDATA;
  assign WSTRB   = `DUT_PATH.M_AXI_WSTRB;
  assign WLAST   = `DUT_PATH.M_AXI_WLAST;
  assign WUSER   = `DUT_PATH.M_AXI_WUSER;
  assign WVALID  = `DUT_PATH.M_AXI_WVALID;
  assign WREADY  = `DUT_PATH.M_AXI_WREADY;
  assign BID     = `DUT_PATH.M_AXI_BID;
  assign BRESP   = `DUT_PATH.M_AXI_BRESP;
  assign BUSER   = `DUT_PATH.M_AXI_BUSER;
  assign BVALID  = `DUT_PATH.M_AXI_BVALID;
  assign BREADY  = `DUT_PATH.M_AXI_BREADY;
  assign ARID    = `DUT_PATH.M_AXI_ARID;
  assign ARADDR  = `DUT_PATH.M_AXI_ARADDR;
  assign ARLEN   = `DUT_PATH.M_AXI_ARLEN;
  assign ARSIZE  = `DUT_PATH.M_AXI_ARSIZE;
  assign ARBURST = `DUT_PATH.M_AXI_ARBURST;
  assign ARLOCK  = `DUT_PATH.M_AXI_ARLOCK;
  assign ARCACHE = `DUT_PATH.M_AXI_ARCACHE;
  assign ARPROT  = `DUT_PATH.M_AXI_ARPROT;
  assign ARQOS   = `DUT_PATH.M_AXI_ARQOS;
  assign ARUSER  = `DUT_PATH.M_AXI_ARUSER;
  assign ARVALID = `DUT_PATH.M_AXI_ARVALID;
  assign ARREADY = `DUT_PATH.M_AXI_ARREADY;
  assign RID     = `DUT_PATH.M_AXI_RID;
  assign RDATA   = `DUT_PATH.M_AXI_RDATA;
  assign RRESP   = `DUT_PATH.M_AXI_RRESP;
  assign RLAST   = `DUT_PATH.M_AXI_RLAST;
  assign RUSER   = `DUT_PATH.M_AXI_RUSER;
  assign RVALID  = `DUT_PATH.M_AXI_RVALID;
  assign RREADY  = `DUT_PATH.M_AXI_RREADY;

endinterface : dut_if
