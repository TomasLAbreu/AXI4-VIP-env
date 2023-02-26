#*****************************************************************************************
# Vivado (TM) v2019.2 (64-bit)
#
# create_proj.tcl: Tcl script for re-creating project 'test_zcu'
# "$script_file -tclargs \[--project_name <name>\]"
#*****************************************************************************************

# Set the reference directory for source file relative paths
set origin_dir ".."

# Use origin directory path location variable, if specified in the tcl shell
if { [info exists ::origin_dir_loc] } {
  set origin_dir $::origin_dir_loc
}

# Set the project name
set _xil_proj_name_ "proj"

# Set the directory path for the original project from where this script was exported
# set orig_proj_dir "[file normalize "$origin_dir/WORK"]"

# Create project
create_project ${_xil_proj_name_} ./WORK -part xczu7ev-ffvc1156-2-e

#*******************************************************************************
# Project properties
#*******************************************************************************

# Set the directory path for the new project
set proj_dir [get_property directory [current_project]]

# Set project properties
set obj [current_project]
set_property -name "board_part"                   -value "xilinx.com:zcu104:part0:1.1" -objects $obj
set_property -name "default_lib"                  -value "xil_defaultlib" -objects $obj
set_property -name "enable_vhdl_2008"             -value "1" -objects $obj
set_property -name "ip_cache_permissions"         -value "read write" -objects $obj
set_property -name "ip_output_repo"               -value "$proj_dir/${_xil_proj_name_}.cache/ip" -objects $obj
set_property -name "mem.enable_memory_map_generation" -value "1" -objects $obj
set_property -name "platform.board_id"            -value "zcu104" -objects $obj
set_property -name "sim.central_dir"              -value "$proj_dir/${_xil_proj_name_}.ip_user_files" -objects $obj
set_property -name "sim.ip.auto_export_scripts"   -value "1" -objects $obj
set_property -name "simulator_language"           -value "Mixed" -objects $obj
set_property -name "webtalk.activehdl_export_sim" -value "1" -objects $obj
set_property -name "webtalk.ies_export_sim"       -value "1" -objects $obj
set_property -name "webtalk.modelsim_export_sim"  -value "1" -objects $obj
set_property -name "webtalk.questa_export_sim"    -value "1" -objects $obj
set_property -name "webtalk.riviera_export_sim"   -value "1" -objects $obj
set_property -name "webtalk.vcs_export_sim"       -value "1" -objects $obj
set_property -name "webtalk.xsim_export_sim"      -value "1" -objects $obj
set_property -name "webtalk.xsim_launch_sim"      -value "2" -objects $obj
set_property -name "xpm_libraries"                -value "XPM_CDC XPM_MEMORY" -objects $obj

#*******************************************************************************
# Create filesets
#*******************************************************************************

# Create 'sources_1' fileset (if not found)
if {[string equal [get_filesets -quiet sources_1] ""]} {
  create_fileset -srcset sources_1
}

# Set IP repository paths
#set obj [get_filesets sources_1]
#set_property "ip_repo_paths" "[file normalize "$origin_dir/ip_repo"]" $obj

# Rebuild user ip_repo's index before adding any source files
update_ip_catalog -rebuild

# Set 'sources_1' fileset object
set obj [get_filesets sources_1]
add_files -fileset sources_1 "$origin_dir/rtl/"
add_files -fileset sources_1 "$origin_dir/dut/"
# add_files -fileset sources_1 "$origin_dir/vip/"

# add_files -fileset sources_1 -norecurse $origin_dir/bd/*/
# add_files -norecurse /home/tomas/mthesis/hw/bd/axi_fifo/axi_fifo.bd
# add_files -norecurse /home/tomas/mthesis/hw/bd/axi_fifo/hdl/axi_fifo_wrapper.v

# Create 'constrs_1' fileset (if not found)
if {[string equal [get_filesets -quiet constrs_1] ""]} {
  create_fileset -constrset constrs_1
}

# Set 'constrs_1' fileset object
set obj [get_filesets constrs_1]
# add_files -fileset constrs_1 $origin_dir/constraints/

# Create 'sim_1' fileset (if not found)
if {[string equal [get_filesets -quiet sim_1] ""]} {
  create_fileset -simset sim_1
}

# Set 'sim_1' fileset object
set obj [get_filesets sim_1]
add_files -fileset sim_1 "$origin_dir/sim/"
add_files -fileset sim_1 "$origin_dir/utils/"

# Set 'utils_1' fileset object
set obj [get_filesets utils_1]
# add_files -fileset utils_1 "$origin_dir/utils/"

#*******************************************************************************
# set top modules

# sources
set_property top axi_vip_wrapper [current_fileset]

# sim
set_property top tb_axi_vip [get_filesets sim_1]
set_property top_lib xil_defaultlib [get_filesets sim_1]

#*******************************************************************************

puts "INFO: create_proj.tcl RUN SUCCESSFULL\n"

