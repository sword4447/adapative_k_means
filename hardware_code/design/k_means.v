`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 2021/03/25
// Design Name:
// Module Name: k_means
// Project Name:
// Target Devices:
// Tool Versions:
// Description:
//
// Dependencies:
//
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
//
//////////////////////////////////////////////////////////////////////////////////
module k_means(
           output [3:0]  pci_exp_txp,
           output [3:0]  pci_exp_txn,
           input  [3:0]  pci_exp_rxp,
           input  [3:0]  pci_exp_rxn,

           input         pci_clk_p,
           input         pci_clk_n,
           input         pci_rst_l,
           // Inouts
           inout  [63:0] ddr3_dq,
           inout  [7:0]  ddr3_dqs_n,
           inout  [7:0]  ddr3_dqs_p,

           // Outputs
           output [13:0] ddr3_addr,
           output [2:0]  ddr3_ba,
           output        ddr3_ras_n,
           output        ddr3_cas_n,
           output        ddr3_we_n,
           output        ddr3_reset_n,
           output [0:0]  ddr3_ck_p,
           output [0:0]  ddr3_ck_n,
           output [0:0]  ddr3_cke,

           output [0:0]  ddr3_cs_n,

           output [7:0]  ddr3_dm,

           output [0:0]  ddr3_odt,

           // Inputs

           // Differential system clocks
           input         sys_clk_p,
           input         sys_clk_n,

           // output     init_calib_complete,
           output [3:0]  led,

           input         sys_rst
       );
    wire [27:0] app_addr_k_means;
    wire [2:0] app_cmd_k_means;
    wire  app_en_k_means;
    wire  app_wdf_wren_k_means;
    wire [511:0] app_wdf_data_k_means;
    wire [63:0] app_wdf_mask_k_means;

    wire [27:0] app_addr_pcie;
    wire [2:0] app_cmd_pcie;
    wire  app_en_pcie;
    wire [511:0] app_wdf_data_pcie;
    wire  app_wdf_wren_pcie;
    wire [63:0] app_wdf_mask_pcie;

    wire [27:0] app_addr_choose;
    wire [2:0] app_cmd_choose;
    wire  app_en_choose;
    wire [511:0] app_wdf_data_choose;
    wire  app_wdf_wren_choose;
    wire [63:0] app_wdf_mask_choose;

    wire init;

    wire   [511:0] app_rd_data;
    wire           app_rd_data_end;
    wire           app_rd_data_valid;
    wire           app_rdy;
    wire           app_wdf_rdy;

    wire           app_sr_req;
    wire           app_ref_req;
    wire           app_zq_req;
    wire           app_sr_active;
    wire           app_ref_ack;
    wire           app_zq_ack;

    wire           ui_clk;//200MHz
    wire           ui_clk_sync_rst;
    reg ui_clk_sync_rst_n;

    wire           init_calib_complete;

    reg           pio_reset_n;

    always @(posedge user_clk)
    begin
        if (user_reset)
            pio_reset_n <= #TCQ 1'b0;
        else
            pio_reset_n <= #TCQ user_lnk_up;
    end
    //
    mux_2i1o_28b mux_2i1o_28b_0
                (
                    .sel_i (init),
                    .in_0_i (app_addr_pcie),
                    .in_1_i (app_addr_k_means),

                    .out (app_addr_choose)
                );
    mux_2i1o_1b mux_2i1o_1b_0
                (
                    .sel_i (init),
                    .in_0_i (app_en_pcie),
                    .in_1_i (app_en_k_means),

                    .out (app_en_choose)
                );
    mux_2i1o_3b mux_2i1o_3b_0
                (
                    .sel_i (init),
                    .in_0_i (app_cmd_pcie),
                    .in_1_i (app_cmd_k_means),

                    .out (app_cmd_choose)
                );
    mux_2i1o_512b mux_2i1o_512b_0
                (
                    .sel_i (init),
                    .in_0_i (app_wdf_data_pcie),
                    .in_1_i (app_wdf_data_k_means),

                    .out (app_wdf_data_choose)
                );
    mux_2i1o_1b mux_2i1o_1b_2
                (
                    .sel_i (init),
                    .in_0_i (app_wdf_wren_pcie),
                    .in_1_i (app_wdf_wren_k_means),

                    .out (app_wdf_wren_choose)
                );
    mux_2i1o_64b mux_2i1o_64b_0
                (
                    .sel_i (init),
                    .in_0_i (app_wdf_mask_pcie),
                    .in_1_i (app_wdf_mask_k_means),

                    .out (app_wdf_mask_choose)
                );

    always @(posedge ui_clk)
        ui_clk_sync_rst_n <= !ui_clk_sync_rst;

    recursive recursive_1(
                . clk (ui_clk),
                . rst_n (ui_clk_sync_rst_n),

                . addr(app_addr_pcie),//把pcie的ddr地址输入给迭代模块 让迭代模块检测
                . app_wdf_rdy (app_wdf_rdy),
                . app_rdy (app_rdy),
                . app_addr (app_addr_k_means),
                . app_cmd (app_cmd_k_means),
                . app_en (app_en_k_means),
                . app_wdf_data (app_wdf_data_k_means),
                . app_wdf_mask (app_wdf_mask_k_means),
                . app_wdf_wren (app_wdf_wren_k_means),
                . app_rd_data (app_rd_data),
                . app_rd_data_end (),
                . app_rd_data_valid (app_rd_data_valid),

                . init (init)
            );
    // Instantiate the module
    ddr3_ctrl inst_ddr3_ctrl(
                .ddr3_addr                      (ddr3_addr),
                .ddr3_ba                        (ddr3_ba),
                .ddr3_cas_n                     (ddr3_cas_n),
                .ddr3_ck_n                      (ddr3_ck_n),
                .ddr3_ck_p                      (ddr3_ck_p),
                .ddr3_cke                       (ddr3_cke),
                .ddr3_ras_n                     (ddr3_ras_n),
                .ddr3_we_n                      (ddr3_we_n),
                .ddr3_dq                        (ddr3_dq),
                .ddr3_dqs_n                     (ddr3_dqs_n),
                .ddr3_dqs_p                     (ddr3_dqs_p),
                .ddr3_reset_n                   (ddr3_reset_n),
                .init_calib_complete            (init_calib_complete),
                .ddr3_cs_n                      (ddr3_cs_n),
                .ddr3_dm                        (ddr3_dm),
                .ddr3_odt                       (ddr3_odt),


                . app_addr(app_addr_choose),
                . app_cmd(app_cmd_choose),
                . app_en(app_en_choose),
                . app_wdf_data(app_wdf_data_choose),
                . app_wdf_mask(app_wdf_mask_choose),
                . app_wdf_wren(app_wdf_wren_choose),
                . app_wdf_end(app_wdf_wren_choose),

                .app_rd_data                    (app_rd_data),
                .app_rd_data_end                (app_rd_data_end),
                .app_rd_data_valid              (app_rd_data_valid),
                .app_rdy                        (app_rdy),
                .app_wdf_rdy                    (app_wdf_rdy),

                .app_sr_req                     (1'b0),
                .app_ref_req                    (1'b0),
                .app_zq_req                     (1'b0),
                .app_sr_active                  (app_sr_active),
                .app_ref_ack                    (app_ref_ack),
                .app_zq_ack                     (app_zq_ack),
                .ui_clk                         (ui_clk),
                .ui_clk_sync_rst                (ui_clk_sync_rst),

                // System Clock Ports
                .sys_clk_p                      (sys_clk_p),
                .sys_clk_n                      (sys_clk_n),
                .sys_rst                        (sys_rst)
            );

    // Wire Declarations
    wire                                        pipe_mmcm_rst_n;

    wire                                        user_clk;
    wire                                        user_reset;
    wire                                        user_lnk_up;

    // Tx
    wire                                        s_axis_tx_tready;
    wire   [3:0]                                s_axis_tx_tuser;
    wire   [63:0]                               s_axis_tx_tdata;
    wire   [7:0]                                s_axis_tx_tkeep;
    wire                                        s_axis_tx_tlast;
    wire                                        s_axis_tx_tvalid;

    // Rx
    wire   [63:0]                               m_axis_rx_tdata;
    wire   [7:0]                                m_axis_rx_tkeep;
    wire                                        m_axis_rx_tlast;
    wire                                        m_axis_rx_tvalid;
    wire                                        m_axis_rx_tready;
    wire   [21:0]                               m_axis_rx_tuser;

    wire                                        tx_cfg_gnt;
    wire                                        rx_np_ok;
    wire                                        rx_np_req;
    wire                                        cfg_turnoff_ok;
    wire                                        cfg_trn_pending;
    wire                                        cfg_pm_halt_aspm_l0s;
    wire                                        cfg_pm_halt_aspm_l1;
    wire                                        cfg_pm_force_state_en;
    wire   [1:0]                                cfg_pm_force_state;
    wire                                        cfg_pm_wake;
    wire   [63:0]                               cfg_dsn;

    // Flow Control
    wire   [2:0]                                fc_sel;

    //-------------------------------------------------------
    // Configuration (CFG) Interface
    //-------------------------------------------------------
    wire                                        cfg_err_ecrc;
    wire                                        cfg_err_cor;
    wire                                        cfg_err_ur;
    wire                                        cfg_err_cpl_timeout;
    wire                                        cfg_err_cpl_abort;
    wire                                        cfg_err_cpl_unexpect;
    wire                                        cfg_err_posted;
    wire                                        cfg_err_locked;
    wire   [47:0]                               cfg_err_tlp_cpl_header;
    wire   [127:0]                              cfg_err_aer_headerlog;
    wire   [4:0]                                cfg_aer_interrupt_msgnum;

    wire                                        cfg_interrupt;
    wire                                        cfg_interrupt_assert;
    wire   [7:0]                                cfg_interrupt_di;
    wire                                        cfg_interrupt_stat;
    wire   [4:0]                                cfg_pciecap_interrupt_msgnum;

    wire                                        cfg_to_turnoff;
    wire   [7:0]                                cfg_bus_number;
    wire   [4:0]                                cfg_device_number;
    wire   [2:0]                                cfg_function_number;

    wire   [31:0]                               cfg_mgmt_di;
    wire   [3:0]                                cfg_mgmt_byte_en;
    wire   [9:0]                                cfg_mgmt_dwaddr;
    wire                                        cfg_mgmt_wr_en;
    wire                                        cfg_mgmt_rd_en;
    wire                                        cfg_mgmt_wr_readonly;

    //-------------------------------------------------------
    // Physical Layer Control and Status (PL) Interface
    //-------------------------------------------------------
    wire                                        pl_directed_link_auton;
    wire   [1:0]                                pl_directed_link_change;
    wire                                        pl_directed_link_speed;
    wire   [1:0]                                pl_directed_link_width;
    wire                                        pl_upstream_prefer_deemph;

    wire                                        pci_rst_l_c;
    wire                                        pci_clk;

    // Register Declaration
    reg                                         user_reset_q;
    reg                                         user_lnk_up_q;
    reg    [25:0]                               user_clk_heartbeat = 26'h000_0000;

    // Local Parameters
    localparam TCQ            = 1;
    localparam USER_CLK_FREQ  = 2;
    localparam USER_CLK2_DIV2 = "FALSE";
    localparam USERCLK2_FREQ  = (USER_CLK2_DIV2 == "TRUE") ? (USER_CLK_FREQ == 4) ? 3 : (USER_CLK_FREQ == 3) ? 2 : USER_CLK_FREQ : USER_CLK_FREQ;

    //-----------------------------I/O BUFFERS------------------------//

    IBUF   sys_reset_n_ibuf (.O(pci_rst_l_c), .I(pci_rst_l));

    IBUFDS_GTE2 refclk_ibuf (.O(pci_clk), .ODIV2(), .I(pci_clk_p), .CEB(1'b0), .IB(pci_clk_n));

    always @(posedge user_clk)
    begin
        user_reset_q  <= user_reset;
        user_lnk_up_q <= user_lnk_up;
    end

    // Create a Clock Heartbeat on LED #3
    always @(posedge user_clk)
    begin
        user_clk_heartbeat <= #TCQ user_clk_heartbeat + 1'b1;
    end

    assign pipe_mmcm_rst_n = 1'b1;

    // Instantiate the module
    pcie_ctrl_support #(
                        .LINK_CAP_MAX_LINK_WIDTH        ( 4 ),  // PCIe Lane Width
                        .C_DATA_WIDTH                   ( 64 ),                       // RX/TX interface data width
                        .KEEP_WIDTH                     ( 8 ),                         // TSTRB width
                        .PCIE_REFCLK_FREQ               ( 0 ),                       // PCIe reference clock frequency
                        .PCIE_USERCLK1_FREQ             ( USER_CLK_FREQ + 1 ),                   // PCIe user clock 1 frequency
                        .PCIE_USERCLK2_FREQ             ( USERCLK2_FREQ + 1 ),                   // PCIe user clock 2 frequency
                        .PCIE_USE_MODE                  ("3.0"),                     // PCIe use mode
                        .PCIE_GT_DEVICE                 ("GTX")                      // PCIe GT device
                    ) pcie_ctrl_support_i (
                        //----------------------------------------------------------------------------------------------------------------//
                        // PCI Express (pci_exp) Interface                                                                                //
                        //----------------------------------------------------------------------------------------------------------------//
                        // Tx
                        .pci_exp_txn                               ( pci_exp_txn ),
                        .pci_exp_txp                               ( pci_exp_txp ),

                        // Rx
                        .pci_exp_rxn                               ( pci_exp_rxn ),
                        .pci_exp_rxp                               ( pci_exp_rxp ),

                        //----------------------------------------------------------------------------------------------------------------//
                        // Clocking Sharing Interface                                                                                     //
                        //----------------------------------------------------------------------------------------------------------------//
                        .pipe_pclk_out_slave                       ( ),
                        .pipe_rxusrclk_out                         ( ),
                        .pipe_rxoutclk_out                         ( ),
                        .pipe_dclk_out                             ( ),
                        .pipe_userclk1_out                         ( ),
                        .pipe_oobclk_out                           ( ),
                        .pipe_userclk2_out                         ( ),
                        .pipe_mmcm_lock_out                        ( ),
                        .pipe_pclk_sel_slave                       ( 4'b0),
                        .pipe_mmcm_rst_n                           ( pipe_mmcm_rst_n ),        // Async      | Async

                        //----------------------------------------------------------------------------------------------------------------//
                        // AXI-S Interface                                                                                                //
                        //----------------------------------------------------------------------------------------------------------------//

                        // Common
                        .user_clk_out                              ( user_clk ),
                        .user_reset_out                            ( user_reset ),
                        .user_lnk_up                               ( user_lnk_up ),
                        .user_app_rdy                              ( ),

                        // TX
                        .s_axis_tx_tready                          ( s_axis_tx_tready ),
                        .s_axis_tx_tdata                           ( s_axis_tx_tdata ),
                        .s_axis_tx_tkeep                           ( s_axis_tx_tkeep ),
                        .s_axis_tx_tuser                           ( s_axis_tx_tuser ),
                        .s_axis_tx_tlast                           ( s_axis_tx_tlast ),
                        .s_axis_tx_tvalid                          ( s_axis_tx_tvalid ),

                        // Rx
                        .m_axis_rx_tdata                           ( m_axis_rx_tdata ),
                        .m_axis_rx_tkeep                           ( m_axis_rx_tkeep ),
                        .m_axis_rx_tlast                           ( m_axis_rx_tlast ),
                        .m_axis_rx_tvalid                          ( m_axis_rx_tvalid ),
                        .m_axis_rx_tready                          ( m_axis_rx_tready ),
                        .m_axis_rx_tuser                           ( m_axis_rx_tuser ),

                        // Flow Control
                        .fc_cpld                                   ( ),
                        .fc_cplh                                   ( ),
                        .fc_npd                                    ( ),
                        .fc_nph                                    ( ),
                        .fc_pd                                     ( ),
                        .fc_ph                                     ( ),
                        .fc_sel                                    ( fc_sel ),

                        // Management Interface
                        .cfg_mgmt_di                               ( cfg_mgmt_di ),
                        .cfg_mgmt_byte_en                          ( cfg_mgmt_byte_en ),
                        .cfg_mgmt_dwaddr                           ( cfg_mgmt_dwaddr ),
                        .cfg_mgmt_wr_en                            ( cfg_mgmt_wr_en ),
                        .cfg_mgmt_rd_en                            ( cfg_mgmt_rd_en ),
                        .cfg_mgmt_wr_readonly                      ( cfg_mgmt_wr_readonly ),

                        //------------------------------------------------//
                        // EP and RP                                      //
                        //------------------------------------------------//
                        .cfg_mgmt_do                               ( ),
                        .cfg_mgmt_rd_wr_done                       ( ),
                        .cfg_mgmt_wr_rw1c_as_rw                    ( 1'b0 ),

                        // Error Reporting Interface
                        .cfg_err_ecrc                              ( cfg_err_ecrc ),
                        .cfg_err_ur                                ( cfg_err_ur ),
                        .cfg_err_cpl_timeout                       ( cfg_err_cpl_timeout ),
                        .cfg_err_cpl_unexpect                      ( cfg_err_cpl_unexpect ),
                        .cfg_err_cpl_abort                         ( cfg_err_cpl_abort ),
                        .cfg_err_posted                            ( cfg_err_posted ),
                        .cfg_err_cor                               ( cfg_err_cor ),
                        .cfg_err_atomic_egress_blocked             ( cfg_err_atomic_egress_blocked ),
                        .cfg_err_internal_cor                      ( cfg_err_internal_cor ),
                        .cfg_err_malformed                         ( cfg_err_malformed ),
                        .cfg_err_mc_blocked                        ( cfg_err_mc_blocked ),
                        .cfg_err_poisoned                          ( cfg_err_poisoned ),
                        .cfg_err_norecovery                        ( cfg_err_norecovery ),
                        .cfg_err_tlp_cpl_header                    ( cfg_err_tlp_cpl_header ),
                        .cfg_err_cpl_rdy                           ( ),
                        .cfg_err_locked                            ( cfg_err_locked ),
                        .cfg_err_acs                               ( cfg_err_acs ),
                        .cfg_err_internal_uncor                    ( cfg_err_internal_uncor ),

                        //----------------------------------------------------------------------------------------------------------------//
                        // AER Interface                                                                                                  //
                        //----------------------------------------------------------------------------------------------------------------//
                        .cfg_err_aer_headerlog                     ( cfg_err_aer_headerlog ),
                        .cfg_err_aer_headerlog_set                 ( ),
                        .cfg_aer_ecrc_check_en                     ( ),
                        .cfg_aer_ecrc_gen_en                       ( ),
                        .cfg_aer_interrupt_msgnum                  ( cfg_aer_interrupt_msgnum ),

                        .tx_cfg_gnt                                ( tx_cfg_gnt ),
                        .rx_np_ok                                  ( rx_np_ok ),
                        .rx_np_req                                 ( rx_np_req ),
                        .cfg_trn_pending                           ( cfg_trn_pending ),
                        .cfg_pm_halt_aspm_l0s                      ( cfg_pm_halt_aspm_l0s ),
                        .cfg_pm_halt_aspm_l1                       ( cfg_pm_halt_aspm_l1 ),
                        .cfg_pm_force_state_en                     ( cfg_pm_force_state_en ),
                        .cfg_pm_force_state                        ( cfg_pm_force_state ),
                        .cfg_dsn                                   ( cfg_dsn ),
                        .cfg_turnoff_ok                            ( cfg_turnoff_ok ),
                        .cfg_pm_wake                               ( cfg_pm_wake ),
                        //------------------------------------------------//
                        // RP Only                                        //
                        //------------------------------------------------//
                        .cfg_pm_send_pme_to                        ( 1'b0 ),
                        .cfg_ds_bus_number                         ( 8'b0 ),
                        .cfg_ds_device_number                      ( 5'b0 ),
                        .cfg_ds_function_number                    ( 3'b0 ),

                        //------------------------------------------------//
                        // EP Only                                        //
                        //------------------------------------------------//
                        .cfg_interrupt                             ( cfg_interrupt ),
                        .cfg_interrupt_rdy                         ( ),
                        .cfg_interrupt_assert                      ( cfg_interrupt_assert ),
                        .cfg_interrupt_di                          ( cfg_interrupt_di ),
                        .cfg_interrupt_do                          ( ),
                        .cfg_interrupt_mmenable                    ( ),
                        .cfg_interrupt_msienable                   ( ),
                        .cfg_interrupt_msixenable                  ( ),
                        .cfg_interrupt_msixfm                      ( ),
                        .cfg_interrupt_stat                        ( cfg_interrupt_stat ),
                        .cfg_pciecap_interrupt_msgnum              ( cfg_pciecap_interrupt_msgnum ),

                        //----------------------------------------------------------------------------------------------------------------//
                        // Configuration (CFG) Interface                                                                                  //
                        //----------------------------------------------------------------------------------------------------------------//
                        .cfg_status                                ( ),
                        .cfg_command                               ( ),
                        .cfg_dstatus                               ( ),
                        .cfg_lstatus                               ( ),
                        .cfg_pcie_link_state                       ( ),
                        .cfg_dcommand                              ( ),
                        .cfg_lcommand                              ( ),
                        .cfg_dcommand2                             ( ),

                        .cfg_pmcsr_pme_en                          ( ),
                        .cfg_pmcsr_powerstate                      ( ),
                        .cfg_pmcsr_pme_status                      ( ),
                        .cfg_received_func_lvl_rst                 ( ),
                        .tx_buf_av                                 ( ),
                        .tx_err_drop                               ( ),
                        .tx_cfg_req                                ( ),
                        .cfg_to_turnoff                            ( cfg_to_turnoff ),
                        .cfg_bus_number                            ( cfg_bus_number ),
                        .cfg_device_number                         ( cfg_device_number ),
                        .cfg_function_number                       ( cfg_function_number ),
                        .cfg_bridge_serr_en                        ( ),
                        .cfg_slot_control_electromech_il_ctl_pulse ( ),
                        .cfg_root_control_syserr_corr_err_en       ( ),
                        .cfg_root_control_syserr_non_fatal_err_en  ( ),
                        .cfg_root_control_syserr_fatal_err_en      ( ),
                        .cfg_root_control_pme_int_en               ( ),
                        .cfg_aer_rooterr_corr_err_reporting_en     ( ),
                        .cfg_aer_rooterr_non_fatal_err_reporting_en( ),
                        .cfg_aer_rooterr_fatal_err_reporting_en    ( ),
                        .cfg_aer_rooterr_corr_err_received         ( ),
                        .cfg_aer_rooterr_non_fatal_err_received    ( ),
                        .cfg_aer_rooterr_fatal_err_received        ( ),
                        //----------------------------------------------------------------------------------------------------------------//
                        // VC interface                                                                                                   //
                        //----------------------------------------------------------------------------------------------------------------//
                        .cfg_vc_tcvc_map                           ( ),

                        .cfg_msg_received                          ( ),
                        .cfg_msg_data                              ( ),
                        .cfg_msg_received_err_cor                  ( ),
                        .cfg_msg_received_err_non_fatal            ( ),
                        .cfg_msg_received_err_fatal                ( ),
                        .cfg_msg_received_pm_as_nak                ( ),
                        .cfg_msg_received_pme_to_ack               ( ),
                        .cfg_msg_received_assert_int_a             ( ),
                        .cfg_msg_received_assert_int_b             ( ),
                        .cfg_msg_received_assert_int_c             ( ),
                        .cfg_msg_received_assert_int_d             ( ),
                        .cfg_msg_received_deassert_int_a           ( ),
                        .cfg_msg_received_deassert_int_b           ( ),
                        .cfg_msg_received_deassert_int_c           ( ),
                        .cfg_msg_received_deassert_int_d           ( ),
                        .cfg_msg_received_pm_pme                   ( ),
                        .cfg_msg_received_setslotpowerlimit        ( ),

                        //----------------------------------------------------------------------------------------------------------------//
                        // Physical Layer Control and Status (PL) Interface                                                               //
                        //----------------------------------------------------------------------------------------------------------------//
                        .pl_directed_link_change                   ( pl_directed_link_change ),
                        .pl_directed_link_width                    ( pl_directed_link_width ),
                        .pl_directed_link_speed                    ( pl_directed_link_speed ),
                        .pl_directed_link_auton                    ( pl_directed_link_auton ),
                        .pl_upstream_prefer_deemph                 ( pl_upstream_prefer_deemph ),

                        .pl_sel_lnk_rate                           ( ),
                        .pl_sel_lnk_width                          ( ),
                        .pl_ltssm_state                            ( ),
                        .pl_lane_reversal_mode                     ( ),

                        .pl_phy_lnk_up                             ( ),
                        .pl_tx_pm_state                            ( ),
                        .pl_rx_pm_state                            ( ),

                        .pl_link_upcfg_cap                         ( ),
                        .pl_link_gen2_cap                          ( ),
                        .pl_link_partner_gen2_supported            ( ),
                        .pl_initial_link_width                     ( ),

                        .pl_directed_change_done                   ( ),

                        //------------------------------------------------//
                        // EP Only                                        //
                        //------------------------------------------------//
                        .pl_received_hot_rst                       ( ),

                        //------------------------------------------------//
                        // RP Only                                        //
                        //------------------------------------------------//
                        .pl_transmit_hot_rst                       ( 1'b0 ),
                        .pl_downstream_deemph_source               ( 1'b0 ),

                        //----------------------------------------------------------------------------------------------------------------//
                        // PCIe DRP (PCIe DRP) Interface                                                                                  //
                        //----------------------------------------------------------------------------------------------------------------//
                        .pcie_drp_clk                              ( 1'b1 ),
                        .pcie_drp_en                               ( 1'b0 ),
                        .pcie_drp_we                               ( 1'b0 ),
                        .pcie_drp_addr                             ( 9'h0 ),
                        .pcie_drp_di                               ( 16'h0 ),
                        .pcie_drp_rdy                              ( ),
                        .pcie_drp_do                               ( ),

                        //----------------------------------------------------------------------------------------------------------------//
                        // System  (SYS) Interface                                                                                        //
                        //----------------------------------------------------------------------------------------------------------------//
                        .sys_clk                                   ( pci_clk ),
                        .sys_rst_n                                 ( pci_rst_l_c )
                    );

    //Instantiate the module
    pcie_app_7x  #(
                    .C_DATA_WIDTH( 64 ),
                    .TCQ( TCQ )
                ) app (

                    //DDR Interface
                    .ddr_clk (ui_clk),
                    .ddr_rst_n(ui_clk_sync_rst_n),

                    .app_addr (app_addr_pcie),
                    .app_cmd (app_cmd_pcie),
                    .app_en (app_en_pcie),

                    .app_wdf_rdy(app_wdf_rdy),
                    .app_rdy (app_rdy),


                    .app_wdf_data (app_wdf_data_pcie),
                    .app_wdf_end (),
                    .app_wdf_mask (app_wdf_mask_pcie),
                    .app_wdf_wren (app_wdf_wren_pcie),

                    .app_rd_data (app_rd_data),
                    .app_rd_data_end (app_rd_data_end),
                    .app_rd_data_valid (app_rd_data_valid),
                    .k_means_work (init),

                    //----------------------------------------------------------------------------------------------------------------//
                    // AXI-S Interface                                                                                                //
                    //----------------------------------------------------------------------------------------------------------------//

                    // Common
                    .user_clk                       ( user_clk ),
                    .user_reset                     ( user_reset_q ),
                    .user_lnk_up                    ( user_lnk_up_q ),

                    // Tx
                    .s_axis_tx_tready               ( s_axis_tx_tready ),
                    .s_axis_tx_tdata                ( s_axis_tx_tdata ),
                    .s_axis_tx_tkeep                ( s_axis_tx_tkeep ),
                    .s_axis_tx_tuser                ( s_axis_tx_tuser ),
                    .s_axis_tx_tlast                ( s_axis_tx_tlast ),
                    .s_axis_tx_tvalid               ( s_axis_tx_tvalid ),

                    // Rx
                    .m_axis_rx_tdata                ( m_axis_rx_tdata ),
                    .m_axis_rx_tkeep                ( m_axis_rx_tkeep ),
                    .m_axis_rx_tlast                ( m_axis_rx_tlast ),
                    .m_axis_rx_tvalid               ( m_axis_rx_tvalid ),
                    .m_axis_rx_tready               ( m_axis_rx_tready ),
                    .m_axis_rx_tuser                ( m_axis_rx_tuser ),

                    .tx_cfg_gnt                     ( tx_cfg_gnt ),
                    .rx_np_ok                       ( rx_np_ok ),
                    .rx_np_req                      ( rx_np_req ),
                    .cfg_turnoff_ok                 ( cfg_turnoff_ok ),
                    .cfg_trn_pending                ( cfg_trn_pending ),
                    .cfg_pm_halt_aspm_l0s           ( cfg_pm_halt_aspm_l0s ),
                    .cfg_pm_halt_aspm_l1            ( cfg_pm_halt_aspm_l1 ),
                    .cfg_pm_force_state_en          ( cfg_pm_force_state_en ),
                    .cfg_pm_force_state             ( cfg_pm_force_state ),
                    .cfg_pm_wake                    ( cfg_pm_wake ),
                    .cfg_dsn                        ( cfg_dsn ),

                    // Flow Control
                    .fc_sel                         ( fc_sel ),

                    //----------------------------------------------------------------------------------------------------------------//
                    // Configuration (CFG) Interface                                                                                  //
                    //----------------------------------------------------------------------------------------------------------------//
                    .cfg_err_cor                    ( cfg_err_cor ),
                    .cfg_err_atomic_egress_blocked  ( cfg_err_atomic_egress_blocked ),
                    .cfg_err_internal_cor           ( cfg_err_internal_cor ),
                    .cfg_err_malformed              ( cfg_err_malformed ),
                    .cfg_err_mc_blocked             ( cfg_err_mc_blocked ),
                    .cfg_err_poisoned               ( cfg_err_poisoned ),
                    .cfg_err_norecovery             ( cfg_err_norecovery ),
                    .cfg_err_ur                     ( cfg_err_ur ),
                    .cfg_err_ecrc                   ( cfg_err_ecrc ),
                    .cfg_err_cpl_timeout            ( cfg_err_cpl_timeout ),
                    .cfg_err_cpl_abort              ( cfg_err_cpl_abort ),
                    .cfg_err_cpl_unexpect           ( cfg_err_cpl_unexpect ),
                    .cfg_err_posted                 ( cfg_err_posted ),
                    .cfg_err_locked                 ( cfg_err_locked ),
                    .cfg_err_acs                    ( cfg_err_acs ), //1'b0 ),
                    .cfg_err_internal_uncor         ( cfg_err_internal_uncor ), //1'b0 ),
                    .cfg_err_tlp_cpl_header         ( cfg_err_tlp_cpl_header ),
                    //----------------------------------------------------------------------------------------------------------------//
                    // Advanced Error Reporting (AER) Interface                                                                       //
                    //----------------------------------------------------------------------------------------------------------------//
                    .cfg_err_aer_headerlog          ( cfg_err_aer_headerlog ),
                    .cfg_aer_interrupt_msgnum       ( cfg_aer_interrupt_msgnum ),

                    .cfg_to_turnoff                 ( cfg_to_turnoff ),
                    .cfg_bus_number                 ( cfg_bus_number ),
                    .cfg_device_number              ( cfg_device_number ),
                    .cfg_function_number            ( cfg_function_number ),

                    //----------------------------------------------------------------------------------------------------------------//
                    // Management (MGMT) Interface                                                                                    //
                    //----------------------------------------------------------------------------------------------------------------//
                    .cfg_mgmt_di                    ( cfg_mgmt_di ),
                    .cfg_mgmt_byte_en               ( cfg_mgmt_byte_en ),
                    .cfg_mgmt_dwaddr                ( cfg_mgmt_dwaddr ),
                    .cfg_mgmt_wr_en                 ( cfg_mgmt_wr_en ),
                    .cfg_mgmt_rd_en                 ( cfg_mgmt_rd_en ),
                    .cfg_mgmt_wr_readonly           ( cfg_mgmt_wr_readonly ),

                    //----------------------------------------------------------------------------------------------------------------//
                    // Physical Layer Control and Status (PL) Interface                                                               //
                    //----------------------------------------------------------------------------------------------------------------//
                    .pl_directed_link_auton         ( pl_directed_link_auton ),
                    .pl_directed_link_change        ( pl_directed_link_change ),
                    .pl_directed_link_speed         ( pl_directed_link_speed ),
                    .pl_directed_link_width         ( pl_directed_link_width ),
                    .pl_upstream_prefer_deemph      ( pl_upstream_prefer_deemph ),

                    .cfg_interrupt                  ( cfg_interrupt ),
                    .cfg_interrupt_assert           ( cfg_interrupt_assert ),
                    .cfg_interrupt_di               ( cfg_interrupt_di ),
                    .cfg_interrupt_stat             ( cfg_interrupt_stat ),
                    .cfg_pciecap_interrupt_msgnum   ( cfg_pciecap_interrupt_msgnum )
                );

    assign led = {(~user_reset),user_lnk_up,user_clk_heartbeat[25],init_calib_complete};

endmodule
