`timescale 1ps/1ps

module gth_transceivers_buffer_example_top (

    // Differential reference clock inputs
    input  wire mgtrefclk0_x0y5_p,
    input  wire mgtrefclk0_x0y5_n,

    // Serial data ports
    input  wire [9:0] gthrxn_in,
    input  wire [9:0] gthrxp_in,
    output wire [9:0] gthtxn_out,
    output wire [9:0] gthtxp_out,

    // Parallel data ports
    input  wire [319:0] gtwiz_userdata_tx_in,
    output wire [319:0] gtwiz_userdata_rx_out,

    // TXUSRCLK outputs
    output wire gtwiz_userclk_tx_usrclk_out,
    output wire gtwiz_userclk_tx_usrclk2_out,
    output wire gtwiz_userclk_tx_active_out,

    // RXUSRCLK outputs
    output wire gtwiz_userclk_rx_usrclk_out,
    output wire gtwiz_userclk_rx_usrclk2_out,
    output wire gtwiz_userclk_rx_active_out,

    // TX phase interpolator PPM controller
    input wire [9:0] txpippmen_in,
    input wire [9:0] txpippmovrden_in,
    input wire [9:0] txpippmsel_in,
    input wire [9:0] txpippmpd_in,
    input wire [49:0] txpippmstepsize_in,

    // TX buffer
    output wire [19:0] txbufstatus_out,

    // User-provided ports for reset helper block(s)
    input  wire hb_gtwiz_reset_clk_freerun_in,
    input  wire hb_gtwiz_reset_all_in,
    output wire hb_gtwiz_reset_all_out,

    // Initialization
    output wire init_done_out,
    output wire [3:0] init_retry_ctr_out

);


    // ===================================================================================================================
    // PER-CHANNEL SIGNAL ASSIGNMENTS
    // ===================================================================================================================

    // The core and example design wrapper vectorize ports across all enabled transceiver channel and common instances for
    // simplicity and compactness. This example design top module assigns slices of each vector to individual, per-channel
    // signal vectors for use if desired. Signals which connect to helper blocks are prefixed "hb#", signals which connect
    // to transceiver common primitives are prefixed "cm#", and signals which connect to transceiver channel primitives
    // are prefixed "ch#", where "#" is the sequential resource number.

    //--------------------------------------------------------------------------------------------------------------------
    wire [9:0] gthrxn_int;
    assign gthrxn_int = gthrxn_in;

    //--------------------------------------------------------------------------------------------------------------------
    wire [9:0] gthrxp_int;
    assign gthrxp_int = gthrxp_in;

    //--------------------------------------------------------------------------------------------------------------------
    wire [9:0] gthtxn_int;
    assign gthtxn_out = gthtxn_int;

    //--------------------------------------------------------------------------------------------------------------------
    wire [9:0] gthtxp_int;
    assign gthtxp_out = gthtxp_int;

    //--------------------------------------------------------------------------------------------------------------------
    wire [0:0] gtwiz_userclk_tx_reset_int;
    wire [0:0] hb0_gtwiz_userclk_tx_reset_int;
    assign gtwiz_userclk_tx_reset_int[0:0] = hb0_gtwiz_userclk_tx_reset_int;

    //--------------------------------------------------------------------------------------------------------------------
    wire [0:0] gtwiz_userclk_tx_srcclk_int;
    wire [0:0] hb0_gtwiz_userclk_tx_srcclk_int;
    assign hb0_gtwiz_userclk_tx_srcclk_int = gtwiz_userclk_tx_srcclk_int[0:0];

    //--------------------------------------------------------------------------------------------------------------------
    wire [0:0] gtwiz_userclk_tx_usrclk_int;
    assign gtwiz_userclk_tx_usrclk_out = gtwiz_userclk_tx_usrclk_int[0:0];

    //--------------------------------------------------------------------------------------------------------------------
    wire [0:0] gtwiz_userclk_tx_usrclk2_int;
    assign gtwiz_userclk_tx_usrclk2_out = gtwiz_userclk_tx_usrclk2_int[0:0];

    //--------------------------------------------------------------------------------------------------------------------
    wire [0:0] gtwiz_userclk_tx_active_int;
    assign gtwiz_userclk_tx_active_out = gtwiz_userclk_tx_active_int[0:0];

    //--------------------------------------------------------------------------------------------------------------------
    wire [0:0] gtwiz_userclk_rx_reset_int;
    wire [0:0] hb0_gtwiz_userclk_rx_reset_int;
    assign gtwiz_userclk_rx_reset_int[0:0] = hb0_gtwiz_userclk_rx_reset_int;

    //--------------------------------------------------------------------------------------------------------------------
    wire [0:0] gtwiz_userclk_rx_srcclk_int;
    wire [0:0] hb0_gtwiz_userclk_rx_srcclk_int;
    assign hb0_gtwiz_userclk_rx_srcclk_int = gtwiz_userclk_rx_srcclk_int[0:0];

    //--------------------------------------------------------------------------------------------------------------------
    wire [0:0] gtwiz_userclk_rx_usrclk_int;
    assign gtwiz_userclk_rx_usrclk_out = gtwiz_userclk_rx_usrclk_int[0:0];

    //--------------------------------------------------------------------------------------------------------------------
    wire [0:0] gtwiz_userclk_rx_usrclk2_int;
    assign gtwiz_userclk_rx_usrclk2_out = gtwiz_userclk_rx_usrclk2_int[0:0];

    //--------------------------------------------------------------------------------------------------------------------
    wire [0:0] gtwiz_userclk_rx_active_int;
    assign gtwiz_userclk_rx_active_out = gtwiz_userclk_rx_active_int[0:0];

    //--------------------------------------------------------------------------------------------------------------------
    wire [0:0] gtwiz_reset_clk_freerun_int;
    wire [0:0] hb0_gtwiz_reset_clk_freerun_int = 1'b0;
    assign gtwiz_reset_clk_freerun_int[0:0] = hb0_gtwiz_reset_clk_freerun_int;

    //--------------------------------------------------------------------------------------------------------------------
    wire [0:0] gtwiz_reset_all_int;
    wire [0:0] hb0_gtwiz_reset_all_int = 1'b0;
    assign gtwiz_reset_all_int[0:0] = hb0_gtwiz_reset_all_int;

    //--------------------------------------------------------------------------------------------------------------------
    wire [0:0] gtwiz_reset_tx_pll_and_datapath_int;
    wire [0:0] hb0_gtwiz_reset_tx_pll_and_datapath_int;
    assign gtwiz_reset_tx_pll_and_datapath_int[0:0] = hb0_gtwiz_reset_tx_pll_and_datapath_int;

    //--------------------------------------------------------------------------------------------------------------------
    wire [0:0] gtwiz_reset_tx_datapath_int;
    wire [0:0] hb0_gtwiz_reset_tx_datapath_int;
    assign gtwiz_reset_tx_datapath_int[0:0] = hb0_gtwiz_reset_tx_datapath_int;

    //--------------------------------------------------------------------------------------------------------------------
    wire [0:0] gtwiz_reset_rx_pll_and_datapath_int;
    wire [0:0] hb0_gtwiz_reset_rx_pll_and_datapath_int = 1'b0;
    assign gtwiz_reset_rx_pll_and_datapath_int[0:0] = hb0_gtwiz_reset_rx_pll_and_datapath_int;

    //--------------------------------------------------------------------------------------------------------------------
    wire [0:0] gtwiz_reset_rx_datapath_int;
    wire [0:0] hb0_gtwiz_reset_rx_datapath_int = 1'b0;
    assign gtwiz_reset_rx_datapath_int[0:0] = hb0_gtwiz_reset_rx_datapath_int;

    //--------------------------------------------------------------------------------------------------------------------
    wire [0:0] gtwiz_reset_rx_cdr_stable_int;
    wire [0:0] hb0_gtwiz_reset_rx_cdr_stable_int;
    assign hb0_gtwiz_reset_rx_cdr_stable_int = gtwiz_reset_rx_cdr_stable_int[0:0];

    //--------------------------------------------------------------------------------------------------------------------
    wire [0:0] gtwiz_reset_tx_done_int;
    wire [0:0] hb0_gtwiz_reset_tx_done_int;
    assign hb0_gtwiz_reset_tx_done_int = gtwiz_reset_tx_done_int[0:0];

    //--------------------------------------------------------------------------------------------------------------------
    wire [0:0] gtwiz_reset_rx_done_int;
    wire [0:0] hb0_gtwiz_reset_rx_done_int;
    assign hb0_gtwiz_reset_rx_done_int = gtwiz_reset_rx_done_int[0:0];

    //--------------------------------------------------------------------------------------------------------------------
    wire [319:0] gtwiz_userdata_tx_int;
    assign gtwiz_userdata_tx_int = gtwiz_userdata_tx_in;

    //--------------------------------------------------------------------------------------------------------------------
    wire [319:0] gtwiz_userdata_rx_int;
    assign gtwiz_userdata_rx_out = gtwiz_userdata_rx_int;

    //--------------------------------------------------------------------------------------------------------------------
    wire [2:0] gtrefclk00_int;
    wire [0:0] cm0_gtrefclk00_int;
    wire [0:0] cm1_gtrefclk00_int;
    wire [0:0] cm2_gtrefclk00_int;
    assign gtrefclk00_int[0:0] = cm0_gtrefclk00_int;
    assign gtrefclk00_int[1:1] = cm1_gtrefclk00_int;
    assign gtrefclk00_int[2:2] = cm2_gtrefclk00_int;

    //--------------------------------------------------------------------------------------------------------------------
    wire [2:0] qpll0outclk_int;
    wire [0:0] cm0_qpll0outclk_int;
    wire [0:0] cm1_qpll0outclk_int;
    wire [0:0] cm2_qpll0outclk_int;
    assign cm0_qpll0outclk_int = qpll0outclk_int[0:0];
    assign cm1_qpll0outclk_int = qpll0outclk_int[1:1];
    assign cm2_qpll0outclk_int = qpll0outclk_int[2:2];

    //--------------------------------------------------------------------------------------------------------------------
    wire [2:0] qpll0outrefclk_int;
    wire [0:0] cm0_qpll0outrefclk_int;
    wire [0:0] cm1_qpll0outrefclk_int;
    wire [0:0] cm2_qpll0outrefclk_int;
    assign cm0_qpll0outrefclk_int = qpll0outrefclk_int[0:0];
    assign cm1_qpll0outrefclk_int = qpll0outrefclk_int[1:1];
    assign cm2_qpll0outrefclk_int = qpll0outrefclk_int[2:2];

    //--------------------------------------------------------------------------------------------------------------------
    wire [39:0] txdiffctrl_int;
    wire [3:0] ch0_txdiffctrl_int;
    wire [3:0] ch1_txdiffctrl_int;
    wire [3:0] ch2_txdiffctrl_int;
    wire [3:0] ch3_txdiffctrl_int;
    wire [3:0] ch4_txdiffctrl_int;
    wire [3:0] ch5_txdiffctrl_int;
    wire [3:0] ch6_txdiffctrl_int;
    wire [3:0] ch7_txdiffctrl_int;
    wire [3:0] ch8_txdiffctrl_int;
    wire [3:0] ch9_txdiffctrl_int;
    assign txdiffctrl_int[3:0] = ch0_txdiffctrl_int;
    assign txdiffctrl_int[7:4] = ch1_txdiffctrl_int;
    assign txdiffctrl_int[11:8] = ch2_txdiffctrl_int;
    assign txdiffctrl_int[15:12] = ch3_txdiffctrl_int;
    assign txdiffctrl_int[19:16] = ch4_txdiffctrl_int;
    assign txdiffctrl_int[23:20] = ch5_txdiffctrl_int;
    assign txdiffctrl_int[27:24] = ch6_txdiffctrl_int;
    assign txdiffctrl_int[31:28] = ch7_txdiffctrl_int;
    assign txdiffctrl_int[35:32] = ch8_txdiffctrl_int;
    assign txdiffctrl_int[39:36] = ch9_txdiffctrl_int;

    //--------------------------------------------------------------------------------------------------------------------
    wire [69:0] txmaincursor_int;
    wire [6:0] ch0_txmaincursor_int;
    wire [6:0] ch1_txmaincursor_int;
    wire [6:0] ch2_txmaincursor_int;
    wire [6:0] ch3_txmaincursor_int;
    wire [6:0] ch4_txmaincursor_int;
    wire [6:0] ch5_txmaincursor_int;
    wire [6:0] ch6_txmaincursor_int;
    wire [6:0] ch7_txmaincursor_int;
    wire [6:0] ch8_txmaincursor_int;
    wire [6:0] ch9_txmaincursor_int;
    assign txmaincursor_int[6:0] = ch0_txmaincursor_int;
    assign txmaincursor_int[13:7] = ch1_txmaincursor_int;
    assign txmaincursor_int[20:14] = ch2_txmaincursor_int;
    assign txmaincursor_int[27:21] = ch3_txmaincursor_int;
    assign txmaincursor_int[34:28] = ch4_txmaincursor_int;
    assign txmaincursor_int[41:35] = ch5_txmaincursor_int;
    assign txmaincursor_int[48:42] = ch6_txmaincursor_int;
    assign txmaincursor_int[55:49] = ch7_txmaincursor_int;
    assign txmaincursor_int[62:56] = ch8_txmaincursor_int;
    assign txmaincursor_int[69:63] = ch9_txmaincursor_int;

    //--------------------------------------------------------------------------------------------------------------------
    wire [9:0] txpippmen_int;
    assign txpippmen_int = txpippmen_in;

    //--------------------------------------------------------------------------------------------------------------------
    wire [9:0] txpippmovrden_int;
    assign txpippmovrden_int = txpippmovrden_in;

    //--------------------------------------------------------------------------------------------------------------------
    wire [9:0] txpippmpd_int;
    assign txpippmpd_int = txpippmpd_in;

    //--------------------------------------------------------------------------------------------------------------------
    wire [9:0] txpippmsel_int;
    assign txpippmsel_int = txpippmsel_in;

    //--------------------------------------------------------------------------------------------------------------------
    wire [49:0] txpippmstepsize_int;
    assign txpippmstepsize_int = txpippmstepsize_in;

    //--------------------------------------------------------------------------------------------------------------------
    wire [49:0] txpostcursor_int;
    wire [4:0] ch0_txpostcursor_int;
    wire [4:0] ch1_txpostcursor_int;
    wire [4:0] ch2_txpostcursor_int;
    wire [4:0] ch3_txpostcursor_int;
    wire [4:0] ch4_txpostcursor_int;
    wire [4:0] ch5_txpostcursor_int;
    wire [4:0] ch6_txpostcursor_int;
    wire [4:0] ch7_txpostcursor_int;
    wire [4:0] ch8_txpostcursor_int;
    wire [4:0] ch9_txpostcursor_int;
    assign txpostcursor_int[4:0] = ch0_txpostcursor_int;
    assign txpostcursor_int[9:5] = ch1_txpostcursor_int;
    assign txpostcursor_int[14:10] = ch2_txpostcursor_int;
    assign txpostcursor_int[19:15] = ch3_txpostcursor_int;
    assign txpostcursor_int[24:20] = ch4_txpostcursor_int;
    assign txpostcursor_int[29:25] = ch5_txpostcursor_int;
    assign txpostcursor_int[34:30] = ch6_txpostcursor_int;
    assign txpostcursor_int[39:35] = ch7_txpostcursor_int;
    assign txpostcursor_int[44:40] = ch8_txpostcursor_int;
    assign txpostcursor_int[49:45] = ch9_txpostcursor_int;

    //--------------------------------------------------------------------------------------------------------------------
    wire [49:0] txprecursor_int;
    wire [4:0] ch0_txprecursor_int;
    wire [4:0] ch1_txprecursor_int;
    wire [4:0] ch2_txprecursor_int;
    wire [4:0] ch3_txprecursor_int;
    wire [4:0] ch4_txprecursor_int;
    wire [4:0] ch5_txprecursor_int;
    wire [4:0] ch6_txprecursor_int;
    wire [4:0] ch7_txprecursor_int;
    wire [4:0] ch8_txprecursor_int;
    wire [4:0] ch9_txprecursor_int;
    assign txprecursor_int[4:0] = ch0_txprecursor_int;
    assign txprecursor_int[9:5] = ch1_txprecursor_int;
    assign txprecursor_int[14:10] = ch2_txprecursor_int;
    assign txprecursor_int[19:15] = ch3_txprecursor_int;
    assign txprecursor_int[24:20] = ch4_txprecursor_int;
    assign txprecursor_int[29:25] = ch5_txprecursor_int;
    assign txprecursor_int[34:30] = ch6_txprecursor_int;
    assign txprecursor_int[39:35] = ch7_txprecursor_int;
    assign txprecursor_int[44:40] = ch8_txprecursor_int;
    assign txprecursor_int[49:45] = ch9_txprecursor_int;

    //--------------------------------------------------------------------------------------------------------------------
    wire [9:0] gtpowergood_int;
    wire [0:0] ch0_gtpowergood_int;
    wire [0:0] ch1_gtpowergood_int;
    wire [0:0] ch2_gtpowergood_int;
    wire [0:0] ch3_gtpowergood_int;
    wire [0:0] ch4_gtpowergood_int;
    wire [0:0] ch5_gtpowergood_int;
    wire [0:0] ch6_gtpowergood_int;
    wire [0:0] ch7_gtpowergood_int;
    wire [0:0] ch8_gtpowergood_int;
    wire [0:0] ch9_gtpowergood_int;
    assign ch0_gtpowergood_int = gtpowergood_int[0:0];
    assign ch1_gtpowergood_int = gtpowergood_int[1:1];
    assign ch2_gtpowergood_int = gtpowergood_int[2:2];
    assign ch3_gtpowergood_int = gtpowergood_int[3:3];
    assign ch4_gtpowergood_int = gtpowergood_int[4:4];
    assign ch5_gtpowergood_int = gtpowergood_int[5:5];
    assign ch6_gtpowergood_int = gtpowergood_int[6:6];
    assign ch7_gtpowergood_int = gtpowergood_int[7:7];
    assign ch8_gtpowergood_int = gtpowergood_int[8:8];
    assign ch9_gtpowergood_int = gtpowergood_int[9:9];

    //--------------------------------------------------------------------------------------------------------------------
    wire [9:0] rxpmaresetdone_int;
    wire [0:0] ch0_rxpmaresetdone_int;
    wire [0:0] ch1_rxpmaresetdone_int;
    wire [0:0] ch2_rxpmaresetdone_int;
    wire [0:0] ch3_rxpmaresetdone_int;
    wire [0:0] ch4_rxpmaresetdone_int;
    wire [0:0] ch5_rxpmaresetdone_int;
    wire [0:0] ch6_rxpmaresetdone_int;
    wire [0:0] ch7_rxpmaresetdone_int;
    wire [0:0] ch8_rxpmaresetdone_int;
    wire [0:0] ch9_rxpmaresetdone_int;
    assign ch0_rxpmaresetdone_int = rxpmaresetdone_int[0:0];
    assign ch1_rxpmaresetdone_int = rxpmaresetdone_int[1:1];
    assign ch2_rxpmaresetdone_int = rxpmaresetdone_int[2:2];
    assign ch3_rxpmaresetdone_int = rxpmaresetdone_int[3:3];
    assign ch4_rxpmaresetdone_int = rxpmaresetdone_int[4:4];
    assign ch5_rxpmaresetdone_int = rxpmaresetdone_int[5:5];
    assign ch6_rxpmaresetdone_int = rxpmaresetdone_int[6:6];
    assign ch7_rxpmaresetdone_int = rxpmaresetdone_int[7:7];
    assign ch8_rxpmaresetdone_int = rxpmaresetdone_int[8:8];
    assign ch9_rxpmaresetdone_int = rxpmaresetdone_int[9:9];

    //--------------------------------------------------------------------------------------------------------------------
    wire [9:0] rxprgdivresetdone_int;
    wire [0:0] ch0_rxprgdivresetdone_int;
    wire [0:0] ch1_rxprgdivresetdone_int;
    wire [0:0] ch2_rxprgdivresetdone_int;
    wire [0:0] ch3_rxprgdivresetdone_int;
    wire [0:0] ch4_rxprgdivresetdone_int;
    wire [0:0] ch5_rxprgdivresetdone_int;
    wire [0:0] ch6_rxprgdivresetdone_int;
    wire [0:0] ch7_rxprgdivresetdone_int;
    wire [0:0] ch8_rxprgdivresetdone_int;
    wire [0:0] ch9_rxprgdivresetdone_int;
    assign ch0_rxprgdivresetdone_int = rxprgdivresetdone_int[0:0];
    assign ch1_rxprgdivresetdone_int = rxprgdivresetdone_int[1:1];
    assign ch2_rxprgdivresetdone_int = rxprgdivresetdone_int[2:2];
    assign ch3_rxprgdivresetdone_int = rxprgdivresetdone_int[3:3];
    assign ch4_rxprgdivresetdone_int = rxprgdivresetdone_int[4:4];
    assign ch5_rxprgdivresetdone_int = rxprgdivresetdone_int[5:5];
    assign ch6_rxprgdivresetdone_int = rxprgdivresetdone_int[6:6];
    assign ch7_rxprgdivresetdone_int = rxprgdivresetdone_int[7:7];
    assign ch8_rxprgdivresetdone_int = rxprgdivresetdone_int[8:8];
    assign ch9_rxprgdivresetdone_int = rxprgdivresetdone_int[9:9];

    //--------------------------------------------------------------------------------------------------------------------
    wire [19:0] txbufstatus_int;
    assign txbufstatus_out = txbufstatus_int;

    //--------------------------------------------------------------------------------------------------------------------
    wire [9:0] txpmaresetdone_int;
    wire [0:0] ch0_txpmaresetdone_int;
    wire [0:0] ch1_txpmaresetdone_int;
    wire [0:0] ch2_txpmaresetdone_int;
    wire [0:0] ch3_txpmaresetdone_int;
    wire [0:0] ch4_txpmaresetdone_int;
    wire [0:0] ch5_txpmaresetdone_int;
    wire [0:0] ch6_txpmaresetdone_int;
    wire [0:0] ch7_txpmaresetdone_int;
    wire [0:0] ch8_txpmaresetdone_int;
    wire [0:0] ch9_txpmaresetdone_int;
    assign ch0_txpmaresetdone_int = txpmaresetdone_int[0:0];
    assign ch1_txpmaresetdone_int = txpmaresetdone_int[1:1];
    assign ch2_txpmaresetdone_int = txpmaresetdone_int[2:2];
    assign ch3_txpmaresetdone_int = txpmaresetdone_int[3:3];
    assign ch4_txpmaresetdone_int = txpmaresetdone_int[4:4];
    assign ch5_txpmaresetdone_int = txpmaresetdone_int[5:5];
    assign ch6_txpmaresetdone_int = txpmaresetdone_int[6:6];
    assign ch7_txpmaresetdone_int = txpmaresetdone_int[7:7];
    assign ch8_txpmaresetdone_int = txpmaresetdone_int[8:8];
    assign ch9_txpmaresetdone_int = txpmaresetdone_int[9:9];

    //--------------------------------------------------------------------------------------------------------------------
    wire [9:0] txprgdivresetdone_int;
    wire [0:0] ch0_txprgdivresetdone_int;
    wire [0:0] ch1_txprgdivresetdone_int;
    wire [0:0] ch2_txprgdivresetdone_int;
    wire [0:0] ch3_txprgdivresetdone_int;
    wire [0:0] ch4_txprgdivresetdone_int;
    wire [0:0] ch5_txprgdivresetdone_int;
    wire [0:0] ch6_txprgdivresetdone_int;
    wire [0:0] ch7_txprgdivresetdone_int;
    wire [0:0] ch8_txprgdivresetdone_int;
    wire [0:0] ch9_txprgdivresetdone_int;
    assign ch0_txprgdivresetdone_int = txprgdivresetdone_int[0:0];
    assign ch1_txprgdivresetdone_int = txprgdivresetdone_int[1:1];
    assign ch2_txprgdivresetdone_int = txprgdivresetdone_int[2:2];
    assign ch3_txprgdivresetdone_int = txprgdivresetdone_int[3:3];
    assign ch4_txprgdivresetdone_int = txprgdivresetdone_int[4:4];
    assign ch5_txprgdivresetdone_int = txprgdivresetdone_int[5:5];
    assign ch6_txprgdivresetdone_int = txprgdivresetdone_int[6:6];
    assign ch7_txprgdivresetdone_int = txprgdivresetdone_int[7:7];
    assign ch8_txprgdivresetdone_int = txprgdivresetdone_int[8:8];
    assign ch9_txprgdivresetdone_int = txprgdivresetdone_int[9:9];


    // ===================================================================================================================
    // BUFFERS
    // ===================================================================================================================

    // Buffer the hb_gtwiz_reset_all_in input and logically combine it with the internal signal from the example
    // initialization block as well as the VIO-sourced reset
    wire hb_gtwiz_reset_all_vio_int;
    wire hb_gtwiz_reset_all_buf_int;
    wire hb_gtwiz_reset_all_init_int;
    wire hb_gtwiz_reset_all_int;

    IBUF ibuf_hb_gtwiz_reset_all_inst (
        .I (hb_gtwiz_reset_all_in),
        .O (hb_gtwiz_reset_all_buf_int)
    );

    assign hb_gtwiz_reset_all_int = hb_gtwiz_reset_all_buf_int || hb_gtwiz_reset_all_init_int || hb_gtwiz_reset_all_vio_int;

    assign hb_gtwiz_reset_all_out = hb_gtwiz_reset_all_int;

    // Globally buffer the free-running input clock
    wire hb_gtwiz_reset_clk_freerun_buf_int;

    BUFG bufg_clk_freerun_inst (
        .I (hb_gtwiz_reset_clk_freerun_in),
        .O (hb_gtwiz_reset_clk_freerun_buf_int)
    );

    // Instantiate a differential reference clock buffer for each reference clock differential pair in this configuration,
    // and assign the single-ended output of each differential reference clock buffer to the appropriate PLL input signal

    // Differential reference clock buffer for MGTREFCLK0_X0Y5
    wire mgtrefclk0_x0y5_int;

    IBUFDS_GTE3 #(
        .REFCLK_EN_TX_PATH  (1'b0),
        .REFCLK_HROW_CK_SEL (2'b00),
        .REFCLK_ICNTL_RX    (2'b00)
    ) IBUFDS_GTE3_MGTREFCLK0_X0Y5_INST (
        .I     (mgtrefclk0_x0y5_p),
        .IB    (mgtrefclk0_x0y5_n),
        .CEB   (1'b0),
        .O     (mgtrefclk0_x0y5_int),
        .ODIV2 ()
    );

    assign cm0_gtrefclk00_int = mgtrefclk0_x0y5_int;
    assign cm1_gtrefclk00_int = mgtrefclk0_x0y5_int;
    assign cm2_gtrefclk00_int = mgtrefclk0_x0y5_int;


    // ===================================================================================================================
    // USER CLOCKING RESETS
    // ===================================================================================================================

    // The TX user clocking helper block should be held in reset until the clock source of that block is known to be
    // stable. The following assignment is an example of how that stability can be determined, based on the selected TX
    // user clock source. Replace the assignment with the appropriate signal or logic to achieve that behavior as needed.
    assign hb0_gtwiz_userclk_tx_reset_int = ~(&txprgdivresetdone_int && &txpmaresetdone_int);

    // The RX user clocking helper block should be held in reset until the clock source of that block is known to be
    // stable. The following assignment is an example of how that stability can be determined, based on the selected RX
    // user clock source. Replace the assignment with the appropriate signal or logic to achieve that behavior as needed.
    assign hb0_gtwiz_userclk_rx_reset_int = ~(&rxprgdivresetdone_int && &rxpmaresetdone_int);


    // ===================================================================================================================
    // INITIALIZATION
    // ===================================================================================================================

    // Declare the receiver reset signals that interface to the reset controller helper block. For this configuration,
    // which uses the same PLL type for transmitter and receiver, the "reset RX PLL and datapath" feature is not used.
    wire hb_gtwiz_reset_rx_pll_and_datapath_int = 1'b0;
    wire hb_gtwiz_reset_rx_datapath_int;

    // Declare signals which connect the VIO instance to the initialization module for debug purposes
    wire       init_done_int;

    assign init_done_out = init_done_int;

    wire [3:0] init_retry_ctr_int;

    assign init_retry_ctr_out = init_retry_ctr_int;

    // Combine the receiver reset signals form the initialization module and the VIO to drive the appropriate reset
    // controller helper block reset input
    wire hb_gtwiz_reset_rx_pll_and_datapath_vio_int;
    wire hb_gtwiz_reset_rx_datapath_vio_int;
    wire hb_gtwiz_reset_rx_datapath_init_int;

    assign hb_gtwiz_reset_rx_datapath_int = hb_gtwiz_reset_rx_datapath_init_int || hb_gtwiz_reset_rx_datapath_vio_int;

    // The example initialization module interacts with the reset controller helper block and other example design logic
    // to retry failed reset attempts in order to mitigate bring-up issues such as initially-unavilable reference clocks
    // or data connections. It also resets the receiver in the event of link loss in an attempt to regain link, so please
    // note the possibility that this behavior can have the effect of overriding or disturbing user-provided inputs that
    // destabilize the data stream. It is a demonstration only and can be modified to suit your system needs.
    gth_transceivers_buffer_example_init example_init_inst (
        .clk_freerun_in  (hb_gtwiz_reset_clk_freerun_buf_int),
        .reset_all_in    (hb_gtwiz_reset_all_int),
        .tx_init_done_in (gtwiz_reset_tx_done_int),
        .rx_init_done_in (gtwiz_reset_rx_done_int),
        .rx_data_good_in (1'b1),
        .reset_all_out   (hb_gtwiz_reset_all_init_int),
        .reset_rx_out    (hb_gtwiz_reset_rx_datapath_init_int),
        .init_done_out   (init_done_int),
        .retry_ctr_out   (init_retry_ctr_int)
    );


    // ===================================================================================================================
    // VIO FOR HARDWARE BRING-UP AND DEBUG
    // ===================================================================================================================

    // Synchronize gtpowergood into the free-running clock domain for VIO usage
    wire [9:0] gtpowergood_vio_sync;

    (* DONT_TOUCH = "TRUE" *)
    gth_transceivers_buffer_example_bit_synchronizer bit_synchronizer_vio_gtpowergood_0_inst (
        .clk_in (hb_gtwiz_reset_clk_freerun_buf_int),
        .i_in   (gtpowergood_int[0]),
        .o_out  (gtpowergood_vio_sync[0])
    );

    (* DONT_TOUCH = "TRUE" *)
    gth_transceivers_buffer_example_bit_synchronizer bit_synchronizer_vio_gtpowergood_1_inst (
        .clk_in (hb_gtwiz_reset_clk_freerun_buf_int),
        .i_in   (gtpowergood_int[1]),
        .o_out  (gtpowergood_vio_sync[1])
    );

    (* DONT_TOUCH = "TRUE" *)
    gth_transceivers_buffer_example_bit_synchronizer bit_synchronizer_vio_gtpowergood_2_inst (
        .clk_in (hb_gtwiz_reset_clk_freerun_buf_int),
        .i_in   (gtpowergood_int[2]),
        .o_out  (gtpowergood_vio_sync[2])
    );

    (* DONT_TOUCH = "TRUE" *)
    gth_transceivers_buffer_example_bit_synchronizer bit_synchronizer_vio_gtpowergood_3_inst (
        .clk_in (hb_gtwiz_reset_clk_freerun_buf_int),
        .i_in   (gtpowergood_int[3]),
        .o_out  (gtpowergood_vio_sync[3])
    );

    (* DONT_TOUCH = "TRUE" *)
    gth_transceivers_buffer_example_bit_synchronizer bit_synchronizer_vio_gtpowergood_4_inst (
        .clk_in (hb_gtwiz_reset_clk_freerun_buf_int),
        .i_in   (gtpowergood_int[4]),
        .o_out  (gtpowergood_vio_sync[4])
    );

    (* DONT_TOUCH = "TRUE" *)
    gth_transceivers_buffer_example_bit_synchronizer bit_synchronizer_vio_gtpowergood_5_inst (
        .clk_in (hb_gtwiz_reset_clk_freerun_buf_int),
        .i_in   (gtpowergood_int[5]),
        .o_out  (gtpowergood_vio_sync[5])
    );

    (* DONT_TOUCH = "TRUE" *)
    gth_transceivers_buffer_example_bit_synchronizer bit_synchronizer_vio_gtpowergood_6_inst (
        .clk_in (hb_gtwiz_reset_clk_freerun_buf_int),
        .i_in   (gtpowergood_int[6]),
        .o_out  (gtpowergood_vio_sync[6])
    );

    (* DONT_TOUCH = "TRUE" *)
    gth_transceivers_buffer_example_bit_synchronizer bit_synchronizer_vio_gtpowergood_7_inst (
        .clk_in (hb_gtwiz_reset_clk_freerun_buf_int),
        .i_in   (gtpowergood_int[7]),
        .o_out  (gtpowergood_vio_sync[7])
    );

    (* DONT_TOUCH = "TRUE" *)
    gth_transceivers_buffer_example_bit_synchronizer bit_synchronizer_vio_gtpowergood_8_inst (
        .clk_in (hb_gtwiz_reset_clk_freerun_buf_int),
        .i_in   (gtpowergood_int[8]),
        .o_out  (gtpowergood_vio_sync[8])
    );

    (* DONT_TOUCH = "TRUE" *)
    gth_transceivers_buffer_example_bit_synchronizer bit_synchronizer_vio_gtpowergood_9_inst (
        .clk_in (hb_gtwiz_reset_clk_freerun_buf_int),
        .i_in   (gtpowergood_int[9]),
        .o_out  (gtpowergood_vio_sync[9])
    );

    // Synchronize txprgdivresetdone into the free-running clock domain for VIO usage
    wire [9:0] txprgdivresetdone_vio_sync;

    (* DONT_TOUCH = "TRUE" *)
    gth_transceivers_buffer_example_bit_synchronizer bit_synchronizer_vio_txprgdivresetdone_0_inst (
        .clk_in (hb_gtwiz_reset_clk_freerun_buf_int),
        .i_in   (txprgdivresetdone_int[0]),
        .o_out  (txprgdivresetdone_vio_sync[0])
    );

    (* DONT_TOUCH = "TRUE" *)
    gth_transceivers_buffer_example_bit_synchronizer bit_synchronizer_vio_txprgdivresetdone_1_inst (
        .clk_in (hb_gtwiz_reset_clk_freerun_buf_int),
        .i_in   (txprgdivresetdone_int[1]),
        .o_out  (txprgdivresetdone_vio_sync[1])
    );

    (* DONT_TOUCH = "TRUE" *)
    gth_transceivers_buffer_example_bit_synchronizer bit_synchronizer_vio_txprgdivresetdone_2_inst (
        .clk_in (hb_gtwiz_reset_clk_freerun_buf_int),
        .i_in   (txprgdivresetdone_int[2]),
        .o_out  (txprgdivresetdone_vio_sync[2])
    );

    (* DONT_TOUCH = "TRUE" *)
    gth_transceivers_buffer_example_bit_synchronizer bit_synchronizer_vio_txprgdivresetdone_3_inst (
        .clk_in (hb_gtwiz_reset_clk_freerun_buf_int),
        .i_in   (txprgdivresetdone_int[3]),
        .o_out  (txprgdivresetdone_vio_sync[3])
    );

    (* DONT_TOUCH = "TRUE" *)
    gth_transceivers_buffer_example_bit_synchronizer bit_synchronizer_vio_txprgdivresetdone_4_inst (
        .clk_in (hb_gtwiz_reset_clk_freerun_buf_int),
        .i_in   (txprgdivresetdone_int[4]),
        .o_out  (txprgdivresetdone_vio_sync[4])
    );

    (* DONT_TOUCH = "TRUE" *)
    gth_transceivers_buffer_example_bit_synchronizer bit_synchronizer_vio_txprgdivresetdone_5_inst (
        .clk_in (hb_gtwiz_reset_clk_freerun_buf_int),
        .i_in   (txprgdivresetdone_int[5]),
        .o_out  (txprgdivresetdone_vio_sync[5])
    );

    (* DONT_TOUCH = "TRUE" *)
    gth_transceivers_buffer_example_bit_synchronizer bit_synchronizer_vio_txprgdivresetdone_6_inst (
        .clk_in (hb_gtwiz_reset_clk_freerun_buf_int),
        .i_in   (txprgdivresetdone_int[6]),
        .o_out  (txprgdivresetdone_vio_sync[6])
    );

    (* DONT_TOUCH = "TRUE" *)
    gth_transceivers_buffer_example_bit_synchronizer bit_synchronizer_vio_txprgdivresetdone_7_inst (
        .clk_in (hb_gtwiz_reset_clk_freerun_buf_int),
        .i_in   (txprgdivresetdone_int[7]),
        .o_out  (txprgdivresetdone_vio_sync[7])
    );

    (* DONT_TOUCH = "TRUE" *)
    gth_transceivers_buffer_example_bit_synchronizer bit_synchronizer_vio_txprgdivresetdone_8_inst (
        .clk_in (hb_gtwiz_reset_clk_freerun_buf_int),
        .i_in   (txprgdivresetdone_int[8]),
        .o_out  (txprgdivresetdone_vio_sync[8])
    );

    (* DONT_TOUCH = "TRUE" *)
    gth_transceivers_buffer_example_bit_synchronizer bit_synchronizer_vio_txprgdivresetdone_9_inst (
        .clk_in (hb_gtwiz_reset_clk_freerun_buf_int),
        .i_in   (txprgdivresetdone_int[9]),
        .o_out  (txprgdivresetdone_vio_sync[9])
    );

    // Synchronize rxprgdivresetdone into the free-running clock domain for VIO usage
    wire [9:0] rxprgdivresetdone_vio_sync;

    (* DONT_TOUCH = "TRUE" *)
    gth_transceivers_buffer_example_bit_synchronizer bit_synchronizer_vio_rxprgdivresetdone_0_inst (
        .clk_in (hb_gtwiz_reset_clk_freerun_buf_int),
        .i_in   (rxprgdivresetdone_int[0]),
        .o_out  (rxprgdivresetdone_vio_sync[0])
    );

    (* DONT_TOUCH = "TRUE" *)
    gth_transceivers_buffer_example_bit_synchronizer bit_synchronizer_vio_rxprgdivresetdone_1_inst (
        .clk_in (hb_gtwiz_reset_clk_freerun_buf_int),
        .i_in   (rxprgdivresetdone_int[1]),
        .o_out  (rxprgdivresetdone_vio_sync[1])
    );

    (* DONT_TOUCH = "TRUE" *)
    gth_transceivers_buffer_example_bit_synchronizer bit_synchronizer_vio_rxprgdivresetdone_2_inst (
        .clk_in (hb_gtwiz_reset_clk_freerun_buf_int),
        .i_in   (rxprgdivresetdone_int[2]),
        .o_out  (rxprgdivresetdone_vio_sync[2])
    );

    (* DONT_TOUCH = "TRUE" *)
    gth_transceivers_buffer_example_bit_synchronizer bit_synchronizer_vio_rxprgdivresetdone_3_inst (
        .clk_in (hb_gtwiz_reset_clk_freerun_buf_int),
        .i_in   (rxprgdivresetdone_int[3]),
        .o_out  (rxprgdivresetdone_vio_sync[3])
    );

    (* DONT_TOUCH = "TRUE" *)
    gth_transceivers_buffer_example_bit_synchronizer bit_synchronizer_vio_rxprgdivresetdone_4_inst (
        .clk_in (hb_gtwiz_reset_clk_freerun_buf_int),
        .i_in   (rxprgdivresetdone_int[4]),
        .o_out  (rxprgdivresetdone_vio_sync[4])
    );

    (* DONT_TOUCH = "TRUE" *)
    gth_transceivers_buffer_example_bit_synchronizer bit_synchronizer_vio_rxprgdivresetdone_5_inst (
        .clk_in (hb_gtwiz_reset_clk_freerun_buf_int),
        .i_in   (rxprgdivresetdone_int[5]),
        .o_out  (rxprgdivresetdone_vio_sync[5])
    );

    (* DONT_TOUCH = "TRUE" *)
    gth_transceivers_buffer_example_bit_synchronizer bit_synchronizer_vio_rxprgdivresetdone_6_inst (
        .clk_in (hb_gtwiz_reset_clk_freerun_buf_int),
        .i_in   (rxprgdivresetdone_int[6]),
        .o_out  (rxprgdivresetdone_vio_sync[6])
    );

    (* DONT_TOUCH = "TRUE" *)
    gth_transceivers_buffer_example_bit_synchronizer bit_synchronizer_vio_rxprgdivresetdone_7_inst (
        .clk_in (hb_gtwiz_reset_clk_freerun_buf_int),
        .i_in   (rxprgdivresetdone_int[7]),
        .o_out  (rxprgdivresetdone_vio_sync[7])
    );

    (* DONT_TOUCH = "TRUE" *)
    gth_transceivers_buffer_example_bit_synchronizer bit_synchronizer_vio_rxprgdivresetdone_8_inst (
        .clk_in (hb_gtwiz_reset_clk_freerun_buf_int),
        .i_in   (rxprgdivresetdone_int[8]),
        .o_out  (rxprgdivresetdone_vio_sync[8])
    );

    (* DONT_TOUCH = "TRUE" *)
    gth_transceivers_buffer_example_bit_synchronizer bit_synchronizer_vio_rxprgdivresetdone_9_inst (
        .clk_in (hb_gtwiz_reset_clk_freerun_buf_int),
        .i_in   (rxprgdivresetdone_int[9]),
        .o_out  (rxprgdivresetdone_vio_sync[9])
    );

    // Synchronize txpmaresetdone into the free-running clock domain for VIO usage
    wire [9:0] txpmaresetdone_vio_sync;

    (* DONT_TOUCH = "TRUE" *)
    gth_transceivers_buffer_example_bit_synchronizer bit_synchronizer_vio_txpmaresetdone_0_inst (
        .clk_in (hb_gtwiz_reset_clk_freerun_buf_int),
        .i_in   (txpmaresetdone_int[0]),
        .o_out  (txpmaresetdone_vio_sync[0])
    );

    (* DONT_TOUCH = "TRUE" *)
    gth_transceivers_buffer_example_bit_synchronizer bit_synchronizer_vio_txpmaresetdone_1_inst (
        .clk_in (hb_gtwiz_reset_clk_freerun_buf_int),
        .i_in   (txpmaresetdone_int[1]),
        .o_out  (txpmaresetdone_vio_sync[1])
    );

    (* DONT_TOUCH = "TRUE" *)
    gth_transceivers_buffer_example_bit_synchronizer bit_synchronizer_vio_txpmaresetdone_2_inst (
        .clk_in (hb_gtwiz_reset_clk_freerun_buf_int),
        .i_in   (txpmaresetdone_int[2]),
        .o_out  (txpmaresetdone_vio_sync[2])
    );

    (* DONT_TOUCH = "TRUE" *)
    gth_transceivers_buffer_example_bit_synchronizer bit_synchronizer_vio_txpmaresetdone_3_inst (
        .clk_in (hb_gtwiz_reset_clk_freerun_buf_int),
        .i_in   (txpmaresetdone_int[3]),
        .o_out  (txpmaresetdone_vio_sync[3])
    );

    (* DONT_TOUCH = "TRUE" *)
    gth_transceivers_buffer_example_bit_synchronizer bit_synchronizer_vio_txpmaresetdone_4_inst (
        .clk_in (hb_gtwiz_reset_clk_freerun_buf_int),
        .i_in   (txpmaresetdone_int[4]),
        .o_out  (txpmaresetdone_vio_sync[4])
    );

    (* DONT_TOUCH = "TRUE" *)
    gth_transceivers_buffer_example_bit_synchronizer bit_synchronizer_vio_txpmaresetdone_5_inst (
        .clk_in (hb_gtwiz_reset_clk_freerun_buf_int),
        .i_in   (txpmaresetdone_int[5]),
        .o_out  (txpmaresetdone_vio_sync[5])
    );

    (* DONT_TOUCH = "TRUE" *)
    gth_transceivers_buffer_example_bit_synchronizer bit_synchronizer_vio_txpmaresetdone_6_inst (
        .clk_in (hb_gtwiz_reset_clk_freerun_buf_int),
        .i_in   (txpmaresetdone_int[6]),
        .o_out  (txpmaresetdone_vio_sync[6])
    );

    (* DONT_TOUCH = "TRUE" *)
    gth_transceivers_buffer_example_bit_synchronizer bit_synchronizer_vio_txpmaresetdone_7_inst (
        .clk_in (hb_gtwiz_reset_clk_freerun_buf_int),
        .i_in   (txpmaresetdone_int[7]),
        .o_out  (txpmaresetdone_vio_sync[7])
    );

    (* DONT_TOUCH = "TRUE" *)
    gth_transceivers_buffer_example_bit_synchronizer bit_synchronizer_vio_txpmaresetdone_8_inst (
        .clk_in (hb_gtwiz_reset_clk_freerun_buf_int),
        .i_in   (txpmaresetdone_int[8]),
        .o_out  (txpmaresetdone_vio_sync[8])
    );

    (* DONT_TOUCH = "TRUE" *)
    gth_transceivers_buffer_example_bit_synchronizer bit_synchronizer_vio_txpmaresetdone_9_inst (
        .clk_in (hb_gtwiz_reset_clk_freerun_buf_int),
        .i_in   (txpmaresetdone_int[9]),
        .o_out  (txpmaresetdone_vio_sync[9])
    );

    // Synchronize rxpmaresetdone into the free-running clock domain for VIO usage
    wire [9:0] rxpmaresetdone_vio_sync;

    (* DONT_TOUCH = "TRUE" *)
    gth_transceivers_buffer_example_bit_synchronizer bit_synchronizer_vio_rxpmaresetdone_0_inst (
        .clk_in (hb_gtwiz_reset_clk_freerun_buf_int),
        .i_in   (rxpmaresetdone_int[0]),
        .o_out  (rxpmaresetdone_vio_sync[0])
    );

    (* DONT_TOUCH = "TRUE" *)
    gth_transceivers_buffer_example_bit_synchronizer bit_synchronizer_vio_rxpmaresetdone_1_inst (
        .clk_in (hb_gtwiz_reset_clk_freerun_buf_int),
        .i_in   (rxpmaresetdone_int[1]),
        .o_out  (rxpmaresetdone_vio_sync[1])
    );

    (* DONT_TOUCH = "TRUE" *)
    gth_transceivers_buffer_example_bit_synchronizer bit_synchronizer_vio_rxpmaresetdone_2_inst (
        .clk_in (hb_gtwiz_reset_clk_freerun_buf_int),
        .i_in   (rxpmaresetdone_int[2]),
        .o_out  (rxpmaresetdone_vio_sync[2])
    );

    (* DONT_TOUCH = "TRUE" *)
    gth_transceivers_buffer_example_bit_synchronizer bit_synchronizer_vio_rxpmaresetdone_3_inst (
        .clk_in (hb_gtwiz_reset_clk_freerun_buf_int),
        .i_in   (rxpmaresetdone_int[3]),
        .o_out  (rxpmaresetdone_vio_sync[3])
    );

    (* DONT_TOUCH = "TRUE" *)
    gth_transceivers_buffer_example_bit_synchronizer bit_synchronizer_vio_rxpmaresetdone_4_inst (
        .clk_in (hb_gtwiz_reset_clk_freerun_buf_int),
        .i_in   (rxpmaresetdone_int[4]),
        .o_out  (rxpmaresetdone_vio_sync[4])
    );

    (* DONT_TOUCH = "TRUE" *)
    gth_transceivers_buffer_example_bit_synchronizer bit_synchronizer_vio_rxpmaresetdone_5_inst (
        .clk_in (hb_gtwiz_reset_clk_freerun_buf_int),
        .i_in   (rxpmaresetdone_int[5]),
        .o_out  (rxpmaresetdone_vio_sync[5])
    );

    (* DONT_TOUCH = "TRUE" *)
    gth_transceivers_buffer_example_bit_synchronizer bit_synchronizer_vio_rxpmaresetdone_6_inst (
        .clk_in (hb_gtwiz_reset_clk_freerun_buf_int),
        .i_in   (rxpmaresetdone_int[6]),
        .o_out  (rxpmaresetdone_vio_sync[6])
    );

    (* DONT_TOUCH = "TRUE" *)
    gth_transceivers_buffer_example_bit_synchronizer bit_synchronizer_vio_rxpmaresetdone_7_inst (
        .clk_in (hb_gtwiz_reset_clk_freerun_buf_int),
        .i_in   (rxpmaresetdone_int[7]),
        .o_out  (rxpmaresetdone_vio_sync[7])
    );

    (* DONT_TOUCH = "TRUE" *)
    gth_transceivers_buffer_example_bit_synchronizer bit_synchronizer_vio_rxpmaresetdone_8_inst (
        .clk_in (hb_gtwiz_reset_clk_freerun_buf_int),
        .i_in   (rxpmaresetdone_int[8]),
        .o_out  (rxpmaresetdone_vio_sync[8])
    );

    (* DONT_TOUCH = "TRUE" *)
    gth_transceivers_buffer_example_bit_synchronizer bit_synchronizer_vio_rxpmaresetdone_9_inst (
        .clk_in (hb_gtwiz_reset_clk_freerun_buf_int),
        .i_in   (rxpmaresetdone_int[9]),
        .o_out  (rxpmaresetdone_vio_sync[9])
    );

    // Synchronize gtwiz_reset_tx_done into the free-running clock domain for VIO usage
    wire [0:0] gtwiz_reset_tx_done_vio_sync;

    (* DONT_TOUCH = "TRUE" *)
    gth_transceivers_buffer_example_bit_synchronizer bit_synchronizer_vio_gtwiz_reset_tx_done_0_inst (
        .clk_in (hb_gtwiz_reset_clk_freerun_buf_int),
        .i_in   (gtwiz_reset_tx_done_int[0]),
        .o_out  (gtwiz_reset_tx_done_vio_sync[0])
    );

    // Synchronize gtwiz_reset_rx_done into the free-running clock domain for VIO usage
    wire [0:0] gtwiz_reset_rx_done_vio_sync;

    (* DONT_TOUCH = "TRUE" *)
    gth_transceivers_buffer_example_bit_synchronizer bit_synchronizer_vio_gtwiz_reset_rx_done_0_inst (
        .clk_in (hb_gtwiz_reset_clk_freerun_buf_int),
        .i_in   (gtwiz_reset_rx_done_int[0]),
        .o_out  (gtwiz_reset_rx_done_vio_sync[0])
    );


    // Instantiate the VIO IP core for hardware bring-up and debug purposes, connecting relevant debug and analysis
    // signals which have been enabled during Wizard IP customization. This initial set of connected signals is
    // provided as a convenience and example, but more or fewer ports can be used as needed; simply re-customize and
    // re-generate the VIO instance, then connect any exposed signals that are needed. Signals which are synchronous to
    // clocks other than the free-running clock will require synchronization. For usage, refer to Vivado Design Suite
    // User Guide: Programming and Debugging (UG908)
    gth_transceivers_buffer_vio_0 gth_transceivers_buffer_vio_0_inst (
        .clk (hb_gtwiz_reset_clk_freerun_buf_int)
        ,.probe_in0 (init_done_int)
        ,.probe_in1 (init_retry_ctr_int)
        ,.probe_in2 (gtpowergood_vio_sync)
        ,.probe_in3 (txprgdivresetdone_vio_sync)
        ,.probe_in4 (rxprgdivresetdone_vio_sync)
        ,.probe_in5 (txpmaresetdone_vio_sync)
        ,.probe_in6 (rxpmaresetdone_vio_sync)
        ,.probe_in7 (gtwiz_reset_tx_done_vio_sync)
        ,.probe_in8 (gtwiz_reset_rx_done_vio_sync)
        ,.probe_out0 (hb_gtwiz_reset_all_vio_int)
        ,.probe_out1 (hb0_gtwiz_reset_tx_pll_and_datapath_int)
        ,.probe_out2 (hb0_gtwiz_reset_tx_datapath_int)
        ,.probe_out3 (hb_gtwiz_reset_rx_pll_and_datapath_vio_int)
        ,.probe_out4 (hb_gtwiz_reset_rx_datapath_vio_int)
    );

    gth_transceivers_buffer_vio_1 gth_transceivers_buffer_vio_1_inst (
        .clk (hb_gtwiz_reset_clk_freerun_buf_int)
        ,.probe_out0 (ch0_txdiffctrl_int)
        ,.probe_out1 (ch1_txdiffctrl_int)
        ,.probe_out2 (ch2_txdiffctrl_int)
        ,.probe_out3 (ch3_txdiffctrl_int)
        ,.probe_out4 (ch4_txdiffctrl_int)
        ,.probe_out5 (ch5_txdiffctrl_int)
        ,.probe_out6 (ch6_txdiffctrl_int)
        ,.probe_out7 (ch7_txdiffctrl_int)
        ,.probe_out8 (ch8_txdiffctrl_int)
        ,.probe_out9 (ch9_txdiffctrl_int)
        ,.probe_out10 (ch0_txmaincursor_int)
        ,.probe_out11 (ch1_txmaincursor_int)
        ,.probe_out12 (ch2_txmaincursor_int)
        ,.probe_out13 (ch3_txmaincursor_int)
        ,.probe_out14 (ch4_txmaincursor_int)
        ,.probe_out15 (ch5_txmaincursor_int)
        ,.probe_out16 (ch6_txmaincursor_int)
        ,.probe_out17 (ch7_txmaincursor_int)
        ,.probe_out18 (ch8_txmaincursor_int)
        ,.probe_out19 (ch9_txmaincursor_int)
        ,.probe_out20 (ch0_txpostcursor_int)
        ,.probe_out21 (ch1_txpostcursor_int)
        ,.probe_out22 (ch2_txpostcursor_int)
        ,.probe_out23 (ch3_txpostcursor_int)
        ,.probe_out24 (ch4_txpostcursor_int)
        ,.probe_out25 (ch5_txpostcursor_int)
        ,.probe_out26 (ch6_txpostcursor_int)
        ,.probe_out27 (ch7_txpostcursor_int)
        ,.probe_out28 (ch8_txpostcursor_int)
        ,.probe_out29 (ch9_txpostcursor_int)
        ,.probe_out30 (ch0_txprecursor_int)
        ,.probe_out31 (ch1_txprecursor_int)
        ,.probe_out32 (ch2_txprecursor_int)
        ,.probe_out33 (ch3_txprecursor_int)
        ,.probe_out34 (ch4_txprecursor_int)
        ,.probe_out35 (ch5_txprecursor_int)
        ,.probe_out36 (ch6_txprecursor_int)
        ,.probe_out37 (ch7_txprecursor_int)
        ,.probe_out38 (ch8_txprecursor_int)
        ,.probe_out39 (ch9_txprecursor_int)
    );


    // ===================================================================================================================
    // EXAMPLE WRAPPER INSTANCE
    // ===================================================================================================================

    // Instantiate the example design wrapper, mapping its enabled ports to per-channel internal signals and example
    // resources as appropriate
    gth_transceivers_buffer_example_wrapper example_wrapper_inst (
        .gthrxn_in                               (gthrxn_int)
        ,.gthrxp_in                               (gthrxp_int)
        ,.gthtxn_out                              (gthtxn_int)
        ,.gthtxp_out                              (gthtxp_int)
        ,.gtwiz_userclk_tx_reset_in               (gtwiz_userclk_tx_reset_int)
        ,.gtwiz_userclk_tx_srcclk_out             (gtwiz_userclk_tx_srcclk_int)
        ,.gtwiz_userclk_tx_usrclk_out             (gtwiz_userclk_tx_usrclk_int)
        ,.gtwiz_userclk_tx_usrclk2_out            (gtwiz_userclk_tx_usrclk2_int)
        ,.gtwiz_userclk_tx_active_out             (gtwiz_userclk_tx_active_int)
        ,.gtwiz_userclk_rx_reset_in               (gtwiz_userclk_rx_reset_int)
        ,.gtwiz_userclk_rx_srcclk_out             (gtwiz_userclk_rx_srcclk_int)
        ,.gtwiz_userclk_rx_usrclk_out             (gtwiz_userclk_rx_usrclk_int)
        ,.gtwiz_userclk_rx_usrclk2_out            (gtwiz_userclk_rx_usrclk2_int)
        ,.gtwiz_userclk_rx_active_out             (gtwiz_userclk_rx_active_int)
        ,.gtwiz_reset_clk_freerun_in              ({1{hb_gtwiz_reset_clk_freerun_buf_int}})
        ,.gtwiz_reset_all_in                      ({1{hb_gtwiz_reset_all_int}})
        ,.gtwiz_reset_tx_pll_and_datapath_in      (gtwiz_reset_tx_pll_and_datapath_int)
        ,.gtwiz_reset_tx_datapath_in              (gtwiz_reset_tx_datapath_int)
        ,.gtwiz_reset_rx_pll_and_datapath_in      ({1{hb_gtwiz_reset_rx_pll_and_datapath_int}})
        ,.gtwiz_reset_rx_datapath_in              ({1{hb_gtwiz_reset_rx_datapath_int}})
        ,.gtwiz_reset_rx_cdr_stable_out           (gtwiz_reset_rx_cdr_stable_int)
        ,.gtwiz_reset_tx_done_out                 (gtwiz_reset_tx_done_int)
        ,.gtwiz_reset_rx_done_out                 (gtwiz_reset_rx_done_int)
        ,.gtwiz_userdata_tx_in                    (gtwiz_userdata_tx_int)
        ,.gtwiz_userdata_rx_out                   (gtwiz_userdata_rx_int)
        ,.gtrefclk00_in                           (gtrefclk00_int)
        ,.qpll0outclk_out                         (qpll0outclk_int)
        ,.qpll0outrefclk_out                      (qpll0outrefclk_int)
        ,.txdiffctrl_in                           (txdiffctrl_int)
        ,.txmaincursor_in                         (txmaincursor_int)
        ,.txpippmen_in                            (txpippmen_int)
        ,.txpippmovrden_in                        (txpippmovrden_int)
        ,.txpippmpd_in                            (txpippmpd_int)
        ,.txpippmsel_in                           (txpippmsel_int)
        ,.txpippmstepsize_in                      (txpippmstepsize_int)
        ,.txpostcursor_in                         (txpostcursor_int)
        ,.txprecursor_in                          (txprecursor_int)
        ,.gtpowergood_out                         (gtpowergood_int)
        ,.rxpmaresetdone_out                      (rxpmaresetdone_int)
        ,.rxprgdivresetdone_out                   (rxprgdivresetdone_int)
        ,.txbufstatus_out                         (txbufstatus_int)
        ,.txpmaresetdone_out                      (txpmaresetdone_int)
        ,.txprgdivresetdone_out                   (txprgdivresetdone_int)
    );


endmodule
