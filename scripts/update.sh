#!/bin/sh

########################################

echo "\n########### Update Script - Vivado v2019.2\n"
dut_dir=../dut
rtl_dir=../rtl

if [ $(ls $dut_dir/ | wc -l) -gt 1 ]; then
  echo "[ERROR  ] Too many files in $dut_dir. Only 1 is required"
  exit
fi

########################################
# update compile file list
vlog_prj=vlog.prj

dut_files="$dut_dir/$(ls $dut_dir)"
dut_name=$(grep -oP '(?<=module ).*?(?=#)' $dut_files)

vip_files="../rtl/vip/axi_vip.sv ../rtl/vip/my_axi_vip_pkg.sv ../rtl/vip/slv_agent.sv"
top_files="../rtl/axi_vip_wrapper.sv"
sim_files="../sim/dut_if.sv ../sim/tb_axi_vip.sv"

echo "[INFO   ] DUT is in $dut_files"
echo "[INFO   ] DUT_M00_NAME is $dut_name"
echo "[scripts] Updating $vlog_prj..."

rm -rf $vlog_prj
echo "verilog xil_defaultlib $dut_files" >> $vlog_prj
echo "sv xil_defaultlib --include \"../rtl\" --include \"../rtl/vip\" $vip_files" >> $vlog_prj
echo "sv xil_defaultlib --include \"../rtl\" --include \"../rtl/vip\" $top_files" >> $vlog_prj
echo "sv xil_defaultlib --include \"../rtl\" $sim_files" >> $vlog_prj
echo "verilog xil_defaultlib \"glbl.v\"" >> $vlog_prj
echo "nosort" >> $vlog_prj

########################################
# update project constants
constants_file=$rtl_dir/constants.svh
echo "\n[scripts] Updating $constants_file..."

rm -rf $constants_file

# print file body
echo "\`ifndef __constants_vh__" >> $constants_file
echo "\`define __constants_vh__" >> $constants_file

echo "\n/////////////////////////////////////////" >> $constants_file
echo "// User defined constants\n" >> $constants_file

echo "\`define CONSTANT_VIP_INTERFACE     2" >> $constants_file
echo "\`define CONSTANT_AXI_ID_WIDTH      1" >> $constants_file
echo "\`define CONSTANT_AXI_ADDR_WIDTH    32" >> $constants_file
echo "\`define CONSTANT_AXI_DATA_WIDTH    32" >> $constants_file
echo "\`define CONSTANT_AXI_AWUSER_WIDTH  1" >> $constants_file
echo "\`define CONSTANT_AXI_ARUSER_WIDTH  1" >> $constants_file
echo "\`define CONSTANT_AXI_WUSER_WIDTH   1" >> $constants_file
echo "\`define CONSTANT_AXI_RUSER_WIDTH   1" >> $constants_file
echo "\`define CONSTANT_AXI_BUSER_WIDTH   1" >> $constants_file

echo "\n// User constants end" >> $constants_file
echo "/////////////////////////////////////////" >> $constants_file
echo "// THIS WAS AUTOMATICALLY GENERATED" >> $constants_file
echo "// DO NOT CHANGE THE FOLLOWING PARAMETERS\n" >> $constants_file

########### insert automatically generated constants
echo "\`define DUT_M00_NAME     $dut_name" >> $constants_file
########### auto generated constants end

echo "\`define DUT_M00_INST     inst\n" >> $constants_file

echo "\`define WRAPPER          axi_vip_wrapper" >> $constants_file
echo "\`define VIP_INST_NAME    axi_vip_inst\n" >> $constants_file

echo "\`define DUT_PATH         DUT.\`DUT_M00_INST" >> $constants_file
echo "\`define VIP_ITF_PATH     DUT.\`VIP_INST_NAME.IF" >> $constants_file

echo "\n\`endif // __constants_vh__" >> $constants_file

########################################
# utils_wcfg=../utils/tb_behav.wcfg

# echo "[utils  ] Updating $utils_wcfg..."
# sed -i "s/$OLD_DUT_TOP_INST/$DUT_TOP_INST/g" $utils_wcfg
# sed -i "s/$OLD_DUT_M00_INST/$DUT_M00_INST/g" $utils_wcfg

########################################

# scripts_protoinst=protoinst_files/axi_vip.protoinst

# echo "\n[INFO   ] Interface master is $DUT_M00_INST/M00_AXI"
# echo "[scripts] Updating $scripts_protoinst..."

# sed -i "s/$OLD_DUT_TOP_INST/$DUT_TOP_INST/g" $scripts_protoinst
