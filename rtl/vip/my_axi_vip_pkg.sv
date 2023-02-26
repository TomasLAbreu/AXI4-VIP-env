`timescale 1ps/1ps
`include "../rtl/constants.svh"

package my_axi_vip_pkg;
import axi_vip_pkg::*;

parameter VIP_PROTOCOL        = 0;
parameter VIP_READ_WRITE_MODE = "READ_WRITE";
parameter VIP_INTERFACE_MODE  = `CONSTANT_VIP_INTERFACE;
parameter VIP_ADDR_WIDTH      = `CONSTANT_AXI_ADDR_WIDTH;
parameter VIP_DATA_WIDTH      = `CONSTANT_AXI_DATA_WIDTH;
parameter VIP_ID_WIDTH        = `CONSTANT_AXI_ID_WIDTH;
parameter VIP_AWUSER_WIDTH    = `CONSTANT_AXI_AWUSER_WIDTH;
parameter VIP_ARUSER_WIDTH    = `CONSTANT_AXI_ARUSER_WIDTH;
parameter VIP_RUSER_WIDTH     = `CONSTANT_AXI_WUSER_WIDTH;
parameter VIP_WUSER_WIDTH     = `CONSTANT_AXI_RUSER_WIDTH;
parameter VIP_BUSER_WIDTH     = `CONSTANT_AXI_BUSER_WIDTH;
parameter VIP_SUPPORTS_NARROW = 0;
parameter VIP_HAS_BURST       = 1;
parameter VIP_HAS_LOCK        = 1;
parameter VIP_HAS_CACHE       = 1;
parameter VIP_HAS_REGION      = 0;
parameter VIP_HAS_QOS         = 1;
parameter VIP_HAS_PROT        = 1;
parameter VIP_HAS_WSTRB       = 1;
parameter VIP_HAS_BRESP       = 1;
parameter VIP_HAS_RRESP       = 1;
parameter VIP_HAS_ACLKEN      = 0;
parameter VIP_HAS_ARESETN     = 1;

typedef axi_slv_agent #(
  VIP_PROTOCOL,
  VIP_ADDR_WIDTH,
  VIP_DATA_WIDTH,
  VIP_DATA_WIDTH,
  VIP_ID_WIDTH,
  VIP_ID_WIDTH,
  VIP_AWUSER_WIDTH,
  VIP_WUSER_WIDTH,
  VIP_BUSER_WIDTH,
  VIP_ARUSER_WIDTH,
  VIP_RUSER_WIDTH,
  VIP_SUPPORTS_NARROW,
  VIP_HAS_BURST,
  VIP_HAS_LOCK,
  VIP_HAS_CACHE,
  VIP_HAS_REGION,
  VIP_HAS_PROT,
  VIP_HAS_QOS,
  VIP_HAS_WSTRB,
  VIP_HAS_BRESP,
  VIP_HAS_RRESP,
  VIP_HAS_ARESETN
) axi_vip_slv_t;

typedef axi_slv_mem_agent #(
  VIP_PROTOCOL,
  VIP_ADDR_WIDTH,
  VIP_DATA_WIDTH,
  VIP_DATA_WIDTH,
  VIP_ID_WIDTH,
  VIP_ID_WIDTH,
  VIP_AWUSER_WIDTH,
  VIP_WUSER_WIDTH,
  VIP_BUSER_WIDTH,
  VIP_ARUSER_WIDTH,
  VIP_RUSER_WIDTH,
  VIP_SUPPORTS_NARROW,
  VIP_HAS_BURST,
  VIP_HAS_LOCK,
  VIP_HAS_CACHE,
  VIP_HAS_REGION,
  VIP_HAS_PROT,
  VIP_HAS_QOS,
  VIP_HAS_WSTRB,
  VIP_HAS_BRESP,
  VIP_HAS_RRESP,
  VIP_HAS_ARESETN
) axi_vip_slv_mem_t;

endpackage : my_axi_vip_pkg
