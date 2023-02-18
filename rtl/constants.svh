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

`define WRAPPER   top
`define DUT_PATH  DUT.`DUT_TOP_INST.`DUT_M00_INST

`define VIP_NAME      axi_vip_axi_vip_0_0
`define VIP_INST_NAME axi_vip_0

///////////////////////////////////////////////////////////////////////////////
//Configuration address parameters

`endif // __constants_vh__
