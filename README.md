# AXI4-VIP-env

Environment to easily use AXI4 VIP on your AXI design, using Xilinx Vivado tool.

**Strengths**:

- Easy replacement of DUT in environment
- Verification of AXI4 Master IP

**Weaknesses**:

- Currently only supports AXI Master Verification

### System Requirements

- ```Xilinx Vivado 2019.2```
- ```make```

### Setup
1. Clone this github.
```shell
$ git clone git@github.com:TomasLAbreu/AXI4-VIP-env.git
```

2. Load settings for Vivado tool (which can be something like this):
```shell
source /tools/Xilinx/Vivado/2019.2/settings64.sh
```

The project is managed by a ```Makefile``` which calls the required scripts from ```scripts/```. Run ```make help``` to generate list of targets with descriptions.
```shell
$ make help
run             Compile and simulate project
comp            Compile project
sim             Simulate project
update          Update constants, vlog.prj and protoinst files
clean           Clean working directory
help            Generate list of targets with descriptions
```

### How to Use
1. Replace design in ```dut/```
2. Run ```make update``` to generate ```rtl/constants.svh``` and update both ```scripts/vlog.prj``` and ```scripts/protoinst_files```.
3. If needed, update ```rtl/constants.svh``` according to your AXI protocol constants 
4. If needed, update ```rtl/axi_vip_wrapper.sv``` according to new DUT user ports
5. Update testbench ```sim/tb_axi_vip.sv```
6. Compile and simulate the project

6.1. Build and simulate using the makefile:
```shell
$ make
```

6.2. Use Vivado tool to build the project and view the waveforms. To do that, launch Vivado and create project from *tcl* script. This can be done in several ways.
```shell
$ cd scripts/
$ vivado -mode tcl -source create_proj.tcl
```

Then, you can launch Vivado simulation. Start GUI to visualize simulation waveforms.
```shell
Vivado% launch_simulation
Vivado% start_gui
```

In the following times Vivado launches, after creating the Vivado project, ```create_proj.tcl``` is no more needed. To open the Vivado project, type:
```shell
$ vivado -mode tcl scripts/WORK/proj.xpr
```

### Todo 
- Add support for AXI VIP Master and Pass-Through
- Automatize ```axi_vip_wrapper.sv``` generation
- Allow for waveform visualization on Vivado after building project with make
