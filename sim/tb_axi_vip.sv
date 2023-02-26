`timescale 1ns / 1ps
`include "../rtl/constants.svh"

module tb_axi_vip();
  // Users to add ports here
  bit [31:0] rslv_base_waddr;
  bit [31:0] rslv_base_raddr;
  bit [31:0] rnum_burst;
  bit [8:0]  rburst_len;
  bit        ropt_type;

  // Outputs
  bit error_0;
  bit done_0;
  bit init_0;

  // // Auxiliaries

  reg [31:0] rburst_awaddr;
  reg [31:0] rburst_araddr;

  // User ports ends

  // dut_if itf();

  slv_agent agent();
  bit clock;
  bit reset;

  axi_vip_wrapper #(
    .MP_AXI_ID_WIDTH     (`CONSTANT_AXI_ID_WIDTH),
    .MP_AXI_ADDR_WIDTH   (`CONSTANT_AXI_ADDR_WIDTH),
    .MP_AXI_DATA_WIDTH   (`CONSTANT_AXI_DATA_WIDTH),
    .MP_AXI_AWUSER_WIDTH (`CONSTANT_AXI_AWUSER_WIDTH),
    .MP_AXI_ARUSER_WIDTH (`CONSTANT_AXI_ARUSER_WIDTH),
    .MP_AXI_WUSER_WIDTH  (`CONSTANT_AXI_WUSER_WIDTH),
    .MP_AXI_RUSER_WIDTH  (`CONSTANT_AXI_RUSER_WIDTH),
    .MP_AXI_BUSER_WIDTH  (`CONSTANT_AXI_BUSER_WIDTH)
  ) DUT (
    .ACLK    (clock),
    .ARESETN (reset),

    .INIT_AXI_TXN (init_0),
    .AXI_TXN_DONE (done_0),
    .AXI_ERROR    (error_0)
  );

  // Testbench configs
  initial begin
    agent.setup();
    agent.monitor();
    $timeformat (-12, 1, " ps", 1);
  end

  //////////////////////////////////////////////////////////////////////////////
  // Drivers

  always #5 clock <= ~clock;

  initial begin
    clock <= 1'b0;
    reset <= 1'b0;
    #10ns;
    reset <= 1'b1;
    repeat (5) @(negedge clock);
  end

  // Users to add drivers here
  initial begin
    init_0 = 1'b0;
    #20ns;
    init_0 = 1'b1;
    #20ns;
    init_0 = 1'b0;
  end

  initial begin
    rslv_base_waddr <= 32'h80000000;
    rslv_base_raddr <= 32'h80000000;

    rnum_burst <= 32'h00000000;
    rburst_len <= 9'd1;
    ropt_type  <= 1'b1;
  end
  // User drivers end

  //////////////////////////////////////////////////////////////////////////////
  // Monitors
  // Users to add drivers here

  // ------------ WRITE transfers -------------
  // register AWADDR used for the whole AXI burst transaction
  always@(posedge clock or negedge reset) begin
    if(!reset) begin
      rburst_awaddr <= 'b0;
    end else begin
      if(DUT.inst.M_AXI_AWVALID & DUT.inst.M_AXI_AWREADY) begin
        rburst_awaddr <= DUT.inst.M_AXI_AWADDR;
      end
    end
  end
  // display WDATA
  always@(posedge clock) begin
    if(DUT.inst.M_AXI_WVALID & DUT.inst.M_AXI_WREADY) begin
      if(rburst_awaddr == 0) begin
        $display("%3d AWADDR[0x%08x] = 0x%08x", DUT.inst.write_index+1, (DUT.inst.M_AXI_AWADDR + 4*DUT.inst.write_index), DUT.inst.M_AXI_WDATA);
      end else begin
        $display("%3d AWADDR[0x%08x] = 0x%08x", DUT.inst.write_index+1, (rburst_awaddr + 4*DUT.inst.write_index), DUT.inst.M_AXI_WDATA);
      end
    end
  end

  // ------------ READ transfers -------------
  // register ARADDR used for the whole AXI burst transaction
  always@(posedge clock or negedge reset) begin
    if(!reset) begin
      rburst_araddr <= 'b0;
    end else begin
      if(DUT.inst.M_AXI_ARVALID & DUT.inst.M_AXI_ARREADY) begin
        rburst_araddr <= DUT.inst.M_AXI_ARADDR;
      end
    end
  end

  // display RDATA
  always@(posedge clock) begin
    if(DUT.inst.M_AXI_RVALID & DUT.inst.M_AXI_RREADY) begin
      if(rburst_araddr == 0) begin
        $display("%3d ARADDR[0x%08x] = 0x%08x", DUT.inst.read_index+1, (DUT.inst.M_AXI_ARADDR + 4*DUT.inst.read_index), DUT.inst.M_AXI_RDATA);
      end else begin
        $display("%3d ARADDR[0x%08x] = 0x%08x", DUT.inst.read_index+1, (rburst_araddr + 4*DUT.inst.read_index), DUT.inst.M_AXI_RDATA);
      end
    end
  end

  initial begin
    #1ns;
    $display("\n-- Initiating AXI transaction...");
    // $display("Type: %s", DUT.inst.OP_TYPE ? "READ" : "WRITE");
    // $display("Burst length: %3d transfers", DUT.inst.BURST_LEN);
    // $display("Burst size  : %3d bytes", DUT.inst.burst_size_bytes);

    $display("\n-- Monitoring AXI transaction...");
  end
  // User monitors end

  //////////////////////////////////////////////////////////////////////////////
  // Testbench body

  initial begin
    wait(done_0 );//|| ((DUT.inst.write_index == 256) || (DUT.inst.read_index == 256)));

    if (done_0) begin
      $display("Finishing testbench...");
    end else begin
      // $display("FAILED: burst length (%d) longer than max size (256)", DUT.inst.BURST_LEN);
    end

    if (error_0) begin
      $display("FAILED with error");
    end else begin
      $display("PASSED");
    end

    $display("\n");
    #1ns;
    $finish;
  end

endmodule
