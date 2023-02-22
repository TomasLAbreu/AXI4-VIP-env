`ifndef __constants_vh__
`define __constants_vh__

///////////////////////////////////////////////////////////////////////////////
// User defined constants

`define DUT_TOP_NAME axi4_full_v1_0
`define DUT_TOP_INST axi4_full_v1_0_inst

`define DUT_M00_NAME axi4_full_v1_0_M00_AXI
`define DUT_M00_INST axi4_full_v1_0_M00_AXI_inst

// User defined constants end
///////////////////////////////////////////////////////////////////////////////
// Configuration IP names

`define WRAPPER   axi_vip_wrapper

`define VIP_NAME      axi_vip_axi_vip_0_0
// `define VIP_INST_NAME axi_vip_0
`define VIP_INST_NAME axi_vip_inst

// DUT hierarchical path is tb_axi_vip/axi_vip_wrapper/
`define DUT_PATH     DUT.`DUT_TOP_INST.`DUT_M00_INST
`define VIP_ITF_PATH DUT.`VIP_INST_NAME.IF

// add in protoinst
// modules: WRAPPER
// proto_instances: VIP_INST_NAME/S_AXI, DUT_TOP_INST/M00_AXI
///////////////////////////////////////////////////////////////////////////////

`define CONSTANT_VIP_INTERFACE     2
`define CONSTANT_AXI_ID_WIDTH      1
`define CONSTANT_AXI_ADDR_WIDTH    32
`define CONSTANT_AXI_DATA_WIDTH    32
`define CONSTANT_AXI_AWUSER_WIDTH  1
`define CONSTANT_AXI_ARUSER_WIDTH  1
`define CONSTANT_AXI_WUSER_WIDTH   1
`define CONSTANT_AXI_RUSER_WIDTH   1
`define CONSTANT_AXI_BUSER_WIDTH   1

`endif // __constants_vh__

