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
  wire  werror;
  wire  wtxn_done;
  wire  winit_axi_txn;

  // User I/O
  assign AXI_ERROR    = werror;
  assign AXI_TXN_DONE = wtxn_done;
  assign winit_axi_txn = INIT_AXI_TXN;

  `DUT_TOP_NAME #(
    .C_M00_AXI_ADDR_WIDTH   (MP_AXI_ADDR_WIDTH),
    .C_M00_AXI_DATA_WIDTH   (MP_AXI_DATA_WIDTH),
    .C_M00_AXI_ID_WIDTH     (MP_AXI_ID_WIDTH),
    .C_M00_AXI_AWUSER_WIDTH (MP_AXI_AWUSER_WIDTH),
    .C_M00_AXI_ARUSER_WIDTH (MP_AXI_ARUSER_WIDTH),
    .C_M00_AXI_WUSER_WIDTH  (MP_AXI_WUSER_WIDTH),
    .C_M00_AXI_RUSER_WIDTH  (MP_AXI_RUSER_WIDTH),
    .C_M00_AXI_BUSER_WIDTH  (MP_AXI_BUSER_WIDTH)
  ) `DUT_TOP_INST (

    .m00_axi_init_axi_txn (winit_axi_txn),
    .m00_axi_txn_done     (wtxn_done),
    .m00_axi_error        (werror),

    // .waxi_slv_base_waddr(0),
    // .waxi_slv_base_raddr(0),
    // .waxi_burst_len(9'b0),
    // .waxi_num_burst(0),
    // .waxi_op_type(2'b0),
    //////////// User edit end

    // AXI4Full Master Signals
    .m00_axi_aclk    (ACLK),
    .m00_axi_aresetn (ARESETN),
    .m00_axi_araddr  (araddr),
    .m00_axi_arburst (arburst),
    .m00_axi_arcache (arcache),
    .m00_axi_arid    (arid),
    .m00_axi_arlen   (arlen),
    .m00_axi_arlock  (arlock),
    .m00_axi_arprot  (arprot),
    .m00_axi_arqos   (arqos),
    .m00_axi_arready (arready),
    .m00_axi_aruser  (aruser),
    .m00_axi_arvalid (arvalid),
    .m00_axi_awaddr  (awaddr),
    .m00_axi_awburst (awburst),
    .m00_axi_awcache (awcache),
    .m00_axi_awid    (awid),
    .m00_axi_awlen   (awlen),
    .m00_axi_awlock  (awlock),
    .m00_axi_awprot  (awprot),
    .m00_axi_awqos   (awqos),
    .m00_axi_awready (awready),
    .m00_axi_awuser  (awuser),
    .m00_axi_awvalid (awvalid),
    .m00_axi_bid     (bid),
    .m00_axi_bready  (bready),
    .m00_axi_bresp   (bresp),
    .m00_axi_buser   (buser),
    .m00_axi_bvalid  (bvalid),
    .m00_axi_rdata   (rdata),
    .m00_axi_rid     (rid),
    .m00_axi_rlast   (rlast),
    .m00_axi_rready  (rready),
    .m00_axi_rresp   (rresp),
    .m00_axi_ruser   (ruser),
    .m00_axi_rvalid  (rvalid),
    .m00_axi_wdata   (wdata),
    .m00_axi_wlast   (wlast),
    .m00_axi_wready  (wready),
    .m00_axi_wstrb   (wstrb),
    .m00_axi_wuser   (wuser),
    .m00_axi_wvalid  (wvalid)
  );

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
    .s_axi_awsize   (3'B0),
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
    .s_axi_arsize   (3'B0),
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
