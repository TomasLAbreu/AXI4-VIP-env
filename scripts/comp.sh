#!/bin/bash

# Command line options
xv_boost_lib_path=/tools/Xilinx/Vivado/2019.2/tps/boost_1_64_0
xvlog_opts="--relax -L axi_vip_v1_1_6 -L xilinx_vip"

snapshot_name=tb_axi_vip_behav
top_name=tb_axi_vip
wcfg_file=../utils/tb_behav.wcfg

# Script info
echo -e "\n########### Compile Script - Vivado v2019.2\n"
echo -e "[Running  ] Check args and Setup..."

# Main steps
run()
{
  check_args $# $1
  setup $1 $2
  compile
  elaborate
  check_errors
}

# RUN_STEP: <compile>
compile()
{
  echo -e "[Compile  ] Running xvlog..."
  # Compile design files
  xvlog $xvlog_opts -prj vlog.prj 2>&1 | tee logs/compile.log  > /dev/null
}

# RUN_STEP: <elaborate>
elaborate()
{
  echo -e "[Elaborate] Running xelab..."
  # xelab --relax --debug typical --mt auto -L xil_defaultlib -L axi_infrastructure_v1_1_0 -L axi_vip_v1_1_6 -L xilinx_vip -L unisims_ver -L unimacro_ver -L secureip -L xpm --snapshot axi_vip xil_defaultlib.top xil_defaultlib.glbl -log elaborate.log
  xelab --relax --debug typical --mt auto \
  -L xil_defaultlib -L axi_infrastructure_v1_1_0 -L axi_vip_v1_1_6 -L xilinx_vip \
  -L unisims_ver -L unimacro_ver -L secureip -L xpm \
  --snapshot $snapshot_name xil_defaultlib.$top_name xil_defaultlib.glbl \
  -log logs/elaborate.log  > /dev/null
}

# STEP: setup
setup()
{
  case $1 in
    "-lib_map_path")
      if [[ ($2 == "") ]]; then
        echo -e "ERROR: Simulation library directory path not specified (type \"./axi_vip.sh -help\" for more information)\n"
        exit 1
      fi
     copy_setup_file $2
    ;;
    "-reset_run")
      reset_run
      echo -e "INFO: Simulation run files deleted.\n"
      exit 0
    ;;
    "-noclean_files")
      # do not remove previous data
    ;;
    * )
     copy_setup_file $2
  esac

  # Add any setup/initialization commands here:-

  # <user specific commands>

}

# Copy xsim.ini file
copy_setup_file()
{
  file="xsim.ini"
  lib_map_path="/tools/Xilinx/Vivado/2019.2/data/xsim"
  if [[ ($1 != "") ]]; then
    lib_map_path="$1"
  fi
  if [[ ($lib_map_path != "") ]]; then
    src_file="$lib_map_path/$file"
    if [[ -e $src_file ]]; then
      cp $src_file .
    fi

    # Map local design libraries to xsim.ini
    map_local_libs

  fi
}

# Map local design libraries
map_local_libs()
{
  updated_mappings=()
  local_mappings=()

  # Local design libraries
  local_libs=(xil_defaultlib)

  if [[ 0 == ${#local_libs[@]} ]]; then
    return
  fi

  file="xsim.ini"
  file_backup="xsim.ini.bak"

  if [[ -e $file ]]; then
    rm -f $file_backup
    # Create a backup copy of the xsim.ini file
    cp $file $file_backup
    # Read libraries from backup file and search in local library collection
    while read -r line
    do
      IN=$line
      # Split mapping entry with '=' delimiter to fetch library name and mapping
      read lib_name mapping <<<$(IFS="="; echo $IN)
      # If local library found, then construct the local mapping and add to local mapping collection
      if `echo ${local_libs[@]} | grep -wq $lib_name` ; then
        line="$lib_name=xsim.dir/$lib_name"
        local_mappings+=("$lib_name")
      fi
      # Add to updated library mapping collection
      updated_mappings+=("$line")
    done < "$file_backup"
    # Append local libraries not found originally from xsim.ini
    for (( i=0; i<${#local_libs[*]}; i++ )); do
      lib_name="${local_libs[i]}"
      if `echo ${local_mappings[@]} | grep -wvq $lib_name` ; then
        line="$lib_name=xsim.dir/$lib_name"
        updated_mappings+=("$line")
      fi
    done
    # Write updated mappings in xsim.ini
    rm -f $file
    for (( i=0; i<${#updated_mappings[*]}; i++ )); do
      lib_name="${updated_mappings[i]}"
      echo $lib_name >> $file
    done
  else
    for (( i=0; i<${#local_libs[*]}; i++ )); do
      lib_name="${local_libs[i]}"
      mapping="$lib_name=xsim.dir/$lib_name"
      echo $mapping >> $file
    done
  fi
}

# Delete generated data from the previous run
reset_run()
{
  files_to_remove=(logs/* xelab.* xsim* xvhdl* xvlog* run.log *.wdb)

  for (( i=0; i<${#files_to_remove[*]}; i++ )); do
    file="${files_to_remove[i]}"
    if [[ -e $file ]]; then
      # echo  "Removing files: $file"
      rm -rf $file
    fi
  done
  rm -rf $files_to_remove
}

# Check command line arguments
check_args()
{
  if [[ ($1 == 1 ) && ($2 != "-lib_map_path" && $2 != "-noclean_files" && $2 != "-reset_run" && $2 != "-help" && $2 != "-h") ]]; then
    echo -e "ERROR: Unknown option specified '$2' (type \"./axi_vip.sh -help\" for more information)\n"
    exit 1
  fi

  if [[ ($2 == "-help" || $2 == "-h") ]]; then
    usage
  fi
}

check_errors()
{
  logfiles="logs/elaborate.log logs/compile.log logs/simulate.log"

  echo -e "[Results  ] Compile results:\n"
  grep -sh "ERROR:" $logfiles > logs/errors.log
  cat logs/errors.log
  grep -sh "WARNING:" $logfiles > logs/warnings.log
  cat logs/warnings.log

  # echo -e "\n<<<<<<<\n\n"
}

# Script usage
usage()
{
  msg="Usage: axi_vip.sh [-help]\n\
Usage: axi_vip.sh [-lib_map_path]\n\
Usage: axi_vip.sh [-reset_run]\n\
Usage: axi_vip.sh [-noclean_files]\n\n\
[-help] -- Print help information for this script\n\n\
[-lib_map_path <path>] -- Compiled simulation library directory path. The simulation library is compiled\n\
using the compile_simlib tcl command. Please see 'compile_simlib -help' for more information.\n\n\
[-reset_run] -- Recreate simulator setup files and library mappings for a clean run. The generated files\n\
from the previous run will be removed. If you don't want to remove the simulator generated files, use the\n\
-noclean_files switch.\n\n\
[-noclean_files] -- Reset previous run, but do not remove simulator generated files from the previous run.\n\n"
  echo -e $msg
  exit 1
}

# Launch script
run $1 $2
