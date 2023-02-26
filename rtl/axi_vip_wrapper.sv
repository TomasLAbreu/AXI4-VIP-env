`timescale 1 ps / 1 ps
`include "constants.svh"

module axi_vip_wrapper #(
  parameter integer MP_AXI_ID_WIDTH     = 1,
  parameter integer MP_AXI_ADDR_WIDTH   = 32,
  parameter integer MP_AXI_DATA_WIDTH   = 32,
  parameter integer MP_AXI_AWUSER_WIDTH = 1,
  parameter integer MP_AXI_ARUSER_WIDTH = 1,
  parameter integer MP_AXI_WUSER_WIDTH  = 1,
  parameter integer MP_AXI_RUSER_WIDTH  = 1,
  parameter integer MP_AXI_BUSER_WIDTH  = 1
)(
  input ACLK,
  input ARESETN,

  // User to add ports here
  input INIT_AXI_TXN,
  output AXI_ERROR,
  output AXI_TXN_DONE
  // User ports end
);

  // AXI4Full Master Signals
  wire  [MP_AXI_ID_WIDTH-1 : 0]     awid;
  wire  [MP_AXI_ADDR_WIDTH-1 : 0]   awaddr;
  wire  [7 : 0]                     awlen;
  wire  [2 : 0]                     awsize;
  wire  [1 : 0]                     awburst;
  wire  [0 : 0]                     awlock;
  wire  [3 : 0]                     awcache;
  wire  [2 : 0]                     awprot;
  wire  [3 : 0]                     awqos;
  wire  [MP_AXI_AWUSER_WIDTH-1 : 0] awuser;
  wire                              awvalid;
  wire                              awready;

  wire  [MP_AXI_DATA_WIDTH-1 : 0]   wdata;
  wire  [3 : 0]                     wstrb;
  wire                              wlast;
  wire  [MP_AXI_WUSER_WIDTH-1 : 0]  wuser;
  wire                              wvalid;
  wire                              wready;

  wire  [MP_AXI_ID_WIDTH-1 : 0]     bid;
  wire  [1 : 0]                     bresp;
  wire  [MP_AXI_BUSER_WIDTH-1 : 0]  buser;
  wire                              bvalid;
  wire                              bready;

  wire  [MP_AXI_ID_WIDTH-1 : 0]     arid;
  wire  [MP_AXI_ADDR_WIDTH-1 : 0]   araddr;
  wire  [7 : 0]                     arlen;
  wire  [2 : 0]                     arsize;
  wire  [1 : 0]                     arburst;
  wire  [0 : 0]                     arlock;
  wire  [3 : 0]                     arcache;
  wire  [2 : 0]                     arprot;
  wire  [3 : 0]                     arqos;
  wire  [MP_AXI_ARUSER_WIDTH-1 : 0] aruser;
  wire                              arvalid;
  wire                              arready;

  wire  [MP_AXI_ID_WIDTH-1 : 0]     rid;
  wire  [MP_AXI_DATA_WIDTH-1 : 0]   rdata;
  wire  [1 : 0]                     rresp;
  wire                              rlast;
  wire  [MP_AXI_RUSER_WIDTH-1 : 0]  ruser;
  wire                              rvalid;
  wire                              rready;

  //////////// User to edit here
  // User ports
  // wire  werror;
  // wire  wtxn_done;
  // wire  winit_axi_txn;

  // User I/O
  // assign AXI_ERROR    = werror;
  // assign AXI_TXN_DONE = wtxn_done;
  // assign winit_axi_txn = INIT_AXI_TXN;

  //////////// DUT Instantiation

  `DUT_M00_NAME #(
    .C_M_AXI_ID_WIDTH     (MP_AXI_ID_WIDTH),
    .C_M_AXI_ADDR_WIDTH   (MP_AXI_ADDR_WIDTH),
    .C_M_AXI_DATA_WIDTH   (MP_AXI_DATA_WIDTH),
    .C_M_AXI_AWUSER_WIDTH (MP_AXI_AWUSER_WIDTH),
    .C_M_AXI_ARUSER_WIDTH (MP_AXI_ARUSER_WIDTH),
    .C_M_AXI_WUSER_WIDTH  (MP_AXI_WUSER_WIDTH),
    .C_M_AXI_RUSER_WIDTH  (MP_AXI_RUSER_WIDTH),
    .C_M_AXI_BUSER_WIDTH  (MP_AXI_BUSER_WIDTH)
  ) `DUT_M00_INST (

    // User to add ports here

    .INIT_AXI_TXN  (INIT_AXI_TXN),
    .TXN_DONE      (AXI_TXN_DONE),
    .ERROR         (AXI_ERROR),

    // User ports end

    .M_AXI_ACLK    (ACLK),
    .M_AXI_ARESETN (ARESETN),

    .M_AXI_AWID    (awid),
    .M_AXI_AWADDR  (awaddr),
    .M_AXI_AWLEN   (awlen),
    .M_AXI_AWSIZE  (awsize),
    .M_AXI_AWBURST (awburst),
    .M_AXI_AWLOCK  (awlock),
    .M_AXI_AWCACHE (awcache),
    .M_AXI_AWPROT  (awprot),
    .M_AXI_AWQOS   (awqos),
    .M_AXI_AWUSER  (awuser),
    .M_AXI_AWVALID (awvalid),
    .M_AXI_AWREADY (awready),

    .M_AXI_WDATA   (wdata),
    .M_AXI_WSTRB   (wstrb),
    .M_AXI_WLAST   (wlast),
    .M_AXI_WUSER   (wuser),
    .M_AXI_WVALID  (wvalid),
    .M_AXI_WREADY  (wready),

    .M_AXI_BID     (bid),
    .M_AXI_BRESP   (bresp),
    .M_AXI_BUSER   (buser),
    .M_AXI_BVALID  (bvalid),
    .M_AXI_BREADY  (bready),

    .M_AXI_ARID    (arid),
    .M_AXI_ARADDR  (araddr),
    .M_AXI_ARLEN   (arlen),
    .M_AXI_ARSIZE  (arsize),
    .M_AXI_ARBURST (arburst),
    .M_AXI_ARLOCK  (arlock),
    .M_AXI_ARCACHE (arcache),
    .M_AXI_ARPROT  (arprot),
    .M_AXI_ARQOS   (arqos),
    .M_AXI_ARUSER  (aruser),
    .M_AXI_ARVALID (arvalid),
    .M_AXI_ARREADY (arready),

    .M_AXI_RID     (rid),
    .M_AXI_RDATA   (rdata),
    .M_AXI_RRESP   (rresp),
    .M_AXI_RLAST   (rlast),
    .M_AXI_RUSER   (ruser),
    .M_AXI_RVALID  (rvalid),
    .M_AXI_RREADY  (rready)
  );

  //////////// AXI VIP Instantiation

  axi_vip #(
    .C_AXI_PROTOCOL        (0),
    .C_AXI_INTERFACE_MODE  (`CONSTANT_VIP_INTERFACE),
    .C_AXI_ADDR_WIDTH      (`CONSTANT_AXI_ADDR_WIDTH),
    .C_AXI_WDATA_WIDTH     (`CONSTANT_AXI_DATA_WIDTH),
    .C_AXI_RDATA_WIDTH     (`CONSTANT_AXI_DATA_WIDTH),
    .C_AXI_WID_WIDTH       (`CONSTANT_AXI_ID_WIDTH),
    .C_AXI_RID_WIDTH       (`CONSTANT_AXI_ID_WIDTH),
    .C_AXI_AWUSER_WIDTH    (`CONSTANT_AXI_AWUSER_WIDTH),
    .C_AXI_ARUSER_WIDTH    (`CONSTANT_AXI_ARUSER_WIDTH),
    .C_AXI_WUSER_WIDTH     (`CONSTANT_AXI_WUSER_WIDTH),
    .C_AXI_RUSER_WIDTH     (`CONSTANT_AXI_RUSER_WIDTH),
    .C_AXI_BUSER_WIDTH     (`CONSTANT_AXI_BUSER_WIDTH),
    .C_AXI_SUPPORTS_NARROW (0),
    .C_AXI_HAS_BURST       (1),
    .C_AXI_HAS_LOCK        (1),
    .C_AXI_HAS_CACHE       (1),
    .C_AXI_HAS_REGION      (0),
    .C_AXI_HAS_PROT        (1),
    .C_AXI_HAS_QOS         (1),
    .C_AXI_HAS_WSTRB       (1),
    .C_AXI_HAS_BRESP       (1),
    .C_AXI_HAS_RRESP       (1),
    .C_AXI_HAS_ARESETN     (1)
  ) axi_vip_inst (
    .aclk           (ACLK),
    .aclken         (1'B1),
    .aresetn        (ARESETN),

    // VIP Slave Interface Ports
    .s_axi_awid     (awid),
    .s_axi_awaddr   (awaddr),
    .s_axi_awlen    (awlen),
    // .s_axi_awsize   (3'B0),
    .s_axi_awsize   (awsize),
    .s_axi_awburst  (awburst),
    .s_axi_awlock   (awlock),
    .s_axi_awcache  (awcache),
    .s_axi_awprot   (awprot),
    .s_axi_awregion (4'B0),
    .s_axi_awqos    (awqos),
    .s_axi_awuser   (awuser),
    .s_axi_awvalid  (awvalid),
    .s_axi_awready  (awready),

    .s_axi_wid      (1'B0),
    .s_axi_wdata    (wdata),
    .s_axi_wstrb    (wstrb),
    .s_axi_wlast    (wlast),
    .s_axi_wuser    (wuser),
    .s_axi_wvalid   (wvalid),
    .s_axi_wready   (wready),

    .s_axi_bid      (bid),
    .s_axi_bresp    (bresp),
    .s_axi_buser    (buser),
    .s_axi_bvalid   (bvalid),
    .s_axi_bready   (bready),

    .s_axi_arid     (arid),
    .s_axi_araddr   (araddr),
    .s_axi_arlen    (arlen),
    // .s_axi_arsize   (3'B0),
    .s_axi_arsize   (arsize),
    .s_axi_arburst  (arburst),
    .s_axi_arlock   (arlock),
    .s_axi_arcache  (arcache),
    .s_axi_arprot   (arprot),
    .s_axi_arregion (4'B0),
    .s_axi_arqos    (arqos),
    .s_axi_aruser   (aruser),
    .s_axi_arvalid  (arvalid),
    .s_axi_arready  (arready),

    .s_axi_rid      (rid),
    .s_axi_rdata    (rdata),
    .s_axi_rresp    (rresp),
    .s_axi_rlast    (rlast),
    .s_axi_ruser    (ruser),
    .s_axi_rvalid   (rvalid),
    .s_axi_rready   (rready),

    // VIP Master Interface Ports
    .m_axi_awid     (),
    .m_axi_awaddr   (),
    .m_axi_awlen    (),
    .m_axi_awsize   (),
    .m_axi_awburst  (),
    .m_axi_awlock   (),
    .m_axi_awcache  (),
    .m_axi_awprot   (),
    .m_axi_awregion (),
    .m_axi_awqos    (),
    .m_axi_awuser   (),
    .m_axi_awvalid  (),
    .m_axi_awready  (1'B0),

    .m_axi_wid      (),
    .m_axi_wdata    (),
    .m_axi_wstrb    (),
    .m_axi_wlast    (),
    .m_axi_wuser    (),
    .m_axi_wvalid   (),
    .m_axi_wready   (1'B0),

    .m_axi_bid      (1'B0),
    .m_axi_bresp    (2'B0),
    .m_axi_buser    (1'B0),
    .m_axi_bvalid   (1'B0),
    .m_axi_bready   (),

    .m_axi_arid     (),
    .m_axi_araddr   (),
    .m_axi_arlen    (),
    .m_axi_arsize   (),
    .m_axi_arburst  (),
    .m_axi_arlock   (),
    .m_axi_arcache  (),
    .m_axi_arprot   (),
    .m_axi_arregion (),
    .m_axi_arqos    (),
    .m_axi_aruser   (),
    .m_axi_arvalid  (),
    .m_axi_arready  (1'B0),

    .m_axi_rid      (1'B0),
    .m_axi_rdata    (32'B0),
    .m_axi_rresp    (2'B0),
    .m_axi_rlast    (1'B0),
    .m_axi_ruser    (1'B0),
    .m_axi_rvalid   (1'B0),
    .m_axi_rready   ()
  );

endmodule
