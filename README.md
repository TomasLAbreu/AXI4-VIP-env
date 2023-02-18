# AXI4-VIP-env

Environment to easily use AXI4-VIP on your AXI design.

Alows:
- Verification of AXI4 Master IP
- Easy replacement of DUT

### Setup
Clone this github.
```shell
$ git clone git@github.com:TomasLAbreu/AXI4-VIP-env.git
```

Launch Vivado and create project from *tcl* script. This can be done in several ways.
```shell
$ vivado -mode tcl
Vivado% source create_proj.tcl
```

Launch Vivado simulation. Start GUI to visualize simulation waveforms.
```shell
Vivado% launch_simulation
Vivado% start_gui
```
### How to Use
1. Change ```dut/``` files 
2. Update ```rtl/constants.svh``` according to the new DUT names
3. Update ```rtl/top.sv``` and ```sim/dut_if.sv``` according to new DUT user ports
4. Update testbench ```sim/tb_axi_vip.sv```

### Todo 
- Add support for AXI VIP Master and Pass-Through
- Automatize ```top.sv``` and ```constants.svh``` generation
- Automatize ```dut_if.sv``` generation
- Add script to configure ```tb_behav.wcfg```
