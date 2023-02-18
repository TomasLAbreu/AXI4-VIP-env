`timescale 1ns / 1ps
`include "../rtl/constants.svh"

// Automatically generated according to constants.svh
import axi_vip_pkg::*;
import axi_vip_axi_vip_0_0_pkg::*;
// End of automatically generated data

module slv_agent;

  // Automatically generated according to constants.svh
  // `BD_NAME + _ + `VIP_INST_NAME + _0_slv_mem_t
  axi_vip_axi_vip_0_0_slv_mem_t slv_agent_0;
  // End of automatically generated data

  axi_monitor_transaction slv_monitor_transaction;
  axi_monitor_transaction slave_moniter_transaction_queue[$];
  xil_axi_uint            slave_moniter_transaction_queue_size =0;
  xil_axi_uint            slv_agent_verbosity = 0;

  // Setup slave agent
  task setup();
    slv_agent_0 = new("slave vip agent",DUT.`VIP_INST_NAME.inst.IF);

    slv_agent_0.vif_proxy.set_dummy_drive_type(XIL_AXI_VIF_DRIVE_NONE);
    slv_agent_0.set_agent_tag("Slave VIP");
    slv_agent_0.set_verbosity(slv_agent_verbosity);
    slv_agent_0.start_slave();
  endtask : setup

  // Monitor slave agent transactions
  task monitor();
    #1;
    forever begin
      slv_agent_0.monitor.item_collected_port.get(slv_monitor_transaction);
      slave_moniter_transaction_queue.push_back(slv_monitor_transaction);
      slave_moniter_transaction_queue_size++;
    end
  endtask : monitor

endmodule