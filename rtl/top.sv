`timescale 1 ps / 1 ps
`include "constants.svh"

(* CORE_GENERATION_INFO = "axi_vip,IP_Integrator,{x_ipVendor=xilinx.com,x_ipLibrary=BlockDiagram,x_ipName=axi_vip,x_ipVersion=1.00.a,x_ipLanguage=VERILOG,numBlks=2,numReposBlks=2,numNonXlnxBlks=1,numHierBlks=0,maxHierDepth=0,numSysgenBlks=0,numHlsBlks=0,numHdlrefBlks=0,numPkgbdBlks=0,bdsource=USER,synth_mode=OOC_per_IP}" *) (* HW_HANDOFF = "axi_vip.hwdef" *)
module `WRAPPER (
  ACLK,
  ARESETN,

  // User to add ports here
  oAXI_ERROR,
  iINIT_AXI_TXN,
  oAXI_TXN_DONE
  // User ports end
);
  (* X_INTERFACE_INFO = "xilinx.com:signal:clock:1.0 CLK.ACLK CLK" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME CLK.ACLK, ASSOCIATED_RESET ARESETN, CLK_DOMAIN axi_vip_m00_axi_aclk_0, FREQ_HZ 100000000, INSERT_VIP 0, PHASE 0.000" *) input ACLK;
  (* X_INTERFACE_INFO = "xilinx.com:signal:reset:1.0 RST.ARESETN RST" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME RST.ARESETN, INSERT_VIP 0, POLARITY ACTIVE_LOW" *) input ARESETN;

  output oAXI_ERROR;
  input iINIT_AXI_TXN;
  output oAXI_TXN_DONE;

  // AXI4Full Master Signals
  wire  [34:0]  wARADDR;
  wire  [1:0]   wARBURST;
  wire  [3:0]   wARCACHE;
  wire  [0:0]   wARID;
  wire  [7:0]   wARLEN;
  wire          wARLOCK;
  wire  [2:0]   wARPROT;
  wire  [3:0]   wARQOS;
  wire          wARREADY;
  wire  [1:0]   wARUSER;
  wire          wARVALID;
  wire  [34:0]  wAWADDR;
  wire  [1:0]   wAWBURST;
  wire  [3:0]   wAWCACHE;
  wire  [0:0]   wAWID;
  wire  [7:0]   wAWLEN;
  wire          wAWLOCK;
  wire  [2:0]   wAWPROT;
  wire  [3:0]   wAWQOS;
  wire          wAWREADY;
  wire  [1:0]   wAWUSER;
  wire          wAWVALID;
  wire  [0:0]   wBID;
  wire          wBREADY;
  wire  [1:0]   wBRESP;
  wire  [1:0]   wBUSER;
  wire          wBVALID;
  wire  [31:0]  wRDATA;
  wire  [0:0]   wRID;
  wire          wRLAST;
  wire          wRREADY;
  wire  [1:0]   wRRESP;
  wire  [1:0]   wRUSER;
  wire          wRVALID;
  wire  [31:0]  wWDATA;
  wire          wWLAST;
  wire          wWREADY;
  wire  [3:0]   wWSTRB;
  wire  [1:0]   wWUSER;
  wire          wWVALID;

  //////////// User to edit here
  // User ports
  wire  werror;
  wire  wtxn_done;
  wire  winit_axi_txn;

  // User I/O
  assign oAXI_ERROR    = werror;
  assign oAXI_TXN_DONE = wtxn_done;
  assign winit_axi_txn = iINIT_AXI_TXN;

  `DUT_TOP_NAME `DUT_TOP_INST (

    .m00_axi_init_axi_txn (winit_axi_txn),
    .m00_axi_txn_done     (wtxn_done),
    .m00_axi_error        (werror),

    //////////// User edit end

    // AXI4Full Master Signals
    .m00_axi_aclk    (ACLK),
    .m00_axi_aresetn (ARESETN),
    .m00_axi_araddr  (wARADDR),
    .m00_axi_arburst (wARBURST),
    .m00_axi_arcache (wARCACHE),
    .m00_axi_arid    (wARID),
    .m00_axi_arlen   (wARLEN),
    .m00_axi_arlock  (wARLOCK),
    .m00_axi_arprot  (wARPROT),
    .m00_axi_arqos   (wARQOS),
    .m00_axi_arready (wARREADY),
    .m00_axi_aruser  (wARUSER),
    .m00_axi_arvalid (wARVALID),
    .m00_axi_awaddr  (wAWADDR),
    .m00_axi_awburst (wAWBURST),
    .m00_axi_awcache (wAWCACHE),
    .m00_axi_awid    (wAWID),
    .m00_axi_awlen   (wAWLEN),
    .m00_axi_awlock  (wAWLOCK),
    .m00_axi_awprot  (wAWPROT),
    .m00_axi_awqos   (wAWQOS),
    .m00_axi_awready (wAWREADY),
    .m00_axi_awuser  (wAWUSER),
    .m00_axi_awvalid (wAWVALID),
    .m00_axi_bid     (wBID),
    .m00_axi_bready  (wBREADY),
    .m00_axi_bresp   (wBRESP),
    .m00_axi_buser   (wBUSER),
    .m00_axi_bvalid  (wBVALID),
    .m00_axi_rdata   (wRDATA),
    .m00_axi_rid     (wRID),
    .m00_axi_rlast   (wRLAST),
    .m00_axi_rready  (wRREADY),
    .m00_axi_rresp   (wRRESP),
    .m00_axi_ruser   (wRUSER),
    .m00_axi_rvalid  (wRVALID),
    .m00_axi_wdata   (wWDATA),
    .m00_axi_wlast   (wWLAST),
    .m00_axi_wready  (wWREADY),
    .m00_axi_wstrb   (wWSTRB),
    .m00_axi_wuser   (wWUSER),
    .m00_axi_wvalid  (wWVALID)
  );

  `VIP_NAME `VIP_INST_NAME(
    .aclk          (ACLK),
    .aresetn       (ARESETN),
    .s_axi_araddr  (wARADDR),
    .s_axi_arburst (wARBURST),
    .s_axi_arcache (wARCACHE),
    .s_axi_arid    (wARID),
    .s_axi_arlen   (wARLEN),
    .s_axi_arlock  (wARLOCK),
    .s_axi_arprot  (wARPROT),
    .s_axi_arqos   (wARQOS),
    .s_axi_arready (wARREADY),
    .s_axi_aruser  (wARUSER),
    .s_axi_arvalid (wARVALID),
    .s_axi_awaddr  (wAWADDR),
    .s_axi_awburst (wAWBURST),
    .s_axi_awcache (wAWCACHE),
    .s_axi_awid    (wAWID),
    .s_axi_awlen   (wAWLEN),
    .s_axi_awlock  (wAWLOCK),
    .s_axi_awprot  (wAWPROT),
    .s_axi_awqos   (wAWQOS),
    .s_axi_awready (wAWREADY),
    .s_axi_awuser  (wAWUSER),
    .s_axi_awvalid (wAWVALID),
    .s_axi_bid     (wBID),
    .s_axi_bready  (wBREADY),
    .s_axi_bresp   (wBRESP),
    .s_axi_buser   (wBUSER),
    .s_axi_bvalid  (wBVALID),
    .s_axi_rdata   (wRDATA),
    .s_axi_rid     (wRID),
    .s_axi_rlast   (wRLAST),
    .s_axi_rready  (wRREADY),
    .s_axi_rresp   (wRRESP),
    .s_axi_ruser   (wRUSER),
    .s_axi_rvalid  (wRVALID),
    .s_axi_wdata   (wWDATA),
    .s_axi_wlast   (wWLAST),
    .s_axi_wready  (wWREADY),
    .s_axi_wstrb   (wWSTRB),
    .s_axi_wuser   (wWUSER),
    .s_axi_wvalid  (wWVALID)
  );

endmodule
