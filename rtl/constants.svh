`ifndef __constants_vh__
`define __constants_vh__

/////////////////////////////////////////
// User defined constants

`define CONSTANT_VIP_INTERFACE     2
`define CONSTANT_AXI_ID_WIDTH      1
`define CONSTANT_AXI_ADDR_WIDTH    32
`define CONSTANT_AXI_DATA_WIDTH    32
`define CONSTANT_AXI_AWUSER_WIDTH  1
`define CONSTANT_AXI_ARUSER_WIDTH  1
`define CONSTANT_AXI_WUSER_WIDTH   1
`define CONSTANT_AXI_RUSER_WIDTH   1
`define CONSTANT_AXI_BUSER_WIDTH   1

// User constants end
/////////////////////////////////////////
// THIS WAS AUTOMATICALLY GENERATED
// DO NOT CHANGE THE FOLLOWING PARAMETERS

`define DUT_M00_NAME     axi4_full_v1_0_M00_AXI
`define DUT_M00_INST     inst

`define WRAPPER          axi_vip_wrapper
`define VIP_INST_NAME    axi_vip_inst

`define DUT_PATH         DUT.`DUT_M00_INST
`define VIP_ITF_PATH     DUT.`VIP_INST_NAME.IF

`endif // __constants_vh__
