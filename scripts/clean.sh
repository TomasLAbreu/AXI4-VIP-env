#!/bin/bash

echo -e "\n########### Clean Script - Vivado v2019.2\n"

# Command line options
files_to_remove=(*log *jou logs/* .Xil/ xelab.* xsim* xvhdl* xvlog* run.log *.wdb)

for (( i=0; i<${#files_to_remove[*]}; i++ )); do
  file="${files_to_remove[i]}"
  if [[ -e $file ]]; then
    rm -rf $file
  fi
done

echo -e "[Running  ] Simulation run files deleted"
