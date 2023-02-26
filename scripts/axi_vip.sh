#!/bin/bash

# Command line options
xv_boost_lib_path=/tools/Xilinx/Vivado/2019.2/tps/boost_1_64_0
xvlog_opts="--relax -L axi_vip_v1_1_6 -L xilinx_vip"

snapshot_name=tb_axi_vip_behav
top_name=tb_axi_vip
wcfg_file=../utils/tb_behav.wcfg

# RUN_STEP: <compile>

compile()
{
  echo -e "[Compile  ] Mapping local libs..."
  map_local_libs

  echo -e "[Compile  ] Running xvlog..."
  xvlog $xvlog_opts -prj vlog.prj 2>&1 | tee logs/compile.log  > /dev/null

  echo -e "[Elaborate] Running xelab..."
  xelab --relax --debug typical --mt auto \
  -L xil_defaultlib -L axi_infrastructure_v1_1_0 -L axi_vip_v1_1_6 -L xilinx_vip \
  -L unisims_ver -L unimacro_ver -L secureip -L xpm \
  --snapshot $snapshot_name xil_defaultlib.$top_name xil_defaultlib.glbl \
  -log logs/elaborate.log  > /dev/null

  check_errors
}

simulate()
{
  echo -e "[Simulate ] Running xsim..."
  xsim $snapshot_name -key {Behavioral:sim_1:Functional:$top_name} \
  -tclbatch cmd.tcl \
  -protoinst "protoinst_files/axi_vip.protoinst" \
  -view $wcfg_file \
  -log logs/simulate.log

  check_errors
}

check_errors()
{
  logfiles="logs/elaborate.log logs/compile.log logs/simulate.log"

  echo -e "[Results  ] Compile results:\n"
  grep -sh "ERROR:" $logfiles > logs/errors.log
  cat logs/errors.log
  grep -sh "WARNING:" $logfiles > logs/warnings.log
  cat logs/warnings.log
}

clean()
{
  files_to_remove=(logs/* *jou *log .Xil/ xelab.* xsim* xvhdl* xvlog* run.log *.wdb)

  for (( i=0; i<${#files_to_remove[*]}; i++ )); do
    file="${files_to_remove[i]}"
    if [[ -e $file ]]; then
      rm -rf $file
    fi
  done

  echo -e "[Clean    ] Removed compile files"
}

# Script usage
usage()
{
  msg="Usage: axi_vip.sh [-help]\nUsage: axi_vip.sh [-clean | -run | -comp | -sim]"
  echo -e $msg
}

map_local_libs()
{
  file="xsim.ini"
  lib_map_path="/tools/Xilinx/Vivado/2019.2/data/xsim"

  src_file="$lib_map_path/$file"

  if [[ -e $src_file ]]; then
    cp $src_file .
  fi

  # Map local design libraries to xsim.ini
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

#################################################
#Launch script

echo -e "# axi_vip script - Vivado v2019.2"

if [[ $# != 1 ]]; then
  echo "ERROR: Wrong usage"
  usage
  exit 1
fi

# run $1
case $1 in
  "-clean")
    echo "[Setup    ] Running $1..."
    clean
  ;;
  "-run")
    echo "[Setup    ] Running $1..."
    compile
    simulate
  ;;
  "-comp")
    echo "[Setup    ] Running $1..."
    compile
  ;;
  "-sim")
    echo "[Setup    ] Running $1..."
    simulate
  ;;
  "-help")
    usage
  ;;
  * )
    echo "ERROR: Unknown option specified"
    exit 1
esac

exit 0