
    wire dl_reset;
    wire dl_clock;
    assign dl_reset = ap_rst_n;
    assign dl_clock = ap_clk;
    wire [4:0] proc_0_data_FIFO_blk;
    wire [4:0] proc_0_data_PIPO_blk;
    wire [4:0] proc_0_start_FIFO_blk;
    wire [4:0] proc_0_TLF_FIFO_blk;
    wire [4:0] proc_0_input_sync_blk;
    wire [4:0] proc_0_output_sync_blk;
    wire [4:0] proc_dep_vld_vec_0;
    reg [4:0] proc_dep_vld_vec_0_reg;
    wire [4:0] in_chan_dep_vld_vec_0;
    wire [279:0] in_chan_dep_data_vec_0;
    wire [4:0] token_in_vec_0;
    wire [4:0] out_chan_dep_vld_vec_0;
    wire [55:0] out_chan_dep_data_0;
    wire [4:0] token_out_vec_0;
    wire dl_detect_out_0;
    wire dep_chan_vld_1_0;
    wire [55:0] dep_chan_data_1_0;
    wire token_1_0;
    wire dep_chan_vld_2_0;
    wire [55:0] dep_chan_data_2_0;
    wire token_2_0;
    wire dep_chan_vld_22_0;
    wire [55:0] dep_chan_data_22_0;
    wire token_22_0;
    wire dep_chan_vld_30_0;
    wire [55:0] dep_chan_data_30_0;
    wire token_30_0;
    wire dep_chan_vld_38_0;
    wire [55:0] dep_chan_data_38_0;
    wire token_38_0;
    wire [4:0] proc_1_data_FIFO_blk;
    wire [4:0] proc_1_data_PIPO_blk;
    wire [4:0] proc_1_start_FIFO_blk;
    wire [4:0] proc_1_TLF_FIFO_blk;
    wire [4:0] proc_1_input_sync_blk;
    wire [4:0] proc_1_output_sync_blk;
    wire [4:0] proc_dep_vld_vec_1;
    reg [4:0] proc_dep_vld_vec_1_reg;
    wire [4:0] in_chan_dep_vld_vec_1;
    wire [279:0] in_chan_dep_data_vec_1;
    wire [4:0] token_in_vec_1;
    wire [4:0] out_chan_dep_vld_vec_1;
    wire [55:0] out_chan_dep_data_1;
    wire [4:0] token_out_vec_1;
    wire dl_detect_out_1;
    wire dep_chan_vld_0_1;
    wire [55:0] dep_chan_data_0_1;
    wire token_0_1;
    wire dep_chan_vld_8_1;
    wire [55:0] dep_chan_data_8_1;
    wire token_8_1;
    wire dep_chan_vld_9_1;
    wire [55:0] dep_chan_data_9_1;
    wire token_9_1;
    wire dep_chan_vld_22_1;
    wire [55:0] dep_chan_data_22_1;
    wire token_22_1;
    wire dep_chan_vld_23_1;
    wire [55:0] dep_chan_data_23_1;
    wire token_23_1;
    wire [1:0] proc_2_data_FIFO_blk;
    wire [1:0] proc_2_data_PIPO_blk;
    wire [1:0] proc_2_start_FIFO_blk;
    wire [1:0] proc_2_TLF_FIFO_blk;
    wire [1:0] proc_2_input_sync_blk;
    wire [1:0] proc_2_output_sync_blk;
    wire [1:0] proc_dep_vld_vec_2;
    reg [1:0] proc_dep_vld_vec_2_reg;
    wire [1:0] in_chan_dep_vld_vec_2;
    wire [111:0] in_chan_dep_data_vec_2;
    wire [1:0] token_in_vec_2;
    wire [1:0] out_chan_dep_vld_vec_2;
    wire [55:0] out_chan_dep_data_2;
    wire [1:0] token_out_vec_2;
    wire dl_detect_out_2;
    wire dep_chan_vld_0_2;
    wire [55:0] dep_chan_data_0_2;
    wire token_0_2;
    wire dep_chan_vld_3_2;
    wire [55:0] dep_chan_data_3_2;
    wire token_3_2;
    wire [2:0] proc_3_data_FIFO_blk;
    wire [2:0] proc_3_data_PIPO_blk;
    wire [2:0] proc_3_start_FIFO_blk;
    wire [2:0] proc_3_TLF_FIFO_blk;
    wire [2:0] proc_3_input_sync_blk;
    wire [2:0] proc_3_output_sync_blk;
    wire [2:0] proc_dep_vld_vec_3;
    reg [2:0] proc_dep_vld_vec_3_reg;
    wire [2:0] in_chan_dep_vld_vec_3;
    wire [167:0] in_chan_dep_data_vec_3;
    wire [2:0] token_in_vec_3;
    wire [2:0] out_chan_dep_vld_vec_3;
    wire [55:0] out_chan_dep_data_3;
    wire [2:0] token_out_vec_3;
    wire dl_detect_out_3;
    wire dep_chan_vld_2_3;
    wire [55:0] dep_chan_data_2_3;
    wire token_2_3;
    wire dep_chan_vld_4_3;
    wire [55:0] dep_chan_data_4_3;
    wire token_4_3;
    wire dep_chan_vld_7_3;
    wire [55:0] dep_chan_data_7_3;
    wire token_7_3;
    wire [1:0] proc_4_data_FIFO_blk;
    wire [1:0] proc_4_data_PIPO_blk;
    wire [1:0] proc_4_start_FIFO_blk;
    wire [1:0] proc_4_TLF_FIFO_blk;
    wire [1:0] proc_4_input_sync_blk;
    wire [1:0] proc_4_output_sync_blk;
    wire [1:0] proc_dep_vld_vec_4;
    reg [1:0] proc_dep_vld_vec_4_reg;
    wire [1:0] in_chan_dep_vld_vec_4;
    wire [111:0] in_chan_dep_data_vec_4;
    wire [1:0] token_in_vec_4;
    wire [1:0] out_chan_dep_vld_vec_4;
    wire [55:0] out_chan_dep_data_4;
    wire [1:0] token_out_vec_4;
    wire dl_detect_out_4;
    wire dep_chan_vld_3_4;
    wire [55:0] dep_chan_data_3_4;
    wire token_3_4;
    wire dep_chan_vld_5_4;
    wire [55:0] dep_chan_data_5_4;
    wire token_5_4;
    wire [4:0] proc_5_data_FIFO_blk;
    wire [4:0] proc_5_data_PIPO_blk;
    wire [4:0] proc_5_start_FIFO_blk;
    wire [4:0] proc_5_TLF_FIFO_blk;
    wire [4:0] proc_5_input_sync_blk;
    wire [4:0] proc_5_output_sync_blk;
    wire [4:0] proc_dep_vld_vec_5;
    reg [4:0] proc_dep_vld_vec_5_reg;
    wire [4:0] in_chan_dep_vld_vec_5;
    wire [279:0] in_chan_dep_data_vec_5;
    wire [4:0] token_in_vec_5;
    wire [4:0] out_chan_dep_vld_vec_5;
    wire [55:0] out_chan_dep_data_5;
    wire [4:0] token_out_vec_5;
    wire dl_detect_out_5;
    wire dep_chan_vld_4_5;
    wire [55:0] dep_chan_data_4_5;
    wire token_4_5;
    wire dep_chan_vld_6_5;
    wire [55:0] dep_chan_data_6_5;
    wire token_6_5;
    wire dep_chan_vld_7_5;
    wire [55:0] dep_chan_data_7_5;
    wire token_7_5;
    wire dep_chan_vld_8_5;
    wire [55:0] dep_chan_data_8_5;
    wire token_8_5;
    wire dep_chan_vld_9_5;
    wire [55:0] dep_chan_data_9_5;
    wire token_9_5;
    wire [1:0] proc_6_data_FIFO_blk;
    wire [1:0] proc_6_data_PIPO_blk;
    wire [1:0] proc_6_start_FIFO_blk;
    wire [1:0] proc_6_TLF_FIFO_blk;
    wire [1:0] proc_6_input_sync_blk;
    wire [1:0] proc_6_output_sync_blk;
    wire [1:0] proc_dep_vld_vec_6;
    reg [1:0] proc_dep_vld_vec_6_reg;
    wire [1:0] in_chan_dep_vld_vec_6;
    wire [111:0] in_chan_dep_data_vec_6;
    wire [1:0] token_in_vec_6;
    wire [1:0] out_chan_dep_vld_vec_6;
    wire [55:0] out_chan_dep_data_6;
    wire [1:0] token_out_vec_6;
    wire dl_detect_out_6;
    wire dep_chan_vld_5_6;
    wire [55:0] dep_chan_data_5_6;
    wire token_5_6;
    wire dep_chan_vld_7_6;
    wire [55:0] dep_chan_data_7_6;
    wire token_7_6;
    wire [4:0] proc_7_data_FIFO_blk;
    wire [4:0] proc_7_data_PIPO_blk;
    wire [4:0] proc_7_start_FIFO_blk;
    wire [4:0] proc_7_TLF_FIFO_blk;
    wire [4:0] proc_7_input_sync_blk;
    wire [4:0] proc_7_output_sync_blk;
    wire [4:0] proc_dep_vld_vec_7;
    reg [4:0] proc_dep_vld_vec_7_reg;
    wire [4:0] in_chan_dep_vld_vec_7;
    wire [279:0] in_chan_dep_data_vec_7;
    wire [4:0] token_in_vec_7;
    wire [4:0] out_chan_dep_vld_vec_7;
    wire [55:0] out_chan_dep_data_7;
    wire [4:0] token_out_vec_7;
    wire dl_detect_out_7;
    wire dep_chan_vld_3_7;
    wire [55:0] dep_chan_data_3_7;
    wire token_3_7;
    wire dep_chan_vld_5_7;
    wire [55:0] dep_chan_data_5_7;
    wire token_5_7;
    wire dep_chan_vld_6_7;
    wire [55:0] dep_chan_data_6_7;
    wire token_6_7;
    wire dep_chan_vld_22_7;
    wire [55:0] dep_chan_data_22_7;
    wire token_22_7;
    wire dep_chan_vld_23_7;
    wire [55:0] dep_chan_data_23_7;
    wire token_23_7;
    wire [5:0] proc_8_data_FIFO_blk;
    wire [5:0] proc_8_data_PIPO_blk;
    wire [5:0] proc_8_start_FIFO_blk;
    wire [5:0] proc_8_TLF_FIFO_blk;
    wire [5:0] proc_8_input_sync_blk;
    wire [5:0] proc_8_output_sync_blk;
    wire [5:0] proc_dep_vld_vec_8;
    reg [5:0] proc_dep_vld_vec_8_reg;
    wire [5:0] in_chan_dep_vld_vec_8;
    wire [335:0] in_chan_dep_data_vec_8;
    wire [5:0] token_in_vec_8;
    wire [5:0] out_chan_dep_vld_vec_8;
    wire [55:0] out_chan_dep_data_8;
    wire [5:0] token_out_vec_8;
    wire dl_detect_out_8;
    wire dep_chan_vld_1_8;
    wire [55:0] dep_chan_data_1_8;
    wire token_1_8;
    wire dep_chan_vld_5_8;
    wire [55:0] dep_chan_data_5_8;
    wire token_5_8;
    wire dep_chan_vld_15_8;
    wire [55:0] dep_chan_data_15_8;
    wire token_15_8;
    wire dep_chan_vld_16_8;
    wire [55:0] dep_chan_data_16_8;
    wire token_16_8;
    wire dep_chan_vld_30_8;
    wire [55:0] dep_chan_data_30_8;
    wire token_30_8;
    wire dep_chan_vld_31_8;
    wire [55:0] dep_chan_data_31_8;
    wire token_31_8;
    wire [2:0] proc_9_data_FIFO_blk;
    wire [2:0] proc_9_data_PIPO_blk;
    wire [2:0] proc_9_start_FIFO_blk;
    wire [2:0] proc_9_TLF_FIFO_blk;
    wire [2:0] proc_9_input_sync_blk;
    wire [2:0] proc_9_output_sync_blk;
    wire [2:0] proc_dep_vld_vec_9;
    reg [2:0] proc_dep_vld_vec_9_reg;
    wire [2:0] in_chan_dep_vld_vec_9;
    wire [167:0] in_chan_dep_data_vec_9;
    wire [2:0] token_in_vec_9;
    wire [2:0] out_chan_dep_vld_vec_9;
    wire [55:0] out_chan_dep_data_9;
    wire [2:0] token_out_vec_9;
    wire dl_detect_out_9;
    wire dep_chan_vld_1_9;
    wire [55:0] dep_chan_data_1_9;
    wire token_1_9;
    wire dep_chan_vld_5_9;
    wire [55:0] dep_chan_data_5_9;
    wire token_5_9;
    wire dep_chan_vld_10_9;
    wire [55:0] dep_chan_data_10_9;
    wire token_10_9;
    wire [2:0] proc_10_data_FIFO_blk;
    wire [2:0] proc_10_data_PIPO_blk;
    wire [2:0] proc_10_start_FIFO_blk;
    wire [2:0] proc_10_TLF_FIFO_blk;
    wire [2:0] proc_10_input_sync_blk;
    wire [2:0] proc_10_output_sync_blk;
    wire [2:0] proc_dep_vld_vec_10;
    reg [2:0] proc_dep_vld_vec_10_reg;
    wire [2:0] in_chan_dep_vld_vec_10;
    wire [167:0] in_chan_dep_data_vec_10;
    wire [2:0] token_in_vec_10;
    wire [2:0] out_chan_dep_vld_vec_10;
    wire [55:0] out_chan_dep_data_10;
    wire [2:0] token_out_vec_10;
    wire dl_detect_out_10;
    wire dep_chan_vld_9_10;
    wire [55:0] dep_chan_data_9_10;
    wire token_9_10;
    wire dep_chan_vld_11_10;
    wire [55:0] dep_chan_data_11_10;
    wire token_11_10;
    wire dep_chan_vld_14_10;
    wire [55:0] dep_chan_data_14_10;
    wire token_14_10;
    wire [1:0] proc_11_data_FIFO_blk;
    wire [1:0] proc_11_data_PIPO_blk;
    wire [1:0] proc_11_start_FIFO_blk;
    wire [1:0] proc_11_TLF_FIFO_blk;
    wire [1:0] proc_11_input_sync_blk;
    wire [1:0] proc_11_output_sync_blk;
    wire [1:0] proc_dep_vld_vec_11;
    reg [1:0] proc_dep_vld_vec_11_reg;
    wire [1:0] in_chan_dep_vld_vec_11;
    wire [111:0] in_chan_dep_data_vec_11;
    wire [1:0] token_in_vec_11;
    wire [1:0] out_chan_dep_vld_vec_11;
    wire [55:0] out_chan_dep_data_11;
    wire [1:0] token_out_vec_11;
    wire dl_detect_out_11;
    wire dep_chan_vld_10_11;
    wire [55:0] dep_chan_data_10_11;
    wire token_10_11;
    wire dep_chan_vld_12_11;
    wire [55:0] dep_chan_data_12_11;
    wire token_12_11;
    wire [4:0] proc_12_data_FIFO_blk;
    wire [4:0] proc_12_data_PIPO_blk;
    wire [4:0] proc_12_start_FIFO_blk;
    wire [4:0] proc_12_TLF_FIFO_blk;
    wire [4:0] proc_12_input_sync_blk;
    wire [4:0] proc_12_output_sync_blk;
    wire [4:0] proc_dep_vld_vec_12;
    reg [4:0] proc_dep_vld_vec_12_reg;
    wire [4:0] in_chan_dep_vld_vec_12;
    wire [279:0] in_chan_dep_data_vec_12;
    wire [4:0] token_in_vec_12;
    wire [4:0] out_chan_dep_vld_vec_12;
    wire [55:0] out_chan_dep_data_12;
    wire [4:0] token_out_vec_12;
    wire dl_detect_out_12;
    wire dep_chan_vld_11_12;
    wire [55:0] dep_chan_data_11_12;
    wire token_11_12;
    wire dep_chan_vld_13_12;
    wire [55:0] dep_chan_data_13_12;
    wire token_13_12;
    wire dep_chan_vld_14_12;
    wire [55:0] dep_chan_data_14_12;
    wire token_14_12;
    wire dep_chan_vld_15_12;
    wire [55:0] dep_chan_data_15_12;
    wire token_15_12;
    wire dep_chan_vld_16_12;
    wire [55:0] dep_chan_data_16_12;
    wire token_16_12;
    wire [1:0] proc_13_data_FIFO_blk;
    wire [1:0] proc_13_data_PIPO_blk;
    wire [1:0] proc_13_start_FIFO_blk;
    wire [1:0] proc_13_TLF_FIFO_blk;
    wire [1:0] proc_13_input_sync_blk;
    wire [1:0] proc_13_output_sync_blk;
    wire [1:0] proc_dep_vld_vec_13;
    reg [1:0] proc_dep_vld_vec_13_reg;
    wire [1:0] in_chan_dep_vld_vec_13;
    wire [111:0] in_chan_dep_data_vec_13;
    wire [1:0] token_in_vec_13;
    wire [1:0] out_chan_dep_vld_vec_13;
    wire [55:0] out_chan_dep_data_13;
    wire [1:0] token_out_vec_13;
    wire dl_detect_out_13;
    wire dep_chan_vld_12_13;
    wire [55:0] dep_chan_data_12_13;
    wire token_12_13;
    wire dep_chan_vld_14_13;
    wire [55:0] dep_chan_data_14_13;
    wire token_14_13;
    wire [4:0] proc_14_data_FIFO_blk;
    wire [4:0] proc_14_data_PIPO_blk;
    wire [4:0] proc_14_start_FIFO_blk;
    wire [4:0] proc_14_TLF_FIFO_blk;
    wire [4:0] proc_14_input_sync_blk;
    wire [4:0] proc_14_output_sync_blk;
    wire [4:0] proc_dep_vld_vec_14;
    reg [4:0] proc_dep_vld_vec_14_reg;
    wire [4:0] in_chan_dep_vld_vec_14;
    wire [279:0] in_chan_dep_data_vec_14;
    wire [4:0] token_in_vec_14;
    wire [4:0] out_chan_dep_vld_vec_14;
    wire [55:0] out_chan_dep_data_14;
    wire [4:0] token_out_vec_14;
    wire dl_detect_out_14;
    wire dep_chan_vld_10_14;
    wire [55:0] dep_chan_data_10_14;
    wire token_10_14;
    wire dep_chan_vld_12_14;
    wire [55:0] dep_chan_data_12_14;
    wire token_12_14;
    wire dep_chan_vld_13_14;
    wire [55:0] dep_chan_data_13_14;
    wire token_13_14;
    wire dep_chan_vld_30_14;
    wire [55:0] dep_chan_data_30_14;
    wire token_30_14;
    wire dep_chan_vld_31_14;
    wire [55:0] dep_chan_data_31_14;
    wire token_31_14;
    wire [5:0] proc_15_data_FIFO_blk;
    wire [5:0] proc_15_data_PIPO_blk;
    wire [5:0] proc_15_start_FIFO_blk;
    wire [5:0] proc_15_TLF_FIFO_blk;
    wire [5:0] proc_15_input_sync_blk;
    wire [5:0] proc_15_output_sync_blk;
    wire [5:0] proc_dep_vld_vec_15;
    reg [5:0] proc_dep_vld_vec_15_reg;
    wire [5:0] in_chan_dep_vld_vec_15;
    wire [335:0] in_chan_dep_data_vec_15;
    wire [5:0] token_in_vec_15;
    wire [5:0] out_chan_dep_vld_vec_15;
    wire [55:0] out_chan_dep_data_15;
    wire [5:0] token_out_vec_15;
    wire dl_detect_out_15;
    wire dep_chan_vld_8_15;
    wire [55:0] dep_chan_data_8_15;
    wire token_8_15;
    wire dep_chan_vld_12_15;
    wire [55:0] dep_chan_data_12_15;
    wire token_12_15;
    wire dep_chan_vld_38_15;
    wire [55:0] dep_chan_data_38_15;
    wire token_38_15;
    wire dep_chan_vld_39_15;
    wire [55:0] dep_chan_data_39_15;
    wire token_39_15;
    wire dep_chan_vld_46_15;
    wire [55:0] dep_chan_data_46_15;
    wire token_46_15;
    wire dep_chan_vld_47_15;
    wire [55:0] dep_chan_data_47_15;
    wire token_47_15;
    wire [2:0] proc_16_data_FIFO_blk;
    wire [2:0] proc_16_data_PIPO_blk;
    wire [2:0] proc_16_start_FIFO_blk;
    wire [2:0] proc_16_TLF_FIFO_blk;
    wire [2:0] proc_16_input_sync_blk;
    wire [2:0] proc_16_output_sync_blk;
    wire [2:0] proc_dep_vld_vec_16;
    reg [2:0] proc_dep_vld_vec_16_reg;
    wire [2:0] in_chan_dep_vld_vec_16;
    wire [167:0] in_chan_dep_data_vec_16;
    wire [2:0] token_in_vec_16;
    wire [2:0] out_chan_dep_vld_vec_16;
    wire [55:0] out_chan_dep_data_16;
    wire [2:0] token_out_vec_16;
    wire dl_detect_out_16;
    wire dep_chan_vld_8_16;
    wire [55:0] dep_chan_data_8_16;
    wire token_8_16;
    wire dep_chan_vld_12_16;
    wire [55:0] dep_chan_data_12_16;
    wire token_12_16;
    wire dep_chan_vld_17_16;
    wire [55:0] dep_chan_data_17_16;
    wire token_17_16;
    wire [2:0] proc_17_data_FIFO_blk;
    wire [2:0] proc_17_data_PIPO_blk;
    wire [2:0] proc_17_start_FIFO_blk;
    wire [2:0] proc_17_TLF_FIFO_blk;
    wire [2:0] proc_17_input_sync_blk;
    wire [2:0] proc_17_output_sync_blk;
    wire [2:0] proc_dep_vld_vec_17;
    reg [2:0] proc_dep_vld_vec_17_reg;
    wire [2:0] in_chan_dep_vld_vec_17;
    wire [167:0] in_chan_dep_data_vec_17;
    wire [2:0] token_in_vec_17;
    wire [2:0] out_chan_dep_vld_vec_17;
    wire [55:0] out_chan_dep_data_17;
    wire [2:0] token_out_vec_17;
    wire dl_detect_out_17;
    wire dep_chan_vld_16_17;
    wire [55:0] dep_chan_data_16_17;
    wire token_16_17;
    wire dep_chan_vld_18_17;
    wire [55:0] dep_chan_data_18_17;
    wire token_18_17;
    wire dep_chan_vld_21_17;
    wire [55:0] dep_chan_data_21_17;
    wire token_21_17;
    wire [1:0] proc_18_data_FIFO_blk;
    wire [1:0] proc_18_data_PIPO_blk;
    wire [1:0] proc_18_start_FIFO_blk;
    wire [1:0] proc_18_TLF_FIFO_blk;
    wire [1:0] proc_18_input_sync_blk;
    wire [1:0] proc_18_output_sync_blk;
    wire [1:0] proc_dep_vld_vec_18;
    reg [1:0] proc_dep_vld_vec_18_reg;
    wire [1:0] in_chan_dep_vld_vec_18;
    wire [111:0] in_chan_dep_data_vec_18;
    wire [1:0] token_in_vec_18;
    wire [1:0] out_chan_dep_vld_vec_18;
    wire [55:0] out_chan_dep_data_18;
    wire [1:0] token_out_vec_18;
    wire dl_detect_out_18;
    wire dep_chan_vld_17_18;
    wire [55:0] dep_chan_data_17_18;
    wire token_17_18;
    wire dep_chan_vld_19_18;
    wire [55:0] dep_chan_data_19_18;
    wire token_19_18;
    wire [4:0] proc_19_data_FIFO_blk;
    wire [4:0] proc_19_data_PIPO_blk;
    wire [4:0] proc_19_start_FIFO_blk;
    wire [4:0] proc_19_TLF_FIFO_blk;
    wire [4:0] proc_19_input_sync_blk;
    wire [4:0] proc_19_output_sync_blk;
    wire [4:0] proc_dep_vld_vec_19;
    reg [4:0] proc_dep_vld_vec_19_reg;
    wire [4:0] in_chan_dep_vld_vec_19;
    wire [279:0] in_chan_dep_data_vec_19;
    wire [4:0] token_in_vec_19;
    wire [4:0] out_chan_dep_vld_vec_19;
    wire [55:0] out_chan_dep_data_19;
    wire [4:0] token_out_vec_19;
    wire dl_detect_out_19;
    wire dep_chan_vld_18_19;
    wire [55:0] dep_chan_data_18_19;
    wire token_18_19;
    wire dep_chan_vld_20_19;
    wire [55:0] dep_chan_data_20_19;
    wire token_20_19;
    wire dep_chan_vld_21_19;
    wire [55:0] dep_chan_data_21_19;
    wire token_21_19;
    wire dep_chan_vld_46_19;
    wire [55:0] dep_chan_data_46_19;
    wire token_46_19;
    wire dep_chan_vld_47_19;
    wire [55:0] dep_chan_data_47_19;
    wire token_47_19;
    wire [1:0] proc_20_data_FIFO_blk;
    wire [1:0] proc_20_data_PIPO_blk;
    wire [1:0] proc_20_start_FIFO_blk;
    wire [1:0] proc_20_TLF_FIFO_blk;
    wire [1:0] proc_20_input_sync_blk;
    wire [1:0] proc_20_output_sync_blk;
    wire [1:0] proc_dep_vld_vec_20;
    reg [1:0] proc_dep_vld_vec_20_reg;
    wire [1:0] in_chan_dep_vld_vec_20;
    wire [111:0] in_chan_dep_data_vec_20;
    wire [1:0] token_in_vec_20;
    wire [1:0] out_chan_dep_vld_vec_20;
    wire [55:0] out_chan_dep_data_20;
    wire [1:0] token_out_vec_20;
    wire dl_detect_out_20;
    wire dep_chan_vld_19_20;
    wire [55:0] dep_chan_data_19_20;
    wire token_19_20;
    wire dep_chan_vld_21_20;
    wire [55:0] dep_chan_data_21_20;
    wire token_21_20;
    wire [4:0] proc_21_data_FIFO_blk;
    wire [4:0] proc_21_data_PIPO_blk;
    wire [4:0] proc_21_start_FIFO_blk;
    wire [4:0] proc_21_TLF_FIFO_blk;
    wire [4:0] proc_21_input_sync_blk;
    wire [4:0] proc_21_output_sync_blk;
    wire [4:0] proc_dep_vld_vec_21;
    reg [4:0] proc_dep_vld_vec_21_reg;
    wire [4:0] in_chan_dep_vld_vec_21;
    wire [279:0] in_chan_dep_data_vec_21;
    wire [4:0] token_in_vec_21;
    wire [4:0] out_chan_dep_vld_vec_21;
    wire [55:0] out_chan_dep_data_21;
    wire [4:0] token_out_vec_21;
    wire dl_detect_out_21;
    wire dep_chan_vld_17_21;
    wire [55:0] dep_chan_data_17_21;
    wire token_17_21;
    wire dep_chan_vld_19_21;
    wire [55:0] dep_chan_data_19_21;
    wire token_19_21;
    wire dep_chan_vld_20_21;
    wire [55:0] dep_chan_data_20_21;
    wire token_20_21;
    wire dep_chan_vld_38_21;
    wire [55:0] dep_chan_data_38_21;
    wire token_38_21;
    wire dep_chan_vld_39_21;
    wire [55:0] dep_chan_data_39_21;
    wire token_39_21;
    wire [7:0] proc_22_data_FIFO_blk;
    wire [7:0] proc_22_data_PIPO_blk;
    wire [7:0] proc_22_start_FIFO_blk;
    wire [7:0] proc_22_TLF_FIFO_blk;
    wire [7:0] proc_22_input_sync_blk;
    wire [7:0] proc_22_output_sync_blk;
    wire [7:0] proc_dep_vld_vec_22;
    reg [7:0] proc_dep_vld_vec_22_reg;
    wire [7:0] in_chan_dep_vld_vec_22;
    wire [447:0] in_chan_dep_data_vec_22;
    wire [7:0] token_in_vec_22;
    wire [7:0] out_chan_dep_vld_vec_22;
    wire [55:0] out_chan_dep_data_22;
    wire [7:0] token_out_vec_22;
    wire dl_detect_out_22;
    wire dep_chan_vld_0_22;
    wire [55:0] dep_chan_data_0_22;
    wire token_0_22;
    wire dep_chan_vld_1_22;
    wire [55:0] dep_chan_data_1_22;
    wire token_1_22;
    wire dep_chan_vld_7_22;
    wire [55:0] dep_chan_data_7_22;
    wire token_7_22;
    wire dep_chan_vld_30_22;
    wire [55:0] dep_chan_data_30_22;
    wire token_30_22;
    wire dep_chan_vld_38_22;
    wire [55:0] dep_chan_data_38_22;
    wire token_38_22;
    wire dep_chan_vld_52_22;
    wire [55:0] dep_chan_data_52_22;
    wire token_52_22;
    wire dep_chan_vld_54_22;
    wire [55:0] dep_chan_data_54_22;
    wire token_54_22;
    wire dep_chan_vld_55_22;
    wire [55:0] dep_chan_data_55_22;
    wire token_55_22;
    wire [2:0] proc_23_data_FIFO_blk;
    wire [2:0] proc_23_data_PIPO_blk;
    wire [2:0] proc_23_start_FIFO_blk;
    wire [2:0] proc_23_TLF_FIFO_blk;
    wire [2:0] proc_23_input_sync_blk;
    wire [2:0] proc_23_output_sync_blk;
    wire [2:0] proc_dep_vld_vec_23;
    reg [2:0] proc_dep_vld_vec_23_reg;
    wire [2:0] in_chan_dep_vld_vec_23;
    wire [167:0] in_chan_dep_data_vec_23;
    wire [2:0] token_in_vec_23;
    wire [2:0] out_chan_dep_vld_vec_23;
    wire [55:0] out_chan_dep_data_23;
    wire [2:0] token_out_vec_23;
    wire dl_detect_out_23;
    wire dep_chan_vld_1_23;
    wire [55:0] dep_chan_data_1_23;
    wire token_1_23;
    wire dep_chan_vld_7_23;
    wire [55:0] dep_chan_data_7_23;
    wire token_7_23;
    wire dep_chan_vld_24_23;
    wire [55:0] dep_chan_data_24_23;
    wire token_24_23;
    wire [2:0] proc_24_data_FIFO_blk;
    wire [2:0] proc_24_data_PIPO_blk;
    wire [2:0] proc_24_start_FIFO_blk;
    wire [2:0] proc_24_TLF_FIFO_blk;
    wire [2:0] proc_24_input_sync_blk;
    wire [2:0] proc_24_output_sync_blk;
    wire [2:0] proc_dep_vld_vec_24;
    reg [2:0] proc_dep_vld_vec_24_reg;
    wire [2:0] in_chan_dep_vld_vec_24;
    wire [167:0] in_chan_dep_data_vec_24;
    wire [2:0] token_in_vec_24;
    wire [2:0] out_chan_dep_vld_vec_24;
    wire [55:0] out_chan_dep_data_24;
    wire [2:0] token_out_vec_24;
    wire dl_detect_out_24;
    wire dep_chan_vld_23_24;
    wire [55:0] dep_chan_data_23_24;
    wire token_23_24;
    wire dep_chan_vld_52_24;
    wire [55:0] dep_chan_data_52_24;
    wire token_52_24;
    wire dep_chan_vld_54_24;
    wire [55:0] dep_chan_data_54_24;
    wire token_54_24;
    wire [0:0] proc_25_data_FIFO_blk;
    wire [0:0] proc_25_data_PIPO_blk;
    wire [0:0] proc_25_start_FIFO_blk;
    wire [0:0] proc_25_TLF_FIFO_blk;
    wire [0:0] proc_25_input_sync_blk;
    wire [0:0] proc_25_output_sync_blk;
    wire [0:0] proc_dep_vld_vec_25;
    reg [0:0] proc_dep_vld_vec_25_reg;
    wire [0:0] in_chan_dep_vld_vec_25;
    wire [55:0] in_chan_dep_data_vec_25;
    wire [0:0] token_in_vec_25;
    wire [0:0] out_chan_dep_vld_vec_25;
    wire [55:0] out_chan_dep_data_25;
    wire [0:0] token_out_vec_25;
    wire dl_detect_out_25;
    wire dep_chan_vld_26_25;
    wire [55:0] dep_chan_data_26_25;
    wire token_26_25;
    wire [1:0] proc_26_data_FIFO_blk;
    wire [1:0] proc_26_data_PIPO_blk;
    wire [1:0] proc_26_start_FIFO_blk;
    wire [1:0] proc_26_TLF_FIFO_blk;
    wire [1:0] proc_26_input_sync_blk;
    wire [1:0] proc_26_output_sync_blk;
    wire [1:0] proc_dep_vld_vec_26;
    reg [1:0] proc_dep_vld_vec_26_reg;
    wire [1:0] in_chan_dep_vld_vec_26;
    wire [111:0] in_chan_dep_data_vec_26;
    wire [1:0] token_in_vec_26;
    wire [1:0] out_chan_dep_vld_vec_26;
    wire [55:0] out_chan_dep_data_26;
    wire [1:0] token_out_vec_26;
    wire dl_detect_out_26;
    wire dep_chan_vld_25_26;
    wire [55:0] dep_chan_data_25_26;
    wire token_25_26;
    wire dep_chan_vld_27_26;
    wire [55:0] dep_chan_data_27_26;
    wire token_27_26;
    wire [2:0] proc_27_data_FIFO_blk;
    wire [2:0] proc_27_data_PIPO_blk;
    wire [2:0] proc_27_start_FIFO_blk;
    wire [2:0] proc_27_TLF_FIFO_blk;
    wire [2:0] proc_27_input_sync_blk;
    wire [2:0] proc_27_output_sync_blk;
    wire [2:0] proc_dep_vld_vec_27;
    reg [2:0] proc_dep_vld_vec_27_reg;
    wire [2:0] in_chan_dep_vld_vec_27;
    wire [167:0] in_chan_dep_data_vec_27;
    wire [2:0] token_in_vec_27;
    wire [2:0] out_chan_dep_vld_vec_27;
    wire [55:0] out_chan_dep_data_27;
    wire [2:0] token_out_vec_27;
    wire dl_detect_out_27;
    wire dep_chan_vld_26_27;
    wire [55:0] dep_chan_data_26_27;
    wire token_26_27;
    wire dep_chan_vld_28_27;
    wire [55:0] dep_chan_data_28_27;
    wire token_28_27;
    wire dep_chan_vld_29_27;
    wire [55:0] dep_chan_data_29_27;
    wire token_29_27;
    wire [1:0] proc_28_data_FIFO_blk;
    wire [1:0] proc_28_data_PIPO_blk;
    wire [1:0] proc_28_start_FIFO_blk;
    wire [1:0] proc_28_TLF_FIFO_blk;
    wire [1:0] proc_28_input_sync_blk;
    wire [1:0] proc_28_output_sync_blk;
    wire [1:0] proc_dep_vld_vec_28;
    reg [1:0] proc_dep_vld_vec_28_reg;
    wire [1:0] in_chan_dep_vld_vec_28;
    wire [111:0] in_chan_dep_data_vec_28;
    wire [1:0] token_in_vec_28;
    wire [1:0] out_chan_dep_vld_vec_28;
    wire [55:0] out_chan_dep_data_28;
    wire [1:0] token_out_vec_28;
    wire dl_detect_out_28;
    wire dep_chan_vld_27_28;
    wire [55:0] dep_chan_data_27_28;
    wire token_27_28;
    wire dep_chan_vld_29_28;
    wire [55:0] dep_chan_data_29_28;
    wire token_29_28;
    wire [1:0] proc_29_data_FIFO_blk;
    wire [1:0] proc_29_data_PIPO_blk;
    wire [1:0] proc_29_start_FIFO_blk;
    wire [1:0] proc_29_TLF_FIFO_blk;
    wire [1:0] proc_29_input_sync_blk;
    wire [1:0] proc_29_output_sync_blk;
    wire [1:0] proc_dep_vld_vec_29;
    reg [1:0] proc_dep_vld_vec_29_reg;
    wire [1:0] in_chan_dep_vld_vec_29;
    wire [111:0] in_chan_dep_data_vec_29;
    wire [1:0] token_in_vec_29;
    wire [1:0] out_chan_dep_vld_vec_29;
    wire [55:0] out_chan_dep_data_29;
    wire [1:0] token_out_vec_29;
    wire dl_detect_out_29;
    wire dep_chan_vld_27_29;
    wire [55:0] dep_chan_data_27_29;
    wire token_27_29;
    wire dep_chan_vld_28_29;
    wire [55:0] dep_chan_data_28_29;
    wire token_28_29;
    wire [7:0] proc_30_data_FIFO_blk;
    wire [7:0] proc_30_data_PIPO_blk;
    wire [7:0] proc_30_start_FIFO_blk;
    wire [7:0] proc_30_TLF_FIFO_blk;
    wire [7:0] proc_30_input_sync_blk;
    wire [7:0] proc_30_output_sync_blk;
    wire [7:0] proc_dep_vld_vec_30;
    reg [7:0] proc_dep_vld_vec_30_reg;
    wire [7:0] in_chan_dep_vld_vec_30;
    wire [447:0] in_chan_dep_data_vec_30;
    wire [7:0] token_in_vec_30;
    wire [7:0] out_chan_dep_vld_vec_30;
    wire [55:0] out_chan_dep_data_30;
    wire [7:0] token_out_vec_30;
    wire dl_detect_out_30;
    wire dep_chan_vld_0_30;
    wire [55:0] dep_chan_data_0_30;
    wire token_0_30;
    wire dep_chan_vld_8_30;
    wire [55:0] dep_chan_data_8_30;
    wire token_8_30;
    wire dep_chan_vld_14_30;
    wire [55:0] dep_chan_data_14_30;
    wire token_14_30;
    wire dep_chan_vld_22_30;
    wire [55:0] dep_chan_data_22_30;
    wire token_22_30;
    wire dep_chan_vld_38_30;
    wire [55:0] dep_chan_data_38_30;
    wire token_38_30;
    wire dep_chan_vld_49_30;
    wire [55:0] dep_chan_data_49_30;
    wire token_49_30;
    wire dep_chan_vld_51_30;
    wire [55:0] dep_chan_data_51_30;
    wire token_51_30;
    wire dep_chan_vld_55_30;
    wire [55:0] dep_chan_data_55_30;
    wire token_55_30;
    wire [2:0] proc_31_data_FIFO_blk;
    wire [2:0] proc_31_data_PIPO_blk;
    wire [2:0] proc_31_start_FIFO_blk;
    wire [2:0] proc_31_TLF_FIFO_blk;
    wire [2:0] proc_31_input_sync_blk;
    wire [2:0] proc_31_output_sync_blk;
    wire [2:0] proc_dep_vld_vec_31;
    reg [2:0] proc_dep_vld_vec_31_reg;
    wire [2:0] in_chan_dep_vld_vec_31;
    wire [167:0] in_chan_dep_data_vec_31;
    wire [2:0] token_in_vec_31;
    wire [2:0] out_chan_dep_vld_vec_31;
    wire [55:0] out_chan_dep_data_31;
    wire [2:0] token_out_vec_31;
    wire dl_detect_out_31;
    wire dep_chan_vld_8_31;
    wire [55:0] dep_chan_data_8_31;
    wire token_8_31;
    wire dep_chan_vld_14_31;
    wire [55:0] dep_chan_data_14_31;
    wire token_14_31;
    wire dep_chan_vld_32_31;
    wire [55:0] dep_chan_data_32_31;
    wire token_32_31;
    wire [2:0] proc_32_data_FIFO_blk;
    wire [2:0] proc_32_data_PIPO_blk;
    wire [2:0] proc_32_start_FIFO_blk;
    wire [2:0] proc_32_TLF_FIFO_blk;
    wire [2:0] proc_32_input_sync_blk;
    wire [2:0] proc_32_output_sync_blk;
    wire [2:0] proc_dep_vld_vec_32;
    reg [2:0] proc_dep_vld_vec_32_reg;
    wire [2:0] in_chan_dep_vld_vec_32;
    wire [167:0] in_chan_dep_data_vec_32;
    wire [2:0] token_in_vec_32;
    wire [2:0] out_chan_dep_vld_vec_32;
    wire [55:0] out_chan_dep_data_32;
    wire [2:0] token_out_vec_32;
    wire dl_detect_out_32;
    wire dep_chan_vld_31_32;
    wire [55:0] dep_chan_data_31_32;
    wire token_31_32;
    wire dep_chan_vld_49_32;
    wire [55:0] dep_chan_data_49_32;
    wire token_49_32;
    wire dep_chan_vld_51_32;
    wire [55:0] dep_chan_data_51_32;
    wire token_51_32;
    wire [0:0] proc_33_data_FIFO_blk;
    wire [0:0] proc_33_data_PIPO_blk;
    wire [0:0] proc_33_start_FIFO_blk;
    wire [0:0] proc_33_TLF_FIFO_blk;
    wire [0:0] proc_33_input_sync_blk;
    wire [0:0] proc_33_output_sync_blk;
    wire [0:0] proc_dep_vld_vec_33;
    reg [0:0] proc_dep_vld_vec_33_reg;
    wire [0:0] in_chan_dep_vld_vec_33;
    wire [55:0] in_chan_dep_data_vec_33;
    wire [0:0] token_in_vec_33;
    wire [0:0] out_chan_dep_vld_vec_33;
    wire [55:0] out_chan_dep_data_33;
    wire [0:0] token_out_vec_33;
    wire dl_detect_out_33;
    wire dep_chan_vld_34_33;
    wire [55:0] dep_chan_data_34_33;
    wire token_34_33;
    wire [1:0] proc_34_data_FIFO_blk;
    wire [1:0] proc_34_data_PIPO_blk;
    wire [1:0] proc_34_start_FIFO_blk;
    wire [1:0] proc_34_TLF_FIFO_blk;
    wire [1:0] proc_34_input_sync_blk;
    wire [1:0] proc_34_output_sync_blk;
    wire [1:0] proc_dep_vld_vec_34;
    reg [1:0] proc_dep_vld_vec_34_reg;
    wire [1:0] in_chan_dep_vld_vec_34;
    wire [111:0] in_chan_dep_data_vec_34;
    wire [1:0] token_in_vec_34;
    wire [1:0] out_chan_dep_vld_vec_34;
    wire [55:0] out_chan_dep_data_34;
    wire [1:0] token_out_vec_34;
    wire dl_detect_out_34;
    wire dep_chan_vld_33_34;
    wire [55:0] dep_chan_data_33_34;
    wire token_33_34;
    wire dep_chan_vld_35_34;
    wire [55:0] dep_chan_data_35_34;
    wire token_35_34;
    wire [2:0] proc_35_data_FIFO_blk;
    wire [2:0] proc_35_data_PIPO_blk;
    wire [2:0] proc_35_start_FIFO_blk;
    wire [2:0] proc_35_TLF_FIFO_blk;
    wire [2:0] proc_35_input_sync_blk;
    wire [2:0] proc_35_output_sync_blk;
    wire [2:0] proc_dep_vld_vec_35;
    reg [2:0] proc_dep_vld_vec_35_reg;
    wire [2:0] in_chan_dep_vld_vec_35;
    wire [167:0] in_chan_dep_data_vec_35;
    wire [2:0] token_in_vec_35;
    wire [2:0] out_chan_dep_vld_vec_35;
    wire [55:0] out_chan_dep_data_35;
    wire [2:0] token_out_vec_35;
    wire dl_detect_out_35;
    wire dep_chan_vld_34_35;
    wire [55:0] dep_chan_data_34_35;
    wire token_34_35;
    wire dep_chan_vld_36_35;
    wire [55:0] dep_chan_data_36_35;
    wire token_36_35;
    wire dep_chan_vld_37_35;
    wire [55:0] dep_chan_data_37_35;
    wire token_37_35;
    wire [1:0] proc_36_data_FIFO_blk;
    wire [1:0] proc_36_data_PIPO_blk;
    wire [1:0] proc_36_start_FIFO_blk;
    wire [1:0] proc_36_TLF_FIFO_blk;
    wire [1:0] proc_36_input_sync_blk;
    wire [1:0] proc_36_output_sync_blk;
    wire [1:0] proc_dep_vld_vec_36;
    reg [1:0] proc_dep_vld_vec_36_reg;
    wire [1:0] in_chan_dep_vld_vec_36;
    wire [111:0] in_chan_dep_data_vec_36;
    wire [1:0] token_in_vec_36;
    wire [1:0] out_chan_dep_vld_vec_36;
    wire [55:0] out_chan_dep_data_36;
    wire [1:0] token_out_vec_36;
    wire dl_detect_out_36;
    wire dep_chan_vld_35_36;
    wire [55:0] dep_chan_data_35_36;
    wire token_35_36;
    wire dep_chan_vld_37_36;
    wire [55:0] dep_chan_data_37_36;
    wire token_37_36;
    wire [1:0] proc_37_data_FIFO_blk;
    wire [1:0] proc_37_data_PIPO_blk;
    wire [1:0] proc_37_start_FIFO_blk;
    wire [1:0] proc_37_TLF_FIFO_blk;
    wire [1:0] proc_37_input_sync_blk;
    wire [1:0] proc_37_output_sync_blk;
    wire [1:0] proc_dep_vld_vec_37;
    reg [1:0] proc_dep_vld_vec_37_reg;
    wire [1:0] in_chan_dep_vld_vec_37;
    wire [111:0] in_chan_dep_data_vec_37;
    wire [1:0] token_in_vec_37;
    wire [1:0] out_chan_dep_vld_vec_37;
    wire [55:0] out_chan_dep_data_37;
    wire [1:0] token_out_vec_37;
    wire dl_detect_out_37;
    wire dep_chan_vld_35_37;
    wire [55:0] dep_chan_data_35_37;
    wire token_35_37;
    wire dep_chan_vld_36_37;
    wire [55:0] dep_chan_data_36_37;
    wire token_36_37;
    wire [7:0] proc_38_data_FIFO_blk;
    wire [7:0] proc_38_data_PIPO_blk;
    wire [7:0] proc_38_start_FIFO_blk;
    wire [7:0] proc_38_TLF_FIFO_blk;
    wire [7:0] proc_38_input_sync_blk;
    wire [7:0] proc_38_output_sync_blk;
    wire [7:0] proc_dep_vld_vec_38;
    reg [7:0] proc_dep_vld_vec_38_reg;
    wire [7:0] in_chan_dep_vld_vec_38;
    wire [447:0] in_chan_dep_data_vec_38;
    wire [7:0] token_in_vec_38;
    wire [7:0] out_chan_dep_vld_vec_38;
    wire [55:0] out_chan_dep_data_38;
    wire [7:0] token_out_vec_38;
    wire dl_detect_out_38;
    wire dep_chan_vld_0_38;
    wire [55:0] dep_chan_data_0_38;
    wire token_0_38;
    wire dep_chan_vld_15_38;
    wire [55:0] dep_chan_data_15_38;
    wire token_15_38;
    wire dep_chan_vld_21_38;
    wire [55:0] dep_chan_data_21_38;
    wire token_21_38;
    wire dep_chan_vld_22_38;
    wire [55:0] dep_chan_data_22_38;
    wire token_22_38;
    wire dep_chan_vld_30_38;
    wire [55:0] dep_chan_data_30_38;
    wire token_30_38;
    wire dep_chan_vld_46_38;
    wire [55:0] dep_chan_data_46_38;
    wire token_46_38;
    wire dep_chan_vld_48_38;
    wire [55:0] dep_chan_data_48_38;
    wire token_48_38;
    wire dep_chan_vld_55_38;
    wire [55:0] dep_chan_data_55_38;
    wire token_55_38;
    wire [2:0] proc_39_data_FIFO_blk;
    wire [2:0] proc_39_data_PIPO_blk;
    wire [2:0] proc_39_start_FIFO_blk;
    wire [2:0] proc_39_TLF_FIFO_blk;
    wire [2:0] proc_39_input_sync_blk;
    wire [2:0] proc_39_output_sync_blk;
    wire [2:0] proc_dep_vld_vec_39;
    reg [2:0] proc_dep_vld_vec_39_reg;
    wire [2:0] in_chan_dep_vld_vec_39;
    wire [167:0] in_chan_dep_data_vec_39;
    wire [2:0] token_in_vec_39;
    wire [2:0] out_chan_dep_vld_vec_39;
    wire [55:0] out_chan_dep_data_39;
    wire [2:0] token_out_vec_39;
    wire dl_detect_out_39;
    wire dep_chan_vld_15_39;
    wire [55:0] dep_chan_data_15_39;
    wire token_15_39;
    wire dep_chan_vld_21_39;
    wire [55:0] dep_chan_data_21_39;
    wire token_21_39;
    wire dep_chan_vld_40_39;
    wire [55:0] dep_chan_data_40_39;
    wire token_40_39;
    wire [2:0] proc_40_data_FIFO_blk;
    wire [2:0] proc_40_data_PIPO_blk;
    wire [2:0] proc_40_start_FIFO_blk;
    wire [2:0] proc_40_TLF_FIFO_blk;
    wire [2:0] proc_40_input_sync_blk;
    wire [2:0] proc_40_output_sync_blk;
    wire [2:0] proc_dep_vld_vec_40;
    reg [2:0] proc_dep_vld_vec_40_reg;
    wire [2:0] in_chan_dep_vld_vec_40;
    wire [167:0] in_chan_dep_data_vec_40;
    wire [2:0] token_in_vec_40;
    wire [2:0] out_chan_dep_vld_vec_40;
    wire [55:0] out_chan_dep_data_40;
    wire [2:0] token_out_vec_40;
    wire dl_detect_out_40;
    wire dep_chan_vld_39_40;
    wire [55:0] dep_chan_data_39_40;
    wire token_39_40;
    wire dep_chan_vld_46_40;
    wire [55:0] dep_chan_data_46_40;
    wire token_46_40;
    wire dep_chan_vld_48_40;
    wire [55:0] dep_chan_data_48_40;
    wire token_48_40;
    wire [0:0] proc_41_data_FIFO_blk;
    wire [0:0] proc_41_data_PIPO_blk;
    wire [0:0] proc_41_start_FIFO_blk;
    wire [0:0] proc_41_TLF_FIFO_blk;
    wire [0:0] proc_41_input_sync_blk;
    wire [0:0] proc_41_output_sync_blk;
    wire [0:0] proc_dep_vld_vec_41;
    reg [0:0] proc_dep_vld_vec_41_reg;
    wire [0:0] in_chan_dep_vld_vec_41;
    wire [55:0] in_chan_dep_data_vec_41;
    wire [0:0] token_in_vec_41;
    wire [0:0] out_chan_dep_vld_vec_41;
    wire [55:0] out_chan_dep_data_41;
    wire [0:0] token_out_vec_41;
    wire dl_detect_out_41;
    wire dep_chan_vld_42_41;
    wire [55:0] dep_chan_data_42_41;
    wire token_42_41;
    wire [1:0] proc_42_data_FIFO_blk;
    wire [1:0] proc_42_data_PIPO_blk;
    wire [1:0] proc_42_start_FIFO_blk;
    wire [1:0] proc_42_TLF_FIFO_blk;
    wire [1:0] proc_42_input_sync_blk;
    wire [1:0] proc_42_output_sync_blk;
    wire [1:0] proc_dep_vld_vec_42;
    reg [1:0] proc_dep_vld_vec_42_reg;
    wire [1:0] in_chan_dep_vld_vec_42;
    wire [111:0] in_chan_dep_data_vec_42;
    wire [1:0] token_in_vec_42;
    wire [1:0] out_chan_dep_vld_vec_42;
    wire [55:0] out_chan_dep_data_42;
    wire [1:0] token_out_vec_42;
    wire dl_detect_out_42;
    wire dep_chan_vld_41_42;
    wire [55:0] dep_chan_data_41_42;
    wire token_41_42;
    wire dep_chan_vld_43_42;
    wire [55:0] dep_chan_data_43_42;
    wire token_43_42;
    wire [2:0] proc_43_data_FIFO_blk;
    wire [2:0] proc_43_data_PIPO_blk;
    wire [2:0] proc_43_start_FIFO_blk;
    wire [2:0] proc_43_TLF_FIFO_blk;
    wire [2:0] proc_43_input_sync_blk;
    wire [2:0] proc_43_output_sync_blk;
    wire [2:0] proc_dep_vld_vec_43;
    reg [2:0] proc_dep_vld_vec_43_reg;
    wire [2:0] in_chan_dep_vld_vec_43;
    wire [167:0] in_chan_dep_data_vec_43;
    wire [2:0] token_in_vec_43;
    wire [2:0] out_chan_dep_vld_vec_43;
    wire [55:0] out_chan_dep_data_43;
    wire [2:0] token_out_vec_43;
    wire dl_detect_out_43;
    wire dep_chan_vld_42_43;
    wire [55:0] dep_chan_data_42_43;
    wire token_42_43;
    wire dep_chan_vld_44_43;
    wire [55:0] dep_chan_data_44_43;
    wire token_44_43;
    wire dep_chan_vld_45_43;
    wire [55:0] dep_chan_data_45_43;
    wire token_45_43;
    wire [1:0] proc_44_data_FIFO_blk;
    wire [1:0] proc_44_data_PIPO_blk;
    wire [1:0] proc_44_start_FIFO_blk;
    wire [1:0] proc_44_TLF_FIFO_blk;
    wire [1:0] proc_44_input_sync_blk;
    wire [1:0] proc_44_output_sync_blk;
    wire [1:0] proc_dep_vld_vec_44;
    reg [1:0] proc_dep_vld_vec_44_reg;
    wire [1:0] in_chan_dep_vld_vec_44;
    wire [111:0] in_chan_dep_data_vec_44;
    wire [1:0] token_in_vec_44;
    wire [1:0] out_chan_dep_vld_vec_44;
    wire [55:0] out_chan_dep_data_44;
    wire [1:0] token_out_vec_44;
    wire dl_detect_out_44;
    wire dep_chan_vld_43_44;
    wire [55:0] dep_chan_data_43_44;
    wire token_43_44;
    wire dep_chan_vld_45_44;
    wire [55:0] dep_chan_data_45_44;
    wire token_45_44;
    wire [1:0] proc_45_data_FIFO_blk;
    wire [1:0] proc_45_data_PIPO_blk;
    wire [1:0] proc_45_start_FIFO_blk;
    wire [1:0] proc_45_TLF_FIFO_blk;
    wire [1:0] proc_45_input_sync_blk;
    wire [1:0] proc_45_output_sync_blk;
    wire [1:0] proc_dep_vld_vec_45;
    reg [1:0] proc_dep_vld_vec_45_reg;
    wire [1:0] in_chan_dep_vld_vec_45;
    wire [111:0] in_chan_dep_data_vec_45;
    wire [1:0] token_in_vec_45;
    wire [1:0] out_chan_dep_vld_vec_45;
    wire [55:0] out_chan_dep_data_45;
    wire [1:0] token_out_vec_45;
    wire dl_detect_out_45;
    wire dep_chan_vld_43_45;
    wire [55:0] dep_chan_data_43_45;
    wire token_43_45;
    wire dep_chan_vld_44_45;
    wire [55:0] dep_chan_data_44_45;
    wire token_44_45;
    wire [5:0] proc_46_data_FIFO_blk;
    wire [5:0] proc_46_data_PIPO_blk;
    wire [5:0] proc_46_start_FIFO_blk;
    wire [5:0] proc_46_TLF_FIFO_blk;
    wire [5:0] proc_46_input_sync_blk;
    wire [5:0] proc_46_output_sync_blk;
    wire [5:0] proc_dep_vld_vec_46;
    reg [5:0] proc_dep_vld_vec_46_reg;
    wire [5:0] in_chan_dep_vld_vec_46;
    wire [335:0] in_chan_dep_data_vec_46;
    wire [5:0] token_in_vec_46;
    wire [5:0] out_chan_dep_vld_vec_46;
    wire [55:0] out_chan_dep_data_46;
    wire [5:0] token_out_vec_46;
    wire dl_detect_out_46;
    wire dep_chan_vld_15_46;
    wire [55:0] dep_chan_data_15_46;
    wire token_15_46;
    wire dep_chan_vld_19_46;
    wire [55:0] dep_chan_data_19_46;
    wire token_19_46;
    wire dep_chan_vld_38_46;
    wire [55:0] dep_chan_data_38_46;
    wire token_38_46;
    wire dep_chan_vld_40_46;
    wire [55:0] dep_chan_data_40_46;
    wire token_40_46;
    wire dep_chan_vld_49_46;
    wire [55:0] dep_chan_data_49_46;
    wire token_49_46;
    wire dep_chan_vld_50_46;
    wire [55:0] dep_chan_data_50_46;
    wire token_50_46;
    wire [2:0] proc_47_data_FIFO_blk;
    wire [2:0] proc_47_data_PIPO_blk;
    wire [2:0] proc_47_start_FIFO_blk;
    wire [2:0] proc_47_TLF_FIFO_blk;
    wire [2:0] proc_47_input_sync_blk;
    wire [2:0] proc_47_output_sync_blk;
    wire [2:0] proc_dep_vld_vec_47;
    reg [2:0] proc_dep_vld_vec_47_reg;
    wire [2:0] in_chan_dep_vld_vec_47;
    wire [167:0] in_chan_dep_data_vec_47;
    wire [2:0] token_in_vec_47;
    wire [2:0] out_chan_dep_vld_vec_47;
    wire [55:0] out_chan_dep_data_47;
    wire [2:0] token_out_vec_47;
    wire dl_detect_out_47;
    wire dep_chan_vld_15_47;
    wire [55:0] dep_chan_data_15_47;
    wire token_15_47;
    wire dep_chan_vld_19_47;
    wire [55:0] dep_chan_data_19_47;
    wire token_19_47;
    wire dep_chan_vld_48_47;
    wire [55:0] dep_chan_data_48_47;
    wire token_48_47;
    wire [4:0] proc_48_data_FIFO_blk;
    wire [4:0] proc_48_data_PIPO_blk;
    wire [4:0] proc_48_start_FIFO_blk;
    wire [4:0] proc_48_TLF_FIFO_blk;
    wire [4:0] proc_48_input_sync_blk;
    wire [4:0] proc_48_output_sync_blk;
    wire [4:0] proc_dep_vld_vec_48;
    reg [4:0] proc_dep_vld_vec_48_reg;
    wire [4:0] in_chan_dep_vld_vec_48;
    wire [279:0] in_chan_dep_data_vec_48;
    wire [4:0] token_in_vec_48;
    wire [4:0] out_chan_dep_vld_vec_48;
    wire [55:0] out_chan_dep_data_48;
    wire [4:0] token_out_vec_48;
    wire dl_detect_out_48;
    wire dep_chan_vld_38_48;
    wire [55:0] dep_chan_data_38_48;
    wire token_38_48;
    wire dep_chan_vld_40_48;
    wire [55:0] dep_chan_data_40_48;
    wire token_40_48;
    wire dep_chan_vld_47_48;
    wire [55:0] dep_chan_data_47_48;
    wire token_47_48;
    wire dep_chan_vld_49_48;
    wire [55:0] dep_chan_data_49_48;
    wire token_49_48;
    wire dep_chan_vld_50_48;
    wire [55:0] dep_chan_data_50_48;
    wire token_50_48;
    wire [5:0] proc_49_data_FIFO_blk;
    wire [5:0] proc_49_data_PIPO_blk;
    wire [5:0] proc_49_start_FIFO_blk;
    wire [5:0] proc_49_TLF_FIFO_blk;
    wire [5:0] proc_49_input_sync_blk;
    wire [5:0] proc_49_output_sync_blk;
    wire [5:0] proc_dep_vld_vec_49;
    reg [5:0] proc_dep_vld_vec_49_reg;
    wire [5:0] in_chan_dep_vld_vec_49;
    wire [335:0] in_chan_dep_data_vec_49;
    wire [5:0] token_in_vec_49;
    wire [5:0] out_chan_dep_vld_vec_49;
    wire [55:0] out_chan_dep_data_49;
    wire [5:0] token_out_vec_49;
    wire dl_detect_out_49;
    wire dep_chan_vld_30_49;
    wire [55:0] dep_chan_data_30_49;
    wire token_30_49;
    wire dep_chan_vld_32_49;
    wire [55:0] dep_chan_data_32_49;
    wire token_32_49;
    wire dep_chan_vld_46_49;
    wire [55:0] dep_chan_data_46_49;
    wire token_46_49;
    wire dep_chan_vld_48_49;
    wire [55:0] dep_chan_data_48_49;
    wire token_48_49;
    wire dep_chan_vld_52_49;
    wire [55:0] dep_chan_data_52_49;
    wire token_52_49;
    wire dep_chan_vld_53_49;
    wire [55:0] dep_chan_data_53_49;
    wire token_53_49;
    wire [2:0] proc_50_data_FIFO_blk;
    wire [2:0] proc_50_data_PIPO_blk;
    wire [2:0] proc_50_start_FIFO_blk;
    wire [2:0] proc_50_TLF_FIFO_blk;
    wire [2:0] proc_50_input_sync_blk;
    wire [2:0] proc_50_output_sync_blk;
    wire [2:0] proc_dep_vld_vec_50;
    reg [2:0] proc_dep_vld_vec_50_reg;
    wire [2:0] in_chan_dep_vld_vec_50;
    wire [167:0] in_chan_dep_data_vec_50;
    wire [2:0] token_in_vec_50;
    wire [2:0] out_chan_dep_vld_vec_50;
    wire [55:0] out_chan_dep_data_50;
    wire [2:0] token_out_vec_50;
    wire dl_detect_out_50;
    wire dep_chan_vld_46_50;
    wire [55:0] dep_chan_data_46_50;
    wire token_46_50;
    wire dep_chan_vld_48_50;
    wire [55:0] dep_chan_data_48_50;
    wire token_48_50;
    wire dep_chan_vld_51_50;
    wire [55:0] dep_chan_data_51_50;
    wire token_51_50;
    wire [4:0] proc_51_data_FIFO_blk;
    wire [4:0] proc_51_data_PIPO_blk;
    wire [4:0] proc_51_start_FIFO_blk;
    wire [4:0] proc_51_TLF_FIFO_blk;
    wire [4:0] proc_51_input_sync_blk;
    wire [4:0] proc_51_output_sync_blk;
    wire [4:0] proc_dep_vld_vec_51;
    reg [4:0] proc_dep_vld_vec_51_reg;
    wire [4:0] in_chan_dep_vld_vec_51;
    wire [279:0] in_chan_dep_data_vec_51;
    wire [4:0] token_in_vec_51;
    wire [4:0] out_chan_dep_vld_vec_51;
    wire [55:0] out_chan_dep_data_51;
    wire [4:0] token_out_vec_51;
    wire dl_detect_out_51;
    wire dep_chan_vld_30_51;
    wire [55:0] dep_chan_data_30_51;
    wire token_30_51;
    wire dep_chan_vld_32_51;
    wire [55:0] dep_chan_data_32_51;
    wire token_32_51;
    wire dep_chan_vld_50_51;
    wire [55:0] dep_chan_data_50_51;
    wire token_50_51;
    wire dep_chan_vld_52_51;
    wire [55:0] dep_chan_data_52_51;
    wire token_52_51;
    wire dep_chan_vld_53_51;
    wire [55:0] dep_chan_data_53_51;
    wire token_53_51;
    wire [4:0] proc_52_data_FIFO_blk;
    wire [4:0] proc_52_data_PIPO_blk;
    wire [4:0] proc_52_start_FIFO_blk;
    wire [4:0] proc_52_TLF_FIFO_blk;
    wire [4:0] proc_52_input_sync_blk;
    wire [4:0] proc_52_output_sync_blk;
    wire [4:0] proc_dep_vld_vec_52;
    reg [4:0] proc_dep_vld_vec_52_reg;
    wire [4:0] in_chan_dep_vld_vec_52;
    wire [279:0] in_chan_dep_data_vec_52;
    wire [4:0] token_in_vec_52;
    wire [4:0] out_chan_dep_vld_vec_52;
    wire [55:0] out_chan_dep_data_52;
    wire [4:0] token_out_vec_52;
    wire dl_detect_out_52;
    wire dep_chan_vld_22_52;
    wire [55:0] dep_chan_data_22_52;
    wire token_22_52;
    wire dep_chan_vld_24_52;
    wire [55:0] dep_chan_data_24_52;
    wire token_24_52;
    wire dep_chan_vld_49_52;
    wire [55:0] dep_chan_data_49_52;
    wire token_49_52;
    wire dep_chan_vld_51_52;
    wire [55:0] dep_chan_data_51_52;
    wire token_51_52;
    wire dep_chan_vld_55_52;
    wire [55:0] dep_chan_data_55_52;
    wire token_55_52;
    wire [2:0] proc_53_data_FIFO_blk;
    wire [2:0] proc_53_data_PIPO_blk;
    wire [2:0] proc_53_start_FIFO_blk;
    wire [2:0] proc_53_TLF_FIFO_blk;
    wire [2:0] proc_53_input_sync_blk;
    wire [2:0] proc_53_output_sync_blk;
    wire [2:0] proc_dep_vld_vec_53;
    reg [2:0] proc_dep_vld_vec_53_reg;
    wire [2:0] in_chan_dep_vld_vec_53;
    wire [167:0] in_chan_dep_data_vec_53;
    wire [2:0] token_in_vec_53;
    wire [2:0] out_chan_dep_vld_vec_53;
    wire [55:0] out_chan_dep_data_53;
    wire [2:0] token_out_vec_53;
    wire dl_detect_out_53;
    wire dep_chan_vld_49_53;
    wire [55:0] dep_chan_data_49_53;
    wire token_49_53;
    wire dep_chan_vld_51_53;
    wire [55:0] dep_chan_data_51_53;
    wire token_51_53;
    wire dep_chan_vld_54_53;
    wire [55:0] dep_chan_data_54_53;
    wire token_54_53;
    wire [3:0] proc_54_data_FIFO_blk;
    wire [3:0] proc_54_data_PIPO_blk;
    wire [3:0] proc_54_start_FIFO_blk;
    wire [3:0] proc_54_TLF_FIFO_blk;
    wire [3:0] proc_54_input_sync_blk;
    wire [3:0] proc_54_output_sync_blk;
    wire [3:0] proc_dep_vld_vec_54;
    reg [3:0] proc_dep_vld_vec_54_reg;
    wire [3:0] in_chan_dep_vld_vec_54;
    wire [223:0] in_chan_dep_data_vec_54;
    wire [3:0] token_in_vec_54;
    wire [3:0] out_chan_dep_vld_vec_54;
    wire [55:0] out_chan_dep_data_54;
    wire [3:0] token_out_vec_54;
    wire dl_detect_out_54;
    wire dep_chan_vld_22_54;
    wire [55:0] dep_chan_data_22_54;
    wire token_22_54;
    wire dep_chan_vld_24_54;
    wire [55:0] dep_chan_data_24_54;
    wire token_24_54;
    wire dep_chan_vld_53_54;
    wire [55:0] dep_chan_data_53_54;
    wire token_53_54;
    wire dep_chan_vld_55_54;
    wire [55:0] dep_chan_data_55_54;
    wire token_55_54;
    wire [4:0] proc_55_data_FIFO_blk;
    wire [4:0] proc_55_data_PIPO_blk;
    wire [4:0] proc_55_start_FIFO_blk;
    wire [4:0] proc_55_TLF_FIFO_blk;
    wire [4:0] proc_55_input_sync_blk;
    wire [4:0] proc_55_output_sync_blk;
    wire [4:0] proc_dep_vld_vec_55;
    reg [4:0] proc_dep_vld_vec_55_reg;
    wire [4:0] in_chan_dep_vld_vec_55;
    wire [279:0] in_chan_dep_data_vec_55;
    wire [4:0] token_in_vec_55;
    wire [4:0] out_chan_dep_vld_vec_55;
    wire [55:0] out_chan_dep_data_55;
    wire [4:0] token_out_vec_55;
    wire dl_detect_out_55;
    wire dep_chan_vld_22_55;
    wire [55:0] dep_chan_data_22_55;
    wire token_22_55;
    wire dep_chan_vld_30_55;
    wire [55:0] dep_chan_data_30_55;
    wire token_30_55;
    wire dep_chan_vld_38_55;
    wire [55:0] dep_chan_data_38_55;
    wire token_38_55;
    wire dep_chan_vld_52_55;
    wire [55:0] dep_chan_data_52_55;
    wire token_52_55;
    wire dep_chan_vld_54_55;
    wire [55:0] dep_chan_data_54_55;
    wire token_54_55;
    wire [55:0] dl_in_vec;
    wire dl_detect_out;
    wire token_clear;
    reg [55:0] origin;

    reg ap_done_reg_0;// for module grp_shared_dataflow_fu_225.phase_band_1280_800_U0
    always @ (negedge dl_reset or posedge dl_clock) begin
        if (~dl_reset) begin
            ap_done_reg_0 <= 'b0;
        end
        else begin
            ap_done_reg_0 <= grp_shared_dataflow_fu_225.phase_band_1280_800_U0.ap_done & ~grp_shared_dataflow_fu_225.phase_band_1280_800_U0.ap_continue;
        end
    end

    reg ap_done_reg_1;// for module grp_shared_dataflow_fu_225.phase_band_640_400_U0
    always @ (negedge dl_reset or posedge dl_clock) begin
        if (~dl_reset) begin
            ap_done_reg_1 <= 'b0;
        end
        else begin
            ap_done_reg_1 <= grp_shared_dataflow_fu_225.phase_band_640_400_U0.ap_done & ~grp_shared_dataflow_fu_225.phase_band_640_400_U0.ap_continue;
        end
    end

    reg ap_done_reg_2;// for module grp_shared_dataflow_fu_225.phase_band_320_200_U0
    always @ (negedge dl_reset or posedge dl_clock) begin
        if (~dl_reset) begin
            ap_done_reg_2 <= 'b0;
        end
        else begin
            ap_done_reg_2 <= grp_shared_dataflow_fu_225.phase_band_320_200_U0.ap_done & ~grp_shared_dataflow_fu_225.phase_band_320_200_U0.ap_continue;
        end
    end

    reg ap_done_reg_3;// for module grp_shared_dataflow_fu_225.write_image_U0
    always @ (negedge dl_reset or posedge dl_clock) begin
        if (~dl_reset) begin
            ap_done_reg_3 <= 'b0;
        end
        else begin
            ap_done_reg_3 <= grp_shared_dataflow_fu_225.write_image_U0.ap_done & ~grp_shared_dataflow_fu_225.write_image_U0.ap_continue;
        end
    end

    reg ap_done_reg_4;// for module grp_shared_dataflow_fu_225.pyramid_1280_800_U0.fork_float_256000_U0
    always @ (negedge dl_reset or posedge dl_clock) begin
        if (~dl_reset) begin
            ap_done_reg_4 <= 'b0;
        end
        else begin
            ap_done_reg_4 <= grp_shared_dataflow_fu_225.pyramid_1280_800_U0.fork_float_256000_U0.ap_done & ~grp_shared_dataflow_fu_225.pyramid_1280_800_U0.fork_float_256000_U0.ap_continue;
        end
    end

    reg ap_done_reg_5;// for module grp_shared_dataflow_fu_225.pyramid_1280_800_U0.combine_1024000_false_U0
    always @ (negedge dl_reset or posedge dl_clock) begin
        if (~dl_reset) begin
            ap_done_reg_5 <= 'b0;
        end
        else begin
            ap_done_reg_5 <= grp_shared_dataflow_fu_225.pyramid_1280_800_U0.combine_1024000_false_U0.ap_done & ~grp_shared_dataflow_fu_225.pyramid_1280_800_U0.combine_1024000_false_U0.ap_continue;
        end
    end

    reg ap_done_reg_6;// for module grp_shared_dataflow_fu_225.pyramid_640_400_U0.fork_float_64000_U0
    always @ (negedge dl_reset or posedge dl_clock) begin
        if (~dl_reset) begin
            ap_done_reg_6 <= 'b0;
        end
        else begin
            ap_done_reg_6 <= grp_shared_dataflow_fu_225.pyramid_640_400_U0.fork_float_64000_U0.ap_done & ~grp_shared_dataflow_fu_225.pyramid_640_400_U0.fork_float_64000_U0.ap_continue;
        end
    end

    reg ap_done_reg_7;// for module grp_shared_dataflow_fu_225.pyramid_640_400_U0.combine_256000_false_U0
    always @ (negedge dl_reset or posedge dl_clock) begin
        if (~dl_reset) begin
            ap_done_reg_7 <= 'b0;
        end
        else begin
            ap_done_reg_7 <= grp_shared_dataflow_fu_225.pyramid_640_400_U0.combine_256000_false_U0.ap_done & ~grp_shared_dataflow_fu_225.pyramid_640_400_U0.combine_256000_false_U0.ap_continue;
        end
    end

    reg ap_done_reg_8;// for module grp_shared_dataflow_fu_225.pyramid_320_200_U0.fork_float_16000_U0
    always @ (negedge dl_reset or posedge dl_clock) begin
        if (~dl_reset) begin
            ap_done_reg_8 <= 'b0;
        end
        else begin
            ap_done_reg_8 <= grp_shared_dataflow_fu_225.pyramid_320_200_U0.fork_float_16000_U0.ap_done & ~grp_shared_dataflow_fu_225.pyramid_320_200_U0.fork_float_16000_U0.ap_continue;
        end
    end

    reg ap_done_reg_9;// for module grp_shared_dataflow_fu_225.pyramid_320_200_U0.combine_64000_false_U0
    always @ (negedge dl_reset or posedge dl_clock) begin
        if (~dl_reset) begin
            ap_done_reg_9 <= 'b0;
        end
        else begin
            ap_done_reg_9 <= grp_shared_dataflow_fu_225.pyramid_320_200_U0.combine_64000_false_U0.ap_done & ~grp_shared_dataflow_fu_225.pyramid_320_200_U0.combine_64000_false_U0.ap_continue;
        end
    end

    reg ap_done_reg_10;// for module grp_shared_dataflow_fu_225.phase_band_1280_800_U0.phase_core_shared_U0.grp_phase_dataflow_fu_130.compute_phase8_U0
    always @ (negedge dl_reset or posedge dl_clock) begin
        if (~dl_reset) begin
            ap_done_reg_10 <= 'b0;
        end
        else begin
            ap_done_reg_10 <= grp_shared_dataflow_fu_225.phase_band_1280_800_U0.phase_core_shared_U0.grp_phase_dataflow_fu_130.compute_phase8_U0.ap_done & ~grp_shared_dataflow_fu_225.phase_band_1280_800_U0.phase_core_shared_U0.grp_phase_dataflow_fu_130.compute_phase8_U0.ap_continue;
        end
    end

    reg ap_done_reg_11;// for module grp_shared_dataflow_fu_225.phase_band_1280_800_U0.phase_core_shared_U0.grp_phase_dataflow_fu_130.write_words_U0
    always @ (negedge dl_reset or posedge dl_clock) begin
        if (~dl_reset) begin
            ap_done_reg_11 <= 'b0;
        end
        else begin
            ap_done_reg_11 <= grp_shared_dataflow_fu_225.phase_band_1280_800_U0.phase_core_shared_U0.grp_phase_dataflow_fu_130.write_words_U0.ap_done & ~grp_shared_dataflow_fu_225.phase_band_1280_800_U0.phase_core_shared_U0.grp_phase_dataflow_fu_130.write_words_U0.ap_continue;
        end
    end

    reg ap_done_reg_12;// for module grp_shared_dataflow_fu_225.phase_band_640_400_U0.phase_core_shared_1_U0.grp_phase_dataflow_6_fu_130.compute_phase11_U0
    always @ (negedge dl_reset or posedge dl_clock) begin
        if (~dl_reset) begin
            ap_done_reg_12 <= 'b0;
        end
        else begin
            ap_done_reg_12 <= grp_shared_dataflow_fu_225.phase_band_640_400_U0.phase_core_shared_1_U0.grp_phase_dataflow_6_fu_130.compute_phase11_U0.ap_done & ~grp_shared_dataflow_fu_225.phase_band_640_400_U0.phase_core_shared_1_U0.grp_phase_dataflow_6_fu_130.compute_phase11_U0.ap_continue;
        end
    end

    reg ap_done_reg_13;// for module grp_shared_dataflow_fu_225.phase_band_640_400_U0.phase_core_shared_1_U0.grp_phase_dataflow_6_fu_130.write_words_9_U0
    always @ (negedge dl_reset or posedge dl_clock) begin
        if (~dl_reset) begin
            ap_done_reg_13 <= 'b0;
        end
        else begin
            ap_done_reg_13 <= grp_shared_dataflow_fu_225.phase_band_640_400_U0.phase_core_shared_1_U0.grp_phase_dataflow_6_fu_130.write_words_9_U0.ap_done & ~grp_shared_dataflow_fu_225.phase_band_640_400_U0.phase_core_shared_1_U0.grp_phase_dataflow_6_fu_130.write_words_9_U0.ap_continue;
        end
    end

    reg ap_done_reg_14;// for module grp_shared_dataflow_fu_225.phase_band_320_200_U0.phase_core_shared_2_U0.grp_phase_dataflow_7_fu_130.compute_phase14_U0
    always @ (negedge dl_reset or posedge dl_clock) begin
        if (~dl_reset) begin
            ap_done_reg_14 <= 'b0;
        end
        else begin
            ap_done_reg_14 <= grp_shared_dataflow_fu_225.phase_band_320_200_U0.phase_core_shared_2_U0.grp_phase_dataflow_7_fu_130.compute_phase14_U0.ap_done & ~grp_shared_dataflow_fu_225.phase_band_320_200_U0.phase_core_shared_2_U0.grp_phase_dataflow_7_fu_130.compute_phase14_U0.ap_continue;
        end
    end

    reg ap_done_reg_15;// for module grp_shared_dataflow_fu_225.phase_band_320_200_U0.phase_core_shared_2_U0.grp_phase_dataflow_7_fu_130.write_words_11_U0
    always @ (negedge dl_reset or posedge dl_clock) begin
        if (~dl_reset) begin
            ap_done_reg_15 <= 'b0;
        end
        else begin
            ap_done_reg_15 <= grp_shared_dataflow_fu_225.phase_band_320_200_U0.phase_core_shared_2_U0.grp_phase_dataflow_7_fu_130.write_words_11_U0.ap_done & ~grp_shared_dataflow_fu_225.phase_band_320_200_U0.phase_core_shared_2_U0.grp_phase_dataflow_7_fu_130.write_words_11_U0.ap_continue;
        end
    end

reg [15:0] trans_in_cnt_0;// for process grp_shared_dataflow_fu_225.read_image_U0
always @(negedge dl_reset or posedge dl_clock) begin
    if (~dl_reset) begin
         trans_in_cnt_0 <= 16'h0;
    end
    else if (grp_shared_dataflow_fu_225.read_image_U0.start_write == 1'b1) begin
        trans_in_cnt_0 <= trans_in_cnt_0 + 16'h1;
    end
    else begin
        trans_in_cnt_0 <= trans_in_cnt_0;
    end
end

reg [15:0] trans_out_cnt_0;// for process grp_shared_dataflow_fu_225.read_image_U0
always @(negedge dl_reset or posedge dl_clock) begin
    if (~dl_reset) begin
         trans_out_cnt_0 <= 16'h0;
    end
    else if (grp_shared_dataflow_fu_225.read_image_U0.ap_done == 1'b1 && grp_shared_dataflow_fu_225.read_image_U0.ap_continue == 1'b1) begin
        trans_out_cnt_0 <= trans_out_cnt_0 + 16'h1;
    end
    else begin
        trans_out_cnt_0 <= trans_out_cnt_0;
    end
end

reg [15:0] trans_in_cnt_1;// for process grp_shared_dataflow_fu_225.pyramid_1280_800_U0.stencil_1280_800_false_U0
always @(negedge dl_reset or posedge dl_clock) begin
    if (~dl_reset) begin
         trans_in_cnt_1 <= 16'h0;
    end
    else if (grp_shared_dataflow_fu_225.pyramid_1280_800_U0.stencil_1280_800_false_U0.start_write == 1'b1) begin
        trans_in_cnt_1 <= trans_in_cnt_1 + 16'h1;
    end
    else begin
        trans_in_cnt_1 <= trans_in_cnt_1;
    end
end

reg [15:0] trans_out_cnt_1;// for process grp_shared_dataflow_fu_225.pyramid_1280_800_U0.stencil_1280_800_false_U0
always @(negedge dl_reset or posedge dl_clock) begin
    if (~dl_reset) begin
         trans_out_cnt_1 <= 16'h0;
    end
    else if (grp_shared_dataflow_fu_225.pyramid_1280_800_U0.stencil_1280_800_false_U0.ap_done == 1'b1 && grp_shared_dataflow_fu_225.pyramid_1280_800_U0.stencil_1280_800_false_U0.ap_continue == 1'b1) begin
        trans_out_cnt_1 <= trans_out_cnt_1 + 16'h1;
    end
    else begin
        trans_out_cnt_1 <= trans_out_cnt_1;
    end
end

reg [15:0] trans_in_cnt_2;// for process grp_shared_dataflow_fu_225.pyramid_1280_800_U0.blur_fork_1024000_U0
always @(negedge dl_reset or posedge dl_clock) begin
    if (~dl_reset) begin
         trans_in_cnt_2 <= 16'h0;
    end
    else if (grp_shared_dataflow_fu_225.pyramid_1280_800_U0.blur_fork_1024000_U0.start_write == 1'b1) begin
        trans_in_cnt_2 <= trans_in_cnt_2 + 16'h1;
    end
    else begin
        trans_in_cnt_2 <= trans_in_cnt_2;
    end
end

reg [15:0] trans_out_cnt_2;// for process grp_shared_dataflow_fu_225.pyramid_1280_800_U0.blur_fork_1024000_U0
always @(negedge dl_reset or posedge dl_clock) begin
    if (~dl_reset) begin
         trans_out_cnt_2 <= 16'h0;
    end
    else if (grp_shared_dataflow_fu_225.pyramid_1280_800_U0.blur_fork_1024000_U0.ap_done == 1'b1 && grp_shared_dataflow_fu_225.pyramid_1280_800_U0.blur_fork_1024000_U0.ap_continue == 1'b1) begin
        trans_out_cnt_2 <= trans_out_cnt_2 + 16'h1;
    end
    else begin
        trans_out_cnt_2 <= trans_out_cnt_2;
    end
end

reg [15:0] trans_in_cnt_3;// for process grp_shared_dataflow_fu_225.pyramid_1280_800_U0.downsample_1280_800_U0
always @(negedge dl_reset or posedge dl_clock) begin
    if (~dl_reset) begin
         trans_in_cnt_3 <= 16'h0;
    end
    else if (grp_shared_dataflow_fu_225.pyramid_1280_800_U0.downsample_1280_800_U0.start_write == 1'b1) begin
        trans_in_cnt_3 <= trans_in_cnt_3 + 16'h1;
    end
    else begin
        trans_in_cnt_3 <= trans_in_cnt_3;
    end
end

reg [15:0] trans_out_cnt_3;// for process grp_shared_dataflow_fu_225.pyramid_1280_800_U0.downsample_1280_800_U0
always @(negedge dl_reset or posedge dl_clock) begin
    if (~dl_reset) begin
         trans_out_cnt_3 <= 16'h0;
    end
    else if (grp_shared_dataflow_fu_225.pyramid_1280_800_U0.downsample_1280_800_U0.ap_done == 1'b1 && grp_shared_dataflow_fu_225.pyramid_1280_800_U0.downsample_1280_800_U0.ap_continue == 1'b1) begin
        trans_out_cnt_3 <= trans_out_cnt_3 + 16'h1;
    end
    else begin
        trans_out_cnt_3 <= trans_out_cnt_3;
    end
end

reg [15:0] trans_in_cnt_4;// for process grp_shared_dataflow_fu_225.pyramid_1280_800_U0.fork_float_256000_U0
always @(negedge dl_reset or posedge dl_clock) begin
    if (~dl_reset) begin
         trans_in_cnt_4 <= 16'h0;
    end
    else if (grp_shared_dataflow_fu_225.pyramid_1280_800_U0.fork_float_256000_U0.start_write == 1'b1) begin
        trans_in_cnt_4 <= trans_in_cnt_4 + 16'h1;
    end
    else begin
        trans_in_cnt_4 <= trans_in_cnt_4;
    end
end

reg [15:0] trans_out_cnt_4;// for process grp_shared_dataflow_fu_225.pyramid_1280_800_U0.fork_float_256000_U0
always @(negedge dl_reset or posedge dl_clock) begin
    if (~dl_reset) begin
         trans_out_cnt_4 <= 16'h0;
    end
    else if (grp_shared_dataflow_fu_225.pyramid_1280_800_U0.fork_float_256000_U0.ap_done == 1'b1 && grp_shared_dataflow_fu_225.pyramid_1280_800_U0.fork_float_256000_U0.ap_continue == 1'b1) begin
        trans_out_cnt_4 <= trans_out_cnt_4 + 16'h1;
    end
    else begin
        trans_out_cnt_4 <= trans_out_cnt_4;
    end
end

reg [15:0] trans_in_cnt_5;// for process grp_shared_dataflow_fu_225.pyramid_1280_800_U0
always @(negedge dl_reset or posedge dl_clock) begin
    if (~dl_reset) begin
         trans_in_cnt_5 <= 16'h0;
    end
    else if (grp_shared_dataflow_fu_225.pyramid_1280_800_U0.start_write == 1'b1) begin
        trans_in_cnt_5 <= trans_in_cnt_5 + 16'h1;
    end
    else begin
        trans_in_cnt_5 <= trans_in_cnt_5;
    end
end

reg [15:0] trans_out_cnt_5;// for process grp_shared_dataflow_fu_225.pyramid_1280_800_U0
always @(negedge dl_reset or posedge dl_clock) begin
    if (~dl_reset) begin
         trans_out_cnt_5 <= 16'h0;
    end
    else if (grp_shared_dataflow_fu_225.pyramid_1280_800_U0.ap_done == 1'b1 && grp_shared_dataflow_fu_225.pyramid_1280_800_U0.ap_continue == 1'b1) begin
        trans_out_cnt_5 <= trans_out_cnt_5 + 16'h1;
    end
    else begin
        trans_out_cnt_5 <= trans_out_cnt_5;
    end
end

reg [15:0] trans_in_cnt_6;// for process grp_shared_dataflow_fu_225.pyramid_640_400_U0.stencil_640_400_false_U0
always @(negedge dl_reset or posedge dl_clock) begin
    if (~dl_reset) begin
         trans_in_cnt_6 <= 16'h0;
    end
    else if (grp_shared_dataflow_fu_225.pyramid_640_400_U0.stencil_640_400_false_U0.start_write == 1'b1) begin
        trans_in_cnt_6 <= trans_in_cnt_6 + 16'h1;
    end
    else begin
        trans_in_cnt_6 <= trans_in_cnt_6;
    end
end

reg [15:0] trans_out_cnt_6;// for process grp_shared_dataflow_fu_225.pyramid_640_400_U0.stencil_640_400_false_U0
always @(negedge dl_reset or posedge dl_clock) begin
    if (~dl_reset) begin
         trans_out_cnt_6 <= 16'h0;
    end
    else if (grp_shared_dataflow_fu_225.pyramid_640_400_U0.stencil_640_400_false_U0.ap_done == 1'b1 && grp_shared_dataflow_fu_225.pyramid_640_400_U0.stencil_640_400_false_U0.ap_continue == 1'b1) begin
        trans_out_cnt_6 <= trans_out_cnt_6 + 16'h1;
    end
    else begin
        trans_out_cnt_6 <= trans_out_cnt_6;
    end
end

reg [15:0] trans_in_cnt_7;// for process grp_shared_dataflow_fu_225.pyramid_640_400_U0.blur_fork_256000_U0
always @(negedge dl_reset or posedge dl_clock) begin
    if (~dl_reset) begin
         trans_in_cnt_7 <= 16'h0;
    end
    else if (grp_shared_dataflow_fu_225.pyramid_640_400_U0.blur_fork_256000_U0.start_write == 1'b1) begin
        trans_in_cnt_7 <= trans_in_cnt_7 + 16'h1;
    end
    else begin
        trans_in_cnt_7 <= trans_in_cnt_7;
    end
end

reg [15:0] trans_out_cnt_7;// for process grp_shared_dataflow_fu_225.pyramid_640_400_U0.blur_fork_256000_U0
always @(negedge dl_reset or posedge dl_clock) begin
    if (~dl_reset) begin
         trans_out_cnt_7 <= 16'h0;
    end
    else if (grp_shared_dataflow_fu_225.pyramid_640_400_U0.blur_fork_256000_U0.ap_done == 1'b1 && grp_shared_dataflow_fu_225.pyramid_640_400_U0.blur_fork_256000_U0.ap_continue == 1'b1) begin
        trans_out_cnt_7 <= trans_out_cnt_7 + 16'h1;
    end
    else begin
        trans_out_cnt_7 <= trans_out_cnt_7;
    end
end

reg [15:0] trans_in_cnt_8;// for process grp_shared_dataflow_fu_225.pyramid_640_400_U0.downsample_640_400_U0
always @(negedge dl_reset or posedge dl_clock) begin
    if (~dl_reset) begin
         trans_in_cnt_8 <= 16'h0;
    end
    else if (grp_shared_dataflow_fu_225.pyramid_640_400_U0.downsample_640_400_U0.start_write == 1'b1) begin
        trans_in_cnt_8 <= trans_in_cnt_8 + 16'h1;
    end
    else begin
        trans_in_cnt_8 <= trans_in_cnt_8;
    end
end

reg [15:0] trans_out_cnt_8;// for process grp_shared_dataflow_fu_225.pyramid_640_400_U0.downsample_640_400_U0
always @(negedge dl_reset or posedge dl_clock) begin
    if (~dl_reset) begin
         trans_out_cnt_8 <= 16'h0;
    end
    else if (grp_shared_dataflow_fu_225.pyramid_640_400_U0.downsample_640_400_U0.ap_done == 1'b1 && grp_shared_dataflow_fu_225.pyramid_640_400_U0.downsample_640_400_U0.ap_continue == 1'b1) begin
        trans_out_cnt_8 <= trans_out_cnt_8 + 16'h1;
    end
    else begin
        trans_out_cnt_8 <= trans_out_cnt_8;
    end
end

reg [15:0] trans_in_cnt_9;// for process grp_shared_dataflow_fu_225.pyramid_640_400_U0.fork_float_64000_U0
always @(negedge dl_reset or posedge dl_clock) begin
    if (~dl_reset) begin
         trans_in_cnt_9 <= 16'h0;
    end
    else if (grp_shared_dataflow_fu_225.pyramid_640_400_U0.fork_float_64000_U0.start_write == 1'b1) begin
        trans_in_cnt_9 <= trans_in_cnt_9 + 16'h1;
    end
    else begin
        trans_in_cnt_9 <= trans_in_cnt_9;
    end
end

reg [15:0] trans_out_cnt_9;// for process grp_shared_dataflow_fu_225.pyramid_640_400_U0.fork_float_64000_U0
always @(negedge dl_reset or posedge dl_clock) begin
    if (~dl_reset) begin
         trans_out_cnt_9 <= 16'h0;
    end
    else if (grp_shared_dataflow_fu_225.pyramid_640_400_U0.fork_float_64000_U0.ap_done == 1'b1 && grp_shared_dataflow_fu_225.pyramid_640_400_U0.fork_float_64000_U0.ap_continue == 1'b1) begin
        trans_out_cnt_9 <= trans_out_cnt_9 + 16'h1;
    end
    else begin
        trans_out_cnt_9 <= trans_out_cnt_9;
    end
end

reg [15:0] trans_in_cnt_10;// for process grp_shared_dataflow_fu_225.pyramid_640_400_U0
always @(negedge dl_reset or posedge dl_clock) begin
    if (~dl_reset) begin
         trans_in_cnt_10 <= 16'h0;
    end
    else if (grp_shared_dataflow_fu_225.pyramid_640_400_U0.start_write == 1'b1) begin
        trans_in_cnt_10 <= trans_in_cnt_10 + 16'h1;
    end
    else begin
        trans_in_cnt_10 <= trans_in_cnt_10;
    end
end

reg [15:0] trans_out_cnt_10;// for process grp_shared_dataflow_fu_225.pyramid_640_400_U0
always @(negedge dl_reset or posedge dl_clock) begin
    if (~dl_reset) begin
         trans_out_cnt_10 <= 16'h0;
    end
    else if (grp_shared_dataflow_fu_225.pyramid_640_400_U0.ap_done == 1'b1 && grp_shared_dataflow_fu_225.pyramid_640_400_U0.ap_continue == 1'b1) begin
        trans_out_cnt_10 <= trans_out_cnt_10 + 16'h1;
    end
    else begin
        trans_out_cnt_10 <= trans_out_cnt_10;
    end
end

reg [15:0] trans_in_cnt_11;// for process grp_shared_dataflow_fu_225.pyramid_320_200_U0.stencil_320_200_false_U0
always @(negedge dl_reset or posedge dl_clock) begin
    if (~dl_reset) begin
         trans_in_cnt_11 <= 16'h0;
    end
    else if (grp_shared_dataflow_fu_225.pyramid_320_200_U0.stencil_320_200_false_U0.start_write == 1'b1) begin
        trans_in_cnt_11 <= trans_in_cnt_11 + 16'h1;
    end
    else begin
        trans_in_cnt_11 <= trans_in_cnt_11;
    end
end

reg [15:0] trans_out_cnt_11;// for process grp_shared_dataflow_fu_225.pyramid_320_200_U0.stencil_320_200_false_U0
always @(negedge dl_reset or posedge dl_clock) begin
    if (~dl_reset) begin
         trans_out_cnt_11 <= 16'h0;
    end
    else if (grp_shared_dataflow_fu_225.pyramid_320_200_U0.stencil_320_200_false_U0.ap_done == 1'b1 && grp_shared_dataflow_fu_225.pyramid_320_200_U0.stencil_320_200_false_U0.ap_continue == 1'b1) begin
        trans_out_cnt_11 <= trans_out_cnt_11 + 16'h1;
    end
    else begin
        trans_out_cnt_11 <= trans_out_cnt_11;
    end
end

reg [15:0] trans_in_cnt_12;// for process grp_shared_dataflow_fu_225.pyramid_320_200_U0.blur_fork_64000_U0
always @(negedge dl_reset or posedge dl_clock) begin
    if (~dl_reset) begin
         trans_in_cnt_12 <= 16'h0;
    end
    else if (grp_shared_dataflow_fu_225.pyramid_320_200_U0.blur_fork_64000_U0.start_write == 1'b1) begin
        trans_in_cnt_12 <= trans_in_cnt_12 + 16'h1;
    end
    else begin
        trans_in_cnt_12 <= trans_in_cnt_12;
    end
end

reg [15:0] trans_out_cnt_12;// for process grp_shared_dataflow_fu_225.pyramid_320_200_U0.blur_fork_64000_U0
always @(negedge dl_reset or posedge dl_clock) begin
    if (~dl_reset) begin
         trans_out_cnt_12 <= 16'h0;
    end
    else if (grp_shared_dataflow_fu_225.pyramid_320_200_U0.blur_fork_64000_U0.ap_done == 1'b1 && grp_shared_dataflow_fu_225.pyramid_320_200_U0.blur_fork_64000_U0.ap_continue == 1'b1) begin
        trans_out_cnt_12 <= trans_out_cnt_12 + 16'h1;
    end
    else begin
        trans_out_cnt_12 <= trans_out_cnt_12;
    end
end

reg [15:0] trans_in_cnt_13;// for process grp_shared_dataflow_fu_225.pyramid_320_200_U0.downsample_320_200_U0
always @(negedge dl_reset or posedge dl_clock) begin
    if (~dl_reset) begin
         trans_in_cnt_13 <= 16'h0;
    end
    else if (grp_shared_dataflow_fu_225.pyramid_320_200_U0.downsample_320_200_U0.start_write == 1'b1) begin
        trans_in_cnt_13 <= trans_in_cnt_13 + 16'h1;
    end
    else begin
        trans_in_cnt_13 <= trans_in_cnt_13;
    end
end

reg [15:0] trans_out_cnt_13;// for process grp_shared_dataflow_fu_225.pyramid_320_200_U0.downsample_320_200_U0
always @(negedge dl_reset or posedge dl_clock) begin
    if (~dl_reset) begin
         trans_out_cnt_13 <= 16'h0;
    end
    else if (grp_shared_dataflow_fu_225.pyramid_320_200_U0.downsample_320_200_U0.ap_done == 1'b1 && grp_shared_dataflow_fu_225.pyramid_320_200_U0.downsample_320_200_U0.ap_continue == 1'b1) begin
        trans_out_cnt_13 <= trans_out_cnt_13 + 16'h1;
    end
    else begin
        trans_out_cnt_13 <= trans_out_cnt_13;
    end
end

reg [15:0] trans_in_cnt_14;// for process grp_shared_dataflow_fu_225.pyramid_320_200_U0.fork_float_16000_U0
always @(negedge dl_reset or posedge dl_clock) begin
    if (~dl_reset) begin
         trans_in_cnt_14 <= 16'h0;
    end
    else if (grp_shared_dataflow_fu_225.pyramid_320_200_U0.fork_float_16000_U0.start_write == 1'b1) begin
        trans_in_cnt_14 <= trans_in_cnt_14 + 16'h1;
    end
    else begin
        trans_in_cnt_14 <= trans_in_cnt_14;
    end
end

reg [15:0] trans_out_cnt_14;// for process grp_shared_dataflow_fu_225.pyramid_320_200_U0.fork_float_16000_U0
always @(negedge dl_reset or posedge dl_clock) begin
    if (~dl_reset) begin
         trans_out_cnt_14 <= 16'h0;
    end
    else if (grp_shared_dataflow_fu_225.pyramid_320_200_U0.fork_float_16000_U0.ap_done == 1'b1 && grp_shared_dataflow_fu_225.pyramid_320_200_U0.fork_float_16000_U0.ap_continue == 1'b1) begin
        trans_out_cnt_14 <= trans_out_cnt_14 + 16'h1;
    end
    else begin
        trans_out_cnt_14 <= trans_out_cnt_14;
    end
end

reg [15:0] trans_in_cnt_15;// for process grp_shared_dataflow_fu_225.phase_band_1280_800_U0.phase_core_shared_U0.grp_phase_dataflow_fu_130.read_words_U0
always @(negedge dl_reset or posedge dl_clock) begin
    if (~dl_reset) begin
         trans_in_cnt_15 <= 16'h0;
    end
    else if (grp_shared_dataflow_fu_225.phase_band_1280_800_U0.phase_core_shared_U0.grp_phase_dataflow_fu_130.read_words_U0.start_write == 1'b1) begin
        trans_in_cnt_15 <= trans_in_cnt_15 + 16'h1;
    end
    else begin
        trans_in_cnt_15 <= trans_in_cnt_15;
    end
end

reg [15:0] trans_out_cnt_15;// for process grp_shared_dataflow_fu_225.phase_band_1280_800_U0.phase_core_shared_U0.grp_phase_dataflow_fu_130.read_words_U0
always @(negedge dl_reset or posedge dl_clock) begin
    if (~dl_reset) begin
         trans_out_cnt_15 <= 16'h0;
    end
    else if (grp_shared_dataflow_fu_225.phase_band_1280_800_U0.phase_core_shared_U0.grp_phase_dataflow_fu_130.read_words_U0.ap_done == 1'b1 && grp_shared_dataflow_fu_225.phase_band_1280_800_U0.phase_core_shared_U0.grp_phase_dataflow_fu_130.read_words_U0.ap_continue == 1'b1) begin
        trans_out_cnt_15 <= trans_out_cnt_15 + 16'h1;
    end
    else begin
        trans_out_cnt_15 <= trans_out_cnt_15;
    end
end

reg [15:0] trans_in_cnt_16;// for process grp_shared_dataflow_fu_225.phase_band_1280_800_U0.phase_core_shared_U0.grp_phase_dataflow_fu_130.unpack_history7_U0
always @(negedge dl_reset or posedge dl_clock) begin
    if (~dl_reset) begin
         trans_in_cnt_16 <= 16'h0;
    end
    else if (grp_shared_dataflow_fu_225.phase_band_1280_800_U0.phase_core_shared_U0.grp_phase_dataflow_fu_130.unpack_history7_U0.start_write == 1'b1) begin
        trans_in_cnt_16 <= trans_in_cnt_16 + 16'h1;
    end
    else begin
        trans_in_cnt_16 <= trans_in_cnt_16;
    end
end

reg [15:0] trans_out_cnt_16;// for process grp_shared_dataflow_fu_225.phase_band_1280_800_U0.phase_core_shared_U0.grp_phase_dataflow_fu_130.unpack_history7_U0
always @(negedge dl_reset or posedge dl_clock) begin
    if (~dl_reset) begin
         trans_out_cnt_16 <= 16'h0;
    end
    else if (grp_shared_dataflow_fu_225.phase_band_1280_800_U0.phase_core_shared_U0.grp_phase_dataflow_fu_130.unpack_history7_U0.ap_done == 1'b1 && grp_shared_dataflow_fu_225.phase_band_1280_800_U0.phase_core_shared_U0.grp_phase_dataflow_fu_130.unpack_history7_U0.ap_continue == 1'b1) begin
        trans_out_cnt_16 <= trans_out_cnt_16 + 16'h1;
    end
    else begin
        trans_out_cnt_16 <= trans_out_cnt_16;
    end
end

reg [15:0] trans_in_cnt_17;// for process grp_shared_dataflow_fu_225.phase_band_1280_800_U0.phase_core_shared_U0.grp_phase_dataflow_fu_130.compute_phase8_U0
always @(negedge dl_reset or posedge dl_clock) begin
    if (~dl_reset) begin
         trans_in_cnt_17 <= 16'h0;
    end
    else if (grp_shared_dataflow_fu_225.phase_band_1280_800_U0.phase_core_shared_U0.grp_phase_dataflow_fu_130.compute_phase8_U0.start_write == 1'b1) begin
        trans_in_cnt_17 <= trans_in_cnt_17 + 16'h1;
    end
    else begin
        trans_in_cnt_17 <= trans_in_cnt_17;
    end
end

reg [15:0] trans_out_cnt_17;// for process grp_shared_dataflow_fu_225.phase_band_1280_800_U0.phase_core_shared_U0.grp_phase_dataflow_fu_130.compute_phase8_U0
always @(negedge dl_reset or posedge dl_clock) begin
    if (~dl_reset) begin
         trans_out_cnt_17 <= 16'h0;
    end
    else if (grp_shared_dataflow_fu_225.phase_band_1280_800_U0.phase_core_shared_U0.grp_phase_dataflow_fu_130.compute_phase8_U0.ap_done == 1'b1 && grp_shared_dataflow_fu_225.phase_band_1280_800_U0.phase_core_shared_U0.grp_phase_dataflow_fu_130.compute_phase8_U0.ap_continue == 1'b1) begin
        trans_out_cnt_17 <= trans_out_cnt_17 + 16'h1;
    end
    else begin
        trans_out_cnt_17 <= trans_out_cnt_17;
    end
end

reg [15:0] trans_in_cnt_18;// for process grp_shared_dataflow_fu_225.phase_band_1280_800_U0.phase_core_shared_U0.grp_phase_dataflow_fu_130.pack_history9_U0
always @(negedge dl_reset or posedge dl_clock) begin
    if (~dl_reset) begin
         trans_in_cnt_18 <= 16'h0;
    end
    else if (grp_shared_dataflow_fu_225.phase_band_1280_800_U0.phase_core_shared_U0.grp_phase_dataflow_fu_130.pack_history9_U0.start_write == 1'b1) begin
        trans_in_cnt_18 <= trans_in_cnt_18 + 16'h1;
    end
    else begin
        trans_in_cnt_18 <= trans_in_cnt_18;
    end
end

reg [15:0] trans_out_cnt_18;// for process grp_shared_dataflow_fu_225.phase_band_1280_800_U0.phase_core_shared_U0.grp_phase_dataflow_fu_130.pack_history9_U0
always @(negedge dl_reset or posedge dl_clock) begin
    if (~dl_reset) begin
         trans_out_cnt_18 <= 16'h0;
    end
    else if (grp_shared_dataflow_fu_225.phase_band_1280_800_U0.phase_core_shared_U0.grp_phase_dataflow_fu_130.pack_history9_U0.ap_done == 1'b1 && grp_shared_dataflow_fu_225.phase_band_1280_800_U0.phase_core_shared_U0.grp_phase_dataflow_fu_130.pack_history9_U0.ap_continue == 1'b1) begin
        trans_out_cnt_18 <= trans_out_cnt_18 + 16'h1;
    end
    else begin
        trans_out_cnt_18 <= trans_out_cnt_18;
    end
end

reg [15:0] trans_in_cnt_19;// for process grp_shared_dataflow_fu_225.phase_band_640_400_U0.phase_core_shared_1_U0.grp_phase_dataflow_6_fu_130.read_words_8_U0
always @(negedge dl_reset or posedge dl_clock) begin
    if (~dl_reset) begin
         trans_in_cnt_19 <= 16'h0;
    end
    else if (grp_shared_dataflow_fu_225.phase_band_640_400_U0.phase_core_shared_1_U0.grp_phase_dataflow_6_fu_130.read_words_8_U0.start_write == 1'b1) begin
        trans_in_cnt_19 <= trans_in_cnt_19 + 16'h1;
    end
    else begin
        trans_in_cnt_19 <= trans_in_cnt_19;
    end
end

reg [15:0] trans_out_cnt_19;// for process grp_shared_dataflow_fu_225.phase_band_640_400_U0.phase_core_shared_1_U0.grp_phase_dataflow_6_fu_130.read_words_8_U0
always @(negedge dl_reset or posedge dl_clock) begin
    if (~dl_reset) begin
         trans_out_cnt_19 <= 16'h0;
    end
    else if (grp_shared_dataflow_fu_225.phase_band_640_400_U0.phase_core_shared_1_U0.grp_phase_dataflow_6_fu_130.read_words_8_U0.ap_done == 1'b1 && grp_shared_dataflow_fu_225.phase_band_640_400_U0.phase_core_shared_1_U0.grp_phase_dataflow_6_fu_130.read_words_8_U0.ap_continue == 1'b1) begin
        trans_out_cnt_19 <= trans_out_cnt_19 + 16'h1;
    end
    else begin
        trans_out_cnt_19 <= trans_out_cnt_19;
    end
end

reg [15:0] trans_in_cnt_20;// for process grp_shared_dataflow_fu_225.phase_band_640_400_U0.phase_core_shared_1_U0.grp_phase_dataflow_6_fu_130.unpack_history10_U0
always @(negedge dl_reset or posedge dl_clock) begin
    if (~dl_reset) begin
         trans_in_cnt_20 <= 16'h0;
    end
    else if (grp_shared_dataflow_fu_225.phase_band_640_400_U0.phase_core_shared_1_U0.grp_phase_dataflow_6_fu_130.unpack_history10_U0.start_write == 1'b1) begin
        trans_in_cnt_20 <= trans_in_cnt_20 + 16'h1;
    end
    else begin
        trans_in_cnt_20 <= trans_in_cnt_20;
    end
end

reg [15:0] trans_out_cnt_20;// for process grp_shared_dataflow_fu_225.phase_band_640_400_U0.phase_core_shared_1_U0.grp_phase_dataflow_6_fu_130.unpack_history10_U0
always @(negedge dl_reset or posedge dl_clock) begin
    if (~dl_reset) begin
         trans_out_cnt_20 <= 16'h0;
    end
    else if (grp_shared_dataflow_fu_225.phase_band_640_400_U0.phase_core_shared_1_U0.grp_phase_dataflow_6_fu_130.unpack_history10_U0.ap_done == 1'b1 && grp_shared_dataflow_fu_225.phase_band_640_400_U0.phase_core_shared_1_U0.grp_phase_dataflow_6_fu_130.unpack_history10_U0.ap_continue == 1'b1) begin
        trans_out_cnt_20 <= trans_out_cnt_20 + 16'h1;
    end
    else begin
        trans_out_cnt_20 <= trans_out_cnt_20;
    end
end

reg [15:0] trans_in_cnt_21;// for process grp_shared_dataflow_fu_225.phase_band_640_400_U0.phase_core_shared_1_U0.grp_phase_dataflow_6_fu_130.compute_phase11_U0
always @(negedge dl_reset or posedge dl_clock) begin
    if (~dl_reset) begin
         trans_in_cnt_21 <= 16'h0;
    end
    else if (grp_shared_dataflow_fu_225.phase_band_640_400_U0.phase_core_shared_1_U0.grp_phase_dataflow_6_fu_130.compute_phase11_U0.start_write == 1'b1) begin
        trans_in_cnt_21 <= trans_in_cnt_21 + 16'h1;
    end
    else begin
        trans_in_cnt_21 <= trans_in_cnt_21;
    end
end

reg [15:0] trans_out_cnt_21;// for process grp_shared_dataflow_fu_225.phase_band_640_400_U0.phase_core_shared_1_U0.grp_phase_dataflow_6_fu_130.compute_phase11_U0
always @(negedge dl_reset or posedge dl_clock) begin
    if (~dl_reset) begin
         trans_out_cnt_21 <= 16'h0;
    end
    else if (grp_shared_dataflow_fu_225.phase_band_640_400_U0.phase_core_shared_1_U0.grp_phase_dataflow_6_fu_130.compute_phase11_U0.ap_done == 1'b1 && grp_shared_dataflow_fu_225.phase_band_640_400_U0.phase_core_shared_1_U0.grp_phase_dataflow_6_fu_130.compute_phase11_U0.ap_continue == 1'b1) begin
        trans_out_cnt_21 <= trans_out_cnt_21 + 16'h1;
    end
    else begin
        trans_out_cnt_21 <= trans_out_cnt_21;
    end
end

reg [15:0] trans_in_cnt_22;// for process grp_shared_dataflow_fu_225.phase_band_640_400_U0.phase_core_shared_1_U0.grp_phase_dataflow_6_fu_130.pack_history12_U0
always @(negedge dl_reset or posedge dl_clock) begin
    if (~dl_reset) begin
         trans_in_cnt_22 <= 16'h0;
    end
    else if (grp_shared_dataflow_fu_225.phase_band_640_400_U0.phase_core_shared_1_U0.grp_phase_dataflow_6_fu_130.pack_history12_U0.start_write == 1'b1) begin
        trans_in_cnt_22 <= trans_in_cnt_22 + 16'h1;
    end
    else begin
        trans_in_cnt_22 <= trans_in_cnt_22;
    end
end

reg [15:0] trans_out_cnt_22;// for process grp_shared_dataflow_fu_225.phase_band_640_400_U0.phase_core_shared_1_U0.grp_phase_dataflow_6_fu_130.pack_history12_U0
always @(negedge dl_reset or posedge dl_clock) begin
    if (~dl_reset) begin
         trans_out_cnt_22 <= 16'h0;
    end
    else if (grp_shared_dataflow_fu_225.phase_band_640_400_U0.phase_core_shared_1_U0.grp_phase_dataflow_6_fu_130.pack_history12_U0.ap_done == 1'b1 && grp_shared_dataflow_fu_225.phase_band_640_400_U0.phase_core_shared_1_U0.grp_phase_dataflow_6_fu_130.pack_history12_U0.ap_continue == 1'b1) begin
        trans_out_cnt_22 <= trans_out_cnt_22 + 16'h1;
    end
    else begin
        trans_out_cnt_22 <= trans_out_cnt_22;
    end
end

reg [15:0] trans_in_cnt_23;// for process grp_shared_dataflow_fu_225.phase_band_320_200_U0.phase_core_shared_2_U0.grp_phase_dataflow_7_fu_130.read_words_10_U0
always @(negedge dl_reset or posedge dl_clock) begin
    if (~dl_reset) begin
         trans_in_cnt_23 <= 16'h0;
    end
    else if (grp_shared_dataflow_fu_225.phase_band_320_200_U0.phase_core_shared_2_U0.grp_phase_dataflow_7_fu_130.read_words_10_U0.start_write == 1'b1) begin
        trans_in_cnt_23 <= trans_in_cnt_23 + 16'h1;
    end
    else begin
        trans_in_cnt_23 <= trans_in_cnt_23;
    end
end

reg [15:0] trans_out_cnt_23;// for process grp_shared_dataflow_fu_225.phase_band_320_200_U0.phase_core_shared_2_U0.grp_phase_dataflow_7_fu_130.read_words_10_U0
always @(negedge dl_reset or posedge dl_clock) begin
    if (~dl_reset) begin
         trans_out_cnt_23 <= 16'h0;
    end
    else if (grp_shared_dataflow_fu_225.phase_band_320_200_U0.phase_core_shared_2_U0.grp_phase_dataflow_7_fu_130.read_words_10_U0.ap_done == 1'b1 && grp_shared_dataflow_fu_225.phase_band_320_200_U0.phase_core_shared_2_U0.grp_phase_dataflow_7_fu_130.read_words_10_U0.ap_continue == 1'b1) begin
        trans_out_cnt_23 <= trans_out_cnt_23 + 16'h1;
    end
    else begin
        trans_out_cnt_23 <= trans_out_cnt_23;
    end
end

reg [15:0] trans_in_cnt_24;// for process grp_shared_dataflow_fu_225.phase_band_320_200_U0.phase_core_shared_2_U0.grp_phase_dataflow_7_fu_130.unpack_history13_U0
always @(negedge dl_reset or posedge dl_clock) begin
    if (~dl_reset) begin
         trans_in_cnt_24 <= 16'h0;
    end
    else if (grp_shared_dataflow_fu_225.phase_band_320_200_U0.phase_core_shared_2_U0.grp_phase_dataflow_7_fu_130.unpack_history13_U0.start_write == 1'b1) begin
        trans_in_cnt_24 <= trans_in_cnt_24 + 16'h1;
    end
    else begin
        trans_in_cnt_24 <= trans_in_cnt_24;
    end
end

reg [15:0] trans_out_cnt_24;// for process grp_shared_dataflow_fu_225.phase_band_320_200_U0.phase_core_shared_2_U0.grp_phase_dataflow_7_fu_130.unpack_history13_U0
always @(negedge dl_reset or posedge dl_clock) begin
    if (~dl_reset) begin
         trans_out_cnt_24 <= 16'h0;
    end
    else if (grp_shared_dataflow_fu_225.phase_band_320_200_U0.phase_core_shared_2_U0.grp_phase_dataflow_7_fu_130.unpack_history13_U0.ap_done == 1'b1 && grp_shared_dataflow_fu_225.phase_band_320_200_U0.phase_core_shared_2_U0.grp_phase_dataflow_7_fu_130.unpack_history13_U0.ap_continue == 1'b1) begin
        trans_out_cnt_24 <= trans_out_cnt_24 + 16'h1;
    end
    else begin
        trans_out_cnt_24 <= trans_out_cnt_24;
    end
end

reg [15:0] trans_in_cnt_25;// for process grp_shared_dataflow_fu_225.phase_band_320_200_U0.phase_core_shared_2_U0.grp_phase_dataflow_7_fu_130.compute_phase14_U0
always @(negedge dl_reset or posedge dl_clock) begin
    if (~dl_reset) begin
         trans_in_cnt_25 <= 16'h0;
    end
    else if (grp_shared_dataflow_fu_225.phase_band_320_200_U0.phase_core_shared_2_U0.grp_phase_dataflow_7_fu_130.compute_phase14_U0.start_write == 1'b1) begin
        trans_in_cnt_25 <= trans_in_cnt_25 + 16'h1;
    end
    else begin
        trans_in_cnt_25 <= trans_in_cnt_25;
    end
end

reg [15:0] trans_out_cnt_25;// for process grp_shared_dataflow_fu_225.phase_band_320_200_U0.phase_core_shared_2_U0.grp_phase_dataflow_7_fu_130.compute_phase14_U0
always @(negedge dl_reset or posedge dl_clock) begin
    if (~dl_reset) begin
         trans_out_cnt_25 <= 16'h0;
    end
    else if (grp_shared_dataflow_fu_225.phase_band_320_200_U0.phase_core_shared_2_U0.grp_phase_dataflow_7_fu_130.compute_phase14_U0.ap_done == 1'b1 && grp_shared_dataflow_fu_225.phase_band_320_200_U0.phase_core_shared_2_U0.grp_phase_dataflow_7_fu_130.compute_phase14_U0.ap_continue == 1'b1) begin
        trans_out_cnt_25 <= trans_out_cnt_25 + 16'h1;
    end
    else begin
        trans_out_cnt_25 <= trans_out_cnt_25;
    end
end

reg [15:0] trans_in_cnt_26;// for process grp_shared_dataflow_fu_225.phase_band_320_200_U0.phase_core_shared_2_U0.grp_phase_dataflow_7_fu_130.pack_history15_U0
always @(negedge dl_reset or posedge dl_clock) begin
    if (~dl_reset) begin
         trans_in_cnt_26 <= 16'h0;
    end
    else if (grp_shared_dataflow_fu_225.phase_band_320_200_U0.phase_core_shared_2_U0.grp_phase_dataflow_7_fu_130.pack_history15_U0.start_write == 1'b1) begin
        trans_in_cnt_26 <= trans_in_cnt_26 + 16'h1;
    end
    else begin
        trans_in_cnt_26 <= trans_in_cnt_26;
    end
end

reg [15:0] trans_out_cnt_26;// for process grp_shared_dataflow_fu_225.phase_band_320_200_U0.phase_core_shared_2_U0.grp_phase_dataflow_7_fu_130.pack_history15_U0
always @(negedge dl_reset or posedge dl_clock) begin
    if (~dl_reset) begin
         trans_out_cnt_26 <= 16'h0;
    end
    else if (grp_shared_dataflow_fu_225.phase_band_320_200_U0.phase_core_shared_2_U0.grp_phase_dataflow_7_fu_130.pack_history15_U0.ap_done == 1'b1 && grp_shared_dataflow_fu_225.phase_band_320_200_U0.phase_core_shared_2_U0.grp_phase_dataflow_7_fu_130.pack_history15_U0.ap_continue == 1'b1) begin
        trans_out_cnt_26 <= trans_out_cnt_26 + 16'h1;
    end
    else begin
        trans_out_cnt_26 <= trans_out_cnt_26;
    end
end

reg [15:0] trans_in_cnt_27;// for process grp_shared_dataflow_fu_225.phase_band_320_200_U0
always @(negedge dl_reset or posedge dl_clock) begin
    if (~dl_reset) begin
         trans_in_cnt_27 <= 16'h0;
    end
    else if (grp_shared_dataflow_fu_225.phase_band_320_200_U0.start_write == 1'b1) begin
        trans_in_cnt_27 <= trans_in_cnt_27 + 16'h1;
    end
    else begin
        trans_in_cnt_27 <= trans_in_cnt_27;
    end
end

reg [15:0] trans_out_cnt_27;// for process grp_shared_dataflow_fu_225.phase_band_320_200_U0
always @(negedge dl_reset or posedge dl_clock) begin
    if (~dl_reset) begin
         trans_out_cnt_27 <= 16'h0;
    end
    else if (grp_shared_dataflow_fu_225.phase_band_320_200_U0.ap_done == 1'b1 && grp_shared_dataflow_fu_225.phase_band_320_200_U0.ap_continue == 1'b1) begin
        trans_out_cnt_27 <= trans_out_cnt_27 + 16'h1;
    end
    else begin
        trans_out_cnt_27 <= trans_out_cnt_27;
    end
end

reg [15:0] trans_in_cnt_28;// for process grp_shared_dataflow_fu_225.reconstruct_320_200_U0.upsample_160_100_3_U0
always @(negedge dl_reset or posedge dl_clock) begin
    if (~dl_reset) begin
         trans_in_cnt_28 <= 16'h0;
    end
    else if (grp_shared_dataflow_fu_225.reconstruct_320_200_U0.upsample_160_100_3_U0.start_write == 1'b1) begin
        trans_in_cnt_28 <= trans_in_cnt_28 + 16'h1;
    end
    else begin
        trans_in_cnt_28 <= trans_in_cnt_28;
    end
end

reg [15:0] trans_out_cnt_28;// for process grp_shared_dataflow_fu_225.reconstruct_320_200_U0.upsample_160_100_3_U0
always @(negedge dl_reset or posedge dl_clock) begin
    if (~dl_reset) begin
         trans_out_cnt_28 <= 16'h0;
    end
    else if (grp_shared_dataflow_fu_225.reconstruct_320_200_U0.upsample_160_100_3_U0.ap_done == 1'b1 && grp_shared_dataflow_fu_225.reconstruct_320_200_U0.upsample_160_100_3_U0.ap_continue == 1'b1) begin
        trans_out_cnt_28 <= trans_out_cnt_28 + 16'h1;
    end
    else begin
        trans_out_cnt_28 <= trans_out_cnt_28;
    end
end

reg [15:0] trans_in_cnt_29;// for process grp_shared_dataflow_fu_225.phase_band_640_400_U0
always @(negedge dl_reset or posedge dl_clock) begin
    if (~dl_reset) begin
         trans_in_cnt_29 <= 16'h0;
    end
    else if (grp_shared_dataflow_fu_225.phase_band_640_400_U0.start_write == 1'b1) begin
        trans_in_cnt_29 <= trans_in_cnt_29 + 16'h1;
    end
    else begin
        trans_in_cnt_29 <= trans_in_cnt_29;
    end
end

reg [15:0] trans_out_cnt_29;// for process grp_shared_dataflow_fu_225.phase_band_640_400_U0
always @(negedge dl_reset or posedge dl_clock) begin
    if (~dl_reset) begin
         trans_out_cnt_29 <= 16'h0;
    end
    else if (grp_shared_dataflow_fu_225.phase_band_640_400_U0.ap_done == 1'b1 && grp_shared_dataflow_fu_225.phase_band_640_400_U0.ap_continue == 1'b1) begin
        trans_out_cnt_29 <= trans_out_cnt_29 + 16'h1;
    end
    else begin
        trans_out_cnt_29 <= trans_out_cnt_29;
    end
end

reg [15:0] trans_in_cnt_30;// for process grp_shared_dataflow_fu_225.reconstruct_640_400_U0.upsample_320_200_4_U0
always @(negedge dl_reset or posedge dl_clock) begin
    if (~dl_reset) begin
         trans_in_cnt_30 <= 16'h0;
    end
    else if (grp_shared_dataflow_fu_225.reconstruct_640_400_U0.upsample_320_200_4_U0.start_write == 1'b1) begin
        trans_in_cnt_30 <= trans_in_cnt_30 + 16'h1;
    end
    else begin
        trans_in_cnt_30 <= trans_in_cnt_30;
    end
end

reg [15:0] trans_out_cnt_30;// for process grp_shared_dataflow_fu_225.reconstruct_640_400_U0.upsample_320_200_4_U0
always @(negedge dl_reset or posedge dl_clock) begin
    if (~dl_reset) begin
         trans_out_cnt_30 <= 16'h0;
    end
    else if (grp_shared_dataflow_fu_225.reconstruct_640_400_U0.upsample_320_200_4_U0.ap_done == 1'b1 && grp_shared_dataflow_fu_225.reconstruct_640_400_U0.upsample_320_200_4_U0.ap_continue == 1'b1) begin
        trans_out_cnt_30 <= trans_out_cnt_30 + 16'h1;
    end
    else begin
        trans_out_cnt_30 <= trans_out_cnt_30;
    end
end

reg [15:0] trans_in_cnt_31;// for process grp_shared_dataflow_fu_225.phase_band_1280_800_U0
always @(negedge dl_reset or posedge dl_clock) begin
    if (~dl_reset) begin
         trans_in_cnt_31 <= 16'h0;
    end
    else if (grp_shared_dataflow_fu_225.phase_band_1280_800_U0.start_write == 1'b1) begin
        trans_in_cnt_31 <= trans_in_cnt_31 + 16'h1;
    end
    else begin
        trans_in_cnt_31 <= trans_in_cnt_31;
    end
end

reg [15:0] trans_out_cnt_31;// for process grp_shared_dataflow_fu_225.phase_band_1280_800_U0
always @(negedge dl_reset or posedge dl_clock) begin
    if (~dl_reset) begin
         trans_out_cnt_31 <= 16'h0;
    end
    else if (grp_shared_dataflow_fu_225.phase_band_1280_800_U0.ap_done == 1'b1 && grp_shared_dataflow_fu_225.phase_band_1280_800_U0.ap_continue == 1'b1) begin
        trans_out_cnt_31 <= trans_out_cnt_31 + 16'h1;
    end
    else begin
        trans_out_cnt_31 <= trans_out_cnt_31;
    end
end

reg [15:0] trans_in_cnt_32;// for process grp_shared_dataflow_fu_225.reconstruct_1280_800_U0.upsample_640_400_5_U0
always @(negedge dl_reset or posedge dl_clock) begin
    if (~dl_reset) begin
         trans_in_cnt_32 <= 16'h0;
    end
    else if (grp_shared_dataflow_fu_225.reconstruct_1280_800_U0.upsample_640_400_5_U0.start_write == 1'b1) begin
        trans_in_cnt_32 <= trans_in_cnt_32 + 16'h1;
    end
    else begin
        trans_in_cnt_32 <= trans_in_cnt_32;
    end
end

reg [15:0] trans_out_cnt_32;// for process grp_shared_dataflow_fu_225.reconstruct_1280_800_U0.upsample_640_400_5_U0
always @(negedge dl_reset or posedge dl_clock) begin
    if (~dl_reset) begin
         trans_out_cnt_32 <= 16'h0;
    end
    else if (grp_shared_dataflow_fu_225.reconstruct_1280_800_U0.upsample_640_400_5_U0.ap_done == 1'b1 && grp_shared_dataflow_fu_225.reconstruct_1280_800_U0.upsample_640_400_5_U0.ap_continue == 1'b1) begin
        trans_out_cnt_32 <= trans_out_cnt_32 + 16'h1;
    end
    else begin
        trans_out_cnt_32 <= trans_out_cnt_32;
    end
end

reg [15:0] trans_in_cnt_33;// for process grp_shared_dataflow_fu_225.reconstruct_1280_800_U0
always @(negedge dl_reset or posedge dl_clock) begin
    if (~dl_reset) begin
         trans_in_cnt_33 <= 16'h0;
    end
    else if (grp_shared_dataflow_fu_225.reconstruct_1280_800_U0.start_write == 1'b1) begin
        trans_in_cnt_33 <= trans_in_cnt_33 + 16'h1;
    end
    else begin
        trans_in_cnt_33 <= trans_in_cnt_33;
    end
end

reg [15:0] trans_out_cnt_33;// for process grp_shared_dataflow_fu_225.reconstruct_1280_800_U0
always @(negedge dl_reset or posedge dl_clock) begin
    if (~dl_reset) begin
         trans_out_cnt_33 <= 16'h0;
    end
    else if (grp_shared_dataflow_fu_225.reconstruct_1280_800_U0.ap_done == 1'b1 && grp_shared_dataflow_fu_225.reconstruct_1280_800_U0.ap_continue == 1'b1) begin
        trans_out_cnt_33 <= trans_out_cnt_33 + 16'h1;
    end
    else begin
        trans_out_cnt_33 <= trans_out_cnt_33;
    end
end

    // Process: grp_shared_dataflow_fu_225.read_image_U0
    motion60_shared_hls_deadlock_detect_unit #(56, 0, 5, 5) motion60_shared_hls_deadlock_detect_unit_0 (
        .reset(dl_reset),
        .clock(dl_clock),
        .proc_dep_vld_vec(proc_dep_vld_vec_0),
        .in_chan_dep_vld_vec(in_chan_dep_vld_vec_0),
        .in_chan_dep_data_vec(in_chan_dep_data_vec_0),
        .token_in_vec(token_in_vec_0),
        .dl_detect_in(dl_detect_out),
        .origin(origin[0]),
        .token_clear(token_clear),
        .out_chan_dep_vld_vec(out_chan_dep_vld_vec_0),
        .out_chan_dep_data(out_chan_dep_data_0),
        .token_out_vec(token_out_vec_0),
        .dl_detect_out(dl_in_vec[0]));

    assign proc_0_data_FIFO_blk[0] = 1'b0 | (~grp_shared_dataflow_fu_225.read_image_U0.grp_read_image_Pipeline_VITIS_LOOP_155_1_fu_63.g0_blk_n);
    assign proc_0_data_PIPO_blk[0] = 1'b0;
    assign proc_0_start_FIFO_blk[0] = 1'b0 | (~grp_shared_dataflow_fu_225.start_for_pyramid_1280_800_U0_U.if_full_n & grp_shared_dataflow_fu_225.read_image_U0.ap_start & ~grp_shared_dataflow_fu_225.read_image_U0.real_start & (trans_in_cnt_0 == trans_out_cnt_0) & ~grp_shared_dataflow_fu_225.start_for_pyramid_1280_800_U0_U.if_read);
    assign proc_0_TLF_FIFO_blk[0] = 1'b0;
    assign proc_0_input_sync_blk[0] = 1'b0;
    assign proc_0_output_sync_blk[0] = 1'b0;
    assign proc_dep_vld_vec_0[0] = dl_detect_out ? proc_dep_vld_vec_0_reg[0] : (proc_0_data_FIFO_blk[0] | proc_0_data_PIPO_blk[0] | proc_0_start_FIFO_blk[0] | proc_0_TLF_FIFO_blk[0] | proc_0_input_sync_blk[0] | proc_0_output_sync_blk[0]);
    assign proc_0_data_FIFO_blk[1] = 1'b0 | (~grp_shared_dataflow_fu_225.read_image_U0.grp_read_image_Pipeline_VITIS_LOOP_155_1_fu_63.g0_blk_n);
    assign proc_0_data_PIPO_blk[1] = 1'b0;
    assign proc_0_start_FIFO_blk[1] = 1'b0;
    assign proc_0_TLF_FIFO_blk[1] = 1'b0;
    assign proc_0_input_sync_blk[1] = 1'b0;
    assign proc_0_output_sync_blk[1] = 1'b0;
    assign proc_dep_vld_vec_0[1] = dl_detect_out ? proc_dep_vld_vec_0_reg[1] : (proc_0_data_FIFO_blk[1] | proc_0_data_PIPO_blk[1] | proc_0_start_FIFO_blk[1] | proc_0_TLF_FIFO_blk[1] | proc_0_input_sync_blk[1] | proc_0_output_sync_blk[1]);
    assign proc_0_data_FIFO_blk[2] = 1'b0;
    assign proc_0_data_PIPO_blk[2] = 1'b0;
    assign proc_0_start_FIFO_blk[2] = 1'b0;
    assign proc_0_TLF_FIFO_blk[2] = 1'b0;
    assign proc_0_input_sync_blk[2] = 1'b0 | (grp_shared_dataflow_fu_225.ap_sync_read_image_U0_ap_ready & grp_shared_dataflow_fu_225.read_image_U0.ap_idle & ~grp_shared_dataflow_fu_225.ap_sync_phase_band_1280_800_U0_ap_ready);
    assign proc_0_output_sync_blk[2] = 1'b0;
    assign proc_dep_vld_vec_0[2] = dl_detect_out ? proc_dep_vld_vec_0_reg[2] : (proc_0_data_FIFO_blk[2] | proc_0_data_PIPO_blk[2] | proc_0_start_FIFO_blk[2] | proc_0_TLF_FIFO_blk[2] | proc_0_input_sync_blk[2] | proc_0_output_sync_blk[2]);
    assign proc_0_data_FIFO_blk[3] = 1'b0;
    assign proc_0_data_PIPO_blk[3] = 1'b0;
    assign proc_0_start_FIFO_blk[3] = 1'b0;
    assign proc_0_TLF_FIFO_blk[3] = 1'b0;
    assign proc_0_input_sync_blk[3] = 1'b0 | (grp_shared_dataflow_fu_225.ap_sync_read_image_U0_ap_ready & grp_shared_dataflow_fu_225.read_image_U0.ap_idle & ~grp_shared_dataflow_fu_225.ap_sync_phase_band_640_400_U0_ap_ready);
    assign proc_0_output_sync_blk[3] = 1'b0;
    assign proc_dep_vld_vec_0[3] = dl_detect_out ? proc_dep_vld_vec_0_reg[3] : (proc_0_data_FIFO_blk[3] | proc_0_data_PIPO_blk[3] | proc_0_start_FIFO_blk[3] | proc_0_TLF_FIFO_blk[3] | proc_0_input_sync_blk[3] | proc_0_output_sync_blk[3]);
    assign proc_0_data_FIFO_blk[4] = 1'b0;
    assign proc_0_data_PIPO_blk[4] = 1'b0;
    assign proc_0_start_FIFO_blk[4] = 1'b0;
    assign proc_0_TLF_FIFO_blk[4] = 1'b0;
    assign proc_0_input_sync_blk[4] = 1'b0 | (grp_shared_dataflow_fu_225.ap_sync_read_image_U0_ap_ready & grp_shared_dataflow_fu_225.read_image_U0.ap_idle & ~grp_shared_dataflow_fu_225.ap_sync_phase_band_320_200_U0_ap_ready);
    assign proc_0_output_sync_blk[4] = 1'b0;
    assign proc_dep_vld_vec_0[4] = dl_detect_out ? proc_dep_vld_vec_0_reg[4] : (proc_0_data_FIFO_blk[4] | proc_0_data_PIPO_blk[4] | proc_0_start_FIFO_blk[4] | proc_0_TLF_FIFO_blk[4] | proc_0_input_sync_blk[4] | proc_0_output_sync_blk[4]);
    always @ (negedge dl_reset or posedge dl_clock) begin
        if (~dl_reset) begin
            proc_dep_vld_vec_0_reg <= 'b0;
        end
        else begin
            proc_dep_vld_vec_0_reg <= proc_dep_vld_vec_0;
        end
    end
    assign in_chan_dep_vld_vec_0[0] = dep_chan_vld_1_0;
    assign in_chan_dep_data_vec_0[55 : 0] = dep_chan_data_1_0;
    assign token_in_vec_0[0] = token_1_0;
    assign in_chan_dep_vld_vec_0[1] = dep_chan_vld_2_0;
    assign in_chan_dep_data_vec_0[111 : 56] = dep_chan_data_2_0;
    assign token_in_vec_0[1] = token_2_0;
    assign in_chan_dep_vld_vec_0[2] = dep_chan_vld_22_0;
    assign in_chan_dep_data_vec_0[167 : 112] = dep_chan_data_22_0;
    assign token_in_vec_0[2] = token_22_0;
    assign in_chan_dep_vld_vec_0[3] = dep_chan_vld_30_0;
    assign in_chan_dep_data_vec_0[223 : 168] = dep_chan_data_30_0;
    assign token_in_vec_0[3] = token_30_0;
    assign in_chan_dep_vld_vec_0[4] = dep_chan_vld_38_0;
    assign in_chan_dep_data_vec_0[279 : 224] = dep_chan_data_38_0;
    assign token_in_vec_0[4] = token_38_0;
    assign dep_chan_vld_0_1 = out_chan_dep_vld_vec_0[0];
    assign dep_chan_data_0_1 = out_chan_dep_data_0;
    assign token_0_1 = token_out_vec_0[0];
    assign dep_chan_vld_0_2 = out_chan_dep_vld_vec_0[1];
    assign dep_chan_data_0_2 = out_chan_dep_data_0;
    assign token_0_2 = token_out_vec_0[1];
    assign dep_chan_vld_0_22 = out_chan_dep_vld_vec_0[2];
    assign dep_chan_data_0_22 = out_chan_dep_data_0;
    assign token_0_22 = token_out_vec_0[2];
    assign dep_chan_vld_0_30 = out_chan_dep_vld_vec_0[3];
    assign dep_chan_data_0_30 = out_chan_dep_data_0;
    assign token_0_30 = token_out_vec_0[3];
    assign dep_chan_vld_0_38 = out_chan_dep_vld_vec_0[4];
    assign dep_chan_data_0_38 = out_chan_dep_data_0;
    assign token_0_38 = token_out_vec_0[4];

    // Process: grp_shared_dataflow_fu_225.pyramid_1280_800_U0
    motion60_shared_hls_deadlock_detect_unit #(56, 1, 5, 5) motion60_shared_hls_deadlock_detect_unit_1 (
        .reset(dl_reset),
        .clock(dl_clock),
        .proc_dep_vld_vec(proc_dep_vld_vec_1),
        .in_chan_dep_vld_vec(in_chan_dep_vld_vec_1),
        .in_chan_dep_data_vec(in_chan_dep_data_vec_1),
        .token_in_vec(token_in_vec_1),
        .dl_detect_in(dl_detect_out),
        .origin(origin[1]),
        .token_clear(token_clear),
        .out_chan_dep_vld_vec(out_chan_dep_vld_vec_1),
        .out_chan_dep_data(out_chan_dep_data_1),
        .token_out_vec(token_out_vec_1),
        .dl_detect_out(dl_in_vec[1]));

    assign proc_1_data_FIFO_blk[0] = 1'b0 | (~grp_shared_dataflow_fu_225.pyramid_1280_800_U0.stencil_1280_800_false_U0.grp_stencil_1280_800_false_Pipeline_horizontal_fu_118.g0_blk_n) | (~grp_shared_dataflow_fu_225.pyramid_1280_800_U0.stencil_1280_800_false_U0.g0_blk_n);
    assign proc_1_data_PIPO_blk[0] = 1'b0;
    assign proc_1_start_FIFO_blk[0] = 1'b0 | (~grp_shared_dataflow_fu_225.start_for_pyramid_1280_800_U0_U.if_empty_n & grp_shared_dataflow_fu_225.pyramid_1280_800_U0.ap_idle & ~grp_shared_dataflow_fu_225.start_for_pyramid_1280_800_U0_U.if_write);
    assign proc_1_TLF_FIFO_blk[0] = 1'b0;
    assign proc_1_input_sync_blk[0] = 1'b0;
    assign proc_1_output_sync_blk[0] = 1'b0;
    assign proc_dep_vld_vec_1[0] = dl_detect_out ? proc_dep_vld_vec_1_reg[0] : (proc_1_data_FIFO_blk[0] | proc_1_data_PIPO_blk[0] | proc_1_start_FIFO_blk[0] | proc_1_TLF_FIFO_blk[0] | proc_1_input_sync_blk[0] | proc_1_output_sync_blk[0]);
    assign proc_1_data_FIFO_blk[1] = 1'b0 | (~grp_shared_dataflow_fu_225.pyramid_1280_800_U0.combine_1024000_false_U0.band0_blk_n);
    assign proc_1_data_PIPO_blk[1] = 1'b0;
    assign proc_1_start_FIFO_blk[1] = 1'b0;
    assign proc_1_TLF_FIFO_blk[1] = 1'b0;
    assign proc_1_input_sync_blk[1] = 1'b0;
    assign proc_1_output_sync_blk[1] = 1'b0;
    assign proc_dep_vld_vec_1[1] = dl_detect_out ? proc_dep_vld_vec_1_reg[1] : (proc_1_data_FIFO_blk[1] | proc_1_data_PIPO_blk[1] | proc_1_start_FIFO_blk[1] | proc_1_TLF_FIFO_blk[1] | proc_1_input_sync_blk[1] | proc_1_output_sync_blk[1]);
    assign proc_1_data_FIFO_blk[2] = 1'b0 | (~grp_shared_dataflow_fu_225.pyramid_1280_800_U0.combine_1024000_false_U0.band0_blk_n);
    assign proc_1_data_PIPO_blk[2] = 1'b0;
    assign proc_1_start_FIFO_blk[2] = 1'b0;
    assign proc_1_TLF_FIFO_blk[2] = 1'b0;
    assign proc_1_input_sync_blk[2] = 1'b0;
    assign proc_1_output_sync_blk[2] = 1'b0;
    assign proc_dep_vld_vec_1[2] = dl_detect_out ? proc_dep_vld_vec_1_reg[2] : (proc_1_data_FIFO_blk[2] | proc_1_data_PIPO_blk[2] | proc_1_start_FIFO_blk[2] | proc_1_TLF_FIFO_blk[2] | proc_1_input_sync_blk[2] | proc_1_output_sync_blk[2]);
    assign proc_1_data_FIFO_blk[3] = 1'b0 | (~grp_shared_dataflow_fu_225.pyramid_1280_800_U0.fork_float_256000_U0.g1_blk_n);
    assign proc_1_data_PIPO_blk[3] = 1'b0;
    assign proc_1_start_FIFO_blk[3] = 1'b0 | (~grp_shared_dataflow_fu_225.start_for_pyramid_640_400_U0_U.if_full_n & grp_shared_dataflow_fu_225.pyramid_1280_800_U0.ap_start & ~grp_shared_dataflow_fu_225.pyramid_1280_800_U0.real_start & (trans_in_cnt_5 == trans_out_cnt_5) & ~grp_shared_dataflow_fu_225.start_for_pyramid_640_400_U0_U.if_read);
    assign proc_1_TLF_FIFO_blk[3] = 1'b0;
    assign proc_1_input_sync_blk[3] = 1'b0;
    assign proc_1_output_sync_blk[3] = 1'b0;
    assign proc_dep_vld_vec_1[3] = dl_detect_out ? proc_dep_vld_vec_1_reg[3] : (proc_1_data_FIFO_blk[3] | proc_1_data_PIPO_blk[3] | proc_1_start_FIFO_blk[3] | proc_1_TLF_FIFO_blk[3] | proc_1_input_sync_blk[3] | proc_1_output_sync_blk[3]);
    assign proc_1_data_FIFO_blk[4] = 1'b0 | (~grp_shared_dataflow_fu_225.pyramid_1280_800_U0.fork_float_256000_U0.g1_blk_n);
    assign proc_1_data_PIPO_blk[4] = 1'b0;
    assign proc_1_start_FIFO_blk[4] = 1'b0;
    assign proc_1_TLF_FIFO_blk[4] = 1'b0;
    assign proc_1_input_sync_blk[4] = 1'b0;
    assign proc_1_output_sync_blk[4] = 1'b0;
    assign proc_dep_vld_vec_1[4] = dl_detect_out ? proc_dep_vld_vec_1_reg[4] : (proc_1_data_FIFO_blk[4] | proc_1_data_PIPO_blk[4] | proc_1_start_FIFO_blk[4] | proc_1_TLF_FIFO_blk[4] | proc_1_input_sync_blk[4] | proc_1_output_sync_blk[4]);
    always @ (negedge dl_reset or posedge dl_clock) begin
        if (~dl_reset) begin
            proc_dep_vld_vec_1_reg <= 'b0;
        end
        else begin
            proc_dep_vld_vec_1_reg <= proc_dep_vld_vec_1;
        end
    end
    assign in_chan_dep_vld_vec_1[0] = dep_chan_vld_0_1;
    assign in_chan_dep_data_vec_1[55 : 0] = dep_chan_data_0_1;
    assign token_in_vec_1[0] = token_0_1;
    assign in_chan_dep_vld_vec_1[1] = dep_chan_vld_8_1;
    assign in_chan_dep_data_vec_1[111 : 56] = dep_chan_data_8_1;
    assign token_in_vec_1[1] = token_8_1;
    assign in_chan_dep_vld_vec_1[2] = dep_chan_vld_9_1;
    assign in_chan_dep_data_vec_1[167 : 112] = dep_chan_data_9_1;
    assign token_in_vec_1[2] = token_9_1;
    assign in_chan_dep_vld_vec_1[3] = dep_chan_vld_22_1;
    assign in_chan_dep_data_vec_1[223 : 168] = dep_chan_data_22_1;
    assign token_in_vec_1[3] = token_22_1;
    assign in_chan_dep_vld_vec_1[4] = dep_chan_vld_23_1;
    assign in_chan_dep_data_vec_1[279 : 224] = dep_chan_data_23_1;
    assign token_in_vec_1[4] = token_23_1;
    assign dep_chan_vld_1_0 = out_chan_dep_vld_vec_1[0];
    assign dep_chan_data_1_0 = out_chan_dep_data_1;
    assign token_1_0 = token_out_vec_1[0];
    assign dep_chan_vld_1_22 = out_chan_dep_vld_vec_1[1];
    assign dep_chan_data_1_22 = out_chan_dep_data_1;
    assign token_1_22 = token_out_vec_1[1];
    assign dep_chan_vld_1_23 = out_chan_dep_vld_vec_1[2];
    assign dep_chan_data_1_23 = out_chan_dep_data_1;
    assign token_1_23 = token_out_vec_1[2];
    assign dep_chan_vld_1_8 = out_chan_dep_vld_vec_1[3];
    assign dep_chan_data_1_8 = out_chan_dep_data_1;
    assign token_1_8 = token_out_vec_1[3];
    assign dep_chan_vld_1_9 = out_chan_dep_vld_vec_1[4];
    assign dep_chan_data_1_9 = out_chan_dep_data_1;
    assign token_1_9 = token_out_vec_1[4];

    // Process: grp_shared_dataflow_fu_225.pyramid_1280_800_U0.stencil_1280_800_false_U0
    motion60_shared_hls_deadlock_detect_unit #(56, 2, 2, 2) motion60_shared_hls_deadlock_detect_unit_2 (
        .reset(dl_reset),
        .clock(dl_clock),
        .proc_dep_vld_vec(proc_dep_vld_vec_2),
        .in_chan_dep_vld_vec(in_chan_dep_vld_vec_2),
        .in_chan_dep_data_vec(in_chan_dep_data_vec_2),
        .token_in_vec(token_in_vec_2),
        .dl_detect_in(dl_detect_out),
        .origin(origin[2]),
        .token_clear(token_clear),
        .out_chan_dep_vld_vec(out_chan_dep_vld_vec_2),
        .out_chan_dep_data(out_chan_dep_data_2),
        .token_out_vec(token_out_vec_2),
        .dl_detect_out(dl_in_vec[2]));

    assign proc_2_data_FIFO_blk[0] = 1'b0 | (~grp_shared_dataflow_fu_225.pyramid_1280_800_U0.stencil_1280_800_false_U0.g0_blk_n) | (~grp_shared_dataflow_fu_225.pyramid_1280_800_U0.stencil_1280_800_false_U0.grp_stencil_1280_800_false_Pipeline_horizontal_fu_118.g0_blk_n);
    assign proc_2_data_PIPO_blk[0] = 1'b0;
    assign proc_2_start_FIFO_blk[0] = 1'b0;
    assign proc_2_TLF_FIFO_blk[0] = 1'b0;
    assign proc_2_input_sync_blk[0] = 1'b0;
    assign proc_2_output_sync_blk[0] = 1'b0;
    assign proc_dep_vld_vec_2[0] = dl_detect_out ? proc_dep_vld_vec_2_reg[0] : (proc_2_data_FIFO_blk[0] | proc_2_data_PIPO_blk[0] | proc_2_start_FIFO_blk[0] | proc_2_TLF_FIFO_blk[0] | proc_2_input_sync_blk[0] | proc_2_output_sync_blk[0]);
    assign proc_2_data_FIFO_blk[1] = 1'b0 | (~grp_shared_dataflow_fu_225.pyramid_1280_800_U0.stencil_1280_800_false_U0.grp_stencil_1280_800_false_Pipeline_vertical_fu_133.blur_blk_n);
    assign proc_2_data_PIPO_blk[1] = 1'b0;
    assign proc_2_start_FIFO_blk[1] = 1'b0 | (~grp_shared_dataflow_fu_225.pyramid_1280_800_U0.start_for_blur_fork_1024000_U0_U.if_full_n & grp_shared_dataflow_fu_225.pyramid_1280_800_U0.stencil_1280_800_false_U0.ap_start & ~grp_shared_dataflow_fu_225.pyramid_1280_800_U0.stencil_1280_800_false_U0.real_start & (trans_in_cnt_1 == trans_out_cnt_1) & ~grp_shared_dataflow_fu_225.pyramid_1280_800_U0.start_for_blur_fork_1024000_U0_U.if_read);
    assign proc_2_TLF_FIFO_blk[1] = 1'b0;
    assign proc_2_input_sync_blk[1] = 1'b0;
    assign proc_2_output_sync_blk[1] = 1'b0;
    assign proc_dep_vld_vec_2[1] = dl_detect_out ? proc_dep_vld_vec_2_reg[1] : (proc_2_data_FIFO_blk[1] | proc_2_data_PIPO_blk[1] | proc_2_start_FIFO_blk[1] | proc_2_TLF_FIFO_blk[1] | proc_2_input_sync_blk[1] | proc_2_output_sync_blk[1]);
    always @ (negedge dl_reset or posedge dl_clock) begin
        if (~dl_reset) begin
            proc_dep_vld_vec_2_reg <= 'b0;
        end
        else begin
            proc_dep_vld_vec_2_reg <= proc_dep_vld_vec_2;
        end
    end
    assign in_chan_dep_vld_vec_2[0] = dep_chan_vld_0_2;
    assign in_chan_dep_data_vec_2[55 : 0] = dep_chan_data_0_2;
    assign token_in_vec_2[0] = token_0_2;
    assign in_chan_dep_vld_vec_2[1] = dep_chan_vld_3_2;
    assign in_chan_dep_data_vec_2[111 : 56] = dep_chan_data_3_2;
    assign token_in_vec_2[1] = token_3_2;
    assign dep_chan_vld_2_0 = out_chan_dep_vld_vec_2[0];
    assign dep_chan_data_2_0 = out_chan_dep_data_2;
    assign token_2_0 = token_out_vec_2[0];
    assign dep_chan_vld_2_3 = out_chan_dep_vld_vec_2[1];
    assign dep_chan_data_2_3 = out_chan_dep_data_2;
    assign token_2_3 = token_out_vec_2[1];

    // Process: grp_shared_dataflow_fu_225.pyramid_1280_800_U0.blur_fork_1024000_U0
    motion60_shared_hls_deadlock_detect_unit #(56, 3, 3, 3) motion60_shared_hls_deadlock_detect_unit_3 (
        .reset(dl_reset),
        .clock(dl_clock),
        .proc_dep_vld_vec(proc_dep_vld_vec_3),
        .in_chan_dep_vld_vec(in_chan_dep_vld_vec_3),
        .in_chan_dep_data_vec(in_chan_dep_data_vec_3),
        .token_in_vec(token_in_vec_3),
        .dl_detect_in(dl_detect_out),
        .origin(origin[3]),
        .token_clear(token_clear),
        .out_chan_dep_vld_vec(out_chan_dep_vld_vec_3),
        .out_chan_dep_data(out_chan_dep_data_3),
        .token_out_vec(token_out_vec_3),
        .dl_detect_out(dl_in_vec[3]));

    assign proc_3_data_FIFO_blk[0] = 1'b0 | (~grp_shared_dataflow_fu_225.pyramid_1280_800_U0.blur_fork_1024000_U0.blur_blk_n);
    assign proc_3_data_PIPO_blk[0] = 1'b0;
    assign proc_3_start_FIFO_blk[0] = 1'b0 | (~grp_shared_dataflow_fu_225.pyramid_1280_800_U0.start_for_blur_fork_1024000_U0_U.if_empty_n & grp_shared_dataflow_fu_225.pyramid_1280_800_U0.blur_fork_1024000_U0.ap_idle & ~grp_shared_dataflow_fu_225.pyramid_1280_800_U0.start_for_blur_fork_1024000_U0_U.if_write);
    assign proc_3_TLF_FIFO_blk[0] = 1'b0;
    assign proc_3_input_sync_blk[0] = 1'b0;
    assign proc_3_output_sync_blk[0] = 1'b0;
    assign proc_dep_vld_vec_3[0] = dl_detect_out ? proc_dep_vld_vec_3_reg[0] : (proc_3_data_FIFO_blk[0] | proc_3_data_PIPO_blk[0] | proc_3_start_FIFO_blk[0] | proc_3_TLF_FIFO_blk[0] | proc_3_input_sync_blk[0] | proc_3_output_sync_blk[0]);
    assign proc_3_data_FIFO_blk[1] = 1'b0 | (~grp_shared_dataflow_fu_225.pyramid_1280_800_U0.blur_fork_1024000_U0.full_blk_n);
    assign proc_3_data_PIPO_blk[1] = 1'b0;
    assign proc_3_start_FIFO_blk[1] = 1'b0 | (~grp_shared_dataflow_fu_225.pyramid_1280_800_U0.start_for_combine_1024000_false_U0_U.if_full_n & grp_shared_dataflow_fu_225.pyramid_1280_800_U0.blur_fork_1024000_U0.ap_start & ~grp_shared_dataflow_fu_225.pyramid_1280_800_U0.blur_fork_1024000_U0.real_start & (trans_in_cnt_2 == trans_out_cnt_2) & ~grp_shared_dataflow_fu_225.pyramid_1280_800_U0.start_for_combine_1024000_false_U0_U.if_read);
    assign proc_3_TLF_FIFO_blk[1] = 1'b0;
    assign proc_3_input_sync_blk[1] = 1'b0;
    assign proc_3_output_sync_blk[1] = 1'b0;
    assign proc_dep_vld_vec_3[1] = dl_detect_out ? proc_dep_vld_vec_3_reg[1] : (proc_3_data_FIFO_blk[1] | proc_3_data_PIPO_blk[1] | proc_3_start_FIFO_blk[1] | proc_3_TLF_FIFO_blk[1] | proc_3_input_sync_blk[1] | proc_3_output_sync_blk[1]);
    assign proc_3_data_FIFO_blk[2] = 1'b0 | (~grp_shared_dataflow_fu_225.pyramid_1280_800_U0.blur_fork_1024000_U0.dsinput_blk_n);
    assign proc_3_data_PIPO_blk[2] = 1'b0;
    assign proc_3_start_FIFO_blk[2] = 1'b0 | (~grp_shared_dataflow_fu_225.pyramid_1280_800_U0.start_for_downsample_1280_800_U0_U.if_full_n & grp_shared_dataflow_fu_225.pyramid_1280_800_U0.blur_fork_1024000_U0.ap_start & ~grp_shared_dataflow_fu_225.pyramid_1280_800_U0.blur_fork_1024000_U0.real_start & (trans_in_cnt_2 == trans_out_cnt_2) & ~grp_shared_dataflow_fu_225.pyramid_1280_800_U0.start_for_downsample_1280_800_U0_U.if_read);
    assign proc_3_TLF_FIFO_blk[2] = 1'b0;
    assign proc_3_input_sync_blk[2] = 1'b0;
    assign proc_3_output_sync_blk[2] = 1'b0;
    assign proc_dep_vld_vec_3[2] = dl_detect_out ? proc_dep_vld_vec_3_reg[2] : (proc_3_data_FIFO_blk[2] | proc_3_data_PIPO_blk[2] | proc_3_start_FIFO_blk[2] | proc_3_TLF_FIFO_blk[2] | proc_3_input_sync_blk[2] | proc_3_output_sync_blk[2]);
    always @ (negedge dl_reset or posedge dl_clock) begin
        if (~dl_reset) begin
            proc_dep_vld_vec_3_reg <= 'b0;
        end
        else begin
            proc_dep_vld_vec_3_reg <= proc_dep_vld_vec_3;
        end
    end
    assign in_chan_dep_vld_vec_3[0] = dep_chan_vld_2_3;
    assign in_chan_dep_data_vec_3[55 : 0] = dep_chan_data_2_3;
    assign token_in_vec_3[0] = token_2_3;
    assign in_chan_dep_vld_vec_3[1] = dep_chan_vld_4_3;
    assign in_chan_dep_data_vec_3[111 : 56] = dep_chan_data_4_3;
    assign token_in_vec_3[1] = token_4_3;
    assign in_chan_dep_vld_vec_3[2] = dep_chan_vld_7_3;
    assign in_chan_dep_data_vec_3[167 : 112] = dep_chan_data_7_3;
    assign token_in_vec_3[2] = token_7_3;
    assign dep_chan_vld_3_2 = out_chan_dep_vld_vec_3[0];
    assign dep_chan_data_3_2 = out_chan_dep_data_3;
    assign token_3_2 = token_out_vec_3[0];
    assign dep_chan_vld_3_7 = out_chan_dep_vld_vec_3[1];
    assign dep_chan_data_3_7 = out_chan_dep_data_3;
    assign token_3_7 = token_out_vec_3[1];
    assign dep_chan_vld_3_4 = out_chan_dep_vld_vec_3[2];
    assign dep_chan_data_3_4 = out_chan_dep_data_3;
    assign token_3_4 = token_out_vec_3[2];

    // Process: grp_shared_dataflow_fu_225.pyramid_1280_800_U0.downsample_1280_800_U0
    motion60_shared_hls_deadlock_detect_unit #(56, 4, 2, 2) motion60_shared_hls_deadlock_detect_unit_4 (
        .reset(dl_reset),
        .clock(dl_clock),
        .proc_dep_vld_vec(proc_dep_vld_vec_4),
        .in_chan_dep_vld_vec(in_chan_dep_vld_vec_4),
        .in_chan_dep_data_vec(in_chan_dep_data_vec_4),
        .token_in_vec(token_in_vec_4),
        .dl_detect_in(dl_detect_out),
        .origin(origin[4]),
        .token_clear(token_clear),
        .out_chan_dep_vld_vec(out_chan_dep_vld_vec_4),
        .out_chan_dep_data(out_chan_dep_data_4),
        .token_out_vec(token_out_vec_4),
        .dl_detect_out(dl_in_vec[4]));

    assign proc_4_data_FIFO_blk[0] = 1'b0 | (~grp_shared_dataflow_fu_225.pyramid_1280_800_U0.downsample_1280_800_U0.dsinput_blk_n);
    assign proc_4_data_PIPO_blk[0] = 1'b0;
    assign proc_4_start_FIFO_blk[0] = 1'b0 | (~grp_shared_dataflow_fu_225.pyramid_1280_800_U0.start_for_downsample_1280_800_U0_U.if_empty_n & grp_shared_dataflow_fu_225.pyramid_1280_800_U0.downsample_1280_800_U0.ap_idle & ~grp_shared_dataflow_fu_225.pyramid_1280_800_U0.start_for_downsample_1280_800_U0_U.if_write);
    assign proc_4_TLF_FIFO_blk[0] = 1'b0;
    assign proc_4_input_sync_blk[0] = 1'b0;
    assign proc_4_output_sync_blk[0] = 1'b0;
    assign proc_dep_vld_vec_4[0] = dl_detect_out ? proc_dep_vld_vec_4_reg[0] : (proc_4_data_FIFO_blk[0] | proc_4_data_PIPO_blk[0] | proc_4_start_FIFO_blk[0] | proc_4_TLF_FIFO_blk[0] | proc_4_input_sync_blk[0] | proc_4_output_sync_blk[0]);
    assign proc_4_data_FIFO_blk[1] = 1'b0 | (~grp_shared_dataflow_fu_225.pyramid_1280_800_U0.downsample_1280_800_U0.small_r_blk_n);
    assign proc_4_data_PIPO_blk[1] = 1'b0;
    assign proc_4_start_FIFO_blk[1] = 1'b0 | (~grp_shared_dataflow_fu_225.pyramid_1280_800_U0.start_for_fork_float_256000_U0_U.if_full_n & grp_shared_dataflow_fu_225.pyramid_1280_800_U0.downsample_1280_800_U0.ap_start & ~grp_shared_dataflow_fu_225.pyramid_1280_800_U0.downsample_1280_800_U0.real_start & (trans_in_cnt_3 == trans_out_cnt_3) & ~grp_shared_dataflow_fu_225.pyramid_1280_800_U0.start_for_fork_float_256000_U0_U.if_read);
    assign proc_4_TLF_FIFO_blk[1] = 1'b0;
    assign proc_4_input_sync_blk[1] = 1'b0;
    assign proc_4_output_sync_blk[1] = 1'b0;
    assign proc_dep_vld_vec_4[1] = dl_detect_out ? proc_dep_vld_vec_4_reg[1] : (proc_4_data_FIFO_blk[1] | proc_4_data_PIPO_blk[1] | proc_4_start_FIFO_blk[1] | proc_4_TLF_FIFO_blk[1] | proc_4_input_sync_blk[1] | proc_4_output_sync_blk[1]);
    always @ (negedge dl_reset or posedge dl_clock) begin
        if (~dl_reset) begin
            proc_dep_vld_vec_4_reg <= 'b0;
        end
        else begin
            proc_dep_vld_vec_4_reg <= proc_dep_vld_vec_4;
        end
    end
    assign in_chan_dep_vld_vec_4[0] = dep_chan_vld_3_4;
    assign in_chan_dep_data_vec_4[55 : 0] = dep_chan_data_3_4;
    assign token_in_vec_4[0] = token_3_4;
    assign in_chan_dep_vld_vec_4[1] = dep_chan_vld_5_4;
    assign in_chan_dep_data_vec_4[111 : 56] = dep_chan_data_5_4;
    assign token_in_vec_4[1] = token_5_4;
    assign dep_chan_vld_4_3 = out_chan_dep_vld_vec_4[0];
    assign dep_chan_data_4_3 = out_chan_dep_data_4;
    assign token_4_3 = token_out_vec_4[0];
    assign dep_chan_vld_4_5 = out_chan_dep_vld_vec_4[1];
    assign dep_chan_data_4_5 = out_chan_dep_data_4;
    assign token_4_5 = token_out_vec_4[1];

    // Process: grp_shared_dataflow_fu_225.pyramid_1280_800_U0.fork_float_256000_U0
    motion60_shared_hls_deadlock_detect_unit #(56, 5, 5, 5) motion60_shared_hls_deadlock_detect_unit_5 (
        .reset(dl_reset),
        .clock(dl_clock),
        .proc_dep_vld_vec(proc_dep_vld_vec_5),
        .in_chan_dep_vld_vec(in_chan_dep_vld_vec_5),
        .in_chan_dep_data_vec(in_chan_dep_data_vec_5),
        .token_in_vec(token_in_vec_5),
        .dl_detect_in(dl_detect_out),
        .origin(origin[5]),
        .token_clear(token_clear),
        .out_chan_dep_vld_vec(out_chan_dep_vld_vec_5),
        .out_chan_dep_data(out_chan_dep_data_5),
        .token_out_vec(token_out_vec_5),
        .dl_detect_out(dl_in_vec[5]));

    assign proc_5_data_FIFO_blk[0] = 1'b0 | (~grp_shared_dataflow_fu_225.pyramid_1280_800_U0.fork_float_256000_U0.small_r_blk_n);
    assign proc_5_data_PIPO_blk[0] = 1'b0;
    assign proc_5_start_FIFO_blk[0] = 1'b0 | (~grp_shared_dataflow_fu_225.pyramid_1280_800_U0.start_for_fork_float_256000_U0_U.if_empty_n & grp_shared_dataflow_fu_225.pyramid_1280_800_U0.fork_float_256000_U0.ap_idle & ~grp_shared_dataflow_fu_225.pyramid_1280_800_U0.start_for_fork_float_256000_U0_U.if_write);
    assign proc_5_TLF_FIFO_blk[0] = 1'b0;
    assign proc_5_input_sync_blk[0] = 1'b0;
    assign proc_5_output_sync_blk[0] = 1'b0;
    assign proc_dep_vld_vec_5[0] = dl_detect_out ? proc_dep_vld_vec_5_reg[0] : (proc_5_data_FIFO_blk[0] | proc_5_data_PIPO_blk[0] | proc_5_start_FIFO_blk[0] | proc_5_TLF_FIFO_blk[0] | proc_5_input_sync_blk[0] | proc_5_output_sync_blk[0]);
    assign proc_5_data_FIFO_blk[1] = 1'b0 | (~grp_shared_dataflow_fu_225.pyramid_1280_800_U0.fork_float_256000_U0.g1_blk_n);
    assign proc_5_data_PIPO_blk[1] = 1'b0;
    assign proc_5_start_FIFO_blk[1] = 1'b0;
    assign proc_5_TLF_FIFO_blk[1] = 1'b0;
    assign proc_5_input_sync_blk[1] = 1'b0;
    assign proc_5_output_sync_blk[1] = 1'b0;
    assign proc_dep_vld_vec_5[1] = dl_detect_out ? proc_dep_vld_vec_5_reg[1] : (proc_5_data_FIFO_blk[1] | proc_5_data_PIPO_blk[1] | proc_5_start_FIFO_blk[1] | proc_5_TLF_FIFO_blk[1] | proc_5_input_sync_blk[1] | proc_5_output_sync_blk[1]);
    assign proc_5_data_FIFO_blk[2] = 1'b0 | (~grp_shared_dataflow_fu_225.pyramid_1280_800_U0.fork_float_256000_U0.g1_blk_n);
    assign proc_5_data_PIPO_blk[2] = 1'b0;
    assign proc_5_start_FIFO_blk[2] = 1'b0;
    assign proc_5_TLF_FIFO_blk[2] = 1'b0;
    assign proc_5_input_sync_blk[2] = 1'b0;
    assign proc_5_output_sync_blk[2] = 1'b0;
    assign proc_dep_vld_vec_5[2] = dl_detect_out ? proc_dep_vld_vec_5_reg[2] : (proc_5_data_FIFO_blk[2] | proc_5_data_PIPO_blk[2] | proc_5_start_FIFO_blk[2] | proc_5_TLF_FIFO_blk[2] | proc_5_input_sync_blk[2] | proc_5_output_sync_blk[2]);
    assign proc_5_data_FIFO_blk[3] = 1'b0 | (~grp_shared_dataflow_fu_225.pyramid_1280_800_U0.fork_float_256000_U0.usinput_blk_n);
    assign proc_5_data_PIPO_blk[3] = 1'b0;
    assign proc_5_start_FIFO_blk[3] = 1'b0 | (~grp_shared_dataflow_fu_225.pyramid_1280_800_U0.start_for_upsample_640_400_U0_U.if_full_n & grp_shared_dataflow_fu_225.pyramid_1280_800_U0.fork_float_256000_U0.ap_start & ~grp_shared_dataflow_fu_225.pyramid_1280_800_U0.fork_float_256000_U0.real_start & (trans_in_cnt_4 == trans_out_cnt_4) & ~grp_shared_dataflow_fu_225.pyramid_1280_800_U0.start_for_upsample_640_400_U0_U.if_read);
    assign proc_5_TLF_FIFO_blk[3] = 1'b0;
    assign proc_5_input_sync_blk[3] = 1'b0;
    assign proc_5_output_sync_blk[3] = 1'b0;
    assign proc_dep_vld_vec_5[3] = dl_detect_out ? proc_dep_vld_vec_5_reg[3] : (proc_5_data_FIFO_blk[3] | proc_5_data_PIPO_blk[3] | proc_5_start_FIFO_blk[3] | proc_5_TLF_FIFO_blk[3] | proc_5_input_sync_blk[3] | proc_5_output_sync_blk[3]);
    assign proc_5_data_FIFO_blk[4] = 1'b0;
    assign proc_5_data_PIPO_blk[4] = 1'b0;
    assign proc_5_start_FIFO_blk[4] = 1'b0;
    assign proc_5_TLF_FIFO_blk[4] = 1'b0;
    assign proc_5_input_sync_blk[4] = 1'b0;
    assign proc_5_output_sync_blk[4] = 1'b0 | (ap_done_reg_4 & grp_shared_dataflow_fu_225.pyramid_1280_800_U0.fork_float_256000_U0.ap_done & ~grp_shared_dataflow_fu_225.pyramid_1280_800_U0.combine_1024000_false_U0.ap_done);
    assign proc_dep_vld_vec_5[4] = dl_detect_out ? proc_dep_vld_vec_5_reg[4] : (proc_5_data_FIFO_blk[4] | proc_5_data_PIPO_blk[4] | proc_5_start_FIFO_blk[4] | proc_5_TLF_FIFO_blk[4] | proc_5_input_sync_blk[4] | proc_5_output_sync_blk[4]);
    always @ (negedge dl_reset or posedge dl_clock) begin
        if (~dl_reset) begin
            proc_dep_vld_vec_5_reg <= 'b0;
        end
        else begin
            proc_dep_vld_vec_5_reg <= proc_dep_vld_vec_5;
        end
    end
    assign in_chan_dep_vld_vec_5[0] = dep_chan_vld_4_5;
    assign in_chan_dep_data_vec_5[55 : 0] = dep_chan_data_4_5;
    assign token_in_vec_5[0] = token_4_5;
    assign in_chan_dep_vld_vec_5[1] = dep_chan_vld_6_5;
    assign in_chan_dep_data_vec_5[111 : 56] = dep_chan_data_6_5;
    assign token_in_vec_5[1] = token_6_5;
    assign in_chan_dep_vld_vec_5[2] = dep_chan_vld_7_5;
    assign in_chan_dep_data_vec_5[167 : 112] = dep_chan_data_7_5;
    assign token_in_vec_5[2] = token_7_5;
    assign in_chan_dep_vld_vec_5[3] = dep_chan_vld_8_5;
    assign in_chan_dep_data_vec_5[223 : 168] = dep_chan_data_8_5;
    assign token_in_vec_5[3] = token_8_5;
    assign in_chan_dep_vld_vec_5[4] = dep_chan_vld_9_5;
    assign in_chan_dep_data_vec_5[279 : 224] = dep_chan_data_9_5;
    assign token_in_vec_5[4] = token_9_5;
    assign dep_chan_vld_5_4 = out_chan_dep_vld_vec_5[0];
    assign dep_chan_data_5_4 = out_chan_dep_data_5;
    assign token_5_4 = token_out_vec_5[0];
    assign dep_chan_vld_5_8 = out_chan_dep_vld_vec_5[1];
    assign dep_chan_data_5_8 = out_chan_dep_data_5;
    assign token_5_8 = token_out_vec_5[1];
    assign dep_chan_vld_5_9 = out_chan_dep_vld_vec_5[2];
    assign dep_chan_data_5_9 = out_chan_dep_data_5;
    assign token_5_9 = token_out_vec_5[2];
    assign dep_chan_vld_5_6 = out_chan_dep_vld_vec_5[3];
    assign dep_chan_data_5_6 = out_chan_dep_data_5;
    assign token_5_6 = token_out_vec_5[3];
    assign dep_chan_vld_5_7 = out_chan_dep_vld_vec_5[4];
    assign dep_chan_data_5_7 = out_chan_dep_data_5;
    assign token_5_7 = token_out_vec_5[4];

    // Process: grp_shared_dataflow_fu_225.pyramid_1280_800_U0.upsample_640_400_U0
    motion60_shared_hls_deadlock_detect_unit #(56, 6, 2, 2) motion60_shared_hls_deadlock_detect_unit_6 (
        .reset(dl_reset),
        .clock(dl_clock),
        .proc_dep_vld_vec(proc_dep_vld_vec_6),
        .in_chan_dep_vld_vec(in_chan_dep_vld_vec_6),
        .in_chan_dep_data_vec(in_chan_dep_data_vec_6),
        .token_in_vec(token_in_vec_6),
        .dl_detect_in(dl_detect_out),
        .origin(origin[6]),
        .token_clear(token_clear),
        .out_chan_dep_vld_vec(out_chan_dep_vld_vec_6),
        .out_chan_dep_data(out_chan_dep_data_6),
        .token_out_vec(token_out_vec_6),
        .dl_detect_out(dl_in_vec[6]));

    assign proc_6_data_FIFO_blk[0] = 1'b0 | (~grp_shared_dataflow_fu_225.pyramid_1280_800_U0.upsample_640_400_U0.grp_upsample_640_400_Pipeline_VITIS_LOOP_98_2_fu_89.usinput_blk_n);
    assign proc_6_data_PIPO_blk[0] = 1'b0;
    assign proc_6_start_FIFO_blk[0] = 1'b0 | (~grp_shared_dataflow_fu_225.pyramid_1280_800_U0.start_for_upsample_640_400_U0_U.if_empty_n & grp_shared_dataflow_fu_225.pyramid_1280_800_U0.upsample_640_400_U0.ap_idle & ~grp_shared_dataflow_fu_225.pyramid_1280_800_U0.start_for_upsample_640_400_U0_U.if_write);
    assign proc_6_TLF_FIFO_blk[0] = 1'b0;
    assign proc_6_input_sync_blk[0] = 1'b0;
    assign proc_6_output_sync_blk[0] = 1'b0;
    assign proc_dep_vld_vec_6[0] = dl_detect_out ? proc_dep_vld_vec_6_reg[0] : (proc_6_data_FIFO_blk[0] | proc_6_data_PIPO_blk[0] | proc_6_start_FIFO_blk[0] | proc_6_TLF_FIFO_blk[0] | proc_6_input_sync_blk[0] | proc_6_output_sync_blk[0]);
    assign proc_6_data_FIFO_blk[1] = 1'b0 | (~grp_shared_dataflow_fu_225.pyramid_1280_800_U0.upsample_640_400_U0.grp_upsample_640_400_Pipeline_VITIS_LOOP_104_3_fu_98.large_r_blk_n);
    assign proc_6_data_PIPO_blk[1] = 1'b0;
    assign proc_6_start_FIFO_blk[1] = 1'b0;
    assign proc_6_TLF_FIFO_blk[1] = 1'b0;
    assign proc_6_input_sync_blk[1] = 1'b0;
    assign proc_6_output_sync_blk[1] = 1'b0;
    assign proc_dep_vld_vec_6[1] = dl_detect_out ? proc_dep_vld_vec_6_reg[1] : (proc_6_data_FIFO_blk[1] | proc_6_data_PIPO_blk[1] | proc_6_start_FIFO_blk[1] | proc_6_TLF_FIFO_blk[1] | proc_6_input_sync_blk[1] | proc_6_output_sync_blk[1]);
    always @ (negedge dl_reset or posedge dl_clock) begin
        if (~dl_reset) begin
            proc_dep_vld_vec_6_reg <= 'b0;
        end
        else begin
            proc_dep_vld_vec_6_reg <= proc_dep_vld_vec_6;
        end
    end
    assign in_chan_dep_vld_vec_6[0] = dep_chan_vld_5_6;
    assign in_chan_dep_data_vec_6[55 : 0] = dep_chan_data_5_6;
    assign token_in_vec_6[0] = token_5_6;
    assign in_chan_dep_vld_vec_6[1] = dep_chan_vld_7_6;
    assign in_chan_dep_data_vec_6[111 : 56] = dep_chan_data_7_6;
    assign token_in_vec_6[1] = token_7_6;
    assign dep_chan_vld_6_5 = out_chan_dep_vld_vec_6[0];
    assign dep_chan_data_6_5 = out_chan_dep_data_6;
    assign token_6_5 = token_out_vec_6[0];
    assign dep_chan_vld_6_7 = out_chan_dep_vld_vec_6[1];
    assign dep_chan_data_6_7 = out_chan_dep_data_6;
    assign token_6_7 = token_out_vec_6[1];

    // Process: grp_shared_dataflow_fu_225.pyramid_1280_800_U0.combine_1024000_false_U0
    motion60_shared_hls_deadlock_detect_unit #(56, 7, 5, 5) motion60_shared_hls_deadlock_detect_unit_7 (
        .reset(dl_reset),
        .clock(dl_clock),
        .proc_dep_vld_vec(proc_dep_vld_vec_7),
        .in_chan_dep_vld_vec(in_chan_dep_vld_vec_7),
        .in_chan_dep_data_vec(in_chan_dep_data_vec_7),
        .token_in_vec(token_in_vec_7),
        .dl_detect_in(dl_detect_out),
        .origin(origin[7]),
        .token_clear(token_clear),
        .out_chan_dep_vld_vec(out_chan_dep_vld_vec_7),
        .out_chan_dep_data(out_chan_dep_data_7),
        .token_out_vec(token_out_vec_7),
        .dl_detect_out(dl_in_vec[7]));

    assign proc_7_data_FIFO_blk[0] = 1'b0 | (~grp_shared_dataflow_fu_225.pyramid_1280_800_U0.combine_1024000_false_U0.full_blk_n);
    assign proc_7_data_PIPO_blk[0] = 1'b0;
    assign proc_7_start_FIFO_blk[0] = 1'b0 | (~grp_shared_dataflow_fu_225.pyramid_1280_800_U0.start_for_combine_1024000_false_U0_U.if_empty_n & grp_shared_dataflow_fu_225.pyramid_1280_800_U0.combine_1024000_false_U0.ap_idle & ~grp_shared_dataflow_fu_225.pyramid_1280_800_U0.start_for_combine_1024000_false_U0_U.if_write);
    assign proc_7_TLF_FIFO_blk[0] = 1'b0;
    assign proc_7_input_sync_blk[0] = 1'b0;
    assign proc_7_output_sync_blk[0] = 1'b0;
    assign proc_dep_vld_vec_7[0] = dl_detect_out ? proc_dep_vld_vec_7_reg[0] : (proc_7_data_FIFO_blk[0] | proc_7_data_PIPO_blk[0] | proc_7_start_FIFO_blk[0] | proc_7_TLF_FIFO_blk[0] | proc_7_input_sync_blk[0] | proc_7_output_sync_blk[0]);
    assign proc_7_data_FIFO_blk[1] = 1'b0 | (~grp_shared_dataflow_fu_225.pyramid_1280_800_U0.combine_1024000_false_U0.large_r_blk_n);
    assign proc_7_data_PIPO_blk[1] = 1'b0;
    assign proc_7_start_FIFO_blk[1] = 1'b0;
    assign proc_7_TLF_FIFO_blk[1] = 1'b0;
    assign proc_7_input_sync_blk[1] = 1'b0;
    assign proc_7_output_sync_blk[1] = 1'b0;
    assign proc_dep_vld_vec_7[1] = dl_detect_out ? proc_dep_vld_vec_7_reg[1] : (proc_7_data_FIFO_blk[1] | proc_7_data_PIPO_blk[1] | proc_7_start_FIFO_blk[1] | proc_7_TLF_FIFO_blk[1] | proc_7_input_sync_blk[1] | proc_7_output_sync_blk[1]);
    assign proc_7_data_FIFO_blk[2] = 1'b0 | (~grp_shared_dataflow_fu_225.pyramid_1280_800_U0.combine_1024000_false_U0.band0_blk_n);
    assign proc_7_data_PIPO_blk[2] = 1'b0;
    assign proc_7_start_FIFO_blk[2] = 1'b0;
    assign proc_7_TLF_FIFO_blk[2] = 1'b0;
    assign proc_7_input_sync_blk[2] = 1'b0;
    assign proc_7_output_sync_blk[2] = 1'b0;
    assign proc_dep_vld_vec_7[2] = dl_detect_out ? proc_dep_vld_vec_7_reg[2] : (proc_7_data_FIFO_blk[2] | proc_7_data_PIPO_blk[2] | proc_7_start_FIFO_blk[2] | proc_7_TLF_FIFO_blk[2] | proc_7_input_sync_blk[2] | proc_7_output_sync_blk[2]);
    assign proc_7_data_FIFO_blk[3] = 1'b0 | (~grp_shared_dataflow_fu_225.pyramid_1280_800_U0.combine_1024000_false_U0.band0_blk_n);
    assign proc_7_data_PIPO_blk[3] = 1'b0;
    assign proc_7_start_FIFO_blk[3] = 1'b0;
    assign proc_7_TLF_FIFO_blk[3] = 1'b0;
    assign proc_7_input_sync_blk[3] = 1'b0;
    assign proc_7_output_sync_blk[3] = 1'b0;
    assign proc_dep_vld_vec_7[3] = dl_detect_out ? proc_dep_vld_vec_7_reg[3] : (proc_7_data_FIFO_blk[3] | proc_7_data_PIPO_blk[3] | proc_7_start_FIFO_blk[3] | proc_7_TLF_FIFO_blk[3] | proc_7_input_sync_blk[3] | proc_7_output_sync_blk[3]);
    assign proc_7_data_FIFO_blk[4] = 1'b0;
    assign proc_7_data_PIPO_blk[4] = 1'b0;
    assign proc_7_start_FIFO_blk[4] = 1'b0;
    assign proc_7_TLF_FIFO_blk[4] = 1'b0;
    assign proc_7_input_sync_blk[4] = 1'b0;
    assign proc_7_output_sync_blk[4] = 1'b0 | (ap_done_reg_5 & grp_shared_dataflow_fu_225.pyramid_1280_800_U0.combine_1024000_false_U0.ap_done & ~grp_shared_dataflow_fu_225.pyramid_1280_800_U0.fork_float_256000_U0.ap_done);
    assign proc_dep_vld_vec_7[4] = dl_detect_out ? proc_dep_vld_vec_7_reg[4] : (proc_7_data_FIFO_blk[4] | proc_7_data_PIPO_blk[4] | proc_7_start_FIFO_blk[4] | proc_7_TLF_FIFO_blk[4] | proc_7_input_sync_blk[4] | proc_7_output_sync_blk[4]);
    always @ (negedge dl_reset or posedge dl_clock) begin
        if (~dl_reset) begin
            proc_dep_vld_vec_7_reg <= 'b0;
        end
        else begin
            proc_dep_vld_vec_7_reg <= proc_dep_vld_vec_7;
        end
    end
    assign in_chan_dep_vld_vec_7[0] = dep_chan_vld_3_7;
    assign in_chan_dep_data_vec_7[55 : 0] = dep_chan_data_3_7;
    assign token_in_vec_7[0] = token_3_7;
    assign in_chan_dep_vld_vec_7[1] = dep_chan_vld_5_7;
    assign in_chan_dep_data_vec_7[111 : 56] = dep_chan_data_5_7;
    assign token_in_vec_7[1] = token_5_7;
    assign in_chan_dep_vld_vec_7[2] = dep_chan_vld_6_7;
    assign in_chan_dep_data_vec_7[167 : 112] = dep_chan_data_6_7;
    assign token_in_vec_7[2] = token_6_7;
    assign in_chan_dep_vld_vec_7[3] = dep_chan_vld_22_7;
    assign in_chan_dep_data_vec_7[223 : 168] = dep_chan_data_22_7;
    assign token_in_vec_7[3] = token_22_7;
    assign in_chan_dep_vld_vec_7[4] = dep_chan_vld_23_7;
    assign in_chan_dep_data_vec_7[279 : 224] = dep_chan_data_23_7;
    assign token_in_vec_7[4] = token_23_7;
    assign dep_chan_vld_7_3 = out_chan_dep_vld_vec_7[0];
    assign dep_chan_data_7_3 = out_chan_dep_data_7;
    assign token_7_3 = token_out_vec_7[0];
    assign dep_chan_vld_7_6 = out_chan_dep_vld_vec_7[1];
    assign dep_chan_data_7_6 = out_chan_dep_data_7;
    assign token_7_6 = token_out_vec_7[1];
    assign dep_chan_vld_7_22 = out_chan_dep_vld_vec_7[2];
    assign dep_chan_data_7_22 = out_chan_dep_data_7;
    assign token_7_22 = token_out_vec_7[2];
    assign dep_chan_vld_7_23 = out_chan_dep_vld_vec_7[3];
    assign dep_chan_data_7_23 = out_chan_dep_data_7;
    assign token_7_23 = token_out_vec_7[3];
    assign dep_chan_vld_7_5 = out_chan_dep_vld_vec_7[4];
    assign dep_chan_data_7_5 = out_chan_dep_data_7;
    assign token_7_5 = token_out_vec_7[4];

    // Process: grp_shared_dataflow_fu_225.pyramid_640_400_U0
    motion60_shared_hls_deadlock_detect_unit #(56, 8, 6, 6) motion60_shared_hls_deadlock_detect_unit_8 (
        .reset(dl_reset),
        .clock(dl_clock),
        .proc_dep_vld_vec(proc_dep_vld_vec_8),
        .in_chan_dep_vld_vec(in_chan_dep_vld_vec_8),
        .in_chan_dep_data_vec(in_chan_dep_data_vec_8),
        .token_in_vec(token_in_vec_8),
        .dl_detect_in(dl_detect_out),
        .origin(origin[8]),
        .token_clear(token_clear),
        .out_chan_dep_vld_vec(out_chan_dep_vld_vec_8),
        .out_chan_dep_data(out_chan_dep_data_8),
        .token_out_vec(token_out_vec_8),
        .dl_detect_out(dl_in_vec[8]));

    assign proc_8_data_FIFO_blk[0] = 1'b0 | (~grp_shared_dataflow_fu_225.pyramid_640_400_U0.stencil_640_400_false_U0.grp_stencil_640_400_false_Pipeline_horizontal_fu_118.g1_blk_n) | (~grp_shared_dataflow_fu_225.pyramid_640_400_U0.stencil_640_400_false_U0.g1_blk_n);
    assign proc_8_data_PIPO_blk[0] = 1'b0;
    assign proc_8_start_FIFO_blk[0] = 1'b0 | (~grp_shared_dataflow_fu_225.start_for_pyramid_640_400_U0_U.if_empty_n & grp_shared_dataflow_fu_225.pyramid_640_400_U0.ap_idle & ~grp_shared_dataflow_fu_225.start_for_pyramid_640_400_U0_U.if_write);
    assign proc_8_TLF_FIFO_blk[0] = 1'b0;
    assign proc_8_input_sync_blk[0] = 1'b0;
    assign proc_8_output_sync_blk[0] = 1'b0;
    assign proc_dep_vld_vec_8[0] = dl_detect_out ? proc_dep_vld_vec_8_reg[0] : (proc_8_data_FIFO_blk[0] | proc_8_data_PIPO_blk[0] | proc_8_start_FIFO_blk[0] | proc_8_TLF_FIFO_blk[0] | proc_8_input_sync_blk[0] | proc_8_output_sync_blk[0]);
    assign proc_8_data_FIFO_blk[1] = 1'b0 | (~grp_shared_dataflow_fu_225.pyramid_640_400_U0.stencil_640_400_false_U0.grp_stencil_640_400_false_Pipeline_horizontal_fu_118.g1_blk_n) | (~grp_shared_dataflow_fu_225.pyramid_640_400_U0.stencil_640_400_false_U0.g1_blk_n);
    assign proc_8_data_PIPO_blk[1] = 1'b0;
    assign proc_8_start_FIFO_blk[1] = 1'b0;
    assign proc_8_TLF_FIFO_blk[1] = 1'b0;
    assign proc_8_input_sync_blk[1] = 1'b0;
    assign proc_8_output_sync_blk[1] = 1'b0;
    assign proc_dep_vld_vec_8[1] = dl_detect_out ? proc_dep_vld_vec_8_reg[1] : (proc_8_data_FIFO_blk[1] | proc_8_data_PIPO_blk[1] | proc_8_start_FIFO_blk[1] | proc_8_TLF_FIFO_blk[1] | proc_8_input_sync_blk[1] | proc_8_output_sync_blk[1]);
    assign proc_8_data_FIFO_blk[2] = 1'b0 | (~grp_shared_dataflow_fu_225.pyramid_640_400_U0.combine_256000_false_U0.band1_blk_n);
    assign proc_8_data_PIPO_blk[2] = 1'b0;
    assign proc_8_start_FIFO_blk[2] = 1'b0;
    assign proc_8_TLF_FIFO_blk[2] = 1'b0;
    assign proc_8_input_sync_blk[2] = 1'b0;
    assign proc_8_output_sync_blk[2] = 1'b0;
    assign proc_dep_vld_vec_8[2] = dl_detect_out ? proc_dep_vld_vec_8_reg[2] : (proc_8_data_FIFO_blk[2] | proc_8_data_PIPO_blk[2] | proc_8_start_FIFO_blk[2] | proc_8_TLF_FIFO_blk[2] | proc_8_input_sync_blk[2] | proc_8_output_sync_blk[2]);
    assign proc_8_data_FIFO_blk[3] = 1'b0 | (~grp_shared_dataflow_fu_225.pyramid_640_400_U0.combine_256000_false_U0.band1_blk_n);
    assign proc_8_data_PIPO_blk[3] = 1'b0;
    assign proc_8_start_FIFO_blk[3] = 1'b0;
    assign proc_8_TLF_FIFO_blk[3] = 1'b0;
    assign proc_8_input_sync_blk[3] = 1'b0;
    assign proc_8_output_sync_blk[3] = 1'b0;
    assign proc_dep_vld_vec_8[3] = dl_detect_out ? proc_dep_vld_vec_8_reg[3] : (proc_8_data_FIFO_blk[3] | proc_8_data_PIPO_blk[3] | proc_8_start_FIFO_blk[3] | proc_8_TLF_FIFO_blk[3] | proc_8_input_sync_blk[3] | proc_8_output_sync_blk[3]);
    assign proc_8_data_FIFO_blk[4] = 1'b0 | (~grp_shared_dataflow_fu_225.pyramid_640_400_U0.fork_float_64000_U0.g2_blk_n);
    assign proc_8_data_PIPO_blk[4] = 1'b0;
    assign proc_8_start_FIFO_blk[4] = 1'b0 | (~grp_shared_dataflow_fu_225.start_for_pyramid_320_200_U0_U.if_full_n & grp_shared_dataflow_fu_225.pyramid_640_400_U0.ap_start & ~grp_shared_dataflow_fu_225.pyramid_640_400_U0.real_start & (trans_in_cnt_10 == trans_out_cnt_10) & ~grp_shared_dataflow_fu_225.start_for_pyramid_320_200_U0_U.if_read);
    assign proc_8_TLF_FIFO_blk[4] = 1'b0;
    assign proc_8_input_sync_blk[4] = 1'b0;
    assign proc_8_output_sync_blk[4] = 1'b0;
    assign proc_dep_vld_vec_8[4] = dl_detect_out ? proc_dep_vld_vec_8_reg[4] : (proc_8_data_FIFO_blk[4] | proc_8_data_PIPO_blk[4] | proc_8_start_FIFO_blk[4] | proc_8_TLF_FIFO_blk[4] | proc_8_input_sync_blk[4] | proc_8_output_sync_blk[4]);
    assign proc_8_data_FIFO_blk[5] = 1'b0 | (~grp_shared_dataflow_fu_225.pyramid_640_400_U0.fork_float_64000_U0.g2_blk_n);
    assign proc_8_data_PIPO_blk[5] = 1'b0;
    assign proc_8_start_FIFO_blk[5] = 1'b0;
    assign proc_8_TLF_FIFO_blk[5] = 1'b0;
    assign proc_8_input_sync_blk[5] = 1'b0;
    assign proc_8_output_sync_blk[5] = 1'b0;
    assign proc_dep_vld_vec_8[5] = dl_detect_out ? proc_dep_vld_vec_8_reg[5] : (proc_8_data_FIFO_blk[5] | proc_8_data_PIPO_blk[5] | proc_8_start_FIFO_blk[5] | proc_8_TLF_FIFO_blk[5] | proc_8_input_sync_blk[5] | proc_8_output_sync_blk[5]);
    always @ (negedge dl_reset or posedge dl_clock) begin
        if (~dl_reset) begin
            proc_dep_vld_vec_8_reg <= 'b0;
        end
        else begin
            proc_dep_vld_vec_8_reg <= proc_dep_vld_vec_8;
        end
    end
    assign in_chan_dep_vld_vec_8[0] = dep_chan_vld_1_8;
    assign in_chan_dep_data_vec_8[55 : 0] = dep_chan_data_1_8;
    assign token_in_vec_8[0] = token_1_8;
    assign in_chan_dep_vld_vec_8[1] = dep_chan_vld_5_8;
    assign in_chan_dep_data_vec_8[111 : 56] = dep_chan_data_5_8;
    assign token_in_vec_8[1] = token_5_8;
    assign in_chan_dep_vld_vec_8[2] = dep_chan_vld_15_8;
    assign in_chan_dep_data_vec_8[167 : 112] = dep_chan_data_15_8;
    assign token_in_vec_8[2] = token_15_8;
    assign in_chan_dep_vld_vec_8[3] = dep_chan_vld_16_8;
    assign in_chan_dep_data_vec_8[223 : 168] = dep_chan_data_16_8;
    assign token_in_vec_8[3] = token_16_8;
    assign in_chan_dep_vld_vec_8[4] = dep_chan_vld_30_8;
    assign in_chan_dep_data_vec_8[279 : 224] = dep_chan_data_30_8;
    assign token_in_vec_8[4] = token_30_8;
    assign in_chan_dep_vld_vec_8[5] = dep_chan_vld_31_8;
    assign in_chan_dep_data_vec_8[335 : 280] = dep_chan_data_31_8;
    assign token_in_vec_8[5] = token_31_8;
    assign dep_chan_vld_8_1 = out_chan_dep_vld_vec_8[0];
    assign dep_chan_data_8_1 = out_chan_dep_data_8;
    assign token_8_1 = token_out_vec_8[0];
    assign dep_chan_vld_8_5 = out_chan_dep_vld_vec_8[1];
    assign dep_chan_data_8_5 = out_chan_dep_data_8;
    assign token_8_5 = token_out_vec_8[1];
    assign dep_chan_vld_8_30 = out_chan_dep_vld_vec_8[2];
    assign dep_chan_data_8_30 = out_chan_dep_data_8;
    assign token_8_30 = token_out_vec_8[2];
    assign dep_chan_vld_8_31 = out_chan_dep_vld_vec_8[3];
    assign dep_chan_data_8_31 = out_chan_dep_data_8;
    assign token_8_31 = token_out_vec_8[3];
    assign dep_chan_vld_8_15 = out_chan_dep_vld_vec_8[4];
    assign dep_chan_data_8_15 = out_chan_dep_data_8;
    assign token_8_15 = token_out_vec_8[4];
    assign dep_chan_vld_8_16 = out_chan_dep_vld_vec_8[5];
    assign dep_chan_data_8_16 = out_chan_dep_data_8;
    assign token_8_16 = token_out_vec_8[5];

    // Process: grp_shared_dataflow_fu_225.pyramid_640_400_U0.stencil_640_400_false_U0
    motion60_shared_hls_deadlock_detect_unit #(56, 9, 3, 3) motion60_shared_hls_deadlock_detect_unit_9 (
        .reset(dl_reset),
        .clock(dl_clock),
        .proc_dep_vld_vec(proc_dep_vld_vec_9),
        .in_chan_dep_vld_vec(in_chan_dep_vld_vec_9),
        .in_chan_dep_data_vec(in_chan_dep_data_vec_9),
        .token_in_vec(token_in_vec_9),
        .dl_detect_in(dl_detect_out),
        .origin(origin[9]),
        .token_clear(token_clear),
        .out_chan_dep_vld_vec(out_chan_dep_vld_vec_9),
        .out_chan_dep_data(out_chan_dep_data_9),
        .token_out_vec(token_out_vec_9),
        .dl_detect_out(dl_in_vec[9]));

    assign proc_9_data_FIFO_blk[0] = 1'b0 | (~grp_shared_dataflow_fu_225.pyramid_640_400_U0.stencil_640_400_false_U0.g1_blk_n) | (~grp_shared_dataflow_fu_225.pyramid_640_400_U0.stencil_640_400_false_U0.grp_stencil_640_400_false_Pipeline_horizontal_fu_118.g1_blk_n);
    assign proc_9_data_PIPO_blk[0] = 1'b0;
    assign proc_9_start_FIFO_blk[0] = 1'b0;
    assign proc_9_TLF_FIFO_blk[0] = 1'b0;
    assign proc_9_input_sync_blk[0] = 1'b0;
    assign proc_9_output_sync_blk[0] = 1'b0;
    assign proc_dep_vld_vec_9[0] = dl_detect_out ? proc_dep_vld_vec_9_reg[0] : (proc_9_data_FIFO_blk[0] | proc_9_data_PIPO_blk[0] | proc_9_start_FIFO_blk[0] | proc_9_TLF_FIFO_blk[0] | proc_9_input_sync_blk[0] | proc_9_output_sync_blk[0]);
    assign proc_9_data_FIFO_blk[1] = 1'b0 | (~grp_shared_dataflow_fu_225.pyramid_640_400_U0.stencil_640_400_false_U0.g1_blk_n) | (~grp_shared_dataflow_fu_225.pyramid_640_400_U0.stencil_640_400_false_U0.grp_stencil_640_400_false_Pipeline_horizontal_fu_118.g1_blk_n);
    assign proc_9_data_PIPO_blk[1] = 1'b0;
    assign proc_9_start_FIFO_blk[1] = 1'b0;
    assign proc_9_TLF_FIFO_blk[1] = 1'b0;
    assign proc_9_input_sync_blk[1] = 1'b0;
    assign proc_9_output_sync_blk[1] = 1'b0;
    assign proc_dep_vld_vec_9[1] = dl_detect_out ? proc_dep_vld_vec_9_reg[1] : (proc_9_data_FIFO_blk[1] | proc_9_data_PIPO_blk[1] | proc_9_start_FIFO_blk[1] | proc_9_TLF_FIFO_blk[1] | proc_9_input_sync_blk[1] | proc_9_output_sync_blk[1]);
    assign proc_9_data_FIFO_blk[2] = 1'b0 | (~grp_shared_dataflow_fu_225.pyramid_640_400_U0.stencil_640_400_false_U0.grp_stencil_640_400_false_Pipeline_vertical_fu_133.blur_blk_n);
    assign proc_9_data_PIPO_blk[2] = 1'b0;
    assign proc_9_start_FIFO_blk[2] = 1'b0 | (~grp_shared_dataflow_fu_225.pyramid_640_400_U0.start_for_blur_fork_256000_U0_U.if_full_n & grp_shared_dataflow_fu_225.pyramid_640_400_U0.stencil_640_400_false_U0.ap_start & ~grp_shared_dataflow_fu_225.pyramid_640_400_U0.stencil_640_400_false_U0.real_start & (trans_in_cnt_6 == trans_out_cnt_6) & ~grp_shared_dataflow_fu_225.pyramid_640_400_U0.start_for_blur_fork_256000_U0_U.if_read);
    assign proc_9_TLF_FIFO_blk[2] = 1'b0;
    assign proc_9_input_sync_blk[2] = 1'b0;
    assign proc_9_output_sync_blk[2] = 1'b0;
    assign proc_dep_vld_vec_9[2] = dl_detect_out ? proc_dep_vld_vec_9_reg[2] : (proc_9_data_FIFO_blk[2] | proc_9_data_PIPO_blk[2] | proc_9_start_FIFO_blk[2] | proc_9_TLF_FIFO_blk[2] | proc_9_input_sync_blk[2] | proc_9_output_sync_blk[2]);
    always @ (negedge dl_reset or posedge dl_clock) begin
        if (~dl_reset) begin
            proc_dep_vld_vec_9_reg <= 'b0;
        end
        else begin
            proc_dep_vld_vec_9_reg <= proc_dep_vld_vec_9;
        end
    end
    assign in_chan_dep_vld_vec_9[0] = dep_chan_vld_1_9;
    assign in_chan_dep_data_vec_9[55 : 0] = dep_chan_data_1_9;
    assign token_in_vec_9[0] = token_1_9;
    assign in_chan_dep_vld_vec_9[1] = dep_chan_vld_5_9;
    assign in_chan_dep_data_vec_9[111 : 56] = dep_chan_data_5_9;
    assign token_in_vec_9[1] = token_5_9;
    assign in_chan_dep_vld_vec_9[2] = dep_chan_vld_10_9;
    assign in_chan_dep_data_vec_9[167 : 112] = dep_chan_data_10_9;
    assign token_in_vec_9[2] = token_10_9;
    assign dep_chan_vld_9_1 = out_chan_dep_vld_vec_9[0];
    assign dep_chan_data_9_1 = out_chan_dep_data_9;
    assign token_9_1 = token_out_vec_9[0];
    assign dep_chan_vld_9_5 = out_chan_dep_vld_vec_9[1];
    assign dep_chan_data_9_5 = out_chan_dep_data_9;
    assign token_9_5 = token_out_vec_9[1];
    assign dep_chan_vld_9_10 = out_chan_dep_vld_vec_9[2];
    assign dep_chan_data_9_10 = out_chan_dep_data_9;
    assign token_9_10 = token_out_vec_9[2];

    // Process: grp_shared_dataflow_fu_225.pyramid_640_400_U0.blur_fork_256000_U0
    motion60_shared_hls_deadlock_detect_unit #(56, 10, 3, 3) motion60_shared_hls_deadlock_detect_unit_10 (
        .reset(dl_reset),
        .clock(dl_clock),
        .proc_dep_vld_vec(proc_dep_vld_vec_10),
        .in_chan_dep_vld_vec(in_chan_dep_vld_vec_10),
        .in_chan_dep_data_vec(in_chan_dep_data_vec_10),
        .token_in_vec(token_in_vec_10),
        .dl_detect_in(dl_detect_out),
        .origin(origin[10]),
        .token_clear(token_clear),
        .out_chan_dep_vld_vec(out_chan_dep_vld_vec_10),
        .out_chan_dep_data(out_chan_dep_data_10),
        .token_out_vec(token_out_vec_10),
        .dl_detect_out(dl_in_vec[10]));

    assign proc_10_data_FIFO_blk[0] = 1'b0 | (~grp_shared_dataflow_fu_225.pyramid_640_400_U0.blur_fork_256000_U0.blur_blk_n);
    assign proc_10_data_PIPO_blk[0] = 1'b0;
    assign proc_10_start_FIFO_blk[0] = 1'b0 | (~grp_shared_dataflow_fu_225.pyramid_640_400_U0.start_for_blur_fork_256000_U0_U.if_empty_n & grp_shared_dataflow_fu_225.pyramid_640_400_U0.blur_fork_256000_U0.ap_idle & ~grp_shared_dataflow_fu_225.pyramid_640_400_U0.start_for_blur_fork_256000_U0_U.if_write);
    assign proc_10_TLF_FIFO_blk[0] = 1'b0;
    assign proc_10_input_sync_blk[0] = 1'b0;
    assign proc_10_output_sync_blk[0] = 1'b0;
    assign proc_dep_vld_vec_10[0] = dl_detect_out ? proc_dep_vld_vec_10_reg[0] : (proc_10_data_FIFO_blk[0] | proc_10_data_PIPO_blk[0] | proc_10_start_FIFO_blk[0] | proc_10_TLF_FIFO_blk[0] | proc_10_input_sync_blk[0] | proc_10_output_sync_blk[0]);
    assign proc_10_data_FIFO_blk[1] = 1'b0 | (~grp_shared_dataflow_fu_225.pyramid_640_400_U0.blur_fork_256000_U0.full_blk_n);
    assign proc_10_data_PIPO_blk[1] = 1'b0;
    assign proc_10_start_FIFO_blk[1] = 1'b0 | (~grp_shared_dataflow_fu_225.pyramid_640_400_U0.start_for_combine_256000_false_U0_U.if_full_n & grp_shared_dataflow_fu_225.pyramid_640_400_U0.blur_fork_256000_U0.ap_start & ~grp_shared_dataflow_fu_225.pyramid_640_400_U0.blur_fork_256000_U0.real_start & (trans_in_cnt_7 == trans_out_cnt_7) & ~grp_shared_dataflow_fu_225.pyramid_640_400_U0.start_for_combine_256000_false_U0_U.if_read);
    assign proc_10_TLF_FIFO_blk[1] = 1'b0;
    assign proc_10_input_sync_blk[1] = 1'b0;
    assign proc_10_output_sync_blk[1] = 1'b0;
    assign proc_dep_vld_vec_10[1] = dl_detect_out ? proc_dep_vld_vec_10_reg[1] : (proc_10_data_FIFO_blk[1] | proc_10_data_PIPO_blk[1] | proc_10_start_FIFO_blk[1] | proc_10_TLF_FIFO_blk[1] | proc_10_input_sync_blk[1] | proc_10_output_sync_blk[1]);
    assign proc_10_data_FIFO_blk[2] = 1'b0 | (~grp_shared_dataflow_fu_225.pyramid_640_400_U0.blur_fork_256000_U0.dsinput_blk_n);
    assign proc_10_data_PIPO_blk[2] = 1'b0;
    assign proc_10_start_FIFO_blk[2] = 1'b0 | (~grp_shared_dataflow_fu_225.pyramid_640_400_U0.start_for_downsample_640_400_U0_U.if_full_n & grp_shared_dataflow_fu_225.pyramid_640_400_U0.blur_fork_256000_U0.ap_start & ~grp_shared_dataflow_fu_225.pyramid_640_400_U0.blur_fork_256000_U0.real_start & (trans_in_cnt_7 == trans_out_cnt_7) & ~grp_shared_dataflow_fu_225.pyramid_640_400_U0.start_for_downsample_640_400_U0_U.if_read);
    assign proc_10_TLF_FIFO_blk[2] = 1'b0;
    assign proc_10_input_sync_blk[2] = 1'b0;
    assign proc_10_output_sync_blk[2] = 1'b0;
    assign proc_dep_vld_vec_10[2] = dl_detect_out ? proc_dep_vld_vec_10_reg[2] : (proc_10_data_FIFO_blk[2] | proc_10_data_PIPO_blk[2] | proc_10_start_FIFO_blk[2] | proc_10_TLF_FIFO_blk[2] | proc_10_input_sync_blk[2] | proc_10_output_sync_blk[2]);
    always @ (negedge dl_reset or posedge dl_clock) begin
        if (~dl_reset) begin
            proc_dep_vld_vec_10_reg <= 'b0;
        end
        else begin
            proc_dep_vld_vec_10_reg <= proc_dep_vld_vec_10;
        end
    end
    assign in_chan_dep_vld_vec_10[0] = dep_chan_vld_9_10;
    assign in_chan_dep_data_vec_10[55 : 0] = dep_chan_data_9_10;
    assign token_in_vec_10[0] = token_9_10;
    assign in_chan_dep_vld_vec_10[1] = dep_chan_vld_11_10;
    assign in_chan_dep_data_vec_10[111 : 56] = dep_chan_data_11_10;
    assign token_in_vec_10[1] = token_11_10;
    assign in_chan_dep_vld_vec_10[2] = dep_chan_vld_14_10;
    assign in_chan_dep_data_vec_10[167 : 112] = dep_chan_data_14_10;
    assign token_in_vec_10[2] = token_14_10;
    assign dep_chan_vld_10_9 = out_chan_dep_vld_vec_10[0];
    assign dep_chan_data_10_9 = out_chan_dep_data_10;
    assign token_10_9 = token_out_vec_10[0];
    assign dep_chan_vld_10_14 = out_chan_dep_vld_vec_10[1];
    assign dep_chan_data_10_14 = out_chan_dep_data_10;
    assign token_10_14 = token_out_vec_10[1];
    assign dep_chan_vld_10_11 = out_chan_dep_vld_vec_10[2];
    assign dep_chan_data_10_11 = out_chan_dep_data_10;
    assign token_10_11 = token_out_vec_10[2];

    // Process: grp_shared_dataflow_fu_225.pyramid_640_400_U0.downsample_640_400_U0
    motion60_shared_hls_deadlock_detect_unit #(56, 11, 2, 2) motion60_shared_hls_deadlock_detect_unit_11 (
        .reset(dl_reset),
        .clock(dl_clock),
        .proc_dep_vld_vec(proc_dep_vld_vec_11),
        .in_chan_dep_vld_vec(in_chan_dep_vld_vec_11),
        .in_chan_dep_data_vec(in_chan_dep_data_vec_11),
        .token_in_vec(token_in_vec_11),
        .dl_detect_in(dl_detect_out),
        .origin(origin[11]),
        .token_clear(token_clear),
        .out_chan_dep_vld_vec(out_chan_dep_vld_vec_11),
        .out_chan_dep_data(out_chan_dep_data_11),
        .token_out_vec(token_out_vec_11),
        .dl_detect_out(dl_in_vec[11]));

    assign proc_11_data_FIFO_blk[0] = 1'b0 | (~grp_shared_dataflow_fu_225.pyramid_640_400_U0.downsample_640_400_U0.dsinput_blk_n);
    assign proc_11_data_PIPO_blk[0] = 1'b0;
    assign proc_11_start_FIFO_blk[0] = 1'b0 | (~grp_shared_dataflow_fu_225.pyramid_640_400_U0.start_for_downsample_640_400_U0_U.if_empty_n & grp_shared_dataflow_fu_225.pyramid_640_400_U0.downsample_640_400_U0.ap_idle & ~grp_shared_dataflow_fu_225.pyramid_640_400_U0.start_for_downsample_640_400_U0_U.if_write);
    assign proc_11_TLF_FIFO_blk[0] = 1'b0;
    assign proc_11_input_sync_blk[0] = 1'b0;
    assign proc_11_output_sync_blk[0] = 1'b0;
    assign proc_dep_vld_vec_11[0] = dl_detect_out ? proc_dep_vld_vec_11_reg[0] : (proc_11_data_FIFO_blk[0] | proc_11_data_PIPO_blk[0] | proc_11_start_FIFO_blk[0] | proc_11_TLF_FIFO_blk[0] | proc_11_input_sync_blk[0] | proc_11_output_sync_blk[0]);
    assign proc_11_data_FIFO_blk[1] = 1'b0 | (~grp_shared_dataflow_fu_225.pyramid_640_400_U0.downsample_640_400_U0.small_r_blk_n);
    assign proc_11_data_PIPO_blk[1] = 1'b0;
    assign proc_11_start_FIFO_blk[1] = 1'b0 | (~grp_shared_dataflow_fu_225.pyramid_640_400_U0.start_for_fork_float_64000_U0_U.if_full_n & grp_shared_dataflow_fu_225.pyramid_640_400_U0.downsample_640_400_U0.ap_start & ~grp_shared_dataflow_fu_225.pyramid_640_400_U0.downsample_640_400_U0.real_start & (trans_in_cnt_8 == trans_out_cnt_8) & ~grp_shared_dataflow_fu_225.pyramid_640_400_U0.start_for_fork_float_64000_U0_U.if_read);
    assign proc_11_TLF_FIFO_blk[1] = 1'b0;
    assign proc_11_input_sync_blk[1] = 1'b0;
    assign proc_11_output_sync_blk[1] = 1'b0;
    assign proc_dep_vld_vec_11[1] = dl_detect_out ? proc_dep_vld_vec_11_reg[1] : (proc_11_data_FIFO_blk[1] | proc_11_data_PIPO_blk[1] | proc_11_start_FIFO_blk[1] | proc_11_TLF_FIFO_blk[1] | proc_11_input_sync_blk[1] | proc_11_output_sync_blk[1]);
    always @ (negedge dl_reset or posedge dl_clock) begin
        if (~dl_reset) begin
            proc_dep_vld_vec_11_reg <= 'b0;
        end
        else begin
            proc_dep_vld_vec_11_reg <= proc_dep_vld_vec_11;
        end
    end
    assign in_chan_dep_vld_vec_11[0] = dep_chan_vld_10_11;
    assign in_chan_dep_data_vec_11[55 : 0] = dep_chan_data_10_11;
    assign token_in_vec_11[0] = token_10_11;
    assign in_chan_dep_vld_vec_11[1] = dep_chan_vld_12_11;
    assign in_chan_dep_data_vec_11[111 : 56] = dep_chan_data_12_11;
    assign token_in_vec_11[1] = token_12_11;
    assign dep_chan_vld_11_10 = out_chan_dep_vld_vec_11[0];
    assign dep_chan_data_11_10 = out_chan_dep_data_11;
    assign token_11_10 = token_out_vec_11[0];
    assign dep_chan_vld_11_12 = out_chan_dep_vld_vec_11[1];
    assign dep_chan_data_11_12 = out_chan_dep_data_11;
    assign token_11_12 = token_out_vec_11[1];

    // Process: grp_shared_dataflow_fu_225.pyramid_640_400_U0.fork_float_64000_U0
    motion60_shared_hls_deadlock_detect_unit #(56, 12, 5, 5) motion60_shared_hls_deadlock_detect_unit_12 (
        .reset(dl_reset),
        .clock(dl_clock),
        .proc_dep_vld_vec(proc_dep_vld_vec_12),
        .in_chan_dep_vld_vec(in_chan_dep_vld_vec_12),
        .in_chan_dep_data_vec(in_chan_dep_data_vec_12),
        .token_in_vec(token_in_vec_12),
        .dl_detect_in(dl_detect_out),
        .origin(origin[12]),
        .token_clear(token_clear),
        .out_chan_dep_vld_vec(out_chan_dep_vld_vec_12),
        .out_chan_dep_data(out_chan_dep_data_12),
        .token_out_vec(token_out_vec_12),
        .dl_detect_out(dl_in_vec[12]));

    assign proc_12_data_FIFO_blk[0] = 1'b0 | (~grp_shared_dataflow_fu_225.pyramid_640_400_U0.fork_float_64000_U0.small_r_blk_n);
    assign proc_12_data_PIPO_blk[0] = 1'b0;
    assign proc_12_start_FIFO_blk[0] = 1'b0 | (~grp_shared_dataflow_fu_225.pyramid_640_400_U0.start_for_fork_float_64000_U0_U.if_empty_n & grp_shared_dataflow_fu_225.pyramid_640_400_U0.fork_float_64000_U0.ap_idle & ~grp_shared_dataflow_fu_225.pyramid_640_400_U0.start_for_fork_float_64000_U0_U.if_write);
    assign proc_12_TLF_FIFO_blk[0] = 1'b0;
    assign proc_12_input_sync_blk[0] = 1'b0;
    assign proc_12_output_sync_blk[0] = 1'b0;
    assign proc_dep_vld_vec_12[0] = dl_detect_out ? proc_dep_vld_vec_12_reg[0] : (proc_12_data_FIFO_blk[0] | proc_12_data_PIPO_blk[0] | proc_12_start_FIFO_blk[0] | proc_12_TLF_FIFO_blk[0] | proc_12_input_sync_blk[0] | proc_12_output_sync_blk[0]);
    assign proc_12_data_FIFO_blk[1] = 1'b0 | (~grp_shared_dataflow_fu_225.pyramid_640_400_U0.fork_float_64000_U0.g2_blk_n);
    assign proc_12_data_PIPO_blk[1] = 1'b0;
    assign proc_12_start_FIFO_blk[1] = 1'b0;
    assign proc_12_TLF_FIFO_blk[1] = 1'b0;
    assign proc_12_input_sync_blk[1] = 1'b0;
    assign proc_12_output_sync_blk[1] = 1'b0;
    assign proc_dep_vld_vec_12[1] = dl_detect_out ? proc_dep_vld_vec_12_reg[1] : (proc_12_data_FIFO_blk[1] | proc_12_data_PIPO_blk[1] | proc_12_start_FIFO_blk[1] | proc_12_TLF_FIFO_blk[1] | proc_12_input_sync_blk[1] | proc_12_output_sync_blk[1]);
    assign proc_12_data_FIFO_blk[2] = 1'b0 | (~grp_shared_dataflow_fu_225.pyramid_640_400_U0.fork_float_64000_U0.g2_blk_n);
    assign proc_12_data_PIPO_blk[2] = 1'b0;
    assign proc_12_start_FIFO_blk[2] = 1'b0;
    assign proc_12_TLF_FIFO_blk[2] = 1'b0;
    assign proc_12_input_sync_blk[2] = 1'b0;
    assign proc_12_output_sync_blk[2] = 1'b0;
    assign proc_dep_vld_vec_12[2] = dl_detect_out ? proc_dep_vld_vec_12_reg[2] : (proc_12_data_FIFO_blk[2] | proc_12_data_PIPO_blk[2] | proc_12_start_FIFO_blk[2] | proc_12_TLF_FIFO_blk[2] | proc_12_input_sync_blk[2] | proc_12_output_sync_blk[2]);
    assign proc_12_data_FIFO_blk[3] = 1'b0 | (~grp_shared_dataflow_fu_225.pyramid_640_400_U0.fork_float_64000_U0.usinput_blk_n);
    assign proc_12_data_PIPO_blk[3] = 1'b0;
    assign proc_12_start_FIFO_blk[3] = 1'b0 | (~grp_shared_dataflow_fu_225.pyramid_640_400_U0.start_for_upsample_320_200_U0_U.if_full_n & grp_shared_dataflow_fu_225.pyramid_640_400_U0.fork_float_64000_U0.ap_start & ~grp_shared_dataflow_fu_225.pyramid_640_400_U0.fork_float_64000_U0.real_start & (trans_in_cnt_9 == trans_out_cnt_9) & ~grp_shared_dataflow_fu_225.pyramid_640_400_U0.start_for_upsample_320_200_U0_U.if_read);
    assign proc_12_TLF_FIFO_blk[3] = 1'b0;
    assign proc_12_input_sync_blk[3] = 1'b0;
    assign proc_12_output_sync_blk[3] = 1'b0;
    assign proc_dep_vld_vec_12[3] = dl_detect_out ? proc_dep_vld_vec_12_reg[3] : (proc_12_data_FIFO_blk[3] | proc_12_data_PIPO_blk[3] | proc_12_start_FIFO_blk[3] | proc_12_TLF_FIFO_blk[3] | proc_12_input_sync_blk[3] | proc_12_output_sync_blk[3]);
    assign proc_12_data_FIFO_blk[4] = 1'b0;
    assign proc_12_data_PIPO_blk[4] = 1'b0;
    assign proc_12_start_FIFO_blk[4] = 1'b0;
    assign proc_12_TLF_FIFO_blk[4] = 1'b0;
    assign proc_12_input_sync_blk[4] = 1'b0;
    assign proc_12_output_sync_blk[4] = 1'b0 | (ap_done_reg_6 & grp_shared_dataflow_fu_225.pyramid_640_400_U0.fork_float_64000_U0.ap_done & ~grp_shared_dataflow_fu_225.pyramid_640_400_U0.combine_256000_false_U0.ap_done);
    assign proc_dep_vld_vec_12[4] = dl_detect_out ? proc_dep_vld_vec_12_reg[4] : (proc_12_data_FIFO_blk[4] | proc_12_data_PIPO_blk[4] | proc_12_start_FIFO_blk[4] | proc_12_TLF_FIFO_blk[4] | proc_12_input_sync_blk[4] | proc_12_output_sync_blk[4]);
    always @ (negedge dl_reset or posedge dl_clock) begin
        if (~dl_reset) begin
            proc_dep_vld_vec_12_reg <= 'b0;
        end
        else begin
            proc_dep_vld_vec_12_reg <= proc_dep_vld_vec_12;
        end
    end
    assign in_chan_dep_vld_vec_12[0] = dep_chan_vld_11_12;
    assign in_chan_dep_data_vec_12[55 : 0] = dep_chan_data_11_12;
    assign token_in_vec_12[0] = token_11_12;
    assign in_chan_dep_vld_vec_12[1] = dep_chan_vld_13_12;
    assign in_chan_dep_data_vec_12[111 : 56] = dep_chan_data_13_12;
    assign token_in_vec_12[1] = token_13_12;
    assign in_chan_dep_vld_vec_12[2] = dep_chan_vld_14_12;
    assign in_chan_dep_data_vec_12[167 : 112] = dep_chan_data_14_12;
    assign token_in_vec_12[2] = token_14_12;
    assign in_chan_dep_vld_vec_12[3] = dep_chan_vld_15_12;
    assign in_chan_dep_data_vec_12[223 : 168] = dep_chan_data_15_12;
    assign token_in_vec_12[3] = token_15_12;
    assign in_chan_dep_vld_vec_12[4] = dep_chan_vld_16_12;
    assign in_chan_dep_data_vec_12[279 : 224] = dep_chan_data_16_12;
    assign token_in_vec_12[4] = token_16_12;
    assign dep_chan_vld_12_11 = out_chan_dep_vld_vec_12[0];
    assign dep_chan_data_12_11 = out_chan_dep_data_12;
    assign token_12_11 = token_out_vec_12[0];
    assign dep_chan_vld_12_15 = out_chan_dep_vld_vec_12[1];
    assign dep_chan_data_12_15 = out_chan_dep_data_12;
    assign token_12_15 = token_out_vec_12[1];
    assign dep_chan_vld_12_16 = out_chan_dep_vld_vec_12[2];
    assign dep_chan_data_12_16 = out_chan_dep_data_12;
    assign token_12_16 = token_out_vec_12[2];
    assign dep_chan_vld_12_13 = out_chan_dep_vld_vec_12[3];
    assign dep_chan_data_12_13 = out_chan_dep_data_12;
    assign token_12_13 = token_out_vec_12[3];
    assign dep_chan_vld_12_14 = out_chan_dep_vld_vec_12[4];
    assign dep_chan_data_12_14 = out_chan_dep_data_12;
    assign token_12_14 = token_out_vec_12[4];

    // Process: grp_shared_dataflow_fu_225.pyramid_640_400_U0.upsample_320_200_U0
    motion60_shared_hls_deadlock_detect_unit #(56, 13, 2, 2) motion60_shared_hls_deadlock_detect_unit_13 (
        .reset(dl_reset),
        .clock(dl_clock),
        .proc_dep_vld_vec(proc_dep_vld_vec_13),
        .in_chan_dep_vld_vec(in_chan_dep_vld_vec_13),
        .in_chan_dep_data_vec(in_chan_dep_data_vec_13),
        .token_in_vec(token_in_vec_13),
        .dl_detect_in(dl_detect_out),
        .origin(origin[13]),
        .token_clear(token_clear),
        .out_chan_dep_vld_vec(out_chan_dep_vld_vec_13),
        .out_chan_dep_data(out_chan_dep_data_13),
        .token_out_vec(token_out_vec_13),
        .dl_detect_out(dl_in_vec[13]));

    assign proc_13_data_FIFO_blk[0] = 1'b0 | (~grp_shared_dataflow_fu_225.pyramid_640_400_U0.upsample_320_200_U0.grp_upsample_320_200_Pipeline_VITIS_LOOP_98_2_fu_89.usinput_blk_n);
    assign proc_13_data_PIPO_blk[0] = 1'b0;
    assign proc_13_start_FIFO_blk[0] = 1'b0 | (~grp_shared_dataflow_fu_225.pyramid_640_400_U0.start_for_upsample_320_200_U0_U.if_empty_n & grp_shared_dataflow_fu_225.pyramid_640_400_U0.upsample_320_200_U0.ap_idle & ~grp_shared_dataflow_fu_225.pyramid_640_400_U0.start_for_upsample_320_200_U0_U.if_write);
    assign proc_13_TLF_FIFO_blk[0] = 1'b0;
    assign proc_13_input_sync_blk[0] = 1'b0;
    assign proc_13_output_sync_blk[0] = 1'b0;
    assign proc_dep_vld_vec_13[0] = dl_detect_out ? proc_dep_vld_vec_13_reg[0] : (proc_13_data_FIFO_blk[0] | proc_13_data_PIPO_blk[0] | proc_13_start_FIFO_blk[0] | proc_13_TLF_FIFO_blk[0] | proc_13_input_sync_blk[0] | proc_13_output_sync_blk[0]);
    assign proc_13_data_FIFO_blk[1] = 1'b0 | (~grp_shared_dataflow_fu_225.pyramid_640_400_U0.upsample_320_200_U0.grp_upsample_320_200_Pipeline_VITIS_LOOP_104_3_fu_98.large_r_blk_n);
    assign proc_13_data_PIPO_blk[1] = 1'b0;
    assign proc_13_start_FIFO_blk[1] = 1'b0;
    assign proc_13_TLF_FIFO_blk[1] = 1'b0;
    assign proc_13_input_sync_blk[1] = 1'b0;
    assign proc_13_output_sync_blk[1] = 1'b0;
    assign proc_dep_vld_vec_13[1] = dl_detect_out ? proc_dep_vld_vec_13_reg[1] : (proc_13_data_FIFO_blk[1] | proc_13_data_PIPO_blk[1] | proc_13_start_FIFO_blk[1] | proc_13_TLF_FIFO_blk[1] | proc_13_input_sync_blk[1] | proc_13_output_sync_blk[1]);
    always @ (negedge dl_reset or posedge dl_clock) begin
        if (~dl_reset) begin
            proc_dep_vld_vec_13_reg <= 'b0;
        end
        else begin
            proc_dep_vld_vec_13_reg <= proc_dep_vld_vec_13;
        end
    end
    assign in_chan_dep_vld_vec_13[0] = dep_chan_vld_12_13;
    assign in_chan_dep_data_vec_13[55 : 0] = dep_chan_data_12_13;
    assign token_in_vec_13[0] = token_12_13;
    assign in_chan_dep_vld_vec_13[1] = dep_chan_vld_14_13;
    assign in_chan_dep_data_vec_13[111 : 56] = dep_chan_data_14_13;
    assign token_in_vec_13[1] = token_14_13;
    assign dep_chan_vld_13_12 = out_chan_dep_vld_vec_13[0];
    assign dep_chan_data_13_12 = out_chan_dep_data_13;
    assign token_13_12 = token_out_vec_13[0];
    assign dep_chan_vld_13_14 = out_chan_dep_vld_vec_13[1];
    assign dep_chan_data_13_14 = out_chan_dep_data_13;
    assign token_13_14 = token_out_vec_13[1];

    // Process: grp_shared_dataflow_fu_225.pyramid_640_400_U0.combine_256000_false_U0
    motion60_shared_hls_deadlock_detect_unit #(56, 14, 5, 5) motion60_shared_hls_deadlock_detect_unit_14 (
        .reset(dl_reset),
        .clock(dl_clock),
        .proc_dep_vld_vec(proc_dep_vld_vec_14),
        .in_chan_dep_vld_vec(in_chan_dep_vld_vec_14),
        .in_chan_dep_data_vec(in_chan_dep_data_vec_14),
        .token_in_vec(token_in_vec_14),
        .dl_detect_in(dl_detect_out),
        .origin(origin[14]),
        .token_clear(token_clear),
        .out_chan_dep_vld_vec(out_chan_dep_vld_vec_14),
        .out_chan_dep_data(out_chan_dep_data_14),
        .token_out_vec(token_out_vec_14),
        .dl_detect_out(dl_in_vec[14]));

    assign proc_14_data_FIFO_blk[0] = 1'b0 | (~grp_shared_dataflow_fu_225.pyramid_640_400_U0.combine_256000_false_U0.full_blk_n);
    assign proc_14_data_PIPO_blk[0] = 1'b0;
    assign proc_14_start_FIFO_blk[0] = 1'b0 | (~grp_shared_dataflow_fu_225.pyramid_640_400_U0.start_for_combine_256000_false_U0_U.if_empty_n & grp_shared_dataflow_fu_225.pyramid_640_400_U0.combine_256000_false_U0.ap_idle & ~grp_shared_dataflow_fu_225.pyramid_640_400_U0.start_for_combine_256000_false_U0_U.if_write);
    assign proc_14_TLF_FIFO_blk[0] = 1'b0;
    assign proc_14_input_sync_blk[0] = 1'b0;
    assign proc_14_output_sync_blk[0] = 1'b0;
    assign proc_dep_vld_vec_14[0] = dl_detect_out ? proc_dep_vld_vec_14_reg[0] : (proc_14_data_FIFO_blk[0] | proc_14_data_PIPO_blk[0] | proc_14_start_FIFO_blk[0] | proc_14_TLF_FIFO_blk[0] | proc_14_input_sync_blk[0] | proc_14_output_sync_blk[0]);
    assign proc_14_data_FIFO_blk[1] = 1'b0 | (~grp_shared_dataflow_fu_225.pyramid_640_400_U0.combine_256000_false_U0.large_r_blk_n);
    assign proc_14_data_PIPO_blk[1] = 1'b0;
    assign proc_14_start_FIFO_blk[1] = 1'b0;
    assign proc_14_TLF_FIFO_blk[1] = 1'b0;
    assign proc_14_input_sync_blk[1] = 1'b0;
    assign proc_14_output_sync_blk[1] = 1'b0;
    assign proc_dep_vld_vec_14[1] = dl_detect_out ? proc_dep_vld_vec_14_reg[1] : (proc_14_data_FIFO_blk[1] | proc_14_data_PIPO_blk[1] | proc_14_start_FIFO_blk[1] | proc_14_TLF_FIFO_blk[1] | proc_14_input_sync_blk[1] | proc_14_output_sync_blk[1]);
    assign proc_14_data_FIFO_blk[2] = 1'b0 | (~grp_shared_dataflow_fu_225.pyramid_640_400_U0.combine_256000_false_U0.band1_blk_n);
    assign proc_14_data_PIPO_blk[2] = 1'b0;
    assign proc_14_start_FIFO_blk[2] = 1'b0;
    assign proc_14_TLF_FIFO_blk[2] = 1'b0;
    assign proc_14_input_sync_blk[2] = 1'b0;
    assign proc_14_output_sync_blk[2] = 1'b0;
    assign proc_dep_vld_vec_14[2] = dl_detect_out ? proc_dep_vld_vec_14_reg[2] : (proc_14_data_FIFO_blk[2] | proc_14_data_PIPO_blk[2] | proc_14_start_FIFO_blk[2] | proc_14_TLF_FIFO_blk[2] | proc_14_input_sync_blk[2] | proc_14_output_sync_blk[2]);
    assign proc_14_data_FIFO_blk[3] = 1'b0 | (~grp_shared_dataflow_fu_225.pyramid_640_400_U0.combine_256000_false_U0.band1_blk_n);
    assign proc_14_data_PIPO_blk[3] = 1'b0;
    assign proc_14_start_FIFO_blk[3] = 1'b0;
    assign proc_14_TLF_FIFO_blk[3] = 1'b0;
    assign proc_14_input_sync_blk[3] = 1'b0;
    assign proc_14_output_sync_blk[3] = 1'b0;
    assign proc_dep_vld_vec_14[3] = dl_detect_out ? proc_dep_vld_vec_14_reg[3] : (proc_14_data_FIFO_blk[3] | proc_14_data_PIPO_blk[3] | proc_14_start_FIFO_blk[3] | proc_14_TLF_FIFO_blk[3] | proc_14_input_sync_blk[3] | proc_14_output_sync_blk[3]);
    assign proc_14_data_FIFO_blk[4] = 1'b0;
    assign proc_14_data_PIPO_blk[4] = 1'b0;
    assign proc_14_start_FIFO_blk[4] = 1'b0;
    assign proc_14_TLF_FIFO_blk[4] = 1'b0;
    assign proc_14_input_sync_blk[4] = 1'b0;
    assign proc_14_output_sync_blk[4] = 1'b0 | (ap_done_reg_7 & grp_shared_dataflow_fu_225.pyramid_640_400_U0.combine_256000_false_U0.ap_done & ~grp_shared_dataflow_fu_225.pyramid_640_400_U0.fork_float_64000_U0.ap_done);
    assign proc_dep_vld_vec_14[4] = dl_detect_out ? proc_dep_vld_vec_14_reg[4] : (proc_14_data_FIFO_blk[4] | proc_14_data_PIPO_blk[4] | proc_14_start_FIFO_blk[4] | proc_14_TLF_FIFO_blk[4] | proc_14_input_sync_blk[4] | proc_14_output_sync_blk[4]);
    always @ (negedge dl_reset or posedge dl_clock) begin
        if (~dl_reset) begin
            proc_dep_vld_vec_14_reg <= 'b0;
        end
        else begin
            proc_dep_vld_vec_14_reg <= proc_dep_vld_vec_14;
        end
    end
    assign in_chan_dep_vld_vec_14[0] = dep_chan_vld_10_14;
    assign in_chan_dep_data_vec_14[55 : 0] = dep_chan_data_10_14;
    assign token_in_vec_14[0] = token_10_14;
    assign in_chan_dep_vld_vec_14[1] = dep_chan_vld_12_14;
    assign in_chan_dep_data_vec_14[111 : 56] = dep_chan_data_12_14;
    assign token_in_vec_14[1] = token_12_14;
    assign in_chan_dep_vld_vec_14[2] = dep_chan_vld_13_14;
    assign in_chan_dep_data_vec_14[167 : 112] = dep_chan_data_13_14;
    assign token_in_vec_14[2] = token_13_14;
    assign in_chan_dep_vld_vec_14[3] = dep_chan_vld_30_14;
    assign in_chan_dep_data_vec_14[223 : 168] = dep_chan_data_30_14;
    assign token_in_vec_14[3] = token_30_14;
    assign in_chan_dep_vld_vec_14[4] = dep_chan_vld_31_14;
    assign in_chan_dep_data_vec_14[279 : 224] = dep_chan_data_31_14;
    assign token_in_vec_14[4] = token_31_14;
    assign dep_chan_vld_14_10 = out_chan_dep_vld_vec_14[0];
    assign dep_chan_data_14_10 = out_chan_dep_data_14;
    assign token_14_10 = token_out_vec_14[0];
    assign dep_chan_vld_14_13 = out_chan_dep_vld_vec_14[1];
    assign dep_chan_data_14_13 = out_chan_dep_data_14;
    assign token_14_13 = token_out_vec_14[1];
    assign dep_chan_vld_14_30 = out_chan_dep_vld_vec_14[2];
    assign dep_chan_data_14_30 = out_chan_dep_data_14;
    assign token_14_30 = token_out_vec_14[2];
    assign dep_chan_vld_14_31 = out_chan_dep_vld_vec_14[3];
    assign dep_chan_data_14_31 = out_chan_dep_data_14;
    assign token_14_31 = token_out_vec_14[3];
    assign dep_chan_vld_14_12 = out_chan_dep_vld_vec_14[4];
    assign dep_chan_data_14_12 = out_chan_dep_data_14;
    assign token_14_12 = token_out_vec_14[4];

    // Process: grp_shared_dataflow_fu_225.pyramid_320_200_U0
    motion60_shared_hls_deadlock_detect_unit #(56, 15, 6, 6) motion60_shared_hls_deadlock_detect_unit_15 (
        .reset(dl_reset),
        .clock(dl_clock),
        .proc_dep_vld_vec(proc_dep_vld_vec_15),
        .in_chan_dep_vld_vec(in_chan_dep_vld_vec_15),
        .in_chan_dep_data_vec(in_chan_dep_data_vec_15),
        .token_in_vec(token_in_vec_15),
        .dl_detect_in(dl_detect_out),
        .origin(origin[15]),
        .token_clear(token_clear),
        .out_chan_dep_vld_vec(out_chan_dep_vld_vec_15),
        .out_chan_dep_data(out_chan_dep_data_15),
        .token_out_vec(token_out_vec_15),
        .dl_detect_out(dl_in_vec[15]));

    assign proc_15_data_FIFO_blk[0] = 1'b0 | (~grp_shared_dataflow_fu_225.pyramid_320_200_U0.stencil_320_200_false_U0.grp_stencil_320_200_false_Pipeline_horizontal_fu_118.g2_blk_n) | (~grp_shared_dataflow_fu_225.pyramid_320_200_U0.stencil_320_200_false_U0.g2_blk_n);
    assign proc_15_data_PIPO_blk[0] = 1'b0;
    assign proc_15_start_FIFO_blk[0] = 1'b0 | (~grp_shared_dataflow_fu_225.start_for_pyramid_320_200_U0_U.if_empty_n & grp_shared_dataflow_fu_225.pyramid_320_200_U0.ap_idle & ~grp_shared_dataflow_fu_225.start_for_pyramid_320_200_U0_U.if_write);
    assign proc_15_TLF_FIFO_blk[0] = 1'b0;
    assign proc_15_input_sync_blk[0] = 1'b0;
    assign proc_15_output_sync_blk[0] = 1'b0;
    assign proc_dep_vld_vec_15[0] = dl_detect_out ? proc_dep_vld_vec_15_reg[0] : (proc_15_data_FIFO_blk[0] | proc_15_data_PIPO_blk[0] | proc_15_start_FIFO_blk[0] | proc_15_TLF_FIFO_blk[0] | proc_15_input_sync_blk[0] | proc_15_output_sync_blk[0]);
    assign proc_15_data_FIFO_blk[1] = 1'b0 | (~grp_shared_dataflow_fu_225.pyramid_320_200_U0.stencil_320_200_false_U0.grp_stencil_320_200_false_Pipeline_horizontal_fu_118.g2_blk_n) | (~grp_shared_dataflow_fu_225.pyramid_320_200_U0.stencil_320_200_false_U0.g2_blk_n);
    assign proc_15_data_PIPO_blk[1] = 1'b0;
    assign proc_15_start_FIFO_blk[1] = 1'b0;
    assign proc_15_TLF_FIFO_blk[1] = 1'b0;
    assign proc_15_input_sync_blk[1] = 1'b0;
    assign proc_15_output_sync_blk[1] = 1'b0;
    assign proc_dep_vld_vec_15[1] = dl_detect_out ? proc_dep_vld_vec_15_reg[1] : (proc_15_data_FIFO_blk[1] | proc_15_data_PIPO_blk[1] | proc_15_start_FIFO_blk[1] | proc_15_TLF_FIFO_blk[1] | proc_15_input_sync_blk[1] | proc_15_output_sync_blk[1]);
    assign proc_15_data_FIFO_blk[2] = 1'b0 | (~grp_shared_dataflow_fu_225.pyramid_320_200_U0.combine_64000_false_U0.band2_blk_n);
    assign proc_15_data_PIPO_blk[2] = 1'b0;
    assign proc_15_start_FIFO_blk[2] = 1'b0;
    assign proc_15_TLF_FIFO_blk[2] = 1'b0;
    assign proc_15_input_sync_blk[2] = 1'b0;
    assign proc_15_output_sync_blk[2] = 1'b0;
    assign proc_dep_vld_vec_15[2] = dl_detect_out ? proc_dep_vld_vec_15_reg[2] : (proc_15_data_FIFO_blk[2] | proc_15_data_PIPO_blk[2] | proc_15_start_FIFO_blk[2] | proc_15_TLF_FIFO_blk[2] | proc_15_input_sync_blk[2] | proc_15_output_sync_blk[2]);
    assign proc_15_data_FIFO_blk[3] = 1'b0 | (~grp_shared_dataflow_fu_225.pyramid_320_200_U0.combine_64000_false_U0.band2_blk_n);
    assign proc_15_data_PIPO_blk[3] = 1'b0;
    assign proc_15_start_FIFO_blk[3] = 1'b0;
    assign proc_15_TLF_FIFO_blk[3] = 1'b0;
    assign proc_15_input_sync_blk[3] = 1'b0;
    assign proc_15_output_sync_blk[3] = 1'b0;
    assign proc_dep_vld_vec_15[3] = dl_detect_out ? proc_dep_vld_vec_15_reg[3] : (proc_15_data_FIFO_blk[3] | proc_15_data_PIPO_blk[3] | proc_15_start_FIFO_blk[3] | proc_15_TLF_FIFO_blk[3] | proc_15_input_sync_blk[3] | proc_15_output_sync_blk[3]);
    assign proc_15_data_FIFO_blk[4] = 1'b0 | (~grp_shared_dataflow_fu_225.pyramid_320_200_U0.fork_float_16000_U0.res_blk_n);
    assign proc_15_data_PIPO_blk[4] = 1'b0;
    assign proc_15_start_FIFO_blk[4] = 1'b0;
    assign proc_15_TLF_FIFO_blk[4] = 1'b0;
    assign proc_15_input_sync_blk[4] = 1'b0;
    assign proc_15_output_sync_blk[4] = 1'b0;
    assign proc_dep_vld_vec_15[4] = dl_detect_out ? proc_dep_vld_vec_15_reg[4] : (proc_15_data_FIFO_blk[4] | proc_15_data_PIPO_blk[4] | proc_15_start_FIFO_blk[4] | proc_15_TLF_FIFO_blk[4] | proc_15_input_sync_blk[4] | proc_15_output_sync_blk[4]);
    assign proc_15_data_FIFO_blk[5] = 1'b0 | (~grp_shared_dataflow_fu_225.pyramid_320_200_U0.fork_float_16000_U0.res_blk_n);
    assign proc_15_data_PIPO_blk[5] = 1'b0;
    assign proc_15_start_FIFO_blk[5] = 1'b0;
    assign proc_15_TLF_FIFO_blk[5] = 1'b0;
    assign proc_15_input_sync_blk[5] = 1'b0;
    assign proc_15_output_sync_blk[5] = 1'b0;
    assign proc_dep_vld_vec_15[5] = dl_detect_out ? proc_dep_vld_vec_15_reg[5] : (proc_15_data_FIFO_blk[5] | proc_15_data_PIPO_blk[5] | proc_15_start_FIFO_blk[5] | proc_15_TLF_FIFO_blk[5] | proc_15_input_sync_blk[5] | proc_15_output_sync_blk[5]);
    always @ (negedge dl_reset or posedge dl_clock) begin
        if (~dl_reset) begin
            proc_dep_vld_vec_15_reg <= 'b0;
        end
        else begin
            proc_dep_vld_vec_15_reg <= proc_dep_vld_vec_15;
        end
    end
    assign in_chan_dep_vld_vec_15[0] = dep_chan_vld_8_15;
    assign in_chan_dep_data_vec_15[55 : 0] = dep_chan_data_8_15;
    assign token_in_vec_15[0] = token_8_15;
    assign in_chan_dep_vld_vec_15[1] = dep_chan_vld_12_15;
    assign in_chan_dep_data_vec_15[111 : 56] = dep_chan_data_12_15;
    assign token_in_vec_15[1] = token_12_15;
    assign in_chan_dep_vld_vec_15[2] = dep_chan_vld_38_15;
    assign in_chan_dep_data_vec_15[167 : 112] = dep_chan_data_38_15;
    assign token_in_vec_15[2] = token_38_15;
    assign in_chan_dep_vld_vec_15[3] = dep_chan_vld_39_15;
    assign in_chan_dep_data_vec_15[223 : 168] = dep_chan_data_39_15;
    assign token_in_vec_15[3] = token_39_15;
    assign in_chan_dep_vld_vec_15[4] = dep_chan_vld_46_15;
    assign in_chan_dep_data_vec_15[279 : 224] = dep_chan_data_46_15;
    assign token_in_vec_15[4] = token_46_15;
    assign in_chan_dep_vld_vec_15[5] = dep_chan_vld_47_15;
    assign in_chan_dep_data_vec_15[335 : 280] = dep_chan_data_47_15;
    assign token_in_vec_15[5] = token_47_15;
    assign dep_chan_vld_15_8 = out_chan_dep_vld_vec_15[0];
    assign dep_chan_data_15_8 = out_chan_dep_data_15;
    assign token_15_8 = token_out_vec_15[0];
    assign dep_chan_vld_15_12 = out_chan_dep_vld_vec_15[1];
    assign dep_chan_data_15_12 = out_chan_dep_data_15;
    assign token_15_12 = token_out_vec_15[1];
    assign dep_chan_vld_15_38 = out_chan_dep_vld_vec_15[2];
    assign dep_chan_data_15_38 = out_chan_dep_data_15;
    assign token_15_38 = token_out_vec_15[2];
    assign dep_chan_vld_15_39 = out_chan_dep_vld_vec_15[3];
    assign dep_chan_data_15_39 = out_chan_dep_data_15;
    assign token_15_39 = token_out_vec_15[3];
    assign dep_chan_vld_15_46 = out_chan_dep_vld_vec_15[4];
    assign dep_chan_data_15_46 = out_chan_dep_data_15;
    assign token_15_46 = token_out_vec_15[4];
    assign dep_chan_vld_15_47 = out_chan_dep_vld_vec_15[5];
    assign dep_chan_data_15_47 = out_chan_dep_data_15;
    assign token_15_47 = token_out_vec_15[5];

    // Process: grp_shared_dataflow_fu_225.pyramid_320_200_U0.stencil_320_200_false_U0
    motion60_shared_hls_deadlock_detect_unit #(56, 16, 3, 3) motion60_shared_hls_deadlock_detect_unit_16 (
        .reset(dl_reset),
        .clock(dl_clock),
        .proc_dep_vld_vec(proc_dep_vld_vec_16),
        .in_chan_dep_vld_vec(in_chan_dep_vld_vec_16),
        .in_chan_dep_data_vec(in_chan_dep_data_vec_16),
        .token_in_vec(token_in_vec_16),
        .dl_detect_in(dl_detect_out),
        .origin(origin[16]),
        .token_clear(token_clear),
        .out_chan_dep_vld_vec(out_chan_dep_vld_vec_16),
        .out_chan_dep_data(out_chan_dep_data_16),
        .token_out_vec(token_out_vec_16),
        .dl_detect_out(dl_in_vec[16]));

    assign proc_16_data_FIFO_blk[0] = 1'b0 | (~grp_shared_dataflow_fu_225.pyramid_320_200_U0.stencil_320_200_false_U0.g2_blk_n) | (~grp_shared_dataflow_fu_225.pyramid_320_200_U0.stencil_320_200_false_U0.grp_stencil_320_200_false_Pipeline_horizontal_fu_118.g2_blk_n);
    assign proc_16_data_PIPO_blk[0] = 1'b0;
    assign proc_16_start_FIFO_blk[0] = 1'b0;
    assign proc_16_TLF_FIFO_blk[0] = 1'b0;
    assign proc_16_input_sync_blk[0] = 1'b0;
    assign proc_16_output_sync_blk[0] = 1'b0;
    assign proc_dep_vld_vec_16[0] = dl_detect_out ? proc_dep_vld_vec_16_reg[0] : (proc_16_data_FIFO_blk[0] | proc_16_data_PIPO_blk[0] | proc_16_start_FIFO_blk[0] | proc_16_TLF_FIFO_blk[0] | proc_16_input_sync_blk[0] | proc_16_output_sync_blk[0]);
    assign proc_16_data_FIFO_blk[1] = 1'b0 | (~grp_shared_dataflow_fu_225.pyramid_320_200_U0.stencil_320_200_false_U0.g2_blk_n) | (~grp_shared_dataflow_fu_225.pyramid_320_200_U0.stencil_320_200_false_U0.grp_stencil_320_200_false_Pipeline_horizontal_fu_118.g2_blk_n);
    assign proc_16_data_PIPO_blk[1] = 1'b0;
    assign proc_16_start_FIFO_blk[1] = 1'b0;
    assign proc_16_TLF_FIFO_blk[1] = 1'b0;
    assign proc_16_input_sync_blk[1] = 1'b0;
    assign proc_16_output_sync_blk[1] = 1'b0;
    assign proc_dep_vld_vec_16[1] = dl_detect_out ? proc_dep_vld_vec_16_reg[1] : (proc_16_data_FIFO_blk[1] | proc_16_data_PIPO_blk[1] | proc_16_start_FIFO_blk[1] | proc_16_TLF_FIFO_blk[1] | proc_16_input_sync_blk[1] | proc_16_output_sync_blk[1]);
    assign proc_16_data_FIFO_blk[2] = 1'b0 | (~grp_shared_dataflow_fu_225.pyramid_320_200_U0.stencil_320_200_false_U0.grp_stencil_320_200_false_Pipeline_vertical_fu_133.blur_blk_n);
    assign proc_16_data_PIPO_blk[2] = 1'b0;
    assign proc_16_start_FIFO_blk[2] = 1'b0 | (~grp_shared_dataflow_fu_225.pyramid_320_200_U0.start_for_blur_fork_64000_U0_U.if_full_n & grp_shared_dataflow_fu_225.pyramid_320_200_U0.stencil_320_200_false_U0.ap_start & ~grp_shared_dataflow_fu_225.pyramid_320_200_U0.stencil_320_200_false_U0.real_start & (trans_in_cnt_11 == trans_out_cnt_11) & ~grp_shared_dataflow_fu_225.pyramid_320_200_U0.start_for_blur_fork_64000_U0_U.if_read);
    assign proc_16_TLF_FIFO_blk[2] = 1'b0;
    assign proc_16_input_sync_blk[2] = 1'b0;
    assign proc_16_output_sync_blk[2] = 1'b0;
    assign proc_dep_vld_vec_16[2] = dl_detect_out ? proc_dep_vld_vec_16_reg[2] : (proc_16_data_FIFO_blk[2] | proc_16_data_PIPO_blk[2] | proc_16_start_FIFO_blk[2] | proc_16_TLF_FIFO_blk[2] | proc_16_input_sync_blk[2] | proc_16_output_sync_blk[2]);
    always @ (negedge dl_reset or posedge dl_clock) begin
        if (~dl_reset) begin
            proc_dep_vld_vec_16_reg <= 'b0;
        end
        else begin
            proc_dep_vld_vec_16_reg <= proc_dep_vld_vec_16;
        end
    end
    assign in_chan_dep_vld_vec_16[0] = dep_chan_vld_8_16;
    assign in_chan_dep_data_vec_16[55 : 0] = dep_chan_data_8_16;
    assign token_in_vec_16[0] = token_8_16;
    assign in_chan_dep_vld_vec_16[1] = dep_chan_vld_12_16;
    assign in_chan_dep_data_vec_16[111 : 56] = dep_chan_data_12_16;
    assign token_in_vec_16[1] = token_12_16;
    assign in_chan_dep_vld_vec_16[2] = dep_chan_vld_17_16;
    assign in_chan_dep_data_vec_16[167 : 112] = dep_chan_data_17_16;
    assign token_in_vec_16[2] = token_17_16;
    assign dep_chan_vld_16_8 = out_chan_dep_vld_vec_16[0];
    assign dep_chan_data_16_8 = out_chan_dep_data_16;
    assign token_16_8 = token_out_vec_16[0];
    assign dep_chan_vld_16_12 = out_chan_dep_vld_vec_16[1];
    assign dep_chan_data_16_12 = out_chan_dep_data_16;
    assign token_16_12 = token_out_vec_16[1];
    assign dep_chan_vld_16_17 = out_chan_dep_vld_vec_16[2];
    assign dep_chan_data_16_17 = out_chan_dep_data_16;
    assign token_16_17 = token_out_vec_16[2];

    // Process: grp_shared_dataflow_fu_225.pyramid_320_200_U0.blur_fork_64000_U0
    motion60_shared_hls_deadlock_detect_unit #(56, 17, 3, 3) motion60_shared_hls_deadlock_detect_unit_17 (
        .reset(dl_reset),
        .clock(dl_clock),
        .proc_dep_vld_vec(proc_dep_vld_vec_17),
        .in_chan_dep_vld_vec(in_chan_dep_vld_vec_17),
        .in_chan_dep_data_vec(in_chan_dep_data_vec_17),
        .token_in_vec(token_in_vec_17),
        .dl_detect_in(dl_detect_out),
        .origin(origin[17]),
        .token_clear(token_clear),
        .out_chan_dep_vld_vec(out_chan_dep_vld_vec_17),
        .out_chan_dep_data(out_chan_dep_data_17),
        .token_out_vec(token_out_vec_17),
        .dl_detect_out(dl_in_vec[17]));

    assign proc_17_data_FIFO_blk[0] = 1'b0 | (~grp_shared_dataflow_fu_225.pyramid_320_200_U0.blur_fork_64000_U0.blur_blk_n);
    assign proc_17_data_PIPO_blk[0] = 1'b0;
    assign proc_17_start_FIFO_blk[0] = 1'b0 | (~grp_shared_dataflow_fu_225.pyramid_320_200_U0.start_for_blur_fork_64000_U0_U.if_empty_n & grp_shared_dataflow_fu_225.pyramid_320_200_U0.blur_fork_64000_U0.ap_idle & ~grp_shared_dataflow_fu_225.pyramid_320_200_U0.start_for_blur_fork_64000_U0_U.if_write);
    assign proc_17_TLF_FIFO_blk[0] = 1'b0;
    assign proc_17_input_sync_blk[0] = 1'b0;
    assign proc_17_output_sync_blk[0] = 1'b0;
    assign proc_dep_vld_vec_17[0] = dl_detect_out ? proc_dep_vld_vec_17_reg[0] : (proc_17_data_FIFO_blk[0] | proc_17_data_PIPO_blk[0] | proc_17_start_FIFO_blk[0] | proc_17_TLF_FIFO_blk[0] | proc_17_input_sync_blk[0] | proc_17_output_sync_blk[0]);
    assign proc_17_data_FIFO_blk[1] = 1'b0 | (~grp_shared_dataflow_fu_225.pyramid_320_200_U0.blur_fork_64000_U0.full_blk_n);
    assign proc_17_data_PIPO_blk[1] = 1'b0;
    assign proc_17_start_FIFO_blk[1] = 1'b0 | (~grp_shared_dataflow_fu_225.pyramid_320_200_U0.start_for_combine_64000_false_U0_U.if_full_n & grp_shared_dataflow_fu_225.pyramid_320_200_U0.blur_fork_64000_U0.ap_start & ~grp_shared_dataflow_fu_225.pyramid_320_200_U0.blur_fork_64000_U0.real_start & (trans_in_cnt_12 == trans_out_cnt_12) & ~grp_shared_dataflow_fu_225.pyramid_320_200_U0.start_for_combine_64000_false_U0_U.if_read);
    assign proc_17_TLF_FIFO_blk[1] = 1'b0;
    assign proc_17_input_sync_blk[1] = 1'b0;
    assign proc_17_output_sync_blk[1] = 1'b0;
    assign proc_dep_vld_vec_17[1] = dl_detect_out ? proc_dep_vld_vec_17_reg[1] : (proc_17_data_FIFO_blk[1] | proc_17_data_PIPO_blk[1] | proc_17_start_FIFO_blk[1] | proc_17_TLF_FIFO_blk[1] | proc_17_input_sync_blk[1] | proc_17_output_sync_blk[1]);
    assign proc_17_data_FIFO_blk[2] = 1'b0 | (~grp_shared_dataflow_fu_225.pyramid_320_200_U0.blur_fork_64000_U0.dsinput_blk_n);
    assign proc_17_data_PIPO_blk[2] = 1'b0;
    assign proc_17_start_FIFO_blk[2] = 1'b0 | (~grp_shared_dataflow_fu_225.pyramid_320_200_U0.start_for_downsample_320_200_U0_U.if_full_n & grp_shared_dataflow_fu_225.pyramid_320_200_U0.blur_fork_64000_U0.ap_start & ~grp_shared_dataflow_fu_225.pyramid_320_200_U0.blur_fork_64000_U0.real_start & (trans_in_cnt_12 == trans_out_cnt_12) & ~grp_shared_dataflow_fu_225.pyramid_320_200_U0.start_for_downsample_320_200_U0_U.if_read);
    assign proc_17_TLF_FIFO_blk[2] = 1'b0;
    assign proc_17_input_sync_blk[2] = 1'b0;
    assign proc_17_output_sync_blk[2] = 1'b0;
    assign proc_dep_vld_vec_17[2] = dl_detect_out ? proc_dep_vld_vec_17_reg[2] : (proc_17_data_FIFO_blk[2] | proc_17_data_PIPO_blk[2] | proc_17_start_FIFO_blk[2] | proc_17_TLF_FIFO_blk[2] | proc_17_input_sync_blk[2] | proc_17_output_sync_blk[2]);
    always @ (negedge dl_reset or posedge dl_clock) begin
        if (~dl_reset) begin
            proc_dep_vld_vec_17_reg <= 'b0;
        end
        else begin
            proc_dep_vld_vec_17_reg <= proc_dep_vld_vec_17;
        end
    end
    assign in_chan_dep_vld_vec_17[0] = dep_chan_vld_16_17;
    assign in_chan_dep_data_vec_17[55 : 0] = dep_chan_data_16_17;
    assign token_in_vec_17[0] = token_16_17;
    assign in_chan_dep_vld_vec_17[1] = dep_chan_vld_18_17;
    assign in_chan_dep_data_vec_17[111 : 56] = dep_chan_data_18_17;
    assign token_in_vec_17[1] = token_18_17;
    assign in_chan_dep_vld_vec_17[2] = dep_chan_vld_21_17;
    assign in_chan_dep_data_vec_17[167 : 112] = dep_chan_data_21_17;
    assign token_in_vec_17[2] = token_21_17;
    assign dep_chan_vld_17_16 = out_chan_dep_vld_vec_17[0];
    assign dep_chan_data_17_16 = out_chan_dep_data_17;
    assign token_17_16 = token_out_vec_17[0];
    assign dep_chan_vld_17_21 = out_chan_dep_vld_vec_17[1];
    assign dep_chan_data_17_21 = out_chan_dep_data_17;
    assign token_17_21 = token_out_vec_17[1];
    assign dep_chan_vld_17_18 = out_chan_dep_vld_vec_17[2];
    assign dep_chan_data_17_18 = out_chan_dep_data_17;
    assign token_17_18 = token_out_vec_17[2];

    // Process: grp_shared_dataflow_fu_225.pyramid_320_200_U0.downsample_320_200_U0
    motion60_shared_hls_deadlock_detect_unit #(56, 18, 2, 2) motion60_shared_hls_deadlock_detect_unit_18 (
        .reset(dl_reset),
        .clock(dl_clock),
        .proc_dep_vld_vec(proc_dep_vld_vec_18),
        .in_chan_dep_vld_vec(in_chan_dep_vld_vec_18),
        .in_chan_dep_data_vec(in_chan_dep_data_vec_18),
        .token_in_vec(token_in_vec_18),
        .dl_detect_in(dl_detect_out),
        .origin(origin[18]),
        .token_clear(token_clear),
        .out_chan_dep_vld_vec(out_chan_dep_vld_vec_18),
        .out_chan_dep_data(out_chan_dep_data_18),
        .token_out_vec(token_out_vec_18),
        .dl_detect_out(dl_in_vec[18]));

    assign proc_18_data_FIFO_blk[0] = 1'b0 | (~grp_shared_dataflow_fu_225.pyramid_320_200_U0.downsample_320_200_U0.dsinput_blk_n);
    assign proc_18_data_PIPO_blk[0] = 1'b0;
    assign proc_18_start_FIFO_blk[0] = 1'b0 | (~grp_shared_dataflow_fu_225.pyramid_320_200_U0.start_for_downsample_320_200_U0_U.if_empty_n & grp_shared_dataflow_fu_225.pyramid_320_200_U0.downsample_320_200_U0.ap_idle & ~grp_shared_dataflow_fu_225.pyramid_320_200_U0.start_for_downsample_320_200_U0_U.if_write);
    assign proc_18_TLF_FIFO_blk[0] = 1'b0;
    assign proc_18_input_sync_blk[0] = 1'b0;
    assign proc_18_output_sync_blk[0] = 1'b0;
    assign proc_dep_vld_vec_18[0] = dl_detect_out ? proc_dep_vld_vec_18_reg[0] : (proc_18_data_FIFO_blk[0] | proc_18_data_PIPO_blk[0] | proc_18_start_FIFO_blk[0] | proc_18_TLF_FIFO_blk[0] | proc_18_input_sync_blk[0] | proc_18_output_sync_blk[0]);
    assign proc_18_data_FIFO_blk[1] = 1'b0 | (~grp_shared_dataflow_fu_225.pyramid_320_200_U0.downsample_320_200_U0.small_r_blk_n);
    assign proc_18_data_PIPO_blk[1] = 1'b0;
    assign proc_18_start_FIFO_blk[1] = 1'b0 | (~grp_shared_dataflow_fu_225.pyramid_320_200_U0.start_for_fork_float_16000_U0_U.if_full_n & grp_shared_dataflow_fu_225.pyramid_320_200_U0.downsample_320_200_U0.ap_start & ~grp_shared_dataflow_fu_225.pyramid_320_200_U0.downsample_320_200_U0.real_start & (trans_in_cnt_13 == trans_out_cnt_13) & ~grp_shared_dataflow_fu_225.pyramid_320_200_U0.start_for_fork_float_16000_U0_U.if_read);
    assign proc_18_TLF_FIFO_blk[1] = 1'b0;
    assign proc_18_input_sync_blk[1] = 1'b0;
    assign proc_18_output_sync_blk[1] = 1'b0;
    assign proc_dep_vld_vec_18[1] = dl_detect_out ? proc_dep_vld_vec_18_reg[1] : (proc_18_data_FIFO_blk[1] | proc_18_data_PIPO_blk[1] | proc_18_start_FIFO_blk[1] | proc_18_TLF_FIFO_blk[1] | proc_18_input_sync_blk[1] | proc_18_output_sync_blk[1]);
    always @ (negedge dl_reset or posedge dl_clock) begin
        if (~dl_reset) begin
            proc_dep_vld_vec_18_reg <= 'b0;
        end
        else begin
            proc_dep_vld_vec_18_reg <= proc_dep_vld_vec_18;
        end
    end
    assign in_chan_dep_vld_vec_18[0] = dep_chan_vld_17_18;
    assign in_chan_dep_data_vec_18[55 : 0] = dep_chan_data_17_18;
    assign token_in_vec_18[0] = token_17_18;
    assign in_chan_dep_vld_vec_18[1] = dep_chan_vld_19_18;
    assign in_chan_dep_data_vec_18[111 : 56] = dep_chan_data_19_18;
    assign token_in_vec_18[1] = token_19_18;
    assign dep_chan_vld_18_17 = out_chan_dep_vld_vec_18[0];
    assign dep_chan_data_18_17 = out_chan_dep_data_18;
    assign token_18_17 = token_out_vec_18[0];
    assign dep_chan_vld_18_19 = out_chan_dep_vld_vec_18[1];
    assign dep_chan_data_18_19 = out_chan_dep_data_18;
    assign token_18_19 = token_out_vec_18[1];

    // Process: grp_shared_dataflow_fu_225.pyramid_320_200_U0.fork_float_16000_U0
    motion60_shared_hls_deadlock_detect_unit #(56, 19, 5, 5) motion60_shared_hls_deadlock_detect_unit_19 (
        .reset(dl_reset),
        .clock(dl_clock),
        .proc_dep_vld_vec(proc_dep_vld_vec_19),
        .in_chan_dep_vld_vec(in_chan_dep_vld_vec_19),
        .in_chan_dep_data_vec(in_chan_dep_data_vec_19),
        .token_in_vec(token_in_vec_19),
        .dl_detect_in(dl_detect_out),
        .origin(origin[19]),
        .token_clear(token_clear),
        .out_chan_dep_vld_vec(out_chan_dep_vld_vec_19),
        .out_chan_dep_data(out_chan_dep_data_19),
        .token_out_vec(token_out_vec_19),
        .dl_detect_out(dl_in_vec[19]));

    assign proc_19_data_FIFO_blk[0] = 1'b0 | (~grp_shared_dataflow_fu_225.pyramid_320_200_U0.fork_float_16000_U0.small_r_blk_n);
    assign proc_19_data_PIPO_blk[0] = 1'b0;
    assign proc_19_start_FIFO_blk[0] = 1'b0 | (~grp_shared_dataflow_fu_225.pyramid_320_200_U0.start_for_fork_float_16000_U0_U.if_empty_n & grp_shared_dataflow_fu_225.pyramid_320_200_U0.fork_float_16000_U0.ap_idle & ~grp_shared_dataflow_fu_225.pyramid_320_200_U0.start_for_fork_float_16000_U0_U.if_write);
    assign proc_19_TLF_FIFO_blk[0] = 1'b0;
    assign proc_19_input_sync_blk[0] = 1'b0;
    assign proc_19_output_sync_blk[0] = 1'b0;
    assign proc_dep_vld_vec_19[0] = dl_detect_out ? proc_dep_vld_vec_19_reg[0] : (proc_19_data_FIFO_blk[0] | proc_19_data_PIPO_blk[0] | proc_19_start_FIFO_blk[0] | proc_19_TLF_FIFO_blk[0] | proc_19_input_sync_blk[0] | proc_19_output_sync_blk[0]);
    assign proc_19_data_FIFO_blk[1] = 1'b0 | (~grp_shared_dataflow_fu_225.pyramid_320_200_U0.fork_float_16000_U0.res_blk_n);
    assign proc_19_data_PIPO_blk[1] = 1'b0;
    assign proc_19_start_FIFO_blk[1] = 1'b0;
    assign proc_19_TLF_FIFO_blk[1] = 1'b0;
    assign proc_19_input_sync_blk[1] = 1'b0;
    assign proc_19_output_sync_blk[1] = 1'b0;
    assign proc_dep_vld_vec_19[1] = dl_detect_out ? proc_dep_vld_vec_19_reg[1] : (proc_19_data_FIFO_blk[1] | proc_19_data_PIPO_blk[1] | proc_19_start_FIFO_blk[1] | proc_19_TLF_FIFO_blk[1] | proc_19_input_sync_blk[1] | proc_19_output_sync_blk[1]);
    assign proc_19_data_FIFO_blk[2] = 1'b0 | (~grp_shared_dataflow_fu_225.pyramid_320_200_U0.fork_float_16000_U0.res_blk_n);
    assign proc_19_data_PIPO_blk[2] = 1'b0;
    assign proc_19_start_FIFO_blk[2] = 1'b0;
    assign proc_19_TLF_FIFO_blk[2] = 1'b0;
    assign proc_19_input_sync_blk[2] = 1'b0;
    assign proc_19_output_sync_blk[2] = 1'b0;
    assign proc_dep_vld_vec_19[2] = dl_detect_out ? proc_dep_vld_vec_19_reg[2] : (proc_19_data_FIFO_blk[2] | proc_19_data_PIPO_blk[2] | proc_19_start_FIFO_blk[2] | proc_19_TLF_FIFO_blk[2] | proc_19_input_sync_blk[2] | proc_19_output_sync_blk[2]);
    assign proc_19_data_FIFO_blk[3] = 1'b0 | (~grp_shared_dataflow_fu_225.pyramid_320_200_U0.fork_float_16000_U0.usinput_blk_n);
    assign proc_19_data_PIPO_blk[3] = 1'b0;
    assign proc_19_start_FIFO_blk[3] = 1'b0 | (~grp_shared_dataflow_fu_225.pyramid_320_200_U0.start_for_upsample_160_100_U0_U.if_full_n & grp_shared_dataflow_fu_225.pyramid_320_200_U0.fork_float_16000_U0.ap_start & ~grp_shared_dataflow_fu_225.pyramid_320_200_U0.fork_float_16000_U0.real_start & (trans_in_cnt_14 == trans_out_cnt_14) & ~grp_shared_dataflow_fu_225.pyramid_320_200_U0.start_for_upsample_160_100_U0_U.if_read);
    assign proc_19_TLF_FIFO_blk[3] = 1'b0;
    assign proc_19_input_sync_blk[3] = 1'b0;
    assign proc_19_output_sync_blk[3] = 1'b0;
    assign proc_dep_vld_vec_19[3] = dl_detect_out ? proc_dep_vld_vec_19_reg[3] : (proc_19_data_FIFO_blk[3] | proc_19_data_PIPO_blk[3] | proc_19_start_FIFO_blk[3] | proc_19_TLF_FIFO_blk[3] | proc_19_input_sync_blk[3] | proc_19_output_sync_blk[3]);
    assign proc_19_data_FIFO_blk[4] = 1'b0;
    assign proc_19_data_PIPO_blk[4] = 1'b0;
    assign proc_19_start_FIFO_blk[4] = 1'b0;
    assign proc_19_TLF_FIFO_blk[4] = 1'b0;
    assign proc_19_input_sync_blk[4] = 1'b0;
    assign proc_19_output_sync_blk[4] = 1'b0 | (ap_done_reg_8 & grp_shared_dataflow_fu_225.pyramid_320_200_U0.fork_float_16000_U0.ap_done & ~grp_shared_dataflow_fu_225.pyramid_320_200_U0.combine_64000_false_U0.ap_done);
    assign proc_dep_vld_vec_19[4] = dl_detect_out ? proc_dep_vld_vec_19_reg[4] : (proc_19_data_FIFO_blk[4] | proc_19_data_PIPO_blk[4] | proc_19_start_FIFO_blk[4] | proc_19_TLF_FIFO_blk[4] | proc_19_input_sync_blk[4] | proc_19_output_sync_blk[4]);
    always @ (negedge dl_reset or posedge dl_clock) begin
        if (~dl_reset) begin
            proc_dep_vld_vec_19_reg <= 'b0;
        end
        else begin
            proc_dep_vld_vec_19_reg <= proc_dep_vld_vec_19;
        end
    end
    assign in_chan_dep_vld_vec_19[0] = dep_chan_vld_18_19;
    assign in_chan_dep_data_vec_19[55 : 0] = dep_chan_data_18_19;
    assign token_in_vec_19[0] = token_18_19;
    assign in_chan_dep_vld_vec_19[1] = dep_chan_vld_20_19;
    assign in_chan_dep_data_vec_19[111 : 56] = dep_chan_data_20_19;
    assign token_in_vec_19[1] = token_20_19;
    assign in_chan_dep_vld_vec_19[2] = dep_chan_vld_21_19;
    assign in_chan_dep_data_vec_19[167 : 112] = dep_chan_data_21_19;
    assign token_in_vec_19[2] = token_21_19;
    assign in_chan_dep_vld_vec_19[3] = dep_chan_vld_46_19;
    assign in_chan_dep_data_vec_19[223 : 168] = dep_chan_data_46_19;
    assign token_in_vec_19[3] = token_46_19;
    assign in_chan_dep_vld_vec_19[4] = dep_chan_vld_47_19;
    assign in_chan_dep_data_vec_19[279 : 224] = dep_chan_data_47_19;
    assign token_in_vec_19[4] = token_47_19;
    assign dep_chan_vld_19_18 = out_chan_dep_vld_vec_19[0];
    assign dep_chan_data_19_18 = out_chan_dep_data_19;
    assign token_19_18 = token_out_vec_19[0];
    assign dep_chan_vld_19_46 = out_chan_dep_vld_vec_19[1];
    assign dep_chan_data_19_46 = out_chan_dep_data_19;
    assign token_19_46 = token_out_vec_19[1];
    assign dep_chan_vld_19_47 = out_chan_dep_vld_vec_19[2];
    assign dep_chan_data_19_47 = out_chan_dep_data_19;
    assign token_19_47 = token_out_vec_19[2];
    assign dep_chan_vld_19_20 = out_chan_dep_vld_vec_19[3];
    assign dep_chan_data_19_20 = out_chan_dep_data_19;
    assign token_19_20 = token_out_vec_19[3];
    assign dep_chan_vld_19_21 = out_chan_dep_vld_vec_19[4];
    assign dep_chan_data_19_21 = out_chan_dep_data_19;
    assign token_19_21 = token_out_vec_19[4];

    // Process: grp_shared_dataflow_fu_225.pyramid_320_200_U0.upsample_160_100_U0
    motion60_shared_hls_deadlock_detect_unit #(56, 20, 2, 2) motion60_shared_hls_deadlock_detect_unit_20 (
        .reset(dl_reset),
        .clock(dl_clock),
        .proc_dep_vld_vec(proc_dep_vld_vec_20),
        .in_chan_dep_vld_vec(in_chan_dep_vld_vec_20),
        .in_chan_dep_data_vec(in_chan_dep_data_vec_20),
        .token_in_vec(token_in_vec_20),
        .dl_detect_in(dl_detect_out),
        .origin(origin[20]),
        .token_clear(token_clear),
        .out_chan_dep_vld_vec(out_chan_dep_vld_vec_20),
        .out_chan_dep_data(out_chan_dep_data_20),
        .token_out_vec(token_out_vec_20),
        .dl_detect_out(dl_in_vec[20]));

    assign proc_20_data_FIFO_blk[0] = 1'b0 | (~grp_shared_dataflow_fu_225.pyramid_320_200_U0.upsample_160_100_U0.grp_upsample_160_100_Pipeline_VITIS_LOOP_98_2_fu_89.usinput_blk_n);
    assign proc_20_data_PIPO_blk[0] = 1'b0;
    assign proc_20_start_FIFO_blk[0] = 1'b0 | (~grp_shared_dataflow_fu_225.pyramid_320_200_U0.start_for_upsample_160_100_U0_U.if_empty_n & grp_shared_dataflow_fu_225.pyramid_320_200_U0.upsample_160_100_U0.ap_idle & ~grp_shared_dataflow_fu_225.pyramid_320_200_U0.start_for_upsample_160_100_U0_U.if_write);
    assign proc_20_TLF_FIFO_blk[0] = 1'b0;
    assign proc_20_input_sync_blk[0] = 1'b0;
    assign proc_20_output_sync_blk[0] = 1'b0;
    assign proc_dep_vld_vec_20[0] = dl_detect_out ? proc_dep_vld_vec_20_reg[0] : (proc_20_data_FIFO_blk[0] | proc_20_data_PIPO_blk[0] | proc_20_start_FIFO_blk[0] | proc_20_TLF_FIFO_blk[0] | proc_20_input_sync_blk[0] | proc_20_output_sync_blk[0]);
    assign proc_20_data_FIFO_blk[1] = 1'b0 | (~grp_shared_dataflow_fu_225.pyramid_320_200_U0.upsample_160_100_U0.grp_upsample_160_100_Pipeline_VITIS_LOOP_104_3_fu_98.large_r_blk_n);
    assign proc_20_data_PIPO_blk[1] = 1'b0;
    assign proc_20_start_FIFO_blk[1] = 1'b0;
    assign proc_20_TLF_FIFO_blk[1] = 1'b0;
    assign proc_20_input_sync_blk[1] = 1'b0;
    assign proc_20_output_sync_blk[1] = 1'b0;
    assign proc_dep_vld_vec_20[1] = dl_detect_out ? proc_dep_vld_vec_20_reg[1] : (proc_20_data_FIFO_blk[1] | proc_20_data_PIPO_blk[1] | proc_20_start_FIFO_blk[1] | proc_20_TLF_FIFO_blk[1] | proc_20_input_sync_blk[1] | proc_20_output_sync_blk[1]);
    always @ (negedge dl_reset or posedge dl_clock) begin
        if (~dl_reset) begin
            proc_dep_vld_vec_20_reg <= 'b0;
        end
        else begin
            proc_dep_vld_vec_20_reg <= proc_dep_vld_vec_20;
        end
    end
    assign in_chan_dep_vld_vec_20[0] = dep_chan_vld_19_20;
    assign in_chan_dep_data_vec_20[55 : 0] = dep_chan_data_19_20;
    assign token_in_vec_20[0] = token_19_20;
    assign in_chan_dep_vld_vec_20[1] = dep_chan_vld_21_20;
    assign in_chan_dep_data_vec_20[111 : 56] = dep_chan_data_21_20;
    assign token_in_vec_20[1] = token_21_20;
    assign dep_chan_vld_20_19 = out_chan_dep_vld_vec_20[0];
    assign dep_chan_data_20_19 = out_chan_dep_data_20;
    assign token_20_19 = token_out_vec_20[0];
    assign dep_chan_vld_20_21 = out_chan_dep_vld_vec_20[1];
    assign dep_chan_data_20_21 = out_chan_dep_data_20;
    assign token_20_21 = token_out_vec_20[1];

    // Process: grp_shared_dataflow_fu_225.pyramid_320_200_U0.combine_64000_false_U0
    motion60_shared_hls_deadlock_detect_unit #(56, 21, 5, 5) motion60_shared_hls_deadlock_detect_unit_21 (
        .reset(dl_reset),
        .clock(dl_clock),
        .proc_dep_vld_vec(proc_dep_vld_vec_21),
        .in_chan_dep_vld_vec(in_chan_dep_vld_vec_21),
        .in_chan_dep_data_vec(in_chan_dep_data_vec_21),
        .token_in_vec(token_in_vec_21),
        .dl_detect_in(dl_detect_out),
        .origin(origin[21]),
        .token_clear(token_clear),
        .out_chan_dep_vld_vec(out_chan_dep_vld_vec_21),
        .out_chan_dep_data(out_chan_dep_data_21),
        .token_out_vec(token_out_vec_21),
        .dl_detect_out(dl_in_vec[21]));

    assign proc_21_data_FIFO_blk[0] = 1'b0 | (~grp_shared_dataflow_fu_225.pyramid_320_200_U0.combine_64000_false_U0.full_blk_n);
    assign proc_21_data_PIPO_blk[0] = 1'b0;
    assign proc_21_start_FIFO_blk[0] = 1'b0 | (~grp_shared_dataflow_fu_225.pyramid_320_200_U0.start_for_combine_64000_false_U0_U.if_empty_n & grp_shared_dataflow_fu_225.pyramid_320_200_U0.combine_64000_false_U0.ap_idle & ~grp_shared_dataflow_fu_225.pyramid_320_200_U0.start_for_combine_64000_false_U0_U.if_write);
    assign proc_21_TLF_FIFO_blk[0] = 1'b0;
    assign proc_21_input_sync_blk[0] = 1'b0;
    assign proc_21_output_sync_blk[0] = 1'b0;
    assign proc_dep_vld_vec_21[0] = dl_detect_out ? proc_dep_vld_vec_21_reg[0] : (proc_21_data_FIFO_blk[0] | proc_21_data_PIPO_blk[0] | proc_21_start_FIFO_blk[0] | proc_21_TLF_FIFO_blk[0] | proc_21_input_sync_blk[0] | proc_21_output_sync_blk[0]);
    assign proc_21_data_FIFO_blk[1] = 1'b0 | (~grp_shared_dataflow_fu_225.pyramid_320_200_U0.combine_64000_false_U0.large_r_blk_n);
    assign proc_21_data_PIPO_blk[1] = 1'b0;
    assign proc_21_start_FIFO_blk[1] = 1'b0;
    assign proc_21_TLF_FIFO_blk[1] = 1'b0;
    assign proc_21_input_sync_blk[1] = 1'b0;
    assign proc_21_output_sync_blk[1] = 1'b0;
    assign proc_dep_vld_vec_21[1] = dl_detect_out ? proc_dep_vld_vec_21_reg[1] : (proc_21_data_FIFO_blk[1] | proc_21_data_PIPO_blk[1] | proc_21_start_FIFO_blk[1] | proc_21_TLF_FIFO_blk[1] | proc_21_input_sync_blk[1] | proc_21_output_sync_blk[1]);
    assign proc_21_data_FIFO_blk[2] = 1'b0 | (~grp_shared_dataflow_fu_225.pyramid_320_200_U0.combine_64000_false_U0.band2_blk_n);
    assign proc_21_data_PIPO_blk[2] = 1'b0;
    assign proc_21_start_FIFO_blk[2] = 1'b0;
    assign proc_21_TLF_FIFO_blk[2] = 1'b0;
    assign proc_21_input_sync_blk[2] = 1'b0;
    assign proc_21_output_sync_blk[2] = 1'b0;
    assign proc_dep_vld_vec_21[2] = dl_detect_out ? proc_dep_vld_vec_21_reg[2] : (proc_21_data_FIFO_blk[2] | proc_21_data_PIPO_blk[2] | proc_21_start_FIFO_blk[2] | proc_21_TLF_FIFO_blk[2] | proc_21_input_sync_blk[2] | proc_21_output_sync_blk[2]);
    assign proc_21_data_FIFO_blk[3] = 1'b0 | (~grp_shared_dataflow_fu_225.pyramid_320_200_U0.combine_64000_false_U0.band2_blk_n);
    assign proc_21_data_PIPO_blk[3] = 1'b0;
    assign proc_21_start_FIFO_blk[3] = 1'b0;
    assign proc_21_TLF_FIFO_blk[3] = 1'b0;
    assign proc_21_input_sync_blk[3] = 1'b0;
    assign proc_21_output_sync_blk[3] = 1'b0;
    assign proc_dep_vld_vec_21[3] = dl_detect_out ? proc_dep_vld_vec_21_reg[3] : (proc_21_data_FIFO_blk[3] | proc_21_data_PIPO_blk[3] | proc_21_start_FIFO_blk[3] | proc_21_TLF_FIFO_blk[3] | proc_21_input_sync_blk[3] | proc_21_output_sync_blk[3]);
    assign proc_21_data_FIFO_blk[4] = 1'b0;
    assign proc_21_data_PIPO_blk[4] = 1'b0;
    assign proc_21_start_FIFO_blk[4] = 1'b0;
    assign proc_21_TLF_FIFO_blk[4] = 1'b0;
    assign proc_21_input_sync_blk[4] = 1'b0;
    assign proc_21_output_sync_blk[4] = 1'b0 | (ap_done_reg_9 & grp_shared_dataflow_fu_225.pyramid_320_200_U0.combine_64000_false_U0.ap_done & ~grp_shared_dataflow_fu_225.pyramid_320_200_U0.fork_float_16000_U0.ap_done);
    assign proc_dep_vld_vec_21[4] = dl_detect_out ? proc_dep_vld_vec_21_reg[4] : (proc_21_data_FIFO_blk[4] | proc_21_data_PIPO_blk[4] | proc_21_start_FIFO_blk[4] | proc_21_TLF_FIFO_blk[4] | proc_21_input_sync_blk[4] | proc_21_output_sync_blk[4]);
    always @ (negedge dl_reset or posedge dl_clock) begin
        if (~dl_reset) begin
            proc_dep_vld_vec_21_reg <= 'b0;
        end
        else begin
            proc_dep_vld_vec_21_reg <= proc_dep_vld_vec_21;
        end
    end
    assign in_chan_dep_vld_vec_21[0] = dep_chan_vld_17_21;
    assign in_chan_dep_data_vec_21[55 : 0] = dep_chan_data_17_21;
    assign token_in_vec_21[0] = token_17_21;
    assign in_chan_dep_vld_vec_21[1] = dep_chan_vld_19_21;
    assign in_chan_dep_data_vec_21[111 : 56] = dep_chan_data_19_21;
    assign token_in_vec_21[1] = token_19_21;
    assign in_chan_dep_vld_vec_21[2] = dep_chan_vld_20_21;
    assign in_chan_dep_data_vec_21[167 : 112] = dep_chan_data_20_21;
    assign token_in_vec_21[2] = token_20_21;
    assign in_chan_dep_vld_vec_21[3] = dep_chan_vld_38_21;
    assign in_chan_dep_data_vec_21[223 : 168] = dep_chan_data_38_21;
    assign token_in_vec_21[3] = token_38_21;
    assign in_chan_dep_vld_vec_21[4] = dep_chan_vld_39_21;
    assign in_chan_dep_data_vec_21[279 : 224] = dep_chan_data_39_21;
    assign token_in_vec_21[4] = token_39_21;
    assign dep_chan_vld_21_17 = out_chan_dep_vld_vec_21[0];
    assign dep_chan_data_21_17 = out_chan_dep_data_21;
    assign token_21_17 = token_out_vec_21[0];
    assign dep_chan_vld_21_20 = out_chan_dep_vld_vec_21[1];
    assign dep_chan_data_21_20 = out_chan_dep_data_21;
    assign token_21_20 = token_out_vec_21[1];
    assign dep_chan_vld_21_38 = out_chan_dep_vld_vec_21[2];
    assign dep_chan_data_21_38 = out_chan_dep_data_21;
    assign token_21_38 = token_out_vec_21[2];
    assign dep_chan_vld_21_39 = out_chan_dep_vld_vec_21[3];
    assign dep_chan_data_21_39 = out_chan_dep_data_21;
    assign token_21_39 = token_out_vec_21[3];
    assign dep_chan_vld_21_19 = out_chan_dep_vld_vec_21[4];
    assign dep_chan_data_21_19 = out_chan_dep_data_21;
    assign token_21_19 = token_out_vec_21[4];

    // Process: grp_shared_dataflow_fu_225.phase_band_1280_800_U0
    motion60_shared_hls_deadlock_detect_unit #(56, 22, 8, 8) motion60_shared_hls_deadlock_detect_unit_22 (
        .reset(dl_reset),
        .clock(dl_clock),
        .proc_dep_vld_vec(proc_dep_vld_vec_22),
        .in_chan_dep_vld_vec(in_chan_dep_vld_vec_22),
        .in_chan_dep_data_vec(in_chan_dep_data_vec_22),
        .token_in_vec(token_in_vec_22),
        .dl_detect_in(dl_detect_out),
        .origin(origin[22]),
        .token_clear(token_clear),
        .out_chan_dep_vld_vec(out_chan_dep_vld_vec_22),
        .out_chan_dep_data(out_chan_dep_data_22),
        .token_out_vec(token_out_vec_22),
        .dl_detect_out(dl_in_vec[22]));

    assign proc_22_data_FIFO_blk[0] = 1'b0 | (~grp_shared_dataflow_fu_225.phase_band_1280_800_U0.stencil_1280_800_true_U0.grp_stencil_1280_800_true_Pipeline_horizontal_fu_158.band0_blk_n) | (~grp_shared_dataflow_fu_225.phase_band_1280_800_U0.stencil_1280_800_true_U0.band0_blk_n);
    assign proc_22_data_PIPO_blk[0] = 1'b0;
    assign proc_22_start_FIFO_blk[0] = 1'b0;
    assign proc_22_TLF_FIFO_blk[0] = 1'b0;
    assign proc_22_input_sync_blk[0] = 1'b0;
    assign proc_22_output_sync_blk[0] = 1'b0;
    assign proc_dep_vld_vec_22[0] = dl_detect_out ? proc_dep_vld_vec_22_reg[0] : (proc_22_data_FIFO_blk[0] | proc_22_data_PIPO_blk[0] | proc_22_start_FIFO_blk[0] | proc_22_TLF_FIFO_blk[0] | proc_22_input_sync_blk[0] | proc_22_output_sync_blk[0]);
    assign proc_22_data_FIFO_blk[1] = 1'b0 | (~grp_shared_dataflow_fu_225.phase_band_1280_800_U0.stencil_1280_800_true_U0.grp_stencil_1280_800_true_Pipeline_horizontal_fu_158.band0_blk_n) | (~grp_shared_dataflow_fu_225.phase_band_1280_800_U0.stencil_1280_800_true_U0.band0_blk_n);
    assign proc_22_data_PIPO_blk[1] = 1'b0;
    assign proc_22_start_FIFO_blk[1] = 1'b0;
    assign proc_22_TLF_FIFO_blk[1] = 1'b0;
    assign proc_22_input_sync_blk[1] = 1'b0;
    assign proc_22_output_sync_blk[1] = 1'b0;
    assign proc_dep_vld_vec_22[1] = dl_detect_out ? proc_dep_vld_vec_22_reg[1] : (proc_22_data_FIFO_blk[1] | proc_22_data_PIPO_blk[1] | proc_22_start_FIFO_blk[1] | proc_22_TLF_FIFO_blk[1] | proc_22_input_sync_blk[1] | proc_22_output_sync_blk[1]);
    assign proc_22_data_FIFO_blk[2] = 1'b0 | (~grp_shared_dataflow_fu_225.phase_band_1280_800_U0.phase_core_shared_U0.grp_phase_dataflow_fu_130.compute_phase8_U0.p2_blk_n);
    assign proc_22_data_PIPO_blk[2] = 1'b0;
    assign proc_22_start_FIFO_blk[2] = 1'b0 | (~grp_shared_dataflow_fu_225.start_for_reconstruct_1280_800_U0_U.if_full_n & grp_shared_dataflow_fu_225.phase_band_1280_800_U0.ap_start & ~grp_shared_dataflow_fu_225.phase_band_1280_800_U0.real_start & (trans_in_cnt_31 == trans_out_cnt_31) & ~grp_shared_dataflow_fu_225.start_for_reconstruct_1280_800_U0_U.if_read);
    assign proc_22_TLF_FIFO_blk[2] = 1'b0;
    assign proc_22_input_sync_blk[2] = 1'b0;
    assign proc_22_output_sync_blk[2] = 1'b0;
    assign proc_dep_vld_vec_22[2] = dl_detect_out ? proc_dep_vld_vec_22_reg[2] : (proc_22_data_FIFO_blk[2] | proc_22_data_PIPO_blk[2] | proc_22_start_FIFO_blk[2] | proc_22_TLF_FIFO_blk[2] | proc_22_input_sync_blk[2] | proc_22_output_sync_blk[2]);
    assign proc_22_data_FIFO_blk[3] = 1'b0 | (~grp_shared_dataflow_fu_225.phase_band_1280_800_U0.phase_core_shared_U0.grp_phase_dataflow_fu_130.compute_phase8_U0.p2_blk_n);
    assign proc_22_data_PIPO_blk[3] = 1'b0;
    assign proc_22_start_FIFO_blk[3] = 1'b0;
    assign proc_22_TLF_FIFO_blk[3] = 1'b0;
    assign proc_22_input_sync_blk[3] = 1'b0;
    assign proc_22_output_sync_blk[3] = 1'b0;
    assign proc_dep_vld_vec_22[3] = dl_detect_out ? proc_dep_vld_vec_22_reg[3] : (proc_22_data_FIFO_blk[3] | proc_22_data_PIPO_blk[3] | proc_22_start_FIFO_blk[3] | proc_22_TLF_FIFO_blk[3] | proc_22_input_sync_blk[3] | proc_22_output_sync_blk[3]);
    assign proc_22_data_FIFO_blk[4] = 1'b0;
    assign proc_22_data_PIPO_blk[4] = 1'b0;
    assign proc_22_start_FIFO_blk[4] = 1'b0;
    assign proc_22_TLF_FIFO_blk[4] = 1'b0;
    assign proc_22_input_sync_blk[4] = 1'b0 | (grp_shared_dataflow_fu_225.ap_sync_phase_band_1280_800_U0_ap_ready & grp_shared_dataflow_fu_225.phase_band_1280_800_U0.ap_idle & ~grp_shared_dataflow_fu_225.ap_sync_read_image_U0_ap_ready);
    assign proc_22_output_sync_blk[4] = 1'b0;
    assign proc_dep_vld_vec_22[4] = dl_detect_out ? proc_dep_vld_vec_22_reg[4] : (proc_22_data_FIFO_blk[4] | proc_22_data_PIPO_blk[4] | proc_22_start_FIFO_blk[4] | proc_22_TLF_FIFO_blk[4] | proc_22_input_sync_blk[4] | proc_22_output_sync_blk[4]);
    assign proc_22_data_FIFO_blk[5] = 1'b0;
    assign proc_22_data_PIPO_blk[5] = 1'b0;
    assign proc_22_start_FIFO_blk[5] = 1'b0;
    assign proc_22_TLF_FIFO_blk[5] = 1'b0;
    assign proc_22_input_sync_blk[5] = 1'b0 | (grp_shared_dataflow_fu_225.ap_sync_phase_band_1280_800_U0_ap_ready & grp_shared_dataflow_fu_225.phase_band_1280_800_U0.ap_idle & ~grp_shared_dataflow_fu_225.ap_sync_phase_band_640_400_U0_ap_ready);
    assign proc_22_output_sync_blk[5] = 1'b0 | (ap_done_reg_0 & grp_shared_dataflow_fu_225.phase_band_1280_800_U0.ap_done & ~grp_shared_dataflow_fu_225.phase_band_640_400_U0.ap_done);
    assign proc_dep_vld_vec_22[5] = dl_detect_out ? proc_dep_vld_vec_22_reg[5] : (proc_22_data_FIFO_blk[5] | proc_22_data_PIPO_blk[5] | proc_22_start_FIFO_blk[5] | proc_22_TLF_FIFO_blk[5] | proc_22_input_sync_blk[5] | proc_22_output_sync_blk[5]);
    assign proc_22_data_FIFO_blk[6] = 1'b0;
    assign proc_22_data_PIPO_blk[6] = 1'b0;
    assign proc_22_start_FIFO_blk[6] = 1'b0;
    assign proc_22_TLF_FIFO_blk[6] = 1'b0;
    assign proc_22_input_sync_blk[6] = 1'b0 | (grp_shared_dataflow_fu_225.ap_sync_phase_band_1280_800_U0_ap_ready & grp_shared_dataflow_fu_225.phase_band_1280_800_U0.ap_idle & ~grp_shared_dataflow_fu_225.ap_sync_phase_band_320_200_U0_ap_ready);
    assign proc_22_output_sync_blk[6] = 1'b0 | (ap_done_reg_0 & grp_shared_dataflow_fu_225.phase_band_1280_800_U0.ap_done & ~grp_shared_dataflow_fu_225.phase_band_320_200_U0.ap_done);
    assign proc_dep_vld_vec_22[6] = dl_detect_out ? proc_dep_vld_vec_22_reg[6] : (proc_22_data_FIFO_blk[6] | proc_22_data_PIPO_blk[6] | proc_22_start_FIFO_blk[6] | proc_22_TLF_FIFO_blk[6] | proc_22_input_sync_blk[6] | proc_22_output_sync_blk[6]);
    assign proc_22_data_FIFO_blk[7] = 1'b0;
    assign proc_22_data_PIPO_blk[7] = 1'b0;
    assign proc_22_start_FIFO_blk[7] = 1'b0;
    assign proc_22_TLF_FIFO_blk[7] = 1'b0;
    assign proc_22_input_sync_blk[7] = 1'b0;
    assign proc_22_output_sync_blk[7] = 1'b0 | (ap_done_reg_0 & grp_shared_dataflow_fu_225.phase_band_1280_800_U0.ap_done & ~grp_shared_dataflow_fu_225.write_image_U0.ap_done);
    assign proc_dep_vld_vec_22[7] = dl_detect_out ? proc_dep_vld_vec_22_reg[7] : (proc_22_data_FIFO_blk[7] | proc_22_data_PIPO_blk[7] | proc_22_start_FIFO_blk[7] | proc_22_TLF_FIFO_blk[7] | proc_22_input_sync_blk[7] | proc_22_output_sync_blk[7]);
    always @ (negedge dl_reset or posedge dl_clock) begin
        if (~dl_reset) begin
            proc_dep_vld_vec_22_reg <= 'b0;
        end
        else begin
            proc_dep_vld_vec_22_reg <= proc_dep_vld_vec_22;
        end
    end
    assign in_chan_dep_vld_vec_22[0] = dep_chan_vld_0_22;
    assign in_chan_dep_data_vec_22[55 : 0] = dep_chan_data_0_22;
    assign token_in_vec_22[0] = token_0_22;
    assign in_chan_dep_vld_vec_22[1] = dep_chan_vld_1_22;
    assign in_chan_dep_data_vec_22[111 : 56] = dep_chan_data_1_22;
    assign token_in_vec_22[1] = token_1_22;
    assign in_chan_dep_vld_vec_22[2] = dep_chan_vld_7_22;
    assign in_chan_dep_data_vec_22[167 : 112] = dep_chan_data_7_22;
    assign token_in_vec_22[2] = token_7_22;
    assign in_chan_dep_vld_vec_22[3] = dep_chan_vld_30_22;
    assign in_chan_dep_data_vec_22[223 : 168] = dep_chan_data_30_22;
    assign token_in_vec_22[3] = token_30_22;
    assign in_chan_dep_vld_vec_22[4] = dep_chan_vld_38_22;
    assign in_chan_dep_data_vec_22[279 : 224] = dep_chan_data_38_22;
    assign token_in_vec_22[4] = token_38_22;
    assign in_chan_dep_vld_vec_22[5] = dep_chan_vld_52_22;
    assign in_chan_dep_data_vec_22[335 : 280] = dep_chan_data_52_22;
    assign token_in_vec_22[5] = token_52_22;
    assign in_chan_dep_vld_vec_22[6] = dep_chan_vld_54_22;
    assign in_chan_dep_data_vec_22[391 : 336] = dep_chan_data_54_22;
    assign token_in_vec_22[6] = token_54_22;
    assign in_chan_dep_vld_vec_22[7] = dep_chan_vld_55_22;
    assign in_chan_dep_data_vec_22[447 : 392] = dep_chan_data_55_22;
    assign token_in_vec_22[7] = token_55_22;
    assign dep_chan_vld_22_1 = out_chan_dep_vld_vec_22[0];
    assign dep_chan_data_22_1 = out_chan_dep_data_22;
    assign token_22_1 = token_out_vec_22[0];
    assign dep_chan_vld_22_7 = out_chan_dep_vld_vec_22[1];
    assign dep_chan_data_22_7 = out_chan_dep_data_22;
    assign token_22_7 = token_out_vec_22[1];
    assign dep_chan_vld_22_52 = out_chan_dep_vld_vec_22[2];
    assign dep_chan_data_22_52 = out_chan_dep_data_22;
    assign token_22_52 = token_out_vec_22[2];
    assign dep_chan_vld_22_54 = out_chan_dep_vld_vec_22[3];
    assign dep_chan_data_22_54 = out_chan_dep_data_22;
    assign token_22_54 = token_out_vec_22[3];
    assign dep_chan_vld_22_0 = out_chan_dep_vld_vec_22[4];
    assign dep_chan_data_22_0 = out_chan_dep_data_22;
    assign token_22_0 = token_out_vec_22[4];
    assign dep_chan_vld_22_30 = out_chan_dep_vld_vec_22[5];
    assign dep_chan_data_22_30 = out_chan_dep_data_22;
    assign token_22_30 = token_out_vec_22[5];
    assign dep_chan_vld_22_38 = out_chan_dep_vld_vec_22[6];
    assign dep_chan_data_22_38 = out_chan_dep_data_22;
    assign token_22_38 = token_out_vec_22[6];
    assign dep_chan_vld_22_55 = out_chan_dep_vld_vec_22[7];
    assign dep_chan_data_22_55 = out_chan_dep_data_22;
    assign token_22_55 = token_out_vec_22[7];

    // Process: grp_shared_dataflow_fu_225.phase_band_1280_800_U0.stencil_1280_800_true_U0
    motion60_shared_hls_deadlock_detect_unit #(56, 23, 3, 3) motion60_shared_hls_deadlock_detect_unit_23 (
        .reset(dl_reset),
        .clock(dl_clock),
        .proc_dep_vld_vec(proc_dep_vld_vec_23),
        .in_chan_dep_vld_vec(in_chan_dep_vld_vec_23),
        .in_chan_dep_data_vec(in_chan_dep_data_vec_23),
        .token_in_vec(token_in_vec_23),
        .dl_detect_in(dl_detect_out),
        .origin(origin[23]),
        .token_clear(token_clear),
        .out_chan_dep_vld_vec(out_chan_dep_vld_vec_23),
        .out_chan_dep_data(out_chan_dep_data_23),
        .token_out_vec(token_out_vec_23),
        .dl_detect_out(dl_in_vec[23]));

    assign proc_23_data_FIFO_blk[0] = 1'b0 | (~grp_shared_dataflow_fu_225.phase_band_1280_800_U0.stencil_1280_800_true_U0.band0_blk_n) | (~grp_shared_dataflow_fu_225.phase_band_1280_800_U0.stencil_1280_800_true_U0.grp_stencil_1280_800_true_Pipeline_horizontal_fu_158.band0_blk_n);
    assign proc_23_data_PIPO_blk[0] = 1'b0;
    assign proc_23_start_FIFO_blk[0] = 1'b0;
    assign proc_23_TLF_FIFO_blk[0] = 1'b0;
    assign proc_23_input_sync_blk[0] = 1'b0;
    assign proc_23_output_sync_blk[0] = 1'b0;
    assign proc_dep_vld_vec_23[0] = dl_detect_out ? proc_dep_vld_vec_23_reg[0] : (proc_23_data_FIFO_blk[0] | proc_23_data_PIPO_blk[0] | proc_23_start_FIFO_blk[0] | proc_23_TLF_FIFO_blk[0] | proc_23_input_sync_blk[0] | proc_23_output_sync_blk[0]);
    assign proc_23_data_FIFO_blk[1] = 1'b0 | (~grp_shared_dataflow_fu_225.phase_band_1280_800_U0.stencil_1280_800_true_U0.band0_blk_n) | (~grp_shared_dataflow_fu_225.phase_band_1280_800_U0.stencil_1280_800_true_U0.grp_stencil_1280_800_true_Pipeline_horizontal_fu_158.band0_blk_n);
    assign proc_23_data_PIPO_blk[1] = 1'b0;
    assign proc_23_start_FIFO_blk[1] = 1'b0;
    assign proc_23_TLF_FIFO_blk[1] = 1'b0;
    assign proc_23_input_sync_blk[1] = 1'b0;
    assign proc_23_output_sync_blk[1] = 1'b0;
    assign proc_dep_vld_vec_23[1] = dl_detect_out ? proc_dep_vld_vec_23_reg[1] : (proc_23_data_FIFO_blk[1] | proc_23_data_PIPO_blk[1] | proc_23_start_FIFO_blk[1] | proc_23_TLF_FIFO_blk[1] | proc_23_input_sync_blk[1] | proc_23_output_sync_blk[1]);
    assign proc_23_data_FIFO_blk[2] = 1'b0 | (~grp_shared_dataflow_fu_225.phase_band_1280_800_U0.stencil_1280_800_true_U0.grp_stencil_1280_800_true_Pipeline_vertical_fu_183.gradients_blk_n);
    assign proc_23_data_PIPO_blk[2] = 1'b0;
    assign proc_23_start_FIFO_blk[2] = 1'b0;
    assign proc_23_TLF_FIFO_blk[2] = 1'b0;
    assign proc_23_input_sync_blk[2] = 1'b0 | (grp_shared_dataflow_fu_225.phase_band_1280_800_U0.ap_sync_stencil_1280_800_true_U0_ap_ready & grp_shared_dataflow_fu_225.phase_band_1280_800_U0.stencil_1280_800_true_U0.ap_idle & ~grp_shared_dataflow_fu_225.phase_band_1280_800_U0.ap_sync_phase_core_shared_U0_ap_ready);
    assign proc_23_output_sync_blk[2] = 1'b0;
    assign proc_dep_vld_vec_23[2] = dl_detect_out ? proc_dep_vld_vec_23_reg[2] : (proc_23_data_FIFO_blk[2] | proc_23_data_PIPO_blk[2] | proc_23_start_FIFO_blk[2] | proc_23_TLF_FIFO_blk[2] | proc_23_input_sync_blk[2] | proc_23_output_sync_blk[2]);
    always @ (negedge dl_reset or posedge dl_clock) begin
        if (~dl_reset) begin
            proc_dep_vld_vec_23_reg <= 'b0;
        end
        else begin
            proc_dep_vld_vec_23_reg <= proc_dep_vld_vec_23;
        end
    end
    assign in_chan_dep_vld_vec_23[0] = dep_chan_vld_1_23;
    assign in_chan_dep_data_vec_23[55 : 0] = dep_chan_data_1_23;
    assign token_in_vec_23[0] = token_1_23;
    assign in_chan_dep_vld_vec_23[1] = dep_chan_vld_7_23;
    assign in_chan_dep_data_vec_23[111 : 56] = dep_chan_data_7_23;
    assign token_in_vec_23[1] = token_7_23;
    assign in_chan_dep_vld_vec_23[2] = dep_chan_vld_24_23;
    assign in_chan_dep_data_vec_23[167 : 112] = dep_chan_data_24_23;
    assign token_in_vec_23[2] = token_24_23;
    assign dep_chan_vld_23_1 = out_chan_dep_vld_vec_23[0];
    assign dep_chan_data_23_1 = out_chan_dep_data_23;
    assign token_23_1 = token_out_vec_23[0];
    assign dep_chan_vld_23_7 = out_chan_dep_vld_vec_23[1];
    assign dep_chan_data_23_7 = out_chan_dep_data_23;
    assign token_23_7 = token_out_vec_23[1];
    assign dep_chan_vld_23_24 = out_chan_dep_vld_vec_23[2];
    assign dep_chan_data_23_24 = out_chan_dep_data_23;
    assign token_23_24 = token_out_vec_23[2];

    // Process: grp_shared_dataflow_fu_225.phase_band_1280_800_U0.phase_core_shared_U0
    motion60_shared_hls_deadlock_detect_unit #(56, 24, 3, 3) motion60_shared_hls_deadlock_detect_unit_24 (
        .reset(dl_reset),
        .clock(dl_clock),
        .proc_dep_vld_vec(proc_dep_vld_vec_24),
        .in_chan_dep_vld_vec(in_chan_dep_vld_vec_24),
        .in_chan_dep_data_vec(in_chan_dep_data_vec_24),
        .token_in_vec(token_in_vec_24),
        .dl_detect_in(dl_detect_out),
        .origin(origin[24]),
        .token_clear(token_clear),
        .out_chan_dep_vld_vec(out_chan_dep_vld_vec_24),
        .out_chan_dep_data(out_chan_dep_data_24),
        .token_out_vec(token_out_vec_24),
        .dl_detect_out(dl_in_vec[24]));

    assign proc_24_data_FIFO_blk[0] = 1'b0 | (~grp_shared_dataflow_fu_225.phase_band_1280_800_U0.phase_core_shared_U0.grp_phase_dataflow_fu_130.compute_phase8_U0.gradients_blk_n);
    assign proc_24_data_PIPO_blk[0] = 1'b0;
    assign proc_24_start_FIFO_blk[0] = 1'b0;
    assign proc_24_TLF_FIFO_blk[0] = 1'b0;
    assign proc_24_input_sync_blk[0] = 1'b0 | (grp_shared_dataflow_fu_225.phase_band_1280_800_U0.ap_sync_phase_core_shared_U0_ap_ready & grp_shared_dataflow_fu_225.phase_band_1280_800_U0.phase_core_shared_U0.ap_idle & ~grp_shared_dataflow_fu_225.phase_band_1280_800_U0.ap_sync_stencil_1280_800_true_U0_ap_ready);
    assign proc_24_output_sync_blk[0] = 1'b0;
    assign proc_dep_vld_vec_24[0] = dl_detect_out ? proc_dep_vld_vec_24_reg[0] : (proc_24_data_FIFO_blk[0] | proc_24_data_PIPO_blk[0] | proc_24_start_FIFO_blk[0] | proc_24_TLF_FIFO_blk[0] | proc_24_input_sync_blk[0] | proc_24_output_sync_blk[0]);
    assign proc_24_data_FIFO_blk[1] = 1'b0 | (~grp_shared_dataflow_fu_225.phase_band_1280_800_U0.phase_core_shared_U0.grp_phase_dataflow_fu_130.compute_phase8_U0.p2_blk_n);
    assign proc_24_data_PIPO_blk[1] = 1'b0;
    assign proc_24_start_FIFO_blk[1] = 1'b0;
    assign proc_24_TLF_FIFO_blk[1] = 1'b0;
    assign proc_24_input_sync_blk[1] = 1'b0;
    assign proc_24_output_sync_blk[1] = 1'b0;
    assign proc_dep_vld_vec_24[1] = dl_detect_out ? proc_dep_vld_vec_24_reg[1] : (proc_24_data_FIFO_blk[1] | proc_24_data_PIPO_blk[1] | proc_24_start_FIFO_blk[1] | proc_24_TLF_FIFO_blk[1] | proc_24_input_sync_blk[1] | proc_24_output_sync_blk[1]);
    assign proc_24_data_FIFO_blk[2] = 1'b0 | (~grp_shared_dataflow_fu_225.phase_band_1280_800_U0.phase_core_shared_U0.grp_phase_dataflow_fu_130.compute_phase8_U0.p2_blk_n);
    assign proc_24_data_PIPO_blk[2] = 1'b0;
    assign proc_24_start_FIFO_blk[2] = 1'b0;
    assign proc_24_TLF_FIFO_blk[2] = 1'b0;
    assign proc_24_input_sync_blk[2] = 1'b0;
    assign proc_24_output_sync_blk[2] = 1'b0;
    assign proc_dep_vld_vec_24[2] = dl_detect_out ? proc_dep_vld_vec_24_reg[2] : (proc_24_data_FIFO_blk[2] | proc_24_data_PIPO_blk[2] | proc_24_start_FIFO_blk[2] | proc_24_TLF_FIFO_blk[2] | proc_24_input_sync_blk[2] | proc_24_output_sync_blk[2]);
    always @ (negedge dl_reset or posedge dl_clock) begin
        if (~dl_reset) begin
            proc_dep_vld_vec_24_reg <= 'b0;
        end
        else begin
            proc_dep_vld_vec_24_reg <= proc_dep_vld_vec_24;
        end
    end
    assign in_chan_dep_vld_vec_24[0] = dep_chan_vld_23_24;
    assign in_chan_dep_data_vec_24[55 : 0] = dep_chan_data_23_24;
    assign token_in_vec_24[0] = token_23_24;
    assign in_chan_dep_vld_vec_24[1] = dep_chan_vld_52_24;
    assign in_chan_dep_data_vec_24[111 : 56] = dep_chan_data_52_24;
    assign token_in_vec_24[1] = token_52_24;
    assign in_chan_dep_vld_vec_24[2] = dep_chan_vld_54_24;
    assign in_chan_dep_data_vec_24[167 : 112] = dep_chan_data_54_24;
    assign token_in_vec_24[2] = token_54_24;
    assign dep_chan_vld_24_23 = out_chan_dep_vld_vec_24[0];
    assign dep_chan_data_24_23 = out_chan_dep_data_24;
    assign token_24_23 = token_out_vec_24[0];
    assign dep_chan_vld_24_52 = out_chan_dep_vld_vec_24[1];
    assign dep_chan_data_24_52 = out_chan_dep_data_24;
    assign token_24_52 = token_out_vec_24[1];
    assign dep_chan_vld_24_54 = out_chan_dep_vld_vec_24[2];
    assign dep_chan_data_24_54 = out_chan_dep_data_24;
    assign token_24_54 = token_out_vec_24[2];

    // Process: grp_shared_dataflow_fu_225.phase_band_1280_800_U0.phase_core_shared_U0.grp_phase_dataflow_fu_130.read_words_U0
    motion60_shared_hls_deadlock_detect_unit #(56, 25, 1, 1) motion60_shared_hls_deadlock_detect_unit_25 (
        .reset(dl_reset),
        .clock(dl_clock),
        .proc_dep_vld_vec(proc_dep_vld_vec_25),
        .in_chan_dep_vld_vec(in_chan_dep_vld_vec_25),
        .in_chan_dep_data_vec(in_chan_dep_data_vec_25),
        .token_in_vec(token_in_vec_25),
        .dl_detect_in(dl_detect_out),
        .origin(origin[25]),
        .token_clear(token_clear),
        .out_chan_dep_vld_vec(out_chan_dep_vld_vec_25),
        .out_chan_dep_data(out_chan_dep_data_25),
        .token_out_vec(token_out_vec_25),
        .dl_detect_out(dl_in_vec[25]));

    assign proc_25_data_FIFO_blk[0] = 1'b0 | (~grp_shared_dataflow_fu_225.phase_band_1280_800_U0.phase_core_shared_U0.grp_phase_dataflow_fu_130.read_words_U0.grp_read_words_Pipeline_VITIS_LOOP_10_1_fu_78.read_bus_blk_n);
    assign proc_25_data_PIPO_blk[0] = 1'b0;
    assign proc_25_start_FIFO_blk[0] = 1'b0 | (~grp_shared_dataflow_fu_225.phase_band_1280_800_U0.phase_core_shared_U0.grp_phase_dataflow_fu_130.start_for_unpack_history7_U0_U.if_full_n & grp_shared_dataflow_fu_225.phase_band_1280_800_U0.phase_core_shared_U0.grp_phase_dataflow_fu_130.read_words_U0.ap_start & ~grp_shared_dataflow_fu_225.phase_band_1280_800_U0.phase_core_shared_U0.grp_phase_dataflow_fu_130.read_words_U0.real_start & (trans_in_cnt_15 == trans_out_cnt_15) & ~grp_shared_dataflow_fu_225.phase_band_1280_800_U0.phase_core_shared_U0.grp_phase_dataflow_fu_130.start_for_unpack_history7_U0_U.if_read);
    assign proc_25_TLF_FIFO_blk[0] = 1'b0;
    assign proc_25_input_sync_blk[0] = 1'b0;
    assign proc_25_output_sync_blk[0] = 1'b0;
    assign proc_dep_vld_vec_25[0] = dl_detect_out ? proc_dep_vld_vec_25_reg[0] : (proc_25_data_FIFO_blk[0] | proc_25_data_PIPO_blk[0] | proc_25_start_FIFO_blk[0] | proc_25_TLF_FIFO_blk[0] | proc_25_input_sync_blk[0] | proc_25_output_sync_blk[0]);
    always @ (negedge dl_reset or posedge dl_clock) begin
        if (~dl_reset) begin
            proc_dep_vld_vec_25_reg <= 'b0;
        end
        else begin
            proc_dep_vld_vec_25_reg <= proc_dep_vld_vec_25;
        end
    end
    assign in_chan_dep_vld_vec_25[0] = dep_chan_vld_26_25;
    assign in_chan_dep_data_vec_25[55 : 0] = dep_chan_data_26_25;
    assign token_in_vec_25[0] = token_26_25;
    assign dep_chan_vld_25_26 = out_chan_dep_vld_vec_25[0];
    assign dep_chan_data_25_26 = out_chan_dep_data_25;
    assign token_25_26 = token_out_vec_25[0];

    // Process: grp_shared_dataflow_fu_225.phase_band_1280_800_U0.phase_core_shared_U0.grp_phase_dataflow_fu_130.unpack_history7_U0
    motion60_shared_hls_deadlock_detect_unit #(56, 26, 2, 2) motion60_shared_hls_deadlock_detect_unit_26 (
        .reset(dl_reset),
        .clock(dl_clock),
        .proc_dep_vld_vec(proc_dep_vld_vec_26),
        .in_chan_dep_vld_vec(in_chan_dep_vld_vec_26),
        .in_chan_dep_data_vec(in_chan_dep_data_vec_26),
        .token_in_vec(token_in_vec_26),
        .dl_detect_in(dl_detect_out),
        .origin(origin[26]),
        .token_clear(token_clear),
        .out_chan_dep_vld_vec(out_chan_dep_vld_vec_26),
        .out_chan_dep_data(out_chan_dep_data_26),
        .token_out_vec(token_out_vec_26),
        .dl_detect_out(dl_in_vec[26]));

    assign proc_26_data_FIFO_blk[0] = 1'b0 | (~grp_shared_dataflow_fu_225.phase_band_1280_800_U0.phase_core_shared_U0.grp_phase_dataflow_fu_130.unpack_history7_U0.read_bus_blk_n);
    assign proc_26_data_PIPO_blk[0] = 1'b0;
    assign proc_26_start_FIFO_blk[0] = 1'b0 | (~grp_shared_dataflow_fu_225.phase_band_1280_800_U0.phase_core_shared_U0.grp_phase_dataflow_fu_130.start_for_unpack_history7_U0_U.if_empty_n & grp_shared_dataflow_fu_225.phase_band_1280_800_U0.phase_core_shared_U0.grp_phase_dataflow_fu_130.unpack_history7_U0.ap_idle & ~grp_shared_dataflow_fu_225.phase_band_1280_800_U0.phase_core_shared_U0.grp_phase_dataflow_fu_130.start_for_unpack_history7_U0_U.if_write);
    assign proc_26_TLF_FIFO_blk[0] = 1'b0;
    assign proc_26_input_sync_blk[0] = 1'b0;
    assign proc_26_output_sync_blk[0] = 1'b0;
    assign proc_dep_vld_vec_26[0] = dl_detect_out ? proc_dep_vld_vec_26_reg[0] : (proc_26_data_FIFO_blk[0] | proc_26_data_PIPO_blk[0] | proc_26_start_FIFO_blk[0] | proc_26_TLF_FIFO_blk[0] | proc_26_input_sync_blk[0] | proc_26_output_sync_blk[0]);
    assign proc_26_data_FIFO_blk[1] = 1'b0 | (~grp_shared_dataflow_fu_225.phase_band_1280_800_U0.phase_core_shared_U0.grp_phase_dataflow_fu_130.unpack_history7_U0.history_blk_n);
    assign proc_26_data_PIPO_blk[1] = 1'b0;
    assign proc_26_start_FIFO_blk[1] = 1'b0 | (~grp_shared_dataflow_fu_225.phase_band_1280_800_U0.phase_core_shared_U0.grp_phase_dataflow_fu_130.start_for_compute_phase8_U0_U.if_full_n & grp_shared_dataflow_fu_225.phase_band_1280_800_U0.phase_core_shared_U0.grp_phase_dataflow_fu_130.unpack_history7_U0.ap_start & ~grp_shared_dataflow_fu_225.phase_band_1280_800_U0.phase_core_shared_U0.grp_phase_dataflow_fu_130.unpack_history7_U0.real_start & (trans_in_cnt_16 == trans_out_cnt_16) & ~grp_shared_dataflow_fu_225.phase_band_1280_800_U0.phase_core_shared_U0.grp_phase_dataflow_fu_130.start_for_compute_phase8_U0_U.if_read);
    assign proc_26_TLF_FIFO_blk[1] = 1'b0;
    assign proc_26_input_sync_blk[1] = 1'b0;
    assign proc_26_output_sync_blk[1] = 1'b0;
    assign proc_dep_vld_vec_26[1] = dl_detect_out ? proc_dep_vld_vec_26_reg[1] : (proc_26_data_FIFO_blk[1] | proc_26_data_PIPO_blk[1] | proc_26_start_FIFO_blk[1] | proc_26_TLF_FIFO_blk[1] | proc_26_input_sync_blk[1] | proc_26_output_sync_blk[1]);
    always @ (negedge dl_reset or posedge dl_clock) begin
        if (~dl_reset) begin
            proc_dep_vld_vec_26_reg <= 'b0;
        end
        else begin
            proc_dep_vld_vec_26_reg <= proc_dep_vld_vec_26;
        end
    end
    assign in_chan_dep_vld_vec_26[0] = dep_chan_vld_25_26;
    assign in_chan_dep_data_vec_26[55 : 0] = dep_chan_data_25_26;
    assign token_in_vec_26[0] = token_25_26;
    assign in_chan_dep_vld_vec_26[1] = dep_chan_vld_27_26;
    assign in_chan_dep_data_vec_26[111 : 56] = dep_chan_data_27_26;
    assign token_in_vec_26[1] = token_27_26;
    assign dep_chan_vld_26_25 = out_chan_dep_vld_vec_26[0];
    assign dep_chan_data_26_25 = out_chan_dep_data_26;
    assign token_26_25 = token_out_vec_26[0];
    assign dep_chan_vld_26_27 = out_chan_dep_vld_vec_26[1];
    assign dep_chan_data_26_27 = out_chan_dep_data_26;
    assign token_26_27 = token_out_vec_26[1];

    // Process: grp_shared_dataflow_fu_225.phase_band_1280_800_U0.phase_core_shared_U0.grp_phase_dataflow_fu_130.compute_phase8_U0
    motion60_shared_hls_deadlock_detect_unit #(56, 27, 3, 3) motion60_shared_hls_deadlock_detect_unit_27 (
        .reset(dl_reset),
        .clock(dl_clock),
        .proc_dep_vld_vec(proc_dep_vld_vec_27),
        .in_chan_dep_vld_vec(in_chan_dep_vld_vec_27),
        .in_chan_dep_data_vec(in_chan_dep_data_vec_27),
        .token_in_vec(token_in_vec_27),
        .dl_detect_in(dl_detect_out),
        .origin(origin[27]),
        .token_clear(token_clear),
        .out_chan_dep_vld_vec(out_chan_dep_vld_vec_27),
        .out_chan_dep_data(out_chan_dep_data_27),
        .token_out_vec(token_out_vec_27),
        .dl_detect_out(dl_in_vec[27]));

    assign proc_27_data_FIFO_blk[0] = 1'b0 | (~grp_shared_dataflow_fu_225.phase_band_1280_800_U0.phase_core_shared_U0.grp_phase_dataflow_fu_130.compute_phase8_U0.history_blk_n);
    assign proc_27_data_PIPO_blk[0] = 1'b0;
    assign proc_27_start_FIFO_blk[0] = 1'b0 | (~grp_shared_dataflow_fu_225.phase_band_1280_800_U0.phase_core_shared_U0.grp_phase_dataflow_fu_130.start_for_compute_phase8_U0_U.if_empty_n & grp_shared_dataflow_fu_225.phase_band_1280_800_U0.phase_core_shared_U0.grp_phase_dataflow_fu_130.compute_phase8_U0.ap_idle & ~grp_shared_dataflow_fu_225.phase_band_1280_800_U0.phase_core_shared_U0.grp_phase_dataflow_fu_130.start_for_compute_phase8_U0_U.if_write);
    assign proc_27_TLF_FIFO_blk[0] = 1'b0;
    assign proc_27_input_sync_blk[0] = 1'b0;
    assign proc_27_output_sync_blk[0] = 1'b0;
    assign proc_dep_vld_vec_27[0] = dl_detect_out ? proc_dep_vld_vec_27_reg[0] : (proc_27_data_FIFO_blk[0] | proc_27_data_PIPO_blk[0] | proc_27_start_FIFO_blk[0] | proc_27_TLF_FIFO_blk[0] | proc_27_input_sync_blk[0] | proc_27_output_sync_blk[0]);
    assign proc_27_data_FIFO_blk[1] = 1'b0 | (~grp_shared_dataflow_fu_225.phase_band_1280_800_U0.phase_core_shared_U0.grp_phase_dataflow_fu_130.compute_phase8_U0.updated_blk_n);
    assign proc_27_data_PIPO_blk[1] = 1'b0;
    assign proc_27_start_FIFO_blk[1] = 1'b0 | (~grp_shared_dataflow_fu_225.phase_band_1280_800_U0.phase_core_shared_U0.grp_phase_dataflow_fu_130.start_for_pack_history9_U0_U.if_full_n & grp_shared_dataflow_fu_225.phase_band_1280_800_U0.phase_core_shared_U0.grp_phase_dataflow_fu_130.compute_phase8_U0.ap_start & ~grp_shared_dataflow_fu_225.phase_band_1280_800_U0.phase_core_shared_U0.grp_phase_dataflow_fu_130.compute_phase8_U0.real_start & (trans_in_cnt_17 == trans_out_cnt_17) & ~grp_shared_dataflow_fu_225.phase_band_1280_800_U0.phase_core_shared_U0.grp_phase_dataflow_fu_130.start_for_pack_history9_U0_U.if_read);
    assign proc_27_TLF_FIFO_blk[1] = 1'b0;
    assign proc_27_input_sync_blk[1] = 1'b0;
    assign proc_27_output_sync_blk[1] = 1'b0;
    assign proc_dep_vld_vec_27[1] = dl_detect_out ? proc_dep_vld_vec_27_reg[1] : (proc_27_data_FIFO_blk[1] | proc_27_data_PIPO_blk[1] | proc_27_start_FIFO_blk[1] | proc_27_TLF_FIFO_blk[1] | proc_27_input_sync_blk[1] | proc_27_output_sync_blk[1]);
    assign proc_27_data_FIFO_blk[2] = 1'b0;
    assign proc_27_data_PIPO_blk[2] = 1'b0;
    assign proc_27_start_FIFO_blk[2] = 1'b0;
    assign proc_27_TLF_FIFO_blk[2] = 1'b0;
    assign proc_27_input_sync_blk[2] = 1'b0;
    assign proc_27_output_sync_blk[2] = 1'b0 | (ap_done_reg_10 & grp_shared_dataflow_fu_225.phase_band_1280_800_U0.phase_core_shared_U0.grp_phase_dataflow_fu_130.compute_phase8_U0.ap_done & ~grp_shared_dataflow_fu_225.phase_band_1280_800_U0.phase_core_shared_U0.grp_phase_dataflow_fu_130.write_words_U0.ap_done);
    assign proc_dep_vld_vec_27[2] = dl_detect_out ? proc_dep_vld_vec_27_reg[2] : (proc_27_data_FIFO_blk[2] | proc_27_data_PIPO_blk[2] | proc_27_start_FIFO_blk[2] | proc_27_TLF_FIFO_blk[2] | proc_27_input_sync_blk[2] | proc_27_output_sync_blk[2]);
    always @ (negedge dl_reset or posedge dl_clock) begin
        if (~dl_reset) begin
            proc_dep_vld_vec_27_reg <= 'b0;
        end
        else begin
            proc_dep_vld_vec_27_reg <= proc_dep_vld_vec_27;
        end
    end
    assign in_chan_dep_vld_vec_27[0] = dep_chan_vld_26_27;
    assign in_chan_dep_data_vec_27[55 : 0] = dep_chan_data_26_27;
    assign token_in_vec_27[0] = token_26_27;
    assign in_chan_dep_vld_vec_27[1] = dep_chan_vld_28_27;
    assign in_chan_dep_data_vec_27[111 : 56] = dep_chan_data_28_27;
    assign token_in_vec_27[1] = token_28_27;
    assign in_chan_dep_vld_vec_27[2] = dep_chan_vld_29_27;
    assign in_chan_dep_data_vec_27[167 : 112] = dep_chan_data_29_27;
    assign token_in_vec_27[2] = token_29_27;
    assign dep_chan_vld_27_26 = out_chan_dep_vld_vec_27[0];
    assign dep_chan_data_27_26 = out_chan_dep_data_27;
    assign token_27_26 = token_out_vec_27[0];
    assign dep_chan_vld_27_28 = out_chan_dep_vld_vec_27[1];
    assign dep_chan_data_27_28 = out_chan_dep_data_27;
    assign token_27_28 = token_out_vec_27[1];
    assign dep_chan_vld_27_29 = out_chan_dep_vld_vec_27[2];
    assign dep_chan_data_27_29 = out_chan_dep_data_27;
    assign token_27_29 = token_out_vec_27[2];

    // Process: grp_shared_dataflow_fu_225.phase_band_1280_800_U0.phase_core_shared_U0.grp_phase_dataflow_fu_130.pack_history9_U0
    motion60_shared_hls_deadlock_detect_unit #(56, 28, 2, 2) motion60_shared_hls_deadlock_detect_unit_28 (
        .reset(dl_reset),
        .clock(dl_clock),
        .proc_dep_vld_vec(proc_dep_vld_vec_28),
        .in_chan_dep_vld_vec(in_chan_dep_vld_vec_28),
        .in_chan_dep_data_vec(in_chan_dep_data_vec_28),
        .token_in_vec(token_in_vec_28),
        .dl_detect_in(dl_detect_out),
        .origin(origin[28]),
        .token_clear(token_clear),
        .out_chan_dep_vld_vec(out_chan_dep_vld_vec_28),
        .out_chan_dep_data(out_chan_dep_data_28),
        .token_out_vec(token_out_vec_28),
        .dl_detect_out(dl_in_vec[28]));

    assign proc_28_data_FIFO_blk[0] = 1'b0 | (~grp_shared_dataflow_fu_225.phase_band_1280_800_U0.phase_core_shared_U0.grp_phase_dataflow_fu_130.pack_history9_U0.updated_blk_n);
    assign proc_28_data_PIPO_blk[0] = 1'b0;
    assign proc_28_start_FIFO_blk[0] = 1'b0 | (~grp_shared_dataflow_fu_225.phase_band_1280_800_U0.phase_core_shared_U0.grp_phase_dataflow_fu_130.start_for_pack_history9_U0_U.if_empty_n & grp_shared_dataflow_fu_225.phase_band_1280_800_U0.phase_core_shared_U0.grp_phase_dataflow_fu_130.pack_history9_U0.ap_idle & ~grp_shared_dataflow_fu_225.phase_band_1280_800_U0.phase_core_shared_U0.grp_phase_dataflow_fu_130.start_for_pack_history9_U0_U.if_write);
    assign proc_28_TLF_FIFO_blk[0] = 1'b0;
    assign proc_28_input_sync_blk[0] = 1'b0;
    assign proc_28_output_sync_blk[0] = 1'b0;
    assign proc_dep_vld_vec_28[0] = dl_detect_out ? proc_dep_vld_vec_28_reg[0] : (proc_28_data_FIFO_blk[0] | proc_28_data_PIPO_blk[0] | proc_28_start_FIFO_blk[0] | proc_28_TLF_FIFO_blk[0] | proc_28_input_sync_blk[0] | proc_28_output_sync_blk[0]);
    assign proc_28_data_FIFO_blk[1] = 1'b0 | (~grp_shared_dataflow_fu_225.phase_band_1280_800_U0.phase_core_shared_U0.grp_phase_dataflow_fu_130.pack_history9_U0.write_bus_blk_n);
    assign proc_28_data_PIPO_blk[1] = 1'b0;
    assign proc_28_start_FIFO_blk[1] = 1'b0 | (~grp_shared_dataflow_fu_225.phase_band_1280_800_U0.phase_core_shared_U0.grp_phase_dataflow_fu_130.start_for_write_words_U0_U.if_full_n & grp_shared_dataflow_fu_225.phase_band_1280_800_U0.phase_core_shared_U0.grp_phase_dataflow_fu_130.pack_history9_U0.ap_start & ~grp_shared_dataflow_fu_225.phase_band_1280_800_U0.phase_core_shared_U0.grp_phase_dataflow_fu_130.pack_history9_U0.real_start & (trans_in_cnt_18 == trans_out_cnt_18) & ~grp_shared_dataflow_fu_225.phase_band_1280_800_U0.phase_core_shared_U0.grp_phase_dataflow_fu_130.start_for_write_words_U0_U.if_read);
    assign proc_28_TLF_FIFO_blk[1] = 1'b0;
    assign proc_28_input_sync_blk[1] = 1'b0;
    assign proc_28_output_sync_blk[1] = 1'b0;
    assign proc_dep_vld_vec_28[1] = dl_detect_out ? proc_dep_vld_vec_28_reg[1] : (proc_28_data_FIFO_blk[1] | proc_28_data_PIPO_blk[1] | proc_28_start_FIFO_blk[1] | proc_28_TLF_FIFO_blk[1] | proc_28_input_sync_blk[1] | proc_28_output_sync_blk[1]);
    always @ (negedge dl_reset or posedge dl_clock) begin
        if (~dl_reset) begin
            proc_dep_vld_vec_28_reg <= 'b0;
        end
        else begin
            proc_dep_vld_vec_28_reg <= proc_dep_vld_vec_28;
        end
    end
    assign in_chan_dep_vld_vec_28[0] = dep_chan_vld_27_28;
    assign in_chan_dep_data_vec_28[55 : 0] = dep_chan_data_27_28;
    assign token_in_vec_28[0] = token_27_28;
    assign in_chan_dep_vld_vec_28[1] = dep_chan_vld_29_28;
    assign in_chan_dep_data_vec_28[111 : 56] = dep_chan_data_29_28;
    assign token_in_vec_28[1] = token_29_28;
    assign dep_chan_vld_28_27 = out_chan_dep_vld_vec_28[0];
    assign dep_chan_data_28_27 = out_chan_dep_data_28;
    assign token_28_27 = token_out_vec_28[0];
    assign dep_chan_vld_28_29 = out_chan_dep_vld_vec_28[1];
    assign dep_chan_data_28_29 = out_chan_dep_data_28;
    assign token_28_29 = token_out_vec_28[1];

    // Process: grp_shared_dataflow_fu_225.phase_band_1280_800_U0.phase_core_shared_U0.grp_phase_dataflow_fu_130.write_words_U0
    motion60_shared_hls_deadlock_detect_unit #(56, 29, 2, 2) motion60_shared_hls_deadlock_detect_unit_29 (
        .reset(dl_reset),
        .clock(dl_clock),
        .proc_dep_vld_vec(proc_dep_vld_vec_29),
        .in_chan_dep_vld_vec(in_chan_dep_vld_vec_29),
        .in_chan_dep_data_vec(in_chan_dep_data_vec_29),
        .token_in_vec(token_in_vec_29),
        .dl_detect_in(dl_detect_out),
        .origin(origin[29]),
        .token_clear(token_clear),
        .out_chan_dep_vld_vec(out_chan_dep_vld_vec_29),
        .out_chan_dep_data(out_chan_dep_data_29),
        .token_out_vec(token_out_vec_29),
        .dl_detect_out(dl_in_vec[29]));

    assign proc_29_data_FIFO_blk[0] = 1'b0 | (~grp_shared_dataflow_fu_225.phase_band_1280_800_U0.phase_core_shared_U0.grp_phase_dataflow_fu_130.write_words_U0.grp_write_words_Pipeline_VITIS_LOOP_17_1_fu_85.write_bus_blk_n);
    assign proc_29_data_PIPO_blk[0] = 1'b0;
    assign proc_29_start_FIFO_blk[0] = 1'b0 | (~grp_shared_dataflow_fu_225.phase_band_1280_800_U0.phase_core_shared_U0.grp_phase_dataflow_fu_130.start_for_write_words_U0_U.if_empty_n & grp_shared_dataflow_fu_225.phase_band_1280_800_U0.phase_core_shared_U0.grp_phase_dataflow_fu_130.write_words_U0.ap_idle & ~grp_shared_dataflow_fu_225.phase_band_1280_800_U0.phase_core_shared_U0.grp_phase_dataflow_fu_130.start_for_write_words_U0_U.if_write);
    assign proc_29_TLF_FIFO_blk[0] = 1'b0;
    assign proc_29_input_sync_blk[0] = 1'b0;
    assign proc_29_output_sync_blk[0] = 1'b0;
    assign proc_dep_vld_vec_29[0] = dl_detect_out ? proc_dep_vld_vec_29_reg[0] : (proc_29_data_FIFO_blk[0] | proc_29_data_PIPO_blk[0] | proc_29_start_FIFO_blk[0] | proc_29_TLF_FIFO_blk[0] | proc_29_input_sync_blk[0] | proc_29_output_sync_blk[0]);
    assign proc_29_data_FIFO_blk[1] = 1'b0;
    assign proc_29_data_PIPO_blk[1] = 1'b0;
    assign proc_29_start_FIFO_blk[1] = 1'b0;
    assign proc_29_TLF_FIFO_blk[1] = 1'b0;
    assign proc_29_input_sync_blk[1] = 1'b0;
    assign proc_29_output_sync_blk[1] = 1'b0 | (ap_done_reg_11 & grp_shared_dataflow_fu_225.phase_band_1280_800_U0.phase_core_shared_U0.grp_phase_dataflow_fu_130.write_words_U0.ap_done & ~grp_shared_dataflow_fu_225.phase_band_1280_800_U0.phase_core_shared_U0.grp_phase_dataflow_fu_130.compute_phase8_U0.ap_done);
    assign proc_dep_vld_vec_29[1] = dl_detect_out ? proc_dep_vld_vec_29_reg[1] : (proc_29_data_FIFO_blk[1] | proc_29_data_PIPO_blk[1] | proc_29_start_FIFO_blk[1] | proc_29_TLF_FIFO_blk[1] | proc_29_input_sync_blk[1] | proc_29_output_sync_blk[1]);
    always @ (negedge dl_reset or posedge dl_clock) begin
        if (~dl_reset) begin
            proc_dep_vld_vec_29_reg <= 'b0;
        end
        else begin
            proc_dep_vld_vec_29_reg <= proc_dep_vld_vec_29;
        end
    end
    assign in_chan_dep_vld_vec_29[0] = dep_chan_vld_27_29;
    assign in_chan_dep_data_vec_29[55 : 0] = dep_chan_data_27_29;
    assign token_in_vec_29[0] = token_27_29;
    assign in_chan_dep_vld_vec_29[1] = dep_chan_vld_28_29;
    assign in_chan_dep_data_vec_29[111 : 56] = dep_chan_data_28_29;
    assign token_in_vec_29[1] = token_28_29;
    assign dep_chan_vld_29_28 = out_chan_dep_vld_vec_29[0];
    assign dep_chan_data_29_28 = out_chan_dep_data_29;
    assign token_29_28 = token_out_vec_29[0];
    assign dep_chan_vld_29_27 = out_chan_dep_vld_vec_29[1];
    assign dep_chan_data_29_27 = out_chan_dep_data_29;
    assign token_29_27 = token_out_vec_29[1];

    // Process: grp_shared_dataflow_fu_225.phase_band_640_400_U0
    motion60_shared_hls_deadlock_detect_unit #(56, 30, 8, 8) motion60_shared_hls_deadlock_detect_unit_30 (
        .reset(dl_reset),
        .clock(dl_clock),
        .proc_dep_vld_vec(proc_dep_vld_vec_30),
        .in_chan_dep_vld_vec(in_chan_dep_vld_vec_30),
        .in_chan_dep_data_vec(in_chan_dep_data_vec_30),
        .token_in_vec(token_in_vec_30),
        .dl_detect_in(dl_detect_out),
        .origin(origin[30]),
        .token_clear(token_clear),
        .out_chan_dep_vld_vec(out_chan_dep_vld_vec_30),
        .out_chan_dep_data(out_chan_dep_data_30),
        .token_out_vec(token_out_vec_30),
        .dl_detect_out(dl_in_vec[30]));

    assign proc_30_data_FIFO_blk[0] = 1'b0 | (~grp_shared_dataflow_fu_225.phase_band_640_400_U0.stencil_640_400_true_U0.grp_stencil_640_400_true_Pipeline_horizontal_fu_158.band1_blk_n) | (~grp_shared_dataflow_fu_225.phase_band_640_400_U0.stencil_640_400_true_U0.band1_blk_n);
    assign proc_30_data_PIPO_blk[0] = 1'b0;
    assign proc_30_start_FIFO_blk[0] = 1'b0;
    assign proc_30_TLF_FIFO_blk[0] = 1'b0;
    assign proc_30_input_sync_blk[0] = 1'b0;
    assign proc_30_output_sync_blk[0] = 1'b0;
    assign proc_dep_vld_vec_30[0] = dl_detect_out ? proc_dep_vld_vec_30_reg[0] : (proc_30_data_FIFO_blk[0] | proc_30_data_PIPO_blk[0] | proc_30_start_FIFO_blk[0] | proc_30_TLF_FIFO_blk[0] | proc_30_input_sync_blk[0] | proc_30_output_sync_blk[0]);
    assign proc_30_data_FIFO_blk[1] = 1'b0 | (~grp_shared_dataflow_fu_225.phase_band_640_400_U0.stencil_640_400_true_U0.grp_stencil_640_400_true_Pipeline_horizontal_fu_158.band1_blk_n) | (~grp_shared_dataflow_fu_225.phase_band_640_400_U0.stencil_640_400_true_U0.band1_blk_n);
    assign proc_30_data_PIPO_blk[1] = 1'b0;
    assign proc_30_start_FIFO_blk[1] = 1'b0;
    assign proc_30_TLF_FIFO_blk[1] = 1'b0;
    assign proc_30_input_sync_blk[1] = 1'b0;
    assign proc_30_output_sync_blk[1] = 1'b0;
    assign proc_dep_vld_vec_30[1] = dl_detect_out ? proc_dep_vld_vec_30_reg[1] : (proc_30_data_FIFO_blk[1] | proc_30_data_PIPO_blk[1] | proc_30_start_FIFO_blk[1] | proc_30_TLF_FIFO_blk[1] | proc_30_input_sync_blk[1] | proc_30_output_sync_blk[1]);
    assign proc_30_data_FIFO_blk[2] = 1'b0 | (~grp_shared_dataflow_fu_225.phase_band_640_400_U0.phase_core_shared_1_U0.grp_phase_dataflow_6_fu_130.compute_phase11_U0.p2_blk_n);
    assign proc_30_data_PIPO_blk[2] = 1'b0;
    assign proc_30_start_FIFO_blk[2] = 1'b0 | (~grp_shared_dataflow_fu_225.start_for_reconstruct_640_400_U0_U.if_full_n & grp_shared_dataflow_fu_225.phase_band_640_400_U0.ap_start & ~grp_shared_dataflow_fu_225.phase_band_640_400_U0.real_start & (trans_in_cnt_29 == trans_out_cnt_29) & ~grp_shared_dataflow_fu_225.start_for_reconstruct_640_400_U0_U.if_read);
    assign proc_30_TLF_FIFO_blk[2] = 1'b0;
    assign proc_30_input_sync_blk[2] = 1'b0;
    assign proc_30_output_sync_blk[2] = 1'b0;
    assign proc_dep_vld_vec_30[2] = dl_detect_out ? proc_dep_vld_vec_30_reg[2] : (proc_30_data_FIFO_blk[2] | proc_30_data_PIPO_blk[2] | proc_30_start_FIFO_blk[2] | proc_30_TLF_FIFO_blk[2] | proc_30_input_sync_blk[2] | proc_30_output_sync_blk[2]);
    assign proc_30_data_FIFO_blk[3] = 1'b0 | (~grp_shared_dataflow_fu_225.phase_band_640_400_U0.phase_core_shared_1_U0.grp_phase_dataflow_6_fu_130.compute_phase11_U0.p2_blk_n);
    assign proc_30_data_PIPO_blk[3] = 1'b0;
    assign proc_30_start_FIFO_blk[3] = 1'b0;
    assign proc_30_TLF_FIFO_blk[3] = 1'b0;
    assign proc_30_input_sync_blk[3] = 1'b0;
    assign proc_30_output_sync_blk[3] = 1'b0;
    assign proc_dep_vld_vec_30[3] = dl_detect_out ? proc_dep_vld_vec_30_reg[3] : (proc_30_data_FIFO_blk[3] | proc_30_data_PIPO_blk[3] | proc_30_start_FIFO_blk[3] | proc_30_TLF_FIFO_blk[3] | proc_30_input_sync_blk[3] | proc_30_output_sync_blk[3]);
    assign proc_30_data_FIFO_blk[4] = 1'b0;
    assign proc_30_data_PIPO_blk[4] = 1'b0;
    assign proc_30_start_FIFO_blk[4] = 1'b0;
    assign proc_30_TLF_FIFO_blk[4] = 1'b0;
    assign proc_30_input_sync_blk[4] = 1'b0 | (grp_shared_dataflow_fu_225.ap_sync_phase_band_640_400_U0_ap_ready & grp_shared_dataflow_fu_225.phase_band_640_400_U0.ap_idle & ~grp_shared_dataflow_fu_225.ap_sync_read_image_U0_ap_ready);
    assign proc_30_output_sync_blk[4] = 1'b0;
    assign proc_dep_vld_vec_30[4] = dl_detect_out ? proc_dep_vld_vec_30_reg[4] : (proc_30_data_FIFO_blk[4] | proc_30_data_PIPO_blk[4] | proc_30_start_FIFO_blk[4] | proc_30_TLF_FIFO_blk[4] | proc_30_input_sync_blk[4] | proc_30_output_sync_blk[4]);
    assign proc_30_data_FIFO_blk[5] = 1'b0;
    assign proc_30_data_PIPO_blk[5] = 1'b0;
    assign proc_30_start_FIFO_blk[5] = 1'b0;
    assign proc_30_TLF_FIFO_blk[5] = 1'b0;
    assign proc_30_input_sync_blk[5] = 1'b0 | (grp_shared_dataflow_fu_225.ap_sync_phase_band_640_400_U0_ap_ready & grp_shared_dataflow_fu_225.phase_band_640_400_U0.ap_idle & ~grp_shared_dataflow_fu_225.ap_sync_phase_band_1280_800_U0_ap_ready);
    assign proc_30_output_sync_blk[5] = 1'b0 | (ap_done_reg_1 & grp_shared_dataflow_fu_225.phase_band_640_400_U0.ap_done & ~grp_shared_dataflow_fu_225.phase_band_1280_800_U0.ap_done);
    assign proc_dep_vld_vec_30[5] = dl_detect_out ? proc_dep_vld_vec_30_reg[5] : (proc_30_data_FIFO_blk[5] | proc_30_data_PIPO_blk[5] | proc_30_start_FIFO_blk[5] | proc_30_TLF_FIFO_blk[5] | proc_30_input_sync_blk[5] | proc_30_output_sync_blk[5]);
    assign proc_30_data_FIFO_blk[6] = 1'b0;
    assign proc_30_data_PIPO_blk[6] = 1'b0;
    assign proc_30_start_FIFO_blk[6] = 1'b0;
    assign proc_30_TLF_FIFO_blk[6] = 1'b0;
    assign proc_30_input_sync_blk[6] = 1'b0 | (grp_shared_dataflow_fu_225.ap_sync_phase_band_640_400_U0_ap_ready & grp_shared_dataflow_fu_225.phase_band_640_400_U0.ap_idle & ~grp_shared_dataflow_fu_225.ap_sync_phase_band_320_200_U0_ap_ready);
    assign proc_30_output_sync_blk[6] = 1'b0 | (ap_done_reg_1 & grp_shared_dataflow_fu_225.phase_band_640_400_U0.ap_done & ~grp_shared_dataflow_fu_225.phase_band_320_200_U0.ap_done);
    assign proc_dep_vld_vec_30[6] = dl_detect_out ? proc_dep_vld_vec_30_reg[6] : (proc_30_data_FIFO_blk[6] | proc_30_data_PIPO_blk[6] | proc_30_start_FIFO_blk[6] | proc_30_TLF_FIFO_blk[6] | proc_30_input_sync_blk[6] | proc_30_output_sync_blk[6]);
    assign proc_30_data_FIFO_blk[7] = 1'b0;
    assign proc_30_data_PIPO_blk[7] = 1'b0;
    assign proc_30_start_FIFO_blk[7] = 1'b0;
    assign proc_30_TLF_FIFO_blk[7] = 1'b0;
    assign proc_30_input_sync_blk[7] = 1'b0;
    assign proc_30_output_sync_blk[7] = 1'b0 | (ap_done_reg_1 & grp_shared_dataflow_fu_225.phase_band_640_400_U0.ap_done & ~grp_shared_dataflow_fu_225.write_image_U0.ap_done);
    assign proc_dep_vld_vec_30[7] = dl_detect_out ? proc_dep_vld_vec_30_reg[7] : (proc_30_data_FIFO_blk[7] | proc_30_data_PIPO_blk[7] | proc_30_start_FIFO_blk[7] | proc_30_TLF_FIFO_blk[7] | proc_30_input_sync_blk[7] | proc_30_output_sync_blk[7]);
    always @ (negedge dl_reset or posedge dl_clock) begin
        if (~dl_reset) begin
            proc_dep_vld_vec_30_reg <= 'b0;
        end
        else begin
            proc_dep_vld_vec_30_reg <= proc_dep_vld_vec_30;
        end
    end
    assign in_chan_dep_vld_vec_30[0] = dep_chan_vld_0_30;
    assign in_chan_dep_data_vec_30[55 : 0] = dep_chan_data_0_30;
    assign token_in_vec_30[0] = token_0_30;
    assign in_chan_dep_vld_vec_30[1] = dep_chan_vld_8_30;
    assign in_chan_dep_data_vec_30[111 : 56] = dep_chan_data_8_30;
    assign token_in_vec_30[1] = token_8_30;
    assign in_chan_dep_vld_vec_30[2] = dep_chan_vld_14_30;
    assign in_chan_dep_data_vec_30[167 : 112] = dep_chan_data_14_30;
    assign token_in_vec_30[2] = token_14_30;
    assign in_chan_dep_vld_vec_30[3] = dep_chan_vld_22_30;
    assign in_chan_dep_data_vec_30[223 : 168] = dep_chan_data_22_30;
    assign token_in_vec_30[3] = token_22_30;
    assign in_chan_dep_vld_vec_30[4] = dep_chan_vld_38_30;
    assign in_chan_dep_data_vec_30[279 : 224] = dep_chan_data_38_30;
    assign token_in_vec_30[4] = token_38_30;
    assign in_chan_dep_vld_vec_30[5] = dep_chan_vld_49_30;
    assign in_chan_dep_data_vec_30[335 : 280] = dep_chan_data_49_30;
    assign token_in_vec_30[5] = token_49_30;
    assign in_chan_dep_vld_vec_30[6] = dep_chan_vld_51_30;
    assign in_chan_dep_data_vec_30[391 : 336] = dep_chan_data_51_30;
    assign token_in_vec_30[6] = token_51_30;
    assign in_chan_dep_vld_vec_30[7] = dep_chan_vld_55_30;
    assign in_chan_dep_data_vec_30[447 : 392] = dep_chan_data_55_30;
    assign token_in_vec_30[7] = token_55_30;
    assign dep_chan_vld_30_8 = out_chan_dep_vld_vec_30[0];
    assign dep_chan_data_30_8 = out_chan_dep_data_30;
    assign token_30_8 = token_out_vec_30[0];
    assign dep_chan_vld_30_14 = out_chan_dep_vld_vec_30[1];
    assign dep_chan_data_30_14 = out_chan_dep_data_30;
    assign token_30_14 = token_out_vec_30[1];
    assign dep_chan_vld_30_49 = out_chan_dep_vld_vec_30[2];
    assign dep_chan_data_30_49 = out_chan_dep_data_30;
    assign token_30_49 = token_out_vec_30[2];
    assign dep_chan_vld_30_51 = out_chan_dep_vld_vec_30[3];
    assign dep_chan_data_30_51 = out_chan_dep_data_30;
    assign token_30_51 = token_out_vec_30[3];
    assign dep_chan_vld_30_0 = out_chan_dep_vld_vec_30[4];
    assign dep_chan_data_30_0 = out_chan_dep_data_30;
    assign token_30_0 = token_out_vec_30[4];
    assign dep_chan_vld_30_22 = out_chan_dep_vld_vec_30[5];
    assign dep_chan_data_30_22 = out_chan_dep_data_30;
    assign token_30_22 = token_out_vec_30[5];
    assign dep_chan_vld_30_38 = out_chan_dep_vld_vec_30[6];
    assign dep_chan_data_30_38 = out_chan_dep_data_30;
    assign token_30_38 = token_out_vec_30[6];
    assign dep_chan_vld_30_55 = out_chan_dep_vld_vec_30[7];
    assign dep_chan_data_30_55 = out_chan_dep_data_30;
    assign token_30_55 = token_out_vec_30[7];

    // Process: grp_shared_dataflow_fu_225.phase_band_640_400_U0.stencil_640_400_true_U0
    motion60_shared_hls_deadlock_detect_unit #(56, 31, 3, 3) motion60_shared_hls_deadlock_detect_unit_31 (
        .reset(dl_reset),
        .clock(dl_clock),
        .proc_dep_vld_vec(proc_dep_vld_vec_31),
        .in_chan_dep_vld_vec(in_chan_dep_vld_vec_31),
        .in_chan_dep_data_vec(in_chan_dep_data_vec_31),
        .token_in_vec(token_in_vec_31),
        .dl_detect_in(dl_detect_out),
        .origin(origin[31]),
        .token_clear(token_clear),
        .out_chan_dep_vld_vec(out_chan_dep_vld_vec_31),
        .out_chan_dep_data(out_chan_dep_data_31),
        .token_out_vec(token_out_vec_31),
        .dl_detect_out(dl_in_vec[31]));

    assign proc_31_data_FIFO_blk[0] = 1'b0 | (~grp_shared_dataflow_fu_225.phase_band_640_400_U0.stencil_640_400_true_U0.band1_blk_n) | (~grp_shared_dataflow_fu_225.phase_band_640_400_U0.stencil_640_400_true_U0.grp_stencil_640_400_true_Pipeline_horizontal_fu_158.band1_blk_n);
    assign proc_31_data_PIPO_blk[0] = 1'b0;
    assign proc_31_start_FIFO_blk[0] = 1'b0;
    assign proc_31_TLF_FIFO_blk[0] = 1'b0;
    assign proc_31_input_sync_blk[0] = 1'b0;
    assign proc_31_output_sync_blk[0] = 1'b0;
    assign proc_dep_vld_vec_31[0] = dl_detect_out ? proc_dep_vld_vec_31_reg[0] : (proc_31_data_FIFO_blk[0] | proc_31_data_PIPO_blk[0] | proc_31_start_FIFO_blk[0] | proc_31_TLF_FIFO_blk[0] | proc_31_input_sync_blk[0] | proc_31_output_sync_blk[0]);
    assign proc_31_data_FIFO_blk[1] = 1'b0 | (~grp_shared_dataflow_fu_225.phase_band_640_400_U0.stencil_640_400_true_U0.band1_blk_n) | (~grp_shared_dataflow_fu_225.phase_band_640_400_U0.stencil_640_400_true_U0.grp_stencil_640_400_true_Pipeline_horizontal_fu_158.band1_blk_n);
    assign proc_31_data_PIPO_blk[1] = 1'b0;
    assign proc_31_start_FIFO_blk[1] = 1'b0;
    assign proc_31_TLF_FIFO_blk[1] = 1'b0;
    assign proc_31_input_sync_blk[1] = 1'b0;
    assign proc_31_output_sync_blk[1] = 1'b0;
    assign proc_dep_vld_vec_31[1] = dl_detect_out ? proc_dep_vld_vec_31_reg[1] : (proc_31_data_FIFO_blk[1] | proc_31_data_PIPO_blk[1] | proc_31_start_FIFO_blk[1] | proc_31_TLF_FIFO_blk[1] | proc_31_input_sync_blk[1] | proc_31_output_sync_blk[1]);
    assign proc_31_data_FIFO_blk[2] = 1'b0 | (~grp_shared_dataflow_fu_225.phase_band_640_400_U0.stencil_640_400_true_U0.grp_stencil_640_400_true_Pipeline_vertical_fu_183.gradients_blk_n);
    assign proc_31_data_PIPO_blk[2] = 1'b0;
    assign proc_31_start_FIFO_blk[2] = 1'b0;
    assign proc_31_TLF_FIFO_blk[2] = 1'b0;
    assign proc_31_input_sync_blk[2] = 1'b0 | (grp_shared_dataflow_fu_225.phase_band_640_400_U0.ap_sync_stencil_640_400_true_U0_ap_ready & grp_shared_dataflow_fu_225.phase_band_640_400_U0.stencil_640_400_true_U0.ap_idle & ~grp_shared_dataflow_fu_225.phase_band_640_400_U0.ap_sync_phase_core_shared_1_U0_ap_ready);
    assign proc_31_output_sync_blk[2] = 1'b0;
    assign proc_dep_vld_vec_31[2] = dl_detect_out ? proc_dep_vld_vec_31_reg[2] : (proc_31_data_FIFO_blk[2] | proc_31_data_PIPO_blk[2] | proc_31_start_FIFO_blk[2] | proc_31_TLF_FIFO_blk[2] | proc_31_input_sync_blk[2] | proc_31_output_sync_blk[2]);
    always @ (negedge dl_reset or posedge dl_clock) begin
        if (~dl_reset) begin
            proc_dep_vld_vec_31_reg <= 'b0;
        end
        else begin
            proc_dep_vld_vec_31_reg <= proc_dep_vld_vec_31;
        end
    end
    assign in_chan_dep_vld_vec_31[0] = dep_chan_vld_8_31;
    assign in_chan_dep_data_vec_31[55 : 0] = dep_chan_data_8_31;
    assign token_in_vec_31[0] = token_8_31;
    assign in_chan_dep_vld_vec_31[1] = dep_chan_vld_14_31;
    assign in_chan_dep_data_vec_31[111 : 56] = dep_chan_data_14_31;
    assign token_in_vec_31[1] = token_14_31;
    assign in_chan_dep_vld_vec_31[2] = dep_chan_vld_32_31;
    assign in_chan_dep_data_vec_31[167 : 112] = dep_chan_data_32_31;
    assign token_in_vec_31[2] = token_32_31;
    assign dep_chan_vld_31_8 = out_chan_dep_vld_vec_31[0];
    assign dep_chan_data_31_8 = out_chan_dep_data_31;
    assign token_31_8 = token_out_vec_31[0];
    assign dep_chan_vld_31_14 = out_chan_dep_vld_vec_31[1];
    assign dep_chan_data_31_14 = out_chan_dep_data_31;
    assign token_31_14 = token_out_vec_31[1];
    assign dep_chan_vld_31_32 = out_chan_dep_vld_vec_31[2];
    assign dep_chan_data_31_32 = out_chan_dep_data_31;
    assign token_31_32 = token_out_vec_31[2];

    // Process: grp_shared_dataflow_fu_225.phase_band_640_400_U0.phase_core_shared_1_U0
    motion60_shared_hls_deadlock_detect_unit #(56, 32, 3, 3) motion60_shared_hls_deadlock_detect_unit_32 (
        .reset(dl_reset),
        .clock(dl_clock),
        .proc_dep_vld_vec(proc_dep_vld_vec_32),
        .in_chan_dep_vld_vec(in_chan_dep_vld_vec_32),
        .in_chan_dep_data_vec(in_chan_dep_data_vec_32),
        .token_in_vec(token_in_vec_32),
        .dl_detect_in(dl_detect_out),
        .origin(origin[32]),
        .token_clear(token_clear),
        .out_chan_dep_vld_vec(out_chan_dep_vld_vec_32),
        .out_chan_dep_data(out_chan_dep_data_32),
        .token_out_vec(token_out_vec_32),
        .dl_detect_out(dl_in_vec[32]));

    assign proc_32_data_FIFO_blk[0] = 1'b0 | (~grp_shared_dataflow_fu_225.phase_band_640_400_U0.phase_core_shared_1_U0.grp_phase_dataflow_6_fu_130.compute_phase11_U0.gradients_blk_n);
    assign proc_32_data_PIPO_blk[0] = 1'b0;
    assign proc_32_start_FIFO_blk[0] = 1'b0;
    assign proc_32_TLF_FIFO_blk[0] = 1'b0;
    assign proc_32_input_sync_blk[0] = 1'b0 | (grp_shared_dataflow_fu_225.phase_band_640_400_U0.ap_sync_phase_core_shared_1_U0_ap_ready & grp_shared_dataflow_fu_225.phase_band_640_400_U0.phase_core_shared_1_U0.ap_idle & ~grp_shared_dataflow_fu_225.phase_band_640_400_U0.ap_sync_stencil_640_400_true_U0_ap_ready);
    assign proc_32_output_sync_blk[0] = 1'b0;
    assign proc_dep_vld_vec_32[0] = dl_detect_out ? proc_dep_vld_vec_32_reg[0] : (proc_32_data_FIFO_blk[0] | proc_32_data_PIPO_blk[0] | proc_32_start_FIFO_blk[0] | proc_32_TLF_FIFO_blk[0] | proc_32_input_sync_blk[0] | proc_32_output_sync_blk[0]);
    assign proc_32_data_FIFO_blk[1] = 1'b0 | (~grp_shared_dataflow_fu_225.phase_band_640_400_U0.phase_core_shared_1_U0.grp_phase_dataflow_6_fu_130.compute_phase11_U0.p2_blk_n);
    assign proc_32_data_PIPO_blk[1] = 1'b0;
    assign proc_32_start_FIFO_blk[1] = 1'b0;
    assign proc_32_TLF_FIFO_blk[1] = 1'b0;
    assign proc_32_input_sync_blk[1] = 1'b0;
    assign proc_32_output_sync_blk[1] = 1'b0;
    assign proc_dep_vld_vec_32[1] = dl_detect_out ? proc_dep_vld_vec_32_reg[1] : (proc_32_data_FIFO_blk[1] | proc_32_data_PIPO_blk[1] | proc_32_start_FIFO_blk[1] | proc_32_TLF_FIFO_blk[1] | proc_32_input_sync_blk[1] | proc_32_output_sync_blk[1]);
    assign proc_32_data_FIFO_blk[2] = 1'b0 | (~grp_shared_dataflow_fu_225.phase_band_640_400_U0.phase_core_shared_1_U0.grp_phase_dataflow_6_fu_130.compute_phase11_U0.p2_blk_n);
    assign proc_32_data_PIPO_blk[2] = 1'b0;
    assign proc_32_start_FIFO_blk[2] = 1'b0;
    assign proc_32_TLF_FIFO_blk[2] = 1'b0;
    assign proc_32_input_sync_blk[2] = 1'b0;
    assign proc_32_output_sync_blk[2] = 1'b0;
    assign proc_dep_vld_vec_32[2] = dl_detect_out ? proc_dep_vld_vec_32_reg[2] : (proc_32_data_FIFO_blk[2] | proc_32_data_PIPO_blk[2] | proc_32_start_FIFO_blk[2] | proc_32_TLF_FIFO_blk[2] | proc_32_input_sync_blk[2] | proc_32_output_sync_blk[2]);
    always @ (negedge dl_reset or posedge dl_clock) begin
        if (~dl_reset) begin
            proc_dep_vld_vec_32_reg <= 'b0;
        end
        else begin
            proc_dep_vld_vec_32_reg <= proc_dep_vld_vec_32;
        end
    end
    assign in_chan_dep_vld_vec_32[0] = dep_chan_vld_31_32;
    assign in_chan_dep_data_vec_32[55 : 0] = dep_chan_data_31_32;
    assign token_in_vec_32[0] = token_31_32;
    assign in_chan_dep_vld_vec_32[1] = dep_chan_vld_49_32;
    assign in_chan_dep_data_vec_32[111 : 56] = dep_chan_data_49_32;
    assign token_in_vec_32[1] = token_49_32;
    assign in_chan_dep_vld_vec_32[2] = dep_chan_vld_51_32;
    assign in_chan_dep_data_vec_32[167 : 112] = dep_chan_data_51_32;
    assign token_in_vec_32[2] = token_51_32;
    assign dep_chan_vld_32_31 = out_chan_dep_vld_vec_32[0];
    assign dep_chan_data_32_31 = out_chan_dep_data_32;
    assign token_32_31 = token_out_vec_32[0];
    assign dep_chan_vld_32_49 = out_chan_dep_vld_vec_32[1];
    assign dep_chan_data_32_49 = out_chan_dep_data_32;
    assign token_32_49 = token_out_vec_32[1];
    assign dep_chan_vld_32_51 = out_chan_dep_vld_vec_32[2];
    assign dep_chan_data_32_51 = out_chan_dep_data_32;
    assign token_32_51 = token_out_vec_32[2];

    // Process: grp_shared_dataflow_fu_225.phase_band_640_400_U0.phase_core_shared_1_U0.grp_phase_dataflow_6_fu_130.read_words_8_U0
    motion60_shared_hls_deadlock_detect_unit #(56, 33, 1, 1) motion60_shared_hls_deadlock_detect_unit_33 (
        .reset(dl_reset),
        .clock(dl_clock),
        .proc_dep_vld_vec(proc_dep_vld_vec_33),
        .in_chan_dep_vld_vec(in_chan_dep_vld_vec_33),
        .in_chan_dep_data_vec(in_chan_dep_data_vec_33),
        .token_in_vec(token_in_vec_33),
        .dl_detect_in(dl_detect_out),
        .origin(origin[33]),
        .token_clear(token_clear),
        .out_chan_dep_vld_vec(out_chan_dep_vld_vec_33),
        .out_chan_dep_data(out_chan_dep_data_33),
        .token_out_vec(token_out_vec_33),
        .dl_detect_out(dl_in_vec[33]));

    assign proc_33_data_FIFO_blk[0] = 1'b0 | (~grp_shared_dataflow_fu_225.phase_band_640_400_U0.phase_core_shared_1_U0.grp_phase_dataflow_6_fu_130.read_words_8_U0.grp_read_words_8_Pipeline_VITIS_LOOP_10_1_fu_78.read_bus_blk_n);
    assign proc_33_data_PIPO_blk[0] = 1'b0;
    assign proc_33_start_FIFO_blk[0] = 1'b0 | (~grp_shared_dataflow_fu_225.phase_band_640_400_U0.phase_core_shared_1_U0.grp_phase_dataflow_6_fu_130.start_for_unpack_history10_U0_U.if_full_n & grp_shared_dataflow_fu_225.phase_band_640_400_U0.phase_core_shared_1_U0.grp_phase_dataflow_6_fu_130.read_words_8_U0.ap_start & ~grp_shared_dataflow_fu_225.phase_band_640_400_U0.phase_core_shared_1_U0.grp_phase_dataflow_6_fu_130.read_words_8_U0.real_start & (trans_in_cnt_19 == trans_out_cnt_19) & ~grp_shared_dataflow_fu_225.phase_band_640_400_U0.phase_core_shared_1_U0.grp_phase_dataflow_6_fu_130.start_for_unpack_history10_U0_U.if_read);
    assign proc_33_TLF_FIFO_blk[0] = 1'b0;
    assign proc_33_input_sync_blk[0] = 1'b0;
    assign proc_33_output_sync_blk[0] = 1'b0;
    assign proc_dep_vld_vec_33[0] = dl_detect_out ? proc_dep_vld_vec_33_reg[0] : (proc_33_data_FIFO_blk[0] | proc_33_data_PIPO_blk[0] | proc_33_start_FIFO_blk[0] | proc_33_TLF_FIFO_blk[0] | proc_33_input_sync_blk[0] | proc_33_output_sync_blk[0]);
    always @ (negedge dl_reset or posedge dl_clock) begin
        if (~dl_reset) begin
            proc_dep_vld_vec_33_reg <= 'b0;
        end
        else begin
            proc_dep_vld_vec_33_reg <= proc_dep_vld_vec_33;
        end
    end
    assign in_chan_dep_vld_vec_33[0] = dep_chan_vld_34_33;
    assign in_chan_dep_data_vec_33[55 : 0] = dep_chan_data_34_33;
    assign token_in_vec_33[0] = token_34_33;
    assign dep_chan_vld_33_34 = out_chan_dep_vld_vec_33[0];
    assign dep_chan_data_33_34 = out_chan_dep_data_33;
    assign token_33_34 = token_out_vec_33[0];

    // Process: grp_shared_dataflow_fu_225.phase_band_640_400_U0.phase_core_shared_1_U0.grp_phase_dataflow_6_fu_130.unpack_history10_U0
    motion60_shared_hls_deadlock_detect_unit #(56, 34, 2, 2) motion60_shared_hls_deadlock_detect_unit_34 (
        .reset(dl_reset),
        .clock(dl_clock),
        .proc_dep_vld_vec(proc_dep_vld_vec_34),
        .in_chan_dep_vld_vec(in_chan_dep_vld_vec_34),
        .in_chan_dep_data_vec(in_chan_dep_data_vec_34),
        .token_in_vec(token_in_vec_34),
        .dl_detect_in(dl_detect_out),
        .origin(origin[34]),
        .token_clear(token_clear),
        .out_chan_dep_vld_vec(out_chan_dep_vld_vec_34),
        .out_chan_dep_data(out_chan_dep_data_34),
        .token_out_vec(token_out_vec_34),
        .dl_detect_out(dl_in_vec[34]));

    assign proc_34_data_FIFO_blk[0] = 1'b0 | (~grp_shared_dataflow_fu_225.phase_band_640_400_U0.phase_core_shared_1_U0.grp_phase_dataflow_6_fu_130.unpack_history10_U0.read_bus_blk_n);
    assign proc_34_data_PIPO_blk[0] = 1'b0;
    assign proc_34_start_FIFO_blk[0] = 1'b0 | (~grp_shared_dataflow_fu_225.phase_band_640_400_U0.phase_core_shared_1_U0.grp_phase_dataflow_6_fu_130.start_for_unpack_history10_U0_U.if_empty_n & grp_shared_dataflow_fu_225.phase_band_640_400_U0.phase_core_shared_1_U0.grp_phase_dataflow_6_fu_130.unpack_history10_U0.ap_idle & ~grp_shared_dataflow_fu_225.phase_band_640_400_U0.phase_core_shared_1_U0.grp_phase_dataflow_6_fu_130.start_for_unpack_history10_U0_U.if_write);
    assign proc_34_TLF_FIFO_blk[0] = 1'b0;
    assign proc_34_input_sync_blk[0] = 1'b0;
    assign proc_34_output_sync_blk[0] = 1'b0;
    assign proc_dep_vld_vec_34[0] = dl_detect_out ? proc_dep_vld_vec_34_reg[0] : (proc_34_data_FIFO_blk[0] | proc_34_data_PIPO_blk[0] | proc_34_start_FIFO_blk[0] | proc_34_TLF_FIFO_blk[0] | proc_34_input_sync_blk[0] | proc_34_output_sync_blk[0]);
    assign proc_34_data_FIFO_blk[1] = 1'b0 | (~grp_shared_dataflow_fu_225.phase_band_640_400_U0.phase_core_shared_1_U0.grp_phase_dataflow_6_fu_130.unpack_history10_U0.history_blk_n);
    assign proc_34_data_PIPO_blk[1] = 1'b0;
    assign proc_34_start_FIFO_blk[1] = 1'b0 | (~grp_shared_dataflow_fu_225.phase_band_640_400_U0.phase_core_shared_1_U0.grp_phase_dataflow_6_fu_130.start_for_compute_phase11_U0_U.if_full_n & grp_shared_dataflow_fu_225.phase_band_640_400_U0.phase_core_shared_1_U0.grp_phase_dataflow_6_fu_130.unpack_history10_U0.ap_start & ~grp_shared_dataflow_fu_225.phase_band_640_400_U0.phase_core_shared_1_U0.grp_phase_dataflow_6_fu_130.unpack_history10_U0.real_start & (trans_in_cnt_20 == trans_out_cnt_20) & ~grp_shared_dataflow_fu_225.phase_band_640_400_U0.phase_core_shared_1_U0.grp_phase_dataflow_6_fu_130.start_for_compute_phase11_U0_U.if_read);
    assign proc_34_TLF_FIFO_blk[1] = 1'b0;
    assign proc_34_input_sync_blk[1] = 1'b0;
    assign proc_34_output_sync_blk[1] = 1'b0;
    assign proc_dep_vld_vec_34[1] = dl_detect_out ? proc_dep_vld_vec_34_reg[1] : (proc_34_data_FIFO_blk[1] | proc_34_data_PIPO_blk[1] | proc_34_start_FIFO_blk[1] | proc_34_TLF_FIFO_blk[1] | proc_34_input_sync_blk[1] | proc_34_output_sync_blk[1]);
    always @ (negedge dl_reset or posedge dl_clock) begin
        if (~dl_reset) begin
            proc_dep_vld_vec_34_reg <= 'b0;
        end
        else begin
            proc_dep_vld_vec_34_reg <= proc_dep_vld_vec_34;
        end
    end
    assign in_chan_dep_vld_vec_34[0] = dep_chan_vld_33_34;
    assign in_chan_dep_data_vec_34[55 : 0] = dep_chan_data_33_34;
    assign token_in_vec_34[0] = token_33_34;
    assign in_chan_dep_vld_vec_34[1] = dep_chan_vld_35_34;
    assign in_chan_dep_data_vec_34[111 : 56] = dep_chan_data_35_34;
    assign token_in_vec_34[1] = token_35_34;
    assign dep_chan_vld_34_33 = out_chan_dep_vld_vec_34[0];
    assign dep_chan_data_34_33 = out_chan_dep_data_34;
    assign token_34_33 = token_out_vec_34[0];
    assign dep_chan_vld_34_35 = out_chan_dep_vld_vec_34[1];
    assign dep_chan_data_34_35 = out_chan_dep_data_34;
    assign token_34_35 = token_out_vec_34[1];

    // Process: grp_shared_dataflow_fu_225.phase_band_640_400_U0.phase_core_shared_1_U0.grp_phase_dataflow_6_fu_130.compute_phase11_U0
    motion60_shared_hls_deadlock_detect_unit #(56, 35, 3, 3) motion60_shared_hls_deadlock_detect_unit_35 (
        .reset(dl_reset),
        .clock(dl_clock),
        .proc_dep_vld_vec(proc_dep_vld_vec_35),
        .in_chan_dep_vld_vec(in_chan_dep_vld_vec_35),
        .in_chan_dep_data_vec(in_chan_dep_data_vec_35),
        .token_in_vec(token_in_vec_35),
        .dl_detect_in(dl_detect_out),
        .origin(origin[35]),
        .token_clear(token_clear),
        .out_chan_dep_vld_vec(out_chan_dep_vld_vec_35),
        .out_chan_dep_data(out_chan_dep_data_35),
        .token_out_vec(token_out_vec_35),
        .dl_detect_out(dl_in_vec[35]));

    assign proc_35_data_FIFO_blk[0] = 1'b0 | (~grp_shared_dataflow_fu_225.phase_band_640_400_U0.phase_core_shared_1_U0.grp_phase_dataflow_6_fu_130.compute_phase11_U0.history_blk_n);
    assign proc_35_data_PIPO_blk[0] = 1'b0;
    assign proc_35_start_FIFO_blk[0] = 1'b0 | (~grp_shared_dataflow_fu_225.phase_band_640_400_U0.phase_core_shared_1_U0.grp_phase_dataflow_6_fu_130.start_for_compute_phase11_U0_U.if_empty_n & grp_shared_dataflow_fu_225.phase_band_640_400_U0.phase_core_shared_1_U0.grp_phase_dataflow_6_fu_130.compute_phase11_U0.ap_idle & ~grp_shared_dataflow_fu_225.phase_band_640_400_U0.phase_core_shared_1_U0.grp_phase_dataflow_6_fu_130.start_for_compute_phase11_U0_U.if_write);
    assign proc_35_TLF_FIFO_blk[0] = 1'b0;
    assign proc_35_input_sync_blk[0] = 1'b0;
    assign proc_35_output_sync_blk[0] = 1'b0;
    assign proc_dep_vld_vec_35[0] = dl_detect_out ? proc_dep_vld_vec_35_reg[0] : (proc_35_data_FIFO_blk[0] | proc_35_data_PIPO_blk[0] | proc_35_start_FIFO_blk[0] | proc_35_TLF_FIFO_blk[0] | proc_35_input_sync_blk[0] | proc_35_output_sync_blk[0]);
    assign proc_35_data_FIFO_blk[1] = 1'b0 | (~grp_shared_dataflow_fu_225.phase_band_640_400_U0.phase_core_shared_1_U0.grp_phase_dataflow_6_fu_130.compute_phase11_U0.updated_blk_n);
    assign proc_35_data_PIPO_blk[1] = 1'b0;
    assign proc_35_start_FIFO_blk[1] = 1'b0 | (~grp_shared_dataflow_fu_225.phase_band_640_400_U0.phase_core_shared_1_U0.grp_phase_dataflow_6_fu_130.start_for_pack_history12_U0_U.if_full_n & grp_shared_dataflow_fu_225.phase_band_640_400_U0.phase_core_shared_1_U0.grp_phase_dataflow_6_fu_130.compute_phase11_U0.ap_start & ~grp_shared_dataflow_fu_225.phase_band_640_400_U0.phase_core_shared_1_U0.grp_phase_dataflow_6_fu_130.compute_phase11_U0.real_start & (trans_in_cnt_21 == trans_out_cnt_21) & ~grp_shared_dataflow_fu_225.phase_band_640_400_U0.phase_core_shared_1_U0.grp_phase_dataflow_6_fu_130.start_for_pack_history12_U0_U.if_read);
    assign proc_35_TLF_FIFO_blk[1] = 1'b0;
    assign proc_35_input_sync_blk[1] = 1'b0;
    assign proc_35_output_sync_blk[1] = 1'b0;
    assign proc_dep_vld_vec_35[1] = dl_detect_out ? proc_dep_vld_vec_35_reg[1] : (proc_35_data_FIFO_blk[1] | proc_35_data_PIPO_blk[1] | proc_35_start_FIFO_blk[1] | proc_35_TLF_FIFO_blk[1] | proc_35_input_sync_blk[1] | proc_35_output_sync_blk[1]);
    assign proc_35_data_FIFO_blk[2] = 1'b0;
    assign proc_35_data_PIPO_blk[2] = 1'b0;
    assign proc_35_start_FIFO_blk[2] = 1'b0;
    assign proc_35_TLF_FIFO_blk[2] = 1'b0;
    assign proc_35_input_sync_blk[2] = 1'b0;
    assign proc_35_output_sync_blk[2] = 1'b0 | (ap_done_reg_12 & grp_shared_dataflow_fu_225.phase_band_640_400_U0.phase_core_shared_1_U0.grp_phase_dataflow_6_fu_130.compute_phase11_U0.ap_done & ~grp_shared_dataflow_fu_225.phase_band_640_400_U0.phase_core_shared_1_U0.grp_phase_dataflow_6_fu_130.write_words_9_U0.ap_done);
    assign proc_dep_vld_vec_35[2] = dl_detect_out ? proc_dep_vld_vec_35_reg[2] : (proc_35_data_FIFO_blk[2] | proc_35_data_PIPO_blk[2] | proc_35_start_FIFO_blk[2] | proc_35_TLF_FIFO_blk[2] | proc_35_input_sync_blk[2] | proc_35_output_sync_blk[2]);
    always @ (negedge dl_reset or posedge dl_clock) begin
        if (~dl_reset) begin
            proc_dep_vld_vec_35_reg <= 'b0;
        end
        else begin
            proc_dep_vld_vec_35_reg <= proc_dep_vld_vec_35;
        end
    end
    assign in_chan_dep_vld_vec_35[0] = dep_chan_vld_34_35;
    assign in_chan_dep_data_vec_35[55 : 0] = dep_chan_data_34_35;
    assign token_in_vec_35[0] = token_34_35;
    assign in_chan_dep_vld_vec_35[1] = dep_chan_vld_36_35;
    assign in_chan_dep_data_vec_35[111 : 56] = dep_chan_data_36_35;
    assign token_in_vec_35[1] = token_36_35;
    assign in_chan_dep_vld_vec_35[2] = dep_chan_vld_37_35;
    assign in_chan_dep_data_vec_35[167 : 112] = dep_chan_data_37_35;
    assign token_in_vec_35[2] = token_37_35;
    assign dep_chan_vld_35_34 = out_chan_dep_vld_vec_35[0];
    assign dep_chan_data_35_34 = out_chan_dep_data_35;
    assign token_35_34 = token_out_vec_35[0];
    assign dep_chan_vld_35_36 = out_chan_dep_vld_vec_35[1];
    assign dep_chan_data_35_36 = out_chan_dep_data_35;
    assign token_35_36 = token_out_vec_35[1];
    assign dep_chan_vld_35_37 = out_chan_dep_vld_vec_35[2];
    assign dep_chan_data_35_37 = out_chan_dep_data_35;
    assign token_35_37 = token_out_vec_35[2];

    // Process: grp_shared_dataflow_fu_225.phase_band_640_400_U0.phase_core_shared_1_U0.grp_phase_dataflow_6_fu_130.pack_history12_U0
    motion60_shared_hls_deadlock_detect_unit #(56, 36, 2, 2) motion60_shared_hls_deadlock_detect_unit_36 (
        .reset(dl_reset),
        .clock(dl_clock),
        .proc_dep_vld_vec(proc_dep_vld_vec_36),
        .in_chan_dep_vld_vec(in_chan_dep_vld_vec_36),
        .in_chan_dep_data_vec(in_chan_dep_data_vec_36),
        .token_in_vec(token_in_vec_36),
        .dl_detect_in(dl_detect_out),
        .origin(origin[36]),
        .token_clear(token_clear),
        .out_chan_dep_vld_vec(out_chan_dep_vld_vec_36),
        .out_chan_dep_data(out_chan_dep_data_36),
        .token_out_vec(token_out_vec_36),
        .dl_detect_out(dl_in_vec[36]));

    assign proc_36_data_FIFO_blk[0] = 1'b0 | (~grp_shared_dataflow_fu_225.phase_band_640_400_U0.phase_core_shared_1_U0.grp_phase_dataflow_6_fu_130.pack_history12_U0.updated_blk_n);
    assign proc_36_data_PIPO_blk[0] = 1'b0;
    assign proc_36_start_FIFO_blk[0] = 1'b0 | (~grp_shared_dataflow_fu_225.phase_band_640_400_U0.phase_core_shared_1_U0.grp_phase_dataflow_6_fu_130.start_for_pack_history12_U0_U.if_empty_n & grp_shared_dataflow_fu_225.phase_band_640_400_U0.phase_core_shared_1_U0.grp_phase_dataflow_6_fu_130.pack_history12_U0.ap_idle & ~grp_shared_dataflow_fu_225.phase_band_640_400_U0.phase_core_shared_1_U0.grp_phase_dataflow_6_fu_130.start_for_pack_history12_U0_U.if_write);
    assign proc_36_TLF_FIFO_blk[0] = 1'b0;
    assign proc_36_input_sync_blk[0] = 1'b0;
    assign proc_36_output_sync_blk[0] = 1'b0;
    assign proc_dep_vld_vec_36[0] = dl_detect_out ? proc_dep_vld_vec_36_reg[0] : (proc_36_data_FIFO_blk[0] | proc_36_data_PIPO_blk[0] | proc_36_start_FIFO_blk[0] | proc_36_TLF_FIFO_blk[0] | proc_36_input_sync_blk[0] | proc_36_output_sync_blk[0]);
    assign proc_36_data_FIFO_blk[1] = 1'b0 | (~grp_shared_dataflow_fu_225.phase_band_640_400_U0.phase_core_shared_1_U0.grp_phase_dataflow_6_fu_130.pack_history12_U0.write_bus_blk_n);
    assign proc_36_data_PIPO_blk[1] = 1'b0;
    assign proc_36_start_FIFO_blk[1] = 1'b0 | (~grp_shared_dataflow_fu_225.phase_band_640_400_U0.phase_core_shared_1_U0.grp_phase_dataflow_6_fu_130.start_for_write_words_9_U0_U.if_full_n & grp_shared_dataflow_fu_225.phase_band_640_400_U0.phase_core_shared_1_U0.grp_phase_dataflow_6_fu_130.pack_history12_U0.ap_start & ~grp_shared_dataflow_fu_225.phase_band_640_400_U0.phase_core_shared_1_U0.grp_phase_dataflow_6_fu_130.pack_history12_U0.real_start & (trans_in_cnt_22 == trans_out_cnt_22) & ~grp_shared_dataflow_fu_225.phase_band_640_400_U0.phase_core_shared_1_U0.grp_phase_dataflow_6_fu_130.start_for_write_words_9_U0_U.if_read);
    assign proc_36_TLF_FIFO_blk[1] = 1'b0;
    assign proc_36_input_sync_blk[1] = 1'b0;
    assign proc_36_output_sync_blk[1] = 1'b0;
    assign proc_dep_vld_vec_36[1] = dl_detect_out ? proc_dep_vld_vec_36_reg[1] : (proc_36_data_FIFO_blk[1] | proc_36_data_PIPO_blk[1] | proc_36_start_FIFO_blk[1] | proc_36_TLF_FIFO_blk[1] | proc_36_input_sync_blk[1] | proc_36_output_sync_blk[1]);
    always @ (negedge dl_reset or posedge dl_clock) begin
        if (~dl_reset) begin
            proc_dep_vld_vec_36_reg <= 'b0;
        end
        else begin
            proc_dep_vld_vec_36_reg <= proc_dep_vld_vec_36;
        end
    end
    assign in_chan_dep_vld_vec_36[0] = dep_chan_vld_35_36;
    assign in_chan_dep_data_vec_36[55 : 0] = dep_chan_data_35_36;
    assign token_in_vec_36[0] = token_35_36;
    assign in_chan_dep_vld_vec_36[1] = dep_chan_vld_37_36;
    assign in_chan_dep_data_vec_36[111 : 56] = dep_chan_data_37_36;
    assign token_in_vec_36[1] = token_37_36;
    assign dep_chan_vld_36_35 = out_chan_dep_vld_vec_36[0];
    assign dep_chan_data_36_35 = out_chan_dep_data_36;
    assign token_36_35 = token_out_vec_36[0];
    assign dep_chan_vld_36_37 = out_chan_dep_vld_vec_36[1];
    assign dep_chan_data_36_37 = out_chan_dep_data_36;
    assign token_36_37 = token_out_vec_36[1];

    // Process: grp_shared_dataflow_fu_225.phase_band_640_400_U0.phase_core_shared_1_U0.grp_phase_dataflow_6_fu_130.write_words_9_U0
    motion60_shared_hls_deadlock_detect_unit #(56, 37, 2, 2) motion60_shared_hls_deadlock_detect_unit_37 (
        .reset(dl_reset),
        .clock(dl_clock),
        .proc_dep_vld_vec(proc_dep_vld_vec_37),
        .in_chan_dep_vld_vec(in_chan_dep_vld_vec_37),
        .in_chan_dep_data_vec(in_chan_dep_data_vec_37),
        .token_in_vec(token_in_vec_37),
        .dl_detect_in(dl_detect_out),
        .origin(origin[37]),
        .token_clear(token_clear),
        .out_chan_dep_vld_vec(out_chan_dep_vld_vec_37),
        .out_chan_dep_data(out_chan_dep_data_37),
        .token_out_vec(token_out_vec_37),
        .dl_detect_out(dl_in_vec[37]));

    assign proc_37_data_FIFO_blk[0] = 1'b0 | (~grp_shared_dataflow_fu_225.phase_band_640_400_U0.phase_core_shared_1_U0.grp_phase_dataflow_6_fu_130.write_words_9_U0.grp_write_words_9_Pipeline_VITIS_LOOP_17_1_fu_85.write_bus_blk_n);
    assign proc_37_data_PIPO_blk[0] = 1'b0;
    assign proc_37_start_FIFO_blk[0] = 1'b0 | (~grp_shared_dataflow_fu_225.phase_band_640_400_U0.phase_core_shared_1_U0.grp_phase_dataflow_6_fu_130.start_for_write_words_9_U0_U.if_empty_n & grp_shared_dataflow_fu_225.phase_band_640_400_U0.phase_core_shared_1_U0.grp_phase_dataflow_6_fu_130.write_words_9_U0.ap_idle & ~grp_shared_dataflow_fu_225.phase_band_640_400_U0.phase_core_shared_1_U0.grp_phase_dataflow_6_fu_130.start_for_write_words_9_U0_U.if_write);
    assign proc_37_TLF_FIFO_blk[0] = 1'b0;
    assign proc_37_input_sync_blk[0] = 1'b0;
    assign proc_37_output_sync_blk[0] = 1'b0;
    assign proc_dep_vld_vec_37[0] = dl_detect_out ? proc_dep_vld_vec_37_reg[0] : (proc_37_data_FIFO_blk[0] | proc_37_data_PIPO_blk[0] | proc_37_start_FIFO_blk[0] | proc_37_TLF_FIFO_blk[0] | proc_37_input_sync_blk[0] | proc_37_output_sync_blk[0]);
    assign proc_37_data_FIFO_blk[1] = 1'b0;
    assign proc_37_data_PIPO_blk[1] = 1'b0;
    assign proc_37_start_FIFO_blk[1] = 1'b0;
    assign proc_37_TLF_FIFO_blk[1] = 1'b0;
    assign proc_37_input_sync_blk[1] = 1'b0;
    assign proc_37_output_sync_blk[1] = 1'b0 | (ap_done_reg_13 & grp_shared_dataflow_fu_225.phase_band_640_400_U0.phase_core_shared_1_U0.grp_phase_dataflow_6_fu_130.write_words_9_U0.ap_done & ~grp_shared_dataflow_fu_225.phase_band_640_400_U0.phase_core_shared_1_U0.grp_phase_dataflow_6_fu_130.compute_phase11_U0.ap_done);
    assign proc_dep_vld_vec_37[1] = dl_detect_out ? proc_dep_vld_vec_37_reg[1] : (proc_37_data_FIFO_blk[1] | proc_37_data_PIPO_blk[1] | proc_37_start_FIFO_blk[1] | proc_37_TLF_FIFO_blk[1] | proc_37_input_sync_blk[1] | proc_37_output_sync_blk[1]);
    always @ (negedge dl_reset or posedge dl_clock) begin
        if (~dl_reset) begin
            proc_dep_vld_vec_37_reg <= 'b0;
        end
        else begin
            proc_dep_vld_vec_37_reg <= proc_dep_vld_vec_37;
        end
    end
    assign in_chan_dep_vld_vec_37[0] = dep_chan_vld_35_37;
    assign in_chan_dep_data_vec_37[55 : 0] = dep_chan_data_35_37;
    assign token_in_vec_37[0] = token_35_37;
    assign in_chan_dep_vld_vec_37[1] = dep_chan_vld_36_37;
    assign in_chan_dep_data_vec_37[111 : 56] = dep_chan_data_36_37;
    assign token_in_vec_37[1] = token_36_37;
    assign dep_chan_vld_37_36 = out_chan_dep_vld_vec_37[0];
    assign dep_chan_data_37_36 = out_chan_dep_data_37;
    assign token_37_36 = token_out_vec_37[0];
    assign dep_chan_vld_37_35 = out_chan_dep_vld_vec_37[1];
    assign dep_chan_data_37_35 = out_chan_dep_data_37;
    assign token_37_35 = token_out_vec_37[1];

    // Process: grp_shared_dataflow_fu_225.phase_band_320_200_U0
    motion60_shared_hls_deadlock_detect_unit #(56, 38, 8, 8) motion60_shared_hls_deadlock_detect_unit_38 (
        .reset(dl_reset),
        .clock(dl_clock),
        .proc_dep_vld_vec(proc_dep_vld_vec_38),
        .in_chan_dep_vld_vec(in_chan_dep_vld_vec_38),
        .in_chan_dep_data_vec(in_chan_dep_data_vec_38),
        .token_in_vec(token_in_vec_38),
        .dl_detect_in(dl_detect_out),
        .origin(origin[38]),
        .token_clear(token_clear),
        .out_chan_dep_vld_vec(out_chan_dep_vld_vec_38),
        .out_chan_dep_data(out_chan_dep_data_38),
        .token_out_vec(token_out_vec_38),
        .dl_detect_out(dl_in_vec[38]));

    assign proc_38_data_FIFO_blk[0] = 1'b0 | (~grp_shared_dataflow_fu_225.phase_band_320_200_U0.stencil_320_200_true_U0.grp_stencil_320_200_true_Pipeline_horizontal_fu_158.band2_blk_n) | (~grp_shared_dataflow_fu_225.phase_band_320_200_U0.stencil_320_200_true_U0.band2_blk_n);
    assign proc_38_data_PIPO_blk[0] = 1'b0;
    assign proc_38_start_FIFO_blk[0] = 1'b0;
    assign proc_38_TLF_FIFO_blk[0] = 1'b0;
    assign proc_38_input_sync_blk[0] = 1'b0;
    assign proc_38_output_sync_blk[0] = 1'b0;
    assign proc_dep_vld_vec_38[0] = dl_detect_out ? proc_dep_vld_vec_38_reg[0] : (proc_38_data_FIFO_blk[0] | proc_38_data_PIPO_blk[0] | proc_38_start_FIFO_blk[0] | proc_38_TLF_FIFO_blk[0] | proc_38_input_sync_blk[0] | proc_38_output_sync_blk[0]);
    assign proc_38_data_FIFO_blk[1] = 1'b0 | (~grp_shared_dataflow_fu_225.phase_band_320_200_U0.stencil_320_200_true_U0.grp_stencil_320_200_true_Pipeline_horizontal_fu_158.band2_blk_n) | (~grp_shared_dataflow_fu_225.phase_band_320_200_U0.stencil_320_200_true_U0.band2_blk_n);
    assign proc_38_data_PIPO_blk[1] = 1'b0;
    assign proc_38_start_FIFO_blk[1] = 1'b0;
    assign proc_38_TLF_FIFO_blk[1] = 1'b0;
    assign proc_38_input_sync_blk[1] = 1'b0;
    assign proc_38_output_sync_blk[1] = 1'b0;
    assign proc_dep_vld_vec_38[1] = dl_detect_out ? proc_dep_vld_vec_38_reg[1] : (proc_38_data_FIFO_blk[1] | proc_38_data_PIPO_blk[1] | proc_38_start_FIFO_blk[1] | proc_38_TLF_FIFO_blk[1] | proc_38_input_sync_blk[1] | proc_38_output_sync_blk[1]);
    assign proc_38_data_FIFO_blk[2] = 1'b0 | (~grp_shared_dataflow_fu_225.phase_band_320_200_U0.phase_core_shared_2_U0.grp_phase_dataflow_7_fu_130.compute_phase14_U0.p2_blk_n);
    assign proc_38_data_PIPO_blk[2] = 1'b0;
    assign proc_38_start_FIFO_blk[2] = 1'b0 | (~grp_shared_dataflow_fu_225.start_for_reconstruct_320_200_U0_U.if_full_n & grp_shared_dataflow_fu_225.phase_band_320_200_U0.ap_start & ~grp_shared_dataflow_fu_225.phase_band_320_200_U0.real_start & (trans_in_cnt_27 == trans_out_cnt_27) & ~grp_shared_dataflow_fu_225.start_for_reconstruct_320_200_U0_U.if_read);
    assign proc_38_TLF_FIFO_blk[2] = 1'b0;
    assign proc_38_input_sync_blk[2] = 1'b0;
    assign proc_38_output_sync_blk[2] = 1'b0;
    assign proc_dep_vld_vec_38[2] = dl_detect_out ? proc_dep_vld_vec_38_reg[2] : (proc_38_data_FIFO_blk[2] | proc_38_data_PIPO_blk[2] | proc_38_start_FIFO_blk[2] | proc_38_TLF_FIFO_blk[2] | proc_38_input_sync_blk[2] | proc_38_output_sync_blk[2]);
    assign proc_38_data_FIFO_blk[3] = 1'b0 | (~grp_shared_dataflow_fu_225.phase_band_320_200_U0.phase_core_shared_2_U0.grp_phase_dataflow_7_fu_130.compute_phase14_U0.p2_blk_n);
    assign proc_38_data_PIPO_blk[3] = 1'b0;
    assign proc_38_start_FIFO_blk[3] = 1'b0;
    assign proc_38_TLF_FIFO_blk[3] = 1'b0;
    assign proc_38_input_sync_blk[3] = 1'b0;
    assign proc_38_output_sync_blk[3] = 1'b0;
    assign proc_dep_vld_vec_38[3] = dl_detect_out ? proc_dep_vld_vec_38_reg[3] : (proc_38_data_FIFO_blk[3] | proc_38_data_PIPO_blk[3] | proc_38_start_FIFO_blk[3] | proc_38_TLF_FIFO_blk[3] | proc_38_input_sync_blk[3] | proc_38_output_sync_blk[3]);
    assign proc_38_data_FIFO_blk[4] = 1'b0;
    assign proc_38_data_PIPO_blk[4] = 1'b0;
    assign proc_38_start_FIFO_blk[4] = 1'b0;
    assign proc_38_TLF_FIFO_blk[4] = 1'b0;
    assign proc_38_input_sync_blk[4] = 1'b0 | (grp_shared_dataflow_fu_225.ap_sync_phase_band_320_200_U0_ap_ready & grp_shared_dataflow_fu_225.phase_band_320_200_U0.ap_idle & ~grp_shared_dataflow_fu_225.ap_sync_read_image_U0_ap_ready);
    assign proc_38_output_sync_blk[4] = 1'b0;
    assign proc_dep_vld_vec_38[4] = dl_detect_out ? proc_dep_vld_vec_38_reg[4] : (proc_38_data_FIFO_blk[4] | proc_38_data_PIPO_blk[4] | proc_38_start_FIFO_blk[4] | proc_38_TLF_FIFO_blk[4] | proc_38_input_sync_blk[4] | proc_38_output_sync_blk[4]);
    assign proc_38_data_FIFO_blk[5] = 1'b0;
    assign proc_38_data_PIPO_blk[5] = 1'b0;
    assign proc_38_start_FIFO_blk[5] = 1'b0;
    assign proc_38_TLF_FIFO_blk[5] = 1'b0;
    assign proc_38_input_sync_blk[5] = 1'b0 | (grp_shared_dataflow_fu_225.ap_sync_phase_band_320_200_U0_ap_ready & grp_shared_dataflow_fu_225.phase_band_320_200_U0.ap_idle & ~grp_shared_dataflow_fu_225.ap_sync_phase_band_1280_800_U0_ap_ready);
    assign proc_38_output_sync_blk[5] = 1'b0 | (ap_done_reg_2 & grp_shared_dataflow_fu_225.phase_band_320_200_U0.ap_done & ~grp_shared_dataflow_fu_225.phase_band_1280_800_U0.ap_done);
    assign proc_dep_vld_vec_38[5] = dl_detect_out ? proc_dep_vld_vec_38_reg[5] : (proc_38_data_FIFO_blk[5] | proc_38_data_PIPO_blk[5] | proc_38_start_FIFO_blk[5] | proc_38_TLF_FIFO_blk[5] | proc_38_input_sync_blk[5] | proc_38_output_sync_blk[5]);
    assign proc_38_data_FIFO_blk[6] = 1'b0;
    assign proc_38_data_PIPO_blk[6] = 1'b0;
    assign proc_38_start_FIFO_blk[6] = 1'b0;
    assign proc_38_TLF_FIFO_blk[6] = 1'b0;
    assign proc_38_input_sync_blk[6] = 1'b0 | (grp_shared_dataflow_fu_225.ap_sync_phase_band_320_200_U0_ap_ready & grp_shared_dataflow_fu_225.phase_band_320_200_U0.ap_idle & ~grp_shared_dataflow_fu_225.ap_sync_phase_band_640_400_U0_ap_ready);
    assign proc_38_output_sync_blk[6] = 1'b0 | (ap_done_reg_2 & grp_shared_dataflow_fu_225.phase_band_320_200_U0.ap_done & ~grp_shared_dataflow_fu_225.phase_band_640_400_U0.ap_done);
    assign proc_dep_vld_vec_38[6] = dl_detect_out ? proc_dep_vld_vec_38_reg[6] : (proc_38_data_FIFO_blk[6] | proc_38_data_PIPO_blk[6] | proc_38_start_FIFO_blk[6] | proc_38_TLF_FIFO_blk[6] | proc_38_input_sync_blk[6] | proc_38_output_sync_blk[6]);
    assign proc_38_data_FIFO_blk[7] = 1'b0;
    assign proc_38_data_PIPO_blk[7] = 1'b0;
    assign proc_38_start_FIFO_blk[7] = 1'b0;
    assign proc_38_TLF_FIFO_blk[7] = 1'b0;
    assign proc_38_input_sync_blk[7] = 1'b0;
    assign proc_38_output_sync_blk[7] = 1'b0 | (ap_done_reg_2 & grp_shared_dataflow_fu_225.phase_band_320_200_U0.ap_done & ~grp_shared_dataflow_fu_225.write_image_U0.ap_done);
    assign proc_dep_vld_vec_38[7] = dl_detect_out ? proc_dep_vld_vec_38_reg[7] : (proc_38_data_FIFO_blk[7] | proc_38_data_PIPO_blk[7] | proc_38_start_FIFO_blk[7] | proc_38_TLF_FIFO_blk[7] | proc_38_input_sync_blk[7] | proc_38_output_sync_blk[7]);
    always @ (negedge dl_reset or posedge dl_clock) begin
        if (~dl_reset) begin
            proc_dep_vld_vec_38_reg <= 'b0;
        end
        else begin
            proc_dep_vld_vec_38_reg <= proc_dep_vld_vec_38;
        end
    end
    assign in_chan_dep_vld_vec_38[0] = dep_chan_vld_0_38;
    assign in_chan_dep_data_vec_38[55 : 0] = dep_chan_data_0_38;
    assign token_in_vec_38[0] = token_0_38;
    assign in_chan_dep_vld_vec_38[1] = dep_chan_vld_15_38;
    assign in_chan_dep_data_vec_38[111 : 56] = dep_chan_data_15_38;
    assign token_in_vec_38[1] = token_15_38;
    assign in_chan_dep_vld_vec_38[2] = dep_chan_vld_21_38;
    assign in_chan_dep_data_vec_38[167 : 112] = dep_chan_data_21_38;
    assign token_in_vec_38[2] = token_21_38;
    assign in_chan_dep_vld_vec_38[3] = dep_chan_vld_22_38;
    assign in_chan_dep_data_vec_38[223 : 168] = dep_chan_data_22_38;
    assign token_in_vec_38[3] = token_22_38;
    assign in_chan_dep_vld_vec_38[4] = dep_chan_vld_30_38;
    assign in_chan_dep_data_vec_38[279 : 224] = dep_chan_data_30_38;
    assign token_in_vec_38[4] = token_30_38;
    assign in_chan_dep_vld_vec_38[5] = dep_chan_vld_46_38;
    assign in_chan_dep_data_vec_38[335 : 280] = dep_chan_data_46_38;
    assign token_in_vec_38[5] = token_46_38;
    assign in_chan_dep_vld_vec_38[6] = dep_chan_vld_48_38;
    assign in_chan_dep_data_vec_38[391 : 336] = dep_chan_data_48_38;
    assign token_in_vec_38[6] = token_48_38;
    assign in_chan_dep_vld_vec_38[7] = dep_chan_vld_55_38;
    assign in_chan_dep_data_vec_38[447 : 392] = dep_chan_data_55_38;
    assign token_in_vec_38[7] = token_55_38;
    assign dep_chan_vld_38_15 = out_chan_dep_vld_vec_38[0];
    assign dep_chan_data_38_15 = out_chan_dep_data_38;
    assign token_38_15 = token_out_vec_38[0];
    assign dep_chan_vld_38_21 = out_chan_dep_vld_vec_38[1];
    assign dep_chan_data_38_21 = out_chan_dep_data_38;
    assign token_38_21 = token_out_vec_38[1];
    assign dep_chan_vld_38_46 = out_chan_dep_vld_vec_38[2];
    assign dep_chan_data_38_46 = out_chan_dep_data_38;
    assign token_38_46 = token_out_vec_38[2];
    assign dep_chan_vld_38_48 = out_chan_dep_vld_vec_38[3];
    assign dep_chan_data_38_48 = out_chan_dep_data_38;
    assign token_38_48 = token_out_vec_38[3];
    assign dep_chan_vld_38_0 = out_chan_dep_vld_vec_38[4];
    assign dep_chan_data_38_0 = out_chan_dep_data_38;
    assign token_38_0 = token_out_vec_38[4];
    assign dep_chan_vld_38_22 = out_chan_dep_vld_vec_38[5];
    assign dep_chan_data_38_22 = out_chan_dep_data_38;
    assign token_38_22 = token_out_vec_38[5];
    assign dep_chan_vld_38_30 = out_chan_dep_vld_vec_38[6];
    assign dep_chan_data_38_30 = out_chan_dep_data_38;
    assign token_38_30 = token_out_vec_38[6];
    assign dep_chan_vld_38_55 = out_chan_dep_vld_vec_38[7];
    assign dep_chan_data_38_55 = out_chan_dep_data_38;
    assign token_38_55 = token_out_vec_38[7];

    // Process: grp_shared_dataflow_fu_225.phase_band_320_200_U0.stencil_320_200_true_U0
    motion60_shared_hls_deadlock_detect_unit #(56, 39, 3, 3) motion60_shared_hls_deadlock_detect_unit_39 (
        .reset(dl_reset),
        .clock(dl_clock),
        .proc_dep_vld_vec(proc_dep_vld_vec_39),
        .in_chan_dep_vld_vec(in_chan_dep_vld_vec_39),
        .in_chan_dep_data_vec(in_chan_dep_data_vec_39),
        .token_in_vec(token_in_vec_39),
        .dl_detect_in(dl_detect_out),
        .origin(origin[39]),
        .token_clear(token_clear),
        .out_chan_dep_vld_vec(out_chan_dep_vld_vec_39),
        .out_chan_dep_data(out_chan_dep_data_39),
        .token_out_vec(token_out_vec_39),
        .dl_detect_out(dl_in_vec[39]));

    assign proc_39_data_FIFO_blk[0] = 1'b0 | (~grp_shared_dataflow_fu_225.phase_band_320_200_U0.stencil_320_200_true_U0.band2_blk_n) | (~grp_shared_dataflow_fu_225.phase_band_320_200_U0.stencil_320_200_true_U0.grp_stencil_320_200_true_Pipeline_horizontal_fu_158.band2_blk_n);
    assign proc_39_data_PIPO_blk[0] = 1'b0;
    assign proc_39_start_FIFO_blk[0] = 1'b0;
    assign proc_39_TLF_FIFO_blk[0] = 1'b0;
    assign proc_39_input_sync_blk[0] = 1'b0;
    assign proc_39_output_sync_blk[0] = 1'b0;
    assign proc_dep_vld_vec_39[0] = dl_detect_out ? proc_dep_vld_vec_39_reg[0] : (proc_39_data_FIFO_blk[0] | proc_39_data_PIPO_blk[0] | proc_39_start_FIFO_blk[0] | proc_39_TLF_FIFO_blk[0] | proc_39_input_sync_blk[0] | proc_39_output_sync_blk[0]);
    assign proc_39_data_FIFO_blk[1] = 1'b0 | (~grp_shared_dataflow_fu_225.phase_band_320_200_U0.stencil_320_200_true_U0.band2_blk_n) | (~grp_shared_dataflow_fu_225.phase_band_320_200_U0.stencil_320_200_true_U0.grp_stencil_320_200_true_Pipeline_horizontal_fu_158.band2_blk_n);
    assign proc_39_data_PIPO_blk[1] = 1'b0;
    assign proc_39_start_FIFO_blk[1] = 1'b0;
    assign proc_39_TLF_FIFO_blk[1] = 1'b0;
    assign proc_39_input_sync_blk[1] = 1'b0;
    assign proc_39_output_sync_blk[1] = 1'b0;
    assign proc_dep_vld_vec_39[1] = dl_detect_out ? proc_dep_vld_vec_39_reg[1] : (proc_39_data_FIFO_blk[1] | proc_39_data_PIPO_blk[1] | proc_39_start_FIFO_blk[1] | proc_39_TLF_FIFO_blk[1] | proc_39_input_sync_blk[1] | proc_39_output_sync_blk[1]);
    assign proc_39_data_FIFO_blk[2] = 1'b0 | (~grp_shared_dataflow_fu_225.phase_band_320_200_U0.stencil_320_200_true_U0.grp_stencil_320_200_true_Pipeline_vertical_fu_183.gradients_blk_n);
    assign proc_39_data_PIPO_blk[2] = 1'b0;
    assign proc_39_start_FIFO_blk[2] = 1'b0;
    assign proc_39_TLF_FIFO_blk[2] = 1'b0;
    assign proc_39_input_sync_blk[2] = 1'b0 | (grp_shared_dataflow_fu_225.phase_band_320_200_U0.ap_sync_stencil_320_200_true_U0_ap_ready & grp_shared_dataflow_fu_225.phase_band_320_200_U0.stencil_320_200_true_U0.ap_idle & ~grp_shared_dataflow_fu_225.phase_band_320_200_U0.ap_sync_phase_core_shared_2_U0_ap_ready);
    assign proc_39_output_sync_blk[2] = 1'b0;
    assign proc_dep_vld_vec_39[2] = dl_detect_out ? proc_dep_vld_vec_39_reg[2] : (proc_39_data_FIFO_blk[2] | proc_39_data_PIPO_blk[2] | proc_39_start_FIFO_blk[2] | proc_39_TLF_FIFO_blk[2] | proc_39_input_sync_blk[2] | proc_39_output_sync_blk[2]);
    always @ (negedge dl_reset or posedge dl_clock) begin
        if (~dl_reset) begin
            proc_dep_vld_vec_39_reg <= 'b0;
        end
        else begin
            proc_dep_vld_vec_39_reg <= proc_dep_vld_vec_39;
        end
    end
    assign in_chan_dep_vld_vec_39[0] = dep_chan_vld_15_39;
    assign in_chan_dep_data_vec_39[55 : 0] = dep_chan_data_15_39;
    assign token_in_vec_39[0] = token_15_39;
    assign in_chan_dep_vld_vec_39[1] = dep_chan_vld_21_39;
    assign in_chan_dep_data_vec_39[111 : 56] = dep_chan_data_21_39;
    assign token_in_vec_39[1] = token_21_39;
    assign in_chan_dep_vld_vec_39[2] = dep_chan_vld_40_39;
    assign in_chan_dep_data_vec_39[167 : 112] = dep_chan_data_40_39;
    assign token_in_vec_39[2] = token_40_39;
    assign dep_chan_vld_39_15 = out_chan_dep_vld_vec_39[0];
    assign dep_chan_data_39_15 = out_chan_dep_data_39;
    assign token_39_15 = token_out_vec_39[0];
    assign dep_chan_vld_39_21 = out_chan_dep_vld_vec_39[1];
    assign dep_chan_data_39_21 = out_chan_dep_data_39;
    assign token_39_21 = token_out_vec_39[1];
    assign dep_chan_vld_39_40 = out_chan_dep_vld_vec_39[2];
    assign dep_chan_data_39_40 = out_chan_dep_data_39;
    assign token_39_40 = token_out_vec_39[2];

    // Process: grp_shared_dataflow_fu_225.phase_band_320_200_U0.phase_core_shared_2_U0
    motion60_shared_hls_deadlock_detect_unit #(56, 40, 3, 3) motion60_shared_hls_deadlock_detect_unit_40 (
        .reset(dl_reset),
        .clock(dl_clock),
        .proc_dep_vld_vec(proc_dep_vld_vec_40),
        .in_chan_dep_vld_vec(in_chan_dep_vld_vec_40),
        .in_chan_dep_data_vec(in_chan_dep_data_vec_40),
        .token_in_vec(token_in_vec_40),
        .dl_detect_in(dl_detect_out),
        .origin(origin[40]),
        .token_clear(token_clear),
        .out_chan_dep_vld_vec(out_chan_dep_vld_vec_40),
        .out_chan_dep_data(out_chan_dep_data_40),
        .token_out_vec(token_out_vec_40),
        .dl_detect_out(dl_in_vec[40]));

    assign proc_40_data_FIFO_blk[0] = 1'b0 | (~grp_shared_dataflow_fu_225.phase_band_320_200_U0.phase_core_shared_2_U0.grp_phase_dataflow_7_fu_130.compute_phase14_U0.gradients_blk_n);
    assign proc_40_data_PIPO_blk[0] = 1'b0;
    assign proc_40_start_FIFO_blk[0] = 1'b0;
    assign proc_40_TLF_FIFO_blk[0] = 1'b0;
    assign proc_40_input_sync_blk[0] = 1'b0 | (grp_shared_dataflow_fu_225.phase_band_320_200_U0.ap_sync_phase_core_shared_2_U0_ap_ready & grp_shared_dataflow_fu_225.phase_band_320_200_U0.phase_core_shared_2_U0.ap_idle & ~grp_shared_dataflow_fu_225.phase_band_320_200_U0.ap_sync_stencil_320_200_true_U0_ap_ready);
    assign proc_40_output_sync_blk[0] = 1'b0;
    assign proc_dep_vld_vec_40[0] = dl_detect_out ? proc_dep_vld_vec_40_reg[0] : (proc_40_data_FIFO_blk[0] | proc_40_data_PIPO_blk[0] | proc_40_start_FIFO_blk[0] | proc_40_TLF_FIFO_blk[0] | proc_40_input_sync_blk[0] | proc_40_output_sync_blk[0]);
    assign proc_40_data_FIFO_blk[1] = 1'b0 | (~grp_shared_dataflow_fu_225.phase_band_320_200_U0.phase_core_shared_2_U0.grp_phase_dataflow_7_fu_130.compute_phase14_U0.p2_blk_n);
    assign proc_40_data_PIPO_blk[1] = 1'b0;
    assign proc_40_start_FIFO_blk[1] = 1'b0;
    assign proc_40_TLF_FIFO_blk[1] = 1'b0;
    assign proc_40_input_sync_blk[1] = 1'b0;
    assign proc_40_output_sync_blk[1] = 1'b0;
    assign proc_dep_vld_vec_40[1] = dl_detect_out ? proc_dep_vld_vec_40_reg[1] : (proc_40_data_FIFO_blk[1] | proc_40_data_PIPO_blk[1] | proc_40_start_FIFO_blk[1] | proc_40_TLF_FIFO_blk[1] | proc_40_input_sync_blk[1] | proc_40_output_sync_blk[1]);
    assign proc_40_data_FIFO_blk[2] = 1'b0 | (~grp_shared_dataflow_fu_225.phase_band_320_200_U0.phase_core_shared_2_U0.grp_phase_dataflow_7_fu_130.compute_phase14_U0.p2_blk_n);
    assign proc_40_data_PIPO_blk[2] = 1'b0;
    assign proc_40_start_FIFO_blk[2] = 1'b0;
    assign proc_40_TLF_FIFO_blk[2] = 1'b0;
    assign proc_40_input_sync_blk[2] = 1'b0;
    assign proc_40_output_sync_blk[2] = 1'b0;
    assign proc_dep_vld_vec_40[2] = dl_detect_out ? proc_dep_vld_vec_40_reg[2] : (proc_40_data_FIFO_blk[2] | proc_40_data_PIPO_blk[2] | proc_40_start_FIFO_blk[2] | proc_40_TLF_FIFO_blk[2] | proc_40_input_sync_blk[2] | proc_40_output_sync_blk[2]);
    always @ (negedge dl_reset or posedge dl_clock) begin
        if (~dl_reset) begin
            proc_dep_vld_vec_40_reg <= 'b0;
        end
        else begin
            proc_dep_vld_vec_40_reg <= proc_dep_vld_vec_40;
        end
    end
    assign in_chan_dep_vld_vec_40[0] = dep_chan_vld_39_40;
    assign in_chan_dep_data_vec_40[55 : 0] = dep_chan_data_39_40;
    assign token_in_vec_40[0] = token_39_40;
    assign in_chan_dep_vld_vec_40[1] = dep_chan_vld_46_40;
    assign in_chan_dep_data_vec_40[111 : 56] = dep_chan_data_46_40;
    assign token_in_vec_40[1] = token_46_40;
    assign in_chan_dep_vld_vec_40[2] = dep_chan_vld_48_40;
    assign in_chan_dep_data_vec_40[167 : 112] = dep_chan_data_48_40;
    assign token_in_vec_40[2] = token_48_40;
    assign dep_chan_vld_40_39 = out_chan_dep_vld_vec_40[0];
    assign dep_chan_data_40_39 = out_chan_dep_data_40;
    assign token_40_39 = token_out_vec_40[0];
    assign dep_chan_vld_40_46 = out_chan_dep_vld_vec_40[1];
    assign dep_chan_data_40_46 = out_chan_dep_data_40;
    assign token_40_46 = token_out_vec_40[1];
    assign dep_chan_vld_40_48 = out_chan_dep_vld_vec_40[2];
    assign dep_chan_data_40_48 = out_chan_dep_data_40;
    assign token_40_48 = token_out_vec_40[2];

    // Process: grp_shared_dataflow_fu_225.phase_band_320_200_U0.phase_core_shared_2_U0.grp_phase_dataflow_7_fu_130.read_words_10_U0
    motion60_shared_hls_deadlock_detect_unit #(56, 41, 1, 1) motion60_shared_hls_deadlock_detect_unit_41 (
        .reset(dl_reset),
        .clock(dl_clock),
        .proc_dep_vld_vec(proc_dep_vld_vec_41),
        .in_chan_dep_vld_vec(in_chan_dep_vld_vec_41),
        .in_chan_dep_data_vec(in_chan_dep_data_vec_41),
        .token_in_vec(token_in_vec_41),
        .dl_detect_in(dl_detect_out),
        .origin(origin[41]),
        .token_clear(token_clear),
        .out_chan_dep_vld_vec(out_chan_dep_vld_vec_41),
        .out_chan_dep_data(out_chan_dep_data_41),
        .token_out_vec(token_out_vec_41),
        .dl_detect_out(dl_in_vec[41]));

    assign proc_41_data_FIFO_blk[0] = 1'b0 | (~grp_shared_dataflow_fu_225.phase_band_320_200_U0.phase_core_shared_2_U0.grp_phase_dataflow_7_fu_130.read_words_10_U0.grp_read_words_10_Pipeline_VITIS_LOOP_10_1_fu_78.read_bus_blk_n);
    assign proc_41_data_PIPO_blk[0] = 1'b0;
    assign proc_41_start_FIFO_blk[0] = 1'b0 | (~grp_shared_dataflow_fu_225.phase_band_320_200_U0.phase_core_shared_2_U0.grp_phase_dataflow_7_fu_130.start_for_unpack_history13_U0_U.if_full_n & grp_shared_dataflow_fu_225.phase_band_320_200_U0.phase_core_shared_2_U0.grp_phase_dataflow_7_fu_130.read_words_10_U0.ap_start & ~grp_shared_dataflow_fu_225.phase_band_320_200_U0.phase_core_shared_2_U0.grp_phase_dataflow_7_fu_130.read_words_10_U0.real_start & (trans_in_cnt_23 == trans_out_cnt_23) & ~grp_shared_dataflow_fu_225.phase_band_320_200_U0.phase_core_shared_2_U0.grp_phase_dataflow_7_fu_130.start_for_unpack_history13_U0_U.if_read);
    assign proc_41_TLF_FIFO_blk[0] = 1'b0;
    assign proc_41_input_sync_blk[0] = 1'b0;
    assign proc_41_output_sync_blk[0] = 1'b0;
    assign proc_dep_vld_vec_41[0] = dl_detect_out ? proc_dep_vld_vec_41_reg[0] : (proc_41_data_FIFO_blk[0] | proc_41_data_PIPO_blk[0] | proc_41_start_FIFO_blk[0] | proc_41_TLF_FIFO_blk[0] | proc_41_input_sync_blk[0] | proc_41_output_sync_blk[0]);
    always @ (negedge dl_reset or posedge dl_clock) begin
        if (~dl_reset) begin
            proc_dep_vld_vec_41_reg <= 'b0;
        end
        else begin
            proc_dep_vld_vec_41_reg <= proc_dep_vld_vec_41;
        end
    end
    assign in_chan_dep_vld_vec_41[0] = dep_chan_vld_42_41;
    assign in_chan_dep_data_vec_41[55 : 0] = dep_chan_data_42_41;
    assign token_in_vec_41[0] = token_42_41;
    assign dep_chan_vld_41_42 = out_chan_dep_vld_vec_41[0];
    assign dep_chan_data_41_42 = out_chan_dep_data_41;
    assign token_41_42 = token_out_vec_41[0];

    // Process: grp_shared_dataflow_fu_225.phase_band_320_200_U0.phase_core_shared_2_U0.grp_phase_dataflow_7_fu_130.unpack_history13_U0
    motion60_shared_hls_deadlock_detect_unit #(56, 42, 2, 2) motion60_shared_hls_deadlock_detect_unit_42 (
        .reset(dl_reset),
        .clock(dl_clock),
        .proc_dep_vld_vec(proc_dep_vld_vec_42),
        .in_chan_dep_vld_vec(in_chan_dep_vld_vec_42),
        .in_chan_dep_data_vec(in_chan_dep_data_vec_42),
        .token_in_vec(token_in_vec_42),
        .dl_detect_in(dl_detect_out),
        .origin(origin[42]),
        .token_clear(token_clear),
        .out_chan_dep_vld_vec(out_chan_dep_vld_vec_42),
        .out_chan_dep_data(out_chan_dep_data_42),
        .token_out_vec(token_out_vec_42),
        .dl_detect_out(dl_in_vec[42]));

    assign proc_42_data_FIFO_blk[0] = 1'b0 | (~grp_shared_dataflow_fu_225.phase_band_320_200_U0.phase_core_shared_2_U0.grp_phase_dataflow_7_fu_130.unpack_history13_U0.read_bus_blk_n);
    assign proc_42_data_PIPO_blk[0] = 1'b0;
    assign proc_42_start_FIFO_blk[0] = 1'b0 | (~grp_shared_dataflow_fu_225.phase_band_320_200_U0.phase_core_shared_2_U0.grp_phase_dataflow_7_fu_130.start_for_unpack_history13_U0_U.if_empty_n & grp_shared_dataflow_fu_225.phase_band_320_200_U0.phase_core_shared_2_U0.grp_phase_dataflow_7_fu_130.unpack_history13_U0.ap_idle & ~grp_shared_dataflow_fu_225.phase_band_320_200_U0.phase_core_shared_2_U0.grp_phase_dataflow_7_fu_130.start_for_unpack_history13_U0_U.if_write);
    assign proc_42_TLF_FIFO_blk[0] = 1'b0;
    assign proc_42_input_sync_blk[0] = 1'b0;
    assign proc_42_output_sync_blk[0] = 1'b0;
    assign proc_dep_vld_vec_42[0] = dl_detect_out ? proc_dep_vld_vec_42_reg[0] : (proc_42_data_FIFO_blk[0] | proc_42_data_PIPO_blk[0] | proc_42_start_FIFO_blk[0] | proc_42_TLF_FIFO_blk[0] | proc_42_input_sync_blk[0] | proc_42_output_sync_blk[0]);
    assign proc_42_data_FIFO_blk[1] = 1'b0 | (~grp_shared_dataflow_fu_225.phase_band_320_200_U0.phase_core_shared_2_U0.grp_phase_dataflow_7_fu_130.unpack_history13_U0.history_blk_n);
    assign proc_42_data_PIPO_blk[1] = 1'b0;
    assign proc_42_start_FIFO_blk[1] = 1'b0 | (~grp_shared_dataflow_fu_225.phase_band_320_200_U0.phase_core_shared_2_U0.grp_phase_dataflow_7_fu_130.start_for_compute_phase14_U0_U.if_full_n & grp_shared_dataflow_fu_225.phase_band_320_200_U0.phase_core_shared_2_U0.grp_phase_dataflow_7_fu_130.unpack_history13_U0.ap_start & ~grp_shared_dataflow_fu_225.phase_band_320_200_U0.phase_core_shared_2_U0.grp_phase_dataflow_7_fu_130.unpack_history13_U0.real_start & (trans_in_cnt_24 == trans_out_cnt_24) & ~grp_shared_dataflow_fu_225.phase_band_320_200_U0.phase_core_shared_2_U0.grp_phase_dataflow_7_fu_130.start_for_compute_phase14_U0_U.if_read);
    assign proc_42_TLF_FIFO_blk[1] = 1'b0;
    assign proc_42_input_sync_blk[1] = 1'b0;
    assign proc_42_output_sync_blk[1] = 1'b0;
    assign proc_dep_vld_vec_42[1] = dl_detect_out ? proc_dep_vld_vec_42_reg[1] : (proc_42_data_FIFO_blk[1] | proc_42_data_PIPO_blk[1] | proc_42_start_FIFO_blk[1] | proc_42_TLF_FIFO_blk[1] | proc_42_input_sync_blk[1] | proc_42_output_sync_blk[1]);
    always @ (negedge dl_reset or posedge dl_clock) begin
        if (~dl_reset) begin
            proc_dep_vld_vec_42_reg <= 'b0;
        end
        else begin
            proc_dep_vld_vec_42_reg <= proc_dep_vld_vec_42;
        end
    end
    assign in_chan_dep_vld_vec_42[0] = dep_chan_vld_41_42;
    assign in_chan_dep_data_vec_42[55 : 0] = dep_chan_data_41_42;
    assign token_in_vec_42[0] = token_41_42;
    assign in_chan_dep_vld_vec_42[1] = dep_chan_vld_43_42;
    assign in_chan_dep_data_vec_42[111 : 56] = dep_chan_data_43_42;
    assign token_in_vec_42[1] = token_43_42;
    assign dep_chan_vld_42_41 = out_chan_dep_vld_vec_42[0];
    assign dep_chan_data_42_41 = out_chan_dep_data_42;
    assign token_42_41 = token_out_vec_42[0];
    assign dep_chan_vld_42_43 = out_chan_dep_vld_vec_42[1];
    assign dep_chan_data_42_43 = out_chan_dep_data_42;
    assign token_42_43 = token_out_vec_42[1];

    // Process: grp_shared_dataflow_fu_225.phase_band_320_200_U0.phase_core_shared_2_U0.grp_phase_dataflow_7_fu_130.compute_phase14_U0
    motion60_shared_hls_deadlock_detect_unit #(56, 43, 3, 3) motion60_shared_hls_deadlock_detect_unit_43 (
        .reset(dl_reset),
        .clock(dl_clock),
        .proc_dep_vld_vec(proc_dep_vld_vec_43),
        .in_chan_dep_vld_vec(in_chan_dep_vld_vec_43),
        .in_chan_dep_data_vec(in_chan_dep_data_vec_43),
        .token_in_vec(token_in_vec_43),
        .dl_detect_in(dl_detect_out),
        .origin(origin[43]),
        .token_clear(token_clear),
        .out_chan_dep_vld_vec(out_chan_dep_vld_vec_43),
        .out_chan_dep_data(out_chan_dep_data_43),
        .token_out_vec(token_out_vec_43),
        .dl_detect_out(dl_in_vec[43]));

    assign proc_43_data_FIFO_blk[0] = 1'b0 | (~grp_shared_dataflow_fu_225.phase_band_320_200_U0.phase_core_shared_2_U0.grp_phase_dataflow_7_fu_130.compute_phase14_U0.history_blk_n);
    assign proc_43_data_PIPO_blk[0] = 1'b0;
    assign proc_43_start_FIFO_blk[0] = 1'b0 | (~grp_shared_dataflow_fu_225.phase_band_320_200_U0.phase_core_shared_2_U0.grp_phase_dataflow_7_fu_130.start_for_compute_phase14_U0_U.if_empty_n & grp_shared_dataflow_fu_225.phase_band_320_200_U0.phase_core_shared_2_U0.grp_phase_dataflow_7_fu_130.compute_phase14_U0.ap_idle & ~grp_shared_dataflow_fu_225.phase_band_320_200_U0.phase_core_shared_2_U0.grp_phase_dataflow_7_fu_130.start_for_compute_phase14_U0_U.if_write);
    assign proc_43_TLF_FIFO_blk[0] = 1'b0;
    assign proc_43_input_sync_blk[0] = 1'b0;
    assign proc_43_output_sync_blk[0] = 1'b0;
    assign proc_dep_vld_vec_43[0] = dl_detect_out ? proc_dep_vld_vec_43_reg[0] : (proc_43_data_FIFO_blk[0] | proc_43_data_PIPO_blk[0] | proc_43_start_FIFO_blk[0] | proc_43_TLF_FIFO_blk[0] | proc_43_input_sync_blk[0] | proc_43_output_sync_blk[0]);
    assign proc_43_data_FIFO_blk[1] = 1'b0 | (~grp_shared_dataflow_fu_225.phase_band_320_200_U0.phase_core_shared_2_U0.grp_phase_dataflow_7_fu_130.compute_phase14_U0.updated_blk_n);
    assign proc_43_data_PIPO_blk[1] = 1'b0;
    assign proc_43_start_FIFO_blk[1] = 1'b0 | (~grp_shared_dataflow_fu_225.phase_band_320_200_U0.phase_core_shared_2_U0.grp_phase_dataflow_7_fu_130.start_for_pack_history15_U0_U.if_full_n & grp_shared_dataflow_fu_225.phase_band_320_200_U0.phase_core_shared_2_U0.grp_phase_dataflow_7_fu_130.compute_phase14_U0.ap_start & ~grp_shared_dataflow_fu_225.phase_band_320_200_U0.phase_core_shared_2_U0.grp_phase_dataflow_7_fu_130.compute_phase14_U0.real_start & (trans_in_cnt_25 == trans_out_cnt_25) & ~grp_shared_dataflow_fu_225.phase_band_320_200_U0.phase_core_shared_2_U0.grp_phase_dataflow_7_fu_130.start_for_pack_history15_U0_U.if_read);
    assign proc_43_TLF_FIFO_blk[1] = 1'b0;
    assign proc_43_input_sync_blk[1] = 1'b0;
    assign proc_43_output_sync_blk[1] = 1'b0;
    assign proc_dep_vld_vec_43[1] = dl_detect_out ? proc_dep_vld_vec_43_reg[1] : (proc_43_data_FIFO_blk[1] | proc_43_data_PIPO_blk[1] | proc_43_start_FIFO_blk[1] | proc_43_TLF_FIFO_blk[1] | proc_43_input_sync_blk[1] | proc_43_output_sync_blk[1]);
    assign proc_43_data_FIFO_blk[2] = 1'b0;
    assign proc_43_data_PIPO_blk[2] = 1'b0;
    assign proc_43_start_FIFO_blk[2] = 1'b0;
    assign proc_43_TLF_FIFO_blk[2] = 1'b0;
    assign proc_43_input_sync_blk[2] = 1'b0;
    assign proc_43_output_sync_blk[2] = 1'b0 | (ap_done_reg_14 & grp_shared_dataflow_fu_225.phase_band_320_200_U0.phase_core_shared_2_U0.grp_phase_dataflow_7_fu_130.compute_phase14_U0.ap_done & ~grp_shared_dataflow_fu_225.phase_band_320_200_U0.phase_core_shared_2_U0.grp_phase_dataflow_7_fu_130.write_words_11_U0.ap_done);
    assign proc_dep_vld_vec_43[2] = dl_detect_out ? proc_dep_vld_vec_43_reg[2] : (proc_43_data_FIFO_blk[2] | proc_43_data_PIPO_blk[2] | proc_43_start_FIFO_blk[2] | proc_43_TLF_FIFO_blk[2] | proc_43_input_sync_blk[2] | proc_43_output_sync_blk[2]);
    always @ (negedge dl_reset or posedge dl_clock) begin
        if (~dl_reset) begin
            proc_dep_vld_vec_43_reg <= 'b0;
        end
        else begin
            proc_dep_vld_vec_43_reg <= proc_dep_vld_vec_43;
        end
    end
    assign in_chan_dep_vld_vec_43[0] = dep_chan_vld_42_43;
    assign in_chan_dep_data_vec_43[55 : 0] = dep_chan_data_42_43;
    assign token_in_vec_43[0] = token_42_43;
    assign in_chan_dep_vld_vec_43[1] = dep_chan_vld_44_43;
    assign in_chan_dep_data_vec_43[111 : 56] = dep_chan_data_44_43;
    assign token_in_vec_43[1] = token_44_43;
    assign in_chan_dep_vld_vec_43[2] = dep_chan_vld_45_43;
    assign in_chan_dep_data_vec_43[167 : 112] = dep_chan_data_45_43;
    assign token_in_vec_43[2] = token_45_43;
    assign dep_chan_vld_43_42 = out_chan_dep_vld_vec_43[0];
    assign dep_chan_data_43_42 = out_chan_dep_data_43;
    assign token_43_42 = token_out_vec_43[0];
    assign dep_chan_vld_43_44 = out_chan_dep_vld_vec_43[1];
    assign dep_chan_data_43_44 = out_chan_dep_data_43;
    assign token_43_44 = token_out_vec_43[1];
    assign dep_chan_vld_43_45 = out_chan_dep_vld_vec_43[2];
    assign dep_chan_data_43_45 = out_chan_dep_data_43;
    assign token_43_45 = token_out_vec_43[2];

    // Process: grp_shared_dataflow_fu_225.phase_band_320_200_U0.phase_core_shared_2_U0.grp_phase_dataflow_7_fu_130.pack_history15_U0
    motion60_shared_hls_deadlock_detect_unit #(56, 44, 2, 2) motion60_shared_hls_deadlock_detect_unit_44 (
        .reset(dl_reset),
        .clock(dl_clock),
        .proc_dep_vld_vec(proc_dep_vld_vec_44),
        .in_chan_dep_vld_vec(in_chan_dep_vld_vec_44),
        .in_chan_dep_data_vec(in_chan_dep_data_vec_44),
        .token_in_vec(token_in_vec_44),
        .dl_detect_in(dl_detect_out),
        .origin(origin[44]),
        .token_clear(token_clear),
        .out_chan_dep_vld_vec(out_chan_dep_vld_vec_44),
        .out_chan_dep_data(out_chan_dep_data_44),
        .token_out_vec(token_out_vec_44),
        .dl_detect_out(dl_in_vec[44]));

    assign proc_44_data_FIFO_blk[0] = 1'b0 | (~grp_shared_dataflow_fu_225.phase_band_320_200_U0.phase_core_shared_2_U0.grp_phase_dataflow_7_fu_130.pack_history15_U0.updated_blk_n);
    assign proc_44_data_PIPO_blk[0] = 1'b0;
    assign proc_44_start_FIFO_blk[0] = 1'b0 | (~grp_shared_dataflow_fu_225.phase_band_320_200_U0.phase_core_shared_2_U0.grp_phase_dataflow_7_fu_130.start_for_pack_history15_U0_U.if_empty_n & grp_shared_dataflow_fu_225.phase_band_320_200_U0.phase_core_shared_2_U0.grp_phase_dataflow_7_fu_130.pack_history15_U0.ap_idle & ~grp_shared_dataflow_fu_225.phase_band_320_200_U0.phase_core_shared_2_U0.grp_phase_dataflow_7_fu_130.start_for_pack_history15_U0_U.if_write);
    assign proc_44_TLF_FIFO_blk[0] = 1'b0;
    assign proc_44_input_sync_blk[0] = 1'b0;
    assign proc_44_output_sync_blk[0] = 1'b0;
    assign proc_dep_vld_vec_44[0] = dl_detect_out ? proc_dep_vld_vec_44_reg[0] : (proc_44_data_FIFO_blk[0] | proc_44_data_PIPO_blk[0] | proc_44_start_FIFO_blk[0] | proc_44_TLF_FIFO_blk[0] | proc_44_input_sync_blk[0] | proc_44_output_sync_blk[0]);
    assign proc_44_data_FIFO_blk[1] = 1'b0 | (~grp_shared_dataflow_fu_225.phase_band_320_200_U0.phase_core_shared_2_U0.grp_phase_dataflow_7_fu_130.pack_history15_U0.write_bus_blk_n);
    assign proc_44_data_PIPO_blk[1] = 1'b0;
    assign proc_44_start_FIFO_blk[1] = 1'b0 | (~grp_shared_dataflow_fu_225.phase_band_320_200_U0.phase_core_shared_2_U0.grp_phase_dataflow_7_fu_130.start_for_write_words_11_U0_U.if_full_n & grp_shared_dataflow_fu_225.phase_band_320_200_U0.phase_core_shared_2_U0.grp_phase_dataflow_7_fu_130.pack_history15_U0.ap_start & ~grp_shared_dataflow_fu_225.phase_band_320_200_U0.phase_core_shared_2_U0.grp_phase_dataflow_7_fu_130.pack_history15_U0.real_start & (trans_in_cnt_26 == trans_out_cnt_26) & ~grp_shared_dataflow_fu_225.phase_band_320_200_U0.phase_core_shared_2_U0.grp_phase_dataflow_7_fu_130.start_for_write_words_11_U0_U.if_read);
    assign proc_44_TLF_FIFO_blk[1] = 1'b0;
    assign proc_44_input_sync_blk[1] = 1'b0;
    assign proc_44_output_sync_blk[1] = 1'b0;
    assign proc_dep_vld_vec_44[1] = dl_detect_out ? proc_dep_vld_vec_44_reg[1] : (proc_44_data_FIFO_blk[1] | proc_44_data_PIPO_blk[1] | proc_44_start_FIFO_blk[1] | proc_44_TLF_FIFO_blk[1] | proc_44_input_sync_blk[1] | proc_44_output_sync_blk[1]);
    always @ (negedge dl_reset or posedge dl_clock) begin
        if (~dl_reset) begin
            proc_dep_vld_vec_44_reg <= 'b0;
        end
        else begin
            proc_dep_vld_vec_44_reg <= proc_dep_vld_vec_44;
        end
    end
    assign in_chan_dep_vld_vec_44[0] = dep_chan_vld_43_44;
    assign in_chan_dep_data_vec_44[55 : 0] = dep_chan_data_43_44;
    assign token_in_vec_44[0] = token_43_44;
    assign in_chan_dep_vld_vec_44[1] = dep_chan_vld_45_44;
    assign in_chan_dep_data_vec_44[111 : 56] = dep_chan_data_45_44;
    assign token_in_vec_44[1] = token_45_44;
    assign dep_chan_vld_44_43 = out_chan_dep_vld_vec_44[0];
    assign dep_chan_data_44_43 = out_chan_dep_data_44;
    assign token_44_43 = token_out_vec_44[0];
    assign dep_chan_vld_44_45 = out_chan_dep_vld_vec_44[1];
    assign dep_chan_data_44_45 = out_chan_dep_data_44;
    assign token_44_45 = token_out_vec_44[1];

    // Process: grp_shared_dataflow_fu_225.phase_band_320_200_U0.phase_core_shared_2_U0.grp_phase_dataflow_7_fu_130.write_words_11_U0
    motion60_shared_hls_deadlock_detect_unit #(56, 45, 2, 2) motion60_shared_hls_deadlock_detect_unit_45 (
        .reset(dl_reset),
        .clock(dl_clock),
        .proc_dep_vld_vec(proc_dep_vld_vec_45),
        .in_chan_dep_vld_vec(in_chan_dep_vld_vec_45),
        .in_chan_dep_data_vec(in_chan_dep_data_vec_45),
        .token_in_vec(token_in_vec_45),
        .dl_detect_in(dl_detect_out),
        .origin(origin[45]),
        .token_clear(token_clear),
        .out_chan_dep_vld_vec(out_chan_dep_vld_vec_45),
        .out_chan_dep_data(out_chan_dep_data_45),
        .token_out_vec(token_out_vec_45),
        .dl_detect_out(dl_in_vec[45]));

    assign proc_45_data_FIFO_blk[0] = 1'b0 | (~grp_shared_dataflow_fu_225.phase_band_320_200_U0.phase_core_shared_2_U0.grp_phase_dataflow_7_fu_130.write_words_11_U0.grp_write_words_11_Pipeline_VITIS_LOOP_17_1_fu_85.write_bus_blk_n);
    assign proc_45_data_PIPO_blk[0] = 1'b0;
    assign proc_45_start_FIFO_blk[0] = 1'b0 | (~grp_shared_dataflow_fu_225.phase_band_320_200_U0.phase_core_shared_2_U0.grp_phase_dataflow_7_fu_130.start_for_write_words_11_U0_U.if_empty_n & grp_shared_dataflow_fu_225.phase_band_320_200_U0.phase_core_shared_2_U0.grp_phase_dataflow_7_fu_130.write_words_11_U0.ap_idle & ~grp_shared_dataflow_fu_225.phase_band_320_200_U0.phase_core_shared_2_U0.grp_phase_dataflow_7_fu_130.start_for_write_words_11_U0_U.if_write);
    assign proc_45_TLF_FIFO_blk[0] = 1'b0;
    assign proc_45_input_sync_blk[0] = 1'b0;
    assign proc_45_output_sync_blk[0] = 1'b0;
    assign proc_dep_vld_vec_45[0] = dl_detect_out ? proc_dep_vld_vec_45_reg[0] : (proc_45_data_FIFO_blk[0] | proc_45_data_PIPO_blk[0] | proc_45_start_FIFO_blk[0] | proc_45_TLF_FIFO_blk[0] | proc_45_input_sync_blk[0] | proc_45_output_sync_blk[0]);
    assign proc_45_data_FIFO_blk[1] = 1'b0;
    assign proc_45_data_PIPO_blk[1] = 1'b0;
    assign proc_45_start_FIFO_blk[1] = 1'b0;
    assign proc_45_TLF_FIFO_blk[1] = 1'b0;
    assign proc_45_input_sync_blk[1] = 1'b0;
    assign proc_45_output_sync_blk[1] = 1'b0 | (ap_done_reg_15 & grp_shared_dataflow_fu_225.phase_band_320_200_U0.phase_core_shared_2_U0.grp_phase_dataflow_7_fu_130.write_words_11_U0.ap_done & ~grp_shared_dataflow_fu_225.phase_band_320_200_U0.phase_core_shared_2_U0.grp_phase_dataflow_7_fu_130.compute_phase14_U0.ap_done);
    assign proc_dep_vld_vec_45[1] = dl_detect_out ? proc_dep_vld_vec_45_reg[1] : (proc_45_data_FIFO_blk[1] | proc_45_data_PIPO_blk[1] | proc_45_start_FIFO_blk[1] | proc_45_TLF_FIFO_blk[1] | proc_45_input_sync_blk[1] | proc_45_output_sync_blk[1]);
    always @ (negedge dl_reset or posedge dl_clock) begin
        if (~dl_reset) begin
            proc_dep_vld_vec_45_reg <= 'b0;
        end
        else begin
            proc_dep_vld_vec_45_reg <= proc_dep_vld_vec_45;
        end
    end
    assign in_chan_dep_vld_vec_45[0] = dep_chan_vld_43_45;
    assign in_chan_dep_data_vec_45[55 : 0] = dep_chan_data_43_45;
    assign token_in_vec_45[0] = token_43_45;
    assign in_chan_dep_vld_vec_45[1] = dep_chan_vld_44_45;
    assign in_chan_dep_data_vec_45[111 : 56] = dep_chan_data_44_45;
    assign token_in_vec_45[1] = token_44_45;
    assign dep_chan_vld_45_44 = out_chan_dep_vld_vec_45[0];
    assign dep_chan_data_45_44 = out_chan_dep_data_45;
    assign token_45_44 = token_out_vec_45[0];
    assign dep_chan_vld_45_43 = out_chan_dep_vld_vec_45[1];
    assign dep_chan_data_45_43 = out_chan_dep_data_45;
    assign token_45_43 = token_out_vec_45[1];

    // Process: grp_shared_dataflow_fu_225.reconstruct_320_200_U0
    motion60_shared_hls_deadlock_detect_unit #(56, 46, 6, 6) motion60_shared_hls_deadlock_detect_unit_46 (
        .reset(dl_reset),
        .clock(dl_clock),
        .proc_dep_vld_vec(proc_dep_vld_vec_46),
        .in_chan_dep_vld_vec(in_chan_dep_vld_vec_46),
        .in_chan_dep_data_vec(in_chan_dep_data_vec_46),
        .token_in_vec(token_in_vec_46),
        .dl_detect_in(dl_detect_out),
        .origin(origin[46]),
        .token_clear(token_clear),
        .out_chan_dep_vld_vec(out_chan_dep_vld_vec_46),
        .out_chan_dep_data(out_chan_dep_data_46),
        .token_out_vec(token_out_vec_46),
        .dl_detect_out(dl_in_vec[46]));

    assign proc_46_data_FIFO_blk[0] = 1'b0 | (~grp_shared_dataflow_fu_225.reconstruct_320_200_U0.combine_64000_true_U0.p2_blk_n);
    assign proc_46_data_PIPO_blk[0] = 1'b0;
    assign proc_46_start_FIFO_blk[0] = 1'b0 | (~grp_shared_dataflow_fu_225.start_for_reconstruct_320_200_U0_U.if_empty_n & grp_shared_dataflow_fu_225.reconstruct_320_200_U0.ap_idle & ~grp_shared_dataflow_fu_225.start_for_reconstruct_320_200_U0_U.if_write);
    assign proc_46_TLF_FIFO_blk[0] = 1'b0;
    assign proc_46_input_sync_blk[0] = 1'b0;
    assign proc_46_output_sync_blk[0] = 1'b0;
    assign proc_dep_vld_vec_46[0] = dl_detect_out ? proc_dep_vld_vec_46_reg[0] : (proc_46_data_FIFO_blk[0] | proc_46_data_PIPO_blk[0] | proc_46_start_FIFO_blk[0] | proc_46_TLF_FIFO_blk[0] | proc_46_input_sync_blk[0] | proc_46_output_sync_blk[0]);
    assign proc_46_data_FIFO_blk[1] = 1'b0 | (~grp_shared_dataflow_fu_225.reconstruct_320_200_U0.combine_64000_true_U0.p2_blk_n);
    assign proc_46_data_PIPO_blk[1] = 1'b0;
    assign proc_46_start_FIFO_blk[1] = 1'b0;
    assign proc_46_TLF_FIFO_blk[1] = 1'b0;
    assign proc_46_input_sync_blk[1] = 1'b0;
    assign proc_46_output_sync_blk[1] = 1'b0;
    assign proc_dep_vld_vec_46[1] = dl_detect_out ? proc_dep_vld_vec_46_reg[1] : (proc_46_data_FIFO_blk[1] | proc_46_data_PIPO_blk[1] | proc_46_start_FIFO_blk[1] | proc_46_TLF_FIFO_blk[1] | proc_46_input_sync_blk[1] | proc_46_output_sync_blk[1]);
    assign proc_46_data_FIFO_blk[2] = 1'b0 | (~grp_shared_dataflow_fu_225.reconstruct_320_200_U0.upsample_160_100_3_U0.grp_upsample_160_100_3_Pipeline_VITIS_LOOP_98_2_fu_89.res_blk_n);
    assign proc_46_data_PIPO_blk[2] = 1'b0;
    assign proc_46_start_FIFO_blk[2] = 1'b0;
    assign proc_46_TLF_FIFO_blk[2] = 1'b0;
    assign proc_46_input_sync_blk[2] = 1'b0;
    assign proc_46_output_sync_blk[2] = 1'b0;
    assign proc_dep_vld_vec_46[2] = dl_detect_out ? proc_dep_vld_vec_46_reg[2] : (proc_46_data_FIFO_blk[2] | proc_46_data_PIPO_blk[2] | proc_46_start_FIFO_blk[2] | proc_46_TLF_FIFO_blk[2] | proc_46_input_sync_blk[2] | proc_46_output_sync_blk[2]);
    assign proc_46_data_FIFO_blk[3] = 1'b0 | (~grp_shared_dataflow_fu_225.reconstruct_320_200_U0.upsample_160_100_3_U0.grp_upsample_160_100_3_Pipeline_VITIS_LOOP_98_2_fu_89.res_blk_n);
    assign proc_46_data_PIPO_blk[3] = 1'b0;
    assign proc_46_start_FIFO_blk[3] = 1'b0;
    assign proc_46_TLF_FIFO_blk[3] = 1'b0;
    assign proc_46_input_sync_blk[3] = 1'b0;
    assign proc_46_output_sync_blk[3] = 1'b0;
    assign proc_dep_vld_vec_46[3] = dl_detect_out ? proc_dep_vld_vec_46_reg[3] : (proc_46_data_FIFO_blk[3] | proc_46_data_PIPO_blk[3] | proc_46_start_FIFO_blk[3] | proc_46_TLF_FIFO_blk[3] | proc_46_input_sync_blk[3] | proc_46_output_sync_blk[3]);
    assign proc_46_data_FIFO_blk[4] = 1'b0 | (~grp_shared_dataflow_fu_225.reconstruct_320_200_U0.combine_64000_true_U0.r2_blk_n);
    assign proc_46_data_PIPO_blk[4] = 1'b0;
    assign proc_46_start_FIFO_blk[4] = 1'b0;
    assign proc_46_TLF_FIFO_blk[4] = 1'b0;
    assign proc_46_input_sync_blk[4] = 1'b0;
    assign proc_46_output_sync_blk[4] = 1'b0;
    assign proc_dep_vld_vec_46[4] = dl_detect_out ? proc_dep_vld_vec_46_reg[4] : (proc_46_data_FIFO_blk[4] | proc_46_data_PIPO_blk[4] | proc_46_start_FIFO_blk[4] | proc_46_TLF_FIFO_blk[4] | proc_46_input_sync_blk[4] | proc_46_output_sync_blk[4]);
    assign proc_46_data_FIFO_blk[5] = 1'b0 | (~grp_shared_dataflow_fu_225.reconstruct_320_200_U0.combine_64000_true_U0.r2_blk_n);
    assign proc_46_data_PIPO_blk[5] = 1'b0;
    assign proc_46_start_FIFO_blk[5] = 1'b0;
    assign proc_46_TLF_FIFO_blk[5] = 1'b0;
    assign proc_46_input_sync_blk[5] = 1'b0;
    assign proc_46_output_sync_blk[5] = 1'b0;
    assign proc_dep_vld_vec_46[5] = dl_detect_out ? proc_dep_vld_vec_46_reg[5] : (proc_46_data_FIFO_blk[5] | proc_46_data_PIPO_blk[5] | proc_46_start_FIFO_blk[5] | proc_46_TLF_FIFO_blk[5] | proc_46_input_sync_blk[5] | proc_46_output_sync_blk[5]);
    always @ (negedge dl_reset or posedge dl_clock) begin
        if (~dl_reset) begin
            proc_dep_vld_vec_46_reg <= 'b0;
        end
        else begin
            proc_dep_vld_vec_46_reg <= proc_dep_vld_vec_46;
        end
    end
    assign in_chan_dep_vld_vec_46[0] = dep_chan_vld_15_46;
    assign in_chan_dep_data_vec_46[55 : 0] = dep_chan_data_15_46;
    assign token_in_vec_46[0] = token_15_46;
    assign in_chan_dep_vld_vec_46[1] = dep_chan_vld_19_46;
    assign in_chan_dep_data_vec_46[111 : 56] = dep_chan_data_19_46;
    assign token_in_vec_46[1] = token_19_46;
    assign in_chan_dep_vld_vec_46[2] = dep_chan_vld_38_46;
    assign in_chan_dep_data_vec_46[167 : 112] = dep_chan_data_38_46;
    assign token_in_vec_46[2] = token_38_46;
    assign in_chan_dep_vld_vec_46[3] = dep_chan_vld_40_46;
    assign in_chan_dep_data_vec_46[223 : 168] = dep_chan_data_40_46;
    assign token_in_vec_46[3] = token_40_46;
    assign in_chan_dep_vld_vec_46[4] = dep_chan_vld_49_46;
    assign in_chan_dep_data_vec_46[279 : 224] = dep_chan_data_49_46;
    assign token_in_vec_46[4] = token_49_46;
    assign in_chan_dep_vld_vec_46[5] = dep_chan_vld_50_46;
    assign in_chan_dep_data_vec_46[335 : 280] = dep_chan_data_50_46;
    assign token_in_vec_46[5] = token_50_46;
    assign dep_chan_vld_46_38 = out_chan_dep_vld_vec_46[0];
    assign dep_chan_data_46_38 = out_chan_dep_data_46;
    assign token_46_38 = token_out_vec_46[0];
    assign dep_chan_vld_46_40 = out_chan_dep_vld_vec_46[1];
    assign dep_chan_data_46_40 = out_chan_dep_data_46;
    assign token_46_40 = token_out_vec_46[1];
    assign dep_chan_vld_46_15 = out_chan_dep_vld_vec_46[2];
    assign dep_chan_data_46_15 = out_chan_dep_data_46;
    assign token_46_15 = token_out_vec_46[2];
    assign dep_chan_vld_46_19 = out_chan_dep_vld_vec_46[3];
    assign dep_chan_data_46_19 = out_chan_dep_data_46;
    assign token_46_19 = token_out_vec_46[3];
    assign dep_chan_vld_46_49 = out_chan_dep_vld_vec_46[4];
    assign dep_chan_data_46_49 = out_chan_dep_data_46;
    assign token_46_49 = token_out_vec_46[4];
    assign dep_chan_vld_46_50 = out_chan_dep_vld_vec_46[5];
    assign dep_chan_data_46_50 = out_chan_dep_data_46;
    assign token_46_50 = token_out_vec_46[5];

    // Process: grp_shared_dataflow_fu_225.reconstruct_320_200_U0.upsample_160_100_3_U0
    motion60_shared_hls_deadlock_detect_unit #(56, 47, 3, 3) motion60_shared_hls_deadlock_detect_unit_47 (
        .reset(dl_reset),
        .clock(dl_clock),
        .proc_dep_vld_vec(proc_dep_vld_vec_47),
        .in_chan_dep_vld_vec(in_chan_dep_vld_vec_47),
        .in_chan_dep_data_vec(in_chan_dep_data_vec_47),
        .token_in_vec(token_in_vec_47),
        .dl_detect_in(dl_detect_out),
        .origin(origin[47]),
        .token_clear(token_clear),
        .out_chan_dep_vld_vec(out_chan_dep_vld_vec_47),
        .out_chan_dep_data(out_chan_dep_data_47),
        .token_out_vec(token_out_vec_47),
        .dl_detect_out(dl_in_vec[47]));

    assign proc_47_data_FIFO_blk[0] = 1'b0 | (~grp_shared_dataflow_fu_225.reconstruct_320_200_U0.upsample_160_100_3_U0.grp_upsample_160_100_3_Pipeline_VITIS_LOOP_98_2_fu_89.res_blk_n);
    assign proc_47_data_PIPO_blk[0] = 1'b0;
    assign proc_47_start_FIFO_blk[0] = 1'b0;
    assign proc_47_TLF_FIFO_blk[0] = 1'b0;
    assign proc_47_input_sync_blk[0] = 1'b0;
    assign proc_47_output_sync_blk[0] = 1'b0;
    assign proc_dep_vld_vec_47[0] = dl_detect_out ? proc_dep_vld_vec_47_reg[0] : (proc_47_data_FIFO_blk[0] | proc_47_data_PIPO_blk[0] | proc_47_start_FIFO_blk[0] | proc_47_TLF_FIFO_blk[0] | proc_47_input_sync_blk[0] | proc_47_output_sync_blk[0]);
    assign proc_47_data_FIFO_blk[1] = 1'b0 | (~grp_shared_dataflow_fu_225.reconstruct_320_200_U0.upsample_160_100_3_U0.grp_upsample_160_100_3_Pipeline_VITIS_LOOP_98_2_fu_89.res_blk_n);
    assign proc_47_data_PIPO_blk[1] = 1'b0;
    assign proc_47_start_FIFO_blk[1] = 1'b0;
    assign proc_47_TLF_FIFO_blk[1] = 1'b0;
    assign proc_47_input_sync_blk[1] = 1'b0;
    assign proc_47_output_sync_blk[1] = 1'b0;
    assign proc_dep_vld_vec_47[1] = dl_detect_out ? proc_dep_vld_vec_47_reg[1] : (proc_47_data_FIFO_blk[1] | proc_47_data_PIPO_blk[1] | proc_47_start_FIFO_blk[1] | proc_47_TLF_FIFO_blk[1] | proc_47_input_sync_blk[1] | proc_47_output_sync_blk[1]);
    assign proc_47_data_FIFO_blk[2] = 1'b0 | (~grp_shared_dataflow_fu_225.reconstruct_320_200_U0.upsample_160_100_3_U0.grp_upsample_160_100_3_Pipeline_VITIS_LOOP_104_3_fu_98.large_r_blk_n);
    assign proc_47_data_PIPO_blk[2] = 1'b0;
    assign proc_47_start_FIFO_blk[2] = 1'b0 | (~grp_shared_dataflow_fu_225.reconstruct_320_200_U0.start_for_combine_64000_true_U0_U.if_full_n & grp_shared_dataflow_fu_225.reconstruct_320_200_U0.upsample_160_100_3_U0.ap_start & ~grp_shared_dataflow_fu_225.reconstruct_320_200_U0.upsample_160_100_3_U0.real_start & (trans_in_cnt_28 == trans_out_cnt_28) & ~grp_shared_dataflow_fu_225.reconstruct_320_200_U0.start_for_combine_64000_true_U0_U.if_read);
    assign proc_47_TLF_FIFO_blk[2] = 1'b0;
    assign proc_47_input_sync_blk[2] = 1'b0;
    assign proc_47_output_sync_blk[2] = 1'b0;
    assign proc_dep_vld_vec_47[2] = dl_detect_out ? proc_dep_vld_vec_47_reg[2] : (proc_47_data_FIFO_blk[2] | proc_47_data_PIPO_blk[2] | proc_47_start_FIFO_blk[2] | proc_47_TLF_FIFO_blk[2] | proc_47_input_sync_blk[2] | proc_47_output_sync_blk[2]);
    always @ (negedge dl_reset or posedge dl_clock) begin
        if (~dl_reset) begin
            proc_dep_vld_vec_47_reg <= 'b0;
        end
        else begin
            proc_dep_vld_vec_47_reg <= proc_dep_vld_vec_47;
        end
    end
    assign in_chan_dep_vld_vec_47[0] = dep_chan_vld_15_47;
    assign in_chan_dep_data_vec_47[55 : 0] = dep_chan_data_15_47;
    assign token_in_vec_47[0] = token_15_47;
    assign in_chan_dep_vld_vec_47[1] = dep_chan_vld_19_47;
    assign in_chan_dep_data_vec_47[111 : 56] = dep_chan_data_19_47;
    assign token_in_vec_47[1] = token_19_47;
    assign in_chan_dep_vld_vec_47[2] = dep_chan_vld_48_47;
    assign in_chan_dep_data_vec_47[167 : 112] = dep_chan_data_48_47;
    assign token_in_vec_47[2] = token_48_47;
    assign dep_chan_vld_47_15 = out_chan_dep_vld_vec_47[0];
    assign dep_chan_data_47_15 = out_chan_dep_data_47;
    assign token_47_15 = token_out_vec_47[0];
    assign dep_chan_vld_47_19 = out_chan_dep_vld_vec_47[1];
    assign dep_chan_data_47_19 = out_chan_dep_data_47;
    assign token_47_19 = token_out_vec_47[1];
    assign dep_chan_vld_47_48 = out_chan_dep_vld_vec_47[2];
    assign dep_chan_data_47_48 = out_chan_dep_data_47;
    assign token_47_48 = token_out_vec_47[2];

    // Process: grp_shared_dataflow_fu_225.reconstruct_320_200_U0.combine_64000_true_U0
    motion60_shared_hls_deadlock_detect_unit #(56, 48, 5, 5) motion60_shared_hls_deadlock_detect_unit_48 (
        .reset(dl_reset),
        .clock(dl_clock),
        .proc_dep_vld_vec(proc_dep_vld_vec_48),
        .in_chan_dep_vld_vec(in_chan_dep_vld_vec_48),
        .in_chan_dep_data_vec(in_chan_dep_data_vec_48),
        .token_in_vec(token_in_vec_48),
        .dl_detect_in(dl_detect_out),
        .origin(origin[48]),
        .token_clear(token_clear),
        .out_chan_dep_vld_vec(out_chan_dep_vld_vec_48),
        .out_chan_dep_data(out_chan_dep_data_48),
        .token_out_vec(token_out_vec_48),
        .dl_detect_out(dl_in_vec[48]));

    assign proc_48_data_FIFO_blk[0] = 1'b0 | (~grp_shared_dataflow_fu_225.reconstruct_320_200_U0.combine_64000_true_U0.p2_blk_n);
    assign proc_48_data_PIPO_blk[0] = 1'b0;
    assign proc_48_start_FIFO_blk[0] = 1'b0;
    assign proc_48_TLF_FIFO_blk[0] = 1'b0;
    assign proc_48_input_sync_blk[0] = 1'b0;
    assign proc_48_output_sync_blk[0] = 1'b0;
    assign proc_dep_vld_vec_48[0] = dl_detect_out ? proc_dep_vld_vec_48_reg[0] : (proc_48_data_FIFO_blk[0] | proc_48_data_PIPO_blk[0] | proc_48_start_FIFO_blk[0] | proc_48_TLF_FIFO_blk[0] | proc_48_input_sync_blk[0] | proc_48_output_sync_blk[0]);
    assign proc_48_data_FIFO_blk[1] = 1'b0 | (~grp_shared_dataflow_fu_225.reconstruct_320_200_U0.combine_64000_true_U0.p2_blk_n);
    assign proc_48_data_PIPO_blk[1] = 1'b0;
    assign proc_48_start_FIFO_blk[1] = 1'b0;
    assign proc_48_TLF_FIFO_blk[1] = 1'b0;
    assign proc_48_input_sync_blk[1] = 1'b0;
    assign proc_48_output_sync_blk[1] = 1'b0;
    assign proc_dep_vld_vec_48[1] = dl_detect_out ? proc_dep_vld_vec_48_reg[1] : (proc_48_data_FIFO_blk[1] | proc_48_data_PIPO_blk[1] | proc_48_start_FIFO_blk[1] | proc_48_TLF_FIFO_blk[1] | proc_48_input_sync_blk[1] | proc_48_output_sync_blk[1]);
    assign proc_48_data_FIFO_blk[2] = 1'b0 | (~grp_shared_dataflow_fu_225.reconstruct_320_200_U0.combine_64000_true_U0.large_r_blk_n);
    assign proc_48_data_PIPO_blk[2] = 1'b0;
    assign proc_48_start_FIFO_blk[2] = 1'b0 | (~grp_shared_dataflow_fu_225.reconstruct_320_200_U0.start_for_combine_64000_true_U0_U.if_empty_n & grp_shared_dataflow_fu_225.reconstruct_320_200_U0.combine_64000_true_U0.ap_idle & ~grp_shared_dataflow_fu_225.reconstruct_320_200_U0.start_for_combine_64000_true_U0_U.if_write);
    assign proc_48_TLF_FIFO_blk[2] = 1'b0;
    assign proc_48_input_sync_blk[2] = 1'b0;
    assign proc_48_output_sync_blk[2] = 1'b0;
    assign proc_dep_vld_vec_48[2] = dl_detect_out ? proc_dep_vld_vec_48_reg[2] : (proc_48_data_FIFO_blk[2] | proc_48_data_PIPO_blk[2] | proc_48_start_FIFO_blk[2] | proc_48_TLF_FIFO_blk[2] | proc_48_input_sync_blk[2] | proc_48_output_sync_blk[2]);
    assign proc_48_data_FIFO_blk[3] = 1'b0 | (~grp_shared_dataflow_fu_225.reconstruct_320_200_U0.combine_64000_true_U0.r2_blk_n);
    assign proc_48_data_PIPO_blk[3] = 1'b0;
    assign proc_48_start_FIFO_blk[3] = 1'b0;
    assign proc_48_TLF_FIFO_blk[3] = 1'b0;
    assign proc_48_input_sync_blk[3] = 1'b0;
    assign proc_48_output_sync_blk[3] = 1'b0;
    assign proc_dep_vld_vec_48[3] = dl_detect_out ? proc_dep_vld_vec_48_reg[3] : (proc_48_data_FIFO_blk[3] | proc_48_data_PIPO_blk[3] | proc_48_start_FIFO_blk[3] | proc_48_TLF_FIFO_blk[3] | proc_48_input_sync_blk[3] | proc_48_output_sync_blk[3]);
    assign proc_48_data_FIFO_blk[4] = 1'b0 | (~grp_shared_dataflow_fu_225.reconstruct_320_200_U0.combine_64000_true_U0.r2_blk_n);
    assign proc_48_data_PIPO_blk[4] = 1'b0;
    assign proc_48_start_FIFO_blk[4] = 1'b0;
    assign proc_48_TLF_FIFO_blk[4] = 1'b0;
    assign proc_48_input_sync_blk[4] = 1'b0;
    assign proc_48_output_sync_blk[4] = 1'b0;
    assign proc_dep_vld_vec_48[4] = dl_detect_out ? proc_dep_vld_vec_48_reg[4] : (proc_48_data_FIFO_blk[4] | proc_48_data_PIPO_blk[4] | proc_48_start_FIFO_blk[4] | proc_48_TLF_FIFO_blk[4] | proc_48_input_sync_blk[4] | proc_48_output_sync_blk[4]);
    always @ (negedge dl_reset or posedge dl_clock) begin
        if (~dl_reset) begin
            proc_dep_vld_vec_48_reg <= 'b0;
        end
        else begin
            proc_dep_vld_vec_48_reg <= proc_dep_vld_vec_48;
        end
    end
    assign in_chan_dep_vld_vec_48[0] = dep_chan_vld_38_48;
    assign in_chan_dep_data_vec_48[55 : 0] = dep_chan_data_38_48;
    assign token_in_vec_48[0] = token_38_48;
    assign in_chan_dep_vld_vec_48[1] = dep_chan_vld_40_48;
    assign in_chan_dep_data_vec_48[111 : 56] = dep_chan_data_40_48;
    assign token_in_vec_48[1] = token_40_48;
    assign in_chan_dep_vld_vec_48[2] = dep_chan_vld_47_48;
    assign in_chan_dep_data_vec_48[167 : 112] = dep_chan_data_47_48;
    assign token_in_vec_48[2] = token_47_48;
    assign in_chan_dep_vld_vec_48[3] = dep_chan_vld_49_48;
    assign in_chan_dep_data_vec_48[223 : 168] = dep_chan_data_49_48;
    assign token_in_vec_48[3] = token_49_48;
    assign in_chan_dep_vld_vec_48[4] = dep_chan_vld_50_48;
    assign in_chan_dep_data_vec_48[279 : 224] = dep_chan_data_50_48;
    assign token_in_vec_48[4] = token_50_48;
    assign dep_chan_vld_48_38 = out_chan_dep_vld_vec_48[0];
    assign dep_chan_data_48_38 = out_chan_dep_data_48;
    assign token_48_38 = token_out_vec_48[0];
    assign dep_chan_vld_48_40 = out_chan_dep_vld_vec_48[1];
    assign dep_chan_data_48_40 = out_chan_dep_data_48;
    assign token_48_40 = token_out_vec_48[1];
    assign dep_chan_vld_48_47 = out_chan_dep_vld_vec_48[2];
    assign dep_chan_data_48_47 = out_chan_dep_data_48;
    assign token_48_47 = token_out_vec_48[2];
    assign dep_chan_vld_48_49 = out_chan_dep_vld_vec_48[3];
    assign dep_chan_data_48_49 = out_chan_dep_data_48;
    assign token_48_49 = token_out_vec_48[3];
    assign dep_chan_vld_48_50 = out_chan_dep_vld_vec_48[4];
    assign dep_chan_data_48_50 = out_chan_dep_data_48;
    assign token_48_50 = token_out_vec_48[4];

    // Process: grp_shared_dataflow_fu_225.reconstruct_640_400_U0
    motion60_shared_hls_deadlock_detect_unit #(56, 49, 6, 6) motion60_shared_hls_deadlock_detect_unit_49 (
        .reset(dl_reset),
        .clock(dl_clock),
        .proc_dep_vld_vec(proc_dep_vld_vec_49),
        .in_chan_dep_vld_vec(in_chan_dep_vld_vec_49),
        .in_chan_dep_data_vec(in_chan_dep_data_vec_49),
        .token_in_vec(token_in_vec_49),
        .dl_detect_in(dl_detect_out),
        .origin(origin[49]),
        .token_clear(token_clear),
        .out_chan_dep_vld_vec(out_chan_dep_vld_vec_49),
        .out_chan_dep_data(out_chan_dep_data_49),
        .token_out_vec(token_out_vec_49),
        .dl_detect_out(dl_in_vec[49]));

    assign proc_49_data_FIFO_blk[0] = 1'b0 | (~grp_shared_dataflow_fu_225.reconstruct_640_400_U0.combine_256000_true_U0.p1_blk_n);
    assign proc_49_data_PIPO_blk[0] = 1'b0;
    assign proc_49_start_FIFO_blk[0] = 1'b0 | (~grp_shared_dataflow_fu_225.start_for_reconstruct_640_400_U0_U.if_empty_n & grp_shared_dataflow_fu_225.reconstruct_640_400_U0.ap_idle & ~grp_shared_dataflow_fu_225.start_for_reconstruct_640_400_U0_U.if_write);
    assign proc_49_TLF_FIFO_blk[0] = 1'b0;
    assign proc_49_input_sync_blk[0] = 1'b0;
    assign proc_49_output_sync_blk[0] = 1'b0;
    assign proc_dep_vld_vec_49[0] = dl_detect_out ? proc_dep_vld_vec_49_reg[0] : (proc_49_data_FIFO_blk[0] | proc_49_data_PIPO_blk[0] | proc_49_start_FIFO_blk[0] | proc_49_TLF_FIFO_blk[0] | proc_49_input_sync_blk[0] | proc_49_output_sync_blk[0]);
    assign proc_49_data_FIFO_blk[1] = 1'b0 | (~grp_shared_dataflow_fu_225.reconstruct_640_400_U0.combine_256000_true_U0.p1_blk_n);
    assign proc_49_data_PIPO_blk[1] = 1'b0;
    assign proc_49_start_FIFO_blk[1] = 1'b0;
    assign proc_49_TLF_FIFO_blk[1] = 1'b0;
    assign proc_49_input_sync_blk[1] = 1'b0;
    assign proc_49_output_sync_blk[1] = 1'b0;
    assign proc_dep_vld_vec_49[1] = dl_detect_out ? proc_dep_vld_vec_49_reg[1] : (proc_49_data_FIFO_blk[1] | proc_49_data_PIPO_blk[1] | proc_49_start_FIFO_blk[1] | proc_49_TLF_FIFO_blk[1] | proc_49_input_sync_blk[1] | proc_49_output_sync_blk[1]);
    assign proc_49_data_FIFO_blk[2] = 1'b0 | (~grp_shared_dataflow_fu_225.reconstruct_640_400_U0.upsample_320_200_4_U0.grp_upsample_320_200_4_Pipeline_VITIS_LOOP_98_2_fu_89.r2_blk_n);
    assign proc_49_data_PIPO_blk[2] = 1'b0;
    assign proc_49_start_FIFO_blk[2] = 1'b0;
    assign proc_49_TLF_FIFO_blk[2] = 1'b0;
    assign proc_49_input_sync_blk[2] = 1'b0;
    assign proc_49_output_sync_blk[2] = 1'b0;
    assign proc_dep_vld_vec_49[2] = dl_detect_out ? proc_dep_vld_vec_49_reg[2] : (proc_49_data_FIFO_blk[2] | proc_49_data_PIPO_blk[2] | proc_49_start_FIFO_blk[2] | proc_49_TLF_FIFO_blk[2] | proc_49_input_sync_blk[2] | proc_49_output_sync_blk[2]);
    assign proc_49_data_FIFO_blk[3] = 1'b0 | (~grp_shared_dataflow_fu_225.reconstruct_640_400_U0.upsample_320_200_4_U0.grp_upsample_320_200_4_Pipeline_VITIS_LOOP_98_2_fu_89.r2_blk_n);
    assign proc_49_data_PIPO_blk[3] = 1'b0;
    assign proc_49_start_FIFO_blk[3] = 1'b0;
    assign proc_49_TLF_FIFO_blk[3] = 1'b0;
    assign proc_49_input_sync_blk[3] = 1'b0;
    assign proc_49_output_sync_blk[3] = 1'b0;
    assign proc_dep_vld_vec_49[3] = dl_detect_out ? proc_dep_vld_vec_49_reg[3] : (proc_49_data_FIFO_blk[3] | proc_49_data_PIPO_blk[3] | proc_49_start_FIFO_blk[3] | proc_49_TLF_FIFO_blk[3] | proc_49_input_sync_blk[3] | proc_49_output_sync_blk[3]);
    assign proc_49_data_FIFO_blk[4] = 1'b0 | (~grp_shared_dataflow_fu_225.reconstruct_640_400_U0.combine_256000_true_U0.r1_blk_n);
    assign proc_49_data_PIPO_blk[4] = 1'b0;
    assign proc_49_start_FIFO_blk[4] = 1'b0;
    assign proc_49_TLF_FIFO_blk[4] = 1'b0;
    assign proc_49_input_sync_blk[4] = 1'b0;
    assign proc_49_output_sync_blk[4] = 1'b0;
    assign proc_dep_vld_vec_49[4] = dl_detect_out ? proc_dep_vld_vec_49_reg[4] : (proc_49_data_FIFO_blk[4] | proc_49_data_PIPO_blk[4] | proc_49_start_FIFO_blk[4] | proc_49_TLF_FIFO_blk[4] | proc_49_input_sync_blk[4] | proc_49_output_sync_blk[4]);
    assign proc_49_data_FIFO_blk[5] = 1'b0 | (~grp_shared_dataflow_fu_225.reconstruct_640_400_U0.combine_256000_true_U0.r1_blk_n);
    assign proc_49_data_PIPO_blk[5] = 1'b0;
    assign proc_49_start_FIFO_blk[5] = 1'b0;
    assign proc_49_TLF_FIFO_blk[5] = 1'b0;
    assign proc_49_input_sync_blk[5] = 1'b0;
    assign proc_49_output_sync_blk[5] = 1'b0;
    assign proc_dep_vld_vec_49[5] = dl_detect_out ? proc_dep_vld_vec_49_reg[5] : (proc_49_data_FIFO_blk[5] | proc_49_data_PIPO_blk[5] | proc_49_start_FIFO_blk[5] | proc_49_TLF_FIFO_blk[5] | proc_49_input_sync_blk[5] | proc_49_output_sync_blk[5]);
    always @ (negedge dl_reset or posedge dl_clock) begin
        if (~dl_reset) begin
            proc_dep_vld_vec_49_reg <= 'b0;
        end
        else begin
            proc_dep_vld_vec_49_reg <= proc_dep_vld_vec_49;
        end
    end
    assign in_chan_dep_vld_vec_49[0] = dep_chan_vld_30_49;
    assign in_chan_dep_data_vec_49[55 : 0] = dep_chan_data_30_49;
    assign token_in_vec_49[0] = token_30_49;
    assign in_chan_dep_vld_vec_49[1] = dep_chan_vld_32_49;
    assign in_chan_dep_data_vec_49[111 : 56] = dep_chan_data_32_49;
    assign token_in_vec_49[1] = token_32_49;
    assign in_chan_dep_vld_vec_49[2] = dep_chan_vld_46_49;
    assign in_chan_dep_data_vec_49[167 : 112] = dep_chan_data_46_49;
    assign token_in_vec_49[2] = token_46_49;
    assign in_chan_dep_vld_vec_49[3] = dep_chan_vld_48_49;
    assign in_chan_dep_data_vec_49[223 : 168] = dep_chan_data_48_49;
    assign token_in_vec_49[3] = token_48_49;
    assign in_chan_dep_vld_vec_49[4] = dep_chan_vld_52_49;
    assign in_chan_dep_data_vec_49[279 : 224] = dep_chan_data_52_49;
    assign token_in_vec_49[4] = token_52_49;
    assign in_chan_dep_vld_vec_49[5] = dep_chan_vld_53_49;
    assign in_chan_dep_data_vec_49[335 : 280] = dep_chan_data_53_49;
    assign token_in_vec_49[5] = token_53_49;
    assign dep_chan_vld_49_30 = out_chan_dep_vld_vec_49[0];
    assign dep_chan_data_49_30 = out_chan_dep_data_49;
    assign token_49_30 = token_out_vec_49[0];
    assign dep_chan_vld_49_32 = out_chan_dep_vld_vec_49[1];
    assign dep_chan_data_49_32 = out_chan_dep_data_49;
    assign token_49_32 = token_out_vec_49[1];
    assign dep_chan_vld_49_46 = out_chan_dep_vld_vec_49[2];
    assign dep_chan_data_49_46 = out_chan_dep_data_49;
    assign token_49_46 = token_out_vec_49[2];
    assign dep_chan_vld_49_48 = out_chan_dep_vld_vec_49[3];
    assign dep_chan_data_49_48 = out_chan_dep_data_49;
    assign token_49_48 = token_out_vec_49[3];
    assign dep_chan_vld_49_52 = out_chan_dep_vld_vec_49[4];
    assign dep_chan_data_49_52 = out_chan_dep_data_49;
    assign token_49_52 = token_out_vec_49[4];
    assign dep_chan_vld_49_53 = out_chan_dep_vld_vec_49[5];
    assign dep_chan_data_49_53 = out_chan_dep_data_49;
    assign token_49_53 = token_out_vec_49[5];

    // Process: grp_shared_dataflow_fu_225.reconstruct_640_400_U0.upsample_320_200_4_U0
    motion60_shared_hls_deadlock_detect_unit #(56, 50, 3, 3) motion60_shared_hls_deadlock_detect_unit_50 (
        .reset(dl_reset),
        .clock(dl_clock),
        .proc_dep_vld_vec(proc_dep_vld_vec_50),
        .in_chan_dep_vld_vec(in_chan_dep_vld_vec_50),
        .in_chan_dep_data_vec(in_chan_dep_data_vec_50),
        .token_in_vec(token_in_vec_50),
        .dl_detect_in(dl_detect_out),
        .origin(origin[50]),
        .token_clear(token_clear),
        .out_chan_dep_vld_vec(out_chan_dep_vld_vec_50),
        .out_chan_dep_data(out_chan_dep_data_50),
        .token_out_vec(token_out_vec_50),
        .dl_detect_out(dl_in_vec[50]));

    assign proc_50_data_FIFO_blk[0] = 1'b0 | (~grp_shared_dataflow_fu_225.reconstruct_640_400_U0.upsample_320_200_4_U0.grp_upsample_320_200_4_Pipeline_VITIS_LOOP_98_2_fu_89.r2_blk_n);
    assign proc_50_data_PIPO_blk[0] = 1'b0;
    assign proc_50_start_FIFO_blk[0] = 1'b0;
    assign proc_50_TLF_FIFO_blk[0] = 1'b0;
    assign proc_50_input_sync_blk[0] = 1'b0;
    assign proc_50_output_sync_blk[0] = 1'b0;
    assign proc_dep_vld_vec_50[0] = dl_detect_out ? proc_dep_vld_vec_50_reg[0] : (proc_50_data_FIFO_blk[0] | proc_50_data_PIPO_blk[0] | proc_50_start_FIFO_blk[0] | proc_50_TLF_FIFO_blk[0] | proc_50_input_sync_blk[0] | proc_50_output_sync_blk[0]);
    assign proc_50_data_FIFO_blk[1] = 1'b0 | (~grp_shared_dataflow_fu_225.reconstruct_640_400_U0.upsample_320_200_4_U0.grp_upsample_320_200_4_Pipeline_VITIS_LOOP_98_2_fu_89.r2_blk_n);
    assign proc_50_data_PIPO_blk[1] = 1'b0;
    assign proc_50_start_FIFO_blk[1] = 1'b0;
    assign proc_50_TLF_FIFO_blk[1] = 1'b0;
    assign proc_50_input_sync_blk[1] = 1'b0;
    assign proc_50_output_sync_blk[1] = 1'b0;
    assign proc_dep_vld_vec_50[1] = dl_detect_out ? proc_dep_vld_vec_50_reg[1] : (proc_50_data_FIFO_blk[1] | proc_50_data_PIPO_blk[1] | proc_50_start_FIFO_blk[1] | proc_50_TLF_FIFO_blk[1] | proc_50_input_sync_blk[1] | proc_50_output_sync_blk[1]);
    assign proc_50_data_FIFO_blk[2] = 1'b0 | (~grp_shared_dataflow_fu_225.reconstruct_640_400_U0.upsample_320_200_4_U0.grp_upsample_320_200_4_Pipeline_VITIS_LOOP_104_3_fu_98.large_r_blk_n);
    assign proc_50_data_PIPO_blk[2] = 1'b0;
    assign proc_50_start_FIFO_blk[2] = 1'b0 | (~grp_shared_dataflow_fu_225.reconstruct_640_400_U0.start_for_combine_256000_true_U0_U.if_full_n & grp_shared_dataflow_fu_225.reconstruct_640_400_U0.upsample_320_200_4_U0.ap_start & ~grp_shared_dataflow_fu_225.reconstruct_640_400_U0.upsample_320_200_4_U0.real_start & (trans_in_cnt_30 == trans_out_cnt_30) & ~grp_shared_dataflow_fu_225.reconstruct_640_400_U0.start_for_combine_256000_true_U0_U.if_read);
    assign proc_50_TLF_FIFO_blk[2] = 1'b0;
    assign proc_50_input_sync_blk[2] = 1'b0;
    assign proc_50_output_sync_blk[2] = 1'b0;
    assign proc_dep_vld_vec_50[2] = dl_detect_out ? proc_dep_vld_vec_50_reg[2] : (proc_50_data_FIFO_blk[2] | proc_50_data_PIPO_blk[2] | proc_50_start_FIFO_blk[2] | proc_50_TLF_FIFO_blk[2] | proc_50_input_sync_blk[2] | proc_50_output_sync_blk[2]);
    always @ (negedge dl_reset or posedge dl_clock) begin
        if (~dl_reset) begin
            proc_dep_vld_vec_50_reg <= 'b0;
        end
        else begin
            proc_dep_vld_vec_50_reg <= proc_dep_vld_vec_50;
        end
    end
    assign in_chan_dep_vld_vec_50[0] = dep_chan_vld_46_50;
    assign in_chan_dep_data_vec_50[55 : 0] = dep_chan_data_46_50;
    assign token_in_vec_50[0] = token_46_50;
    assign in_chan_dep_vld_vec_50[1] = dep_chan_vld_48_50;
    assign in_chan_dep_data_vec_50[111 : 56] = dep_chan_data_48_50;
    assign token_in_vec_50[1] = token_48_50;
    assign in_chan_dep_vld_vec_50[2] = dep_chan_vld_51_50;
    assign in_chan_dep_data_vec_50[167 : 112] = dep_chan_data_51_50;
    assign token_in_vec_50[2] = token_51_50;
    assign dep_chan_vld_50_46 = out_chan_dep_vld_vec_50[0];
    assign dep_chan_data_50_46 = out_chan_dep_data_50;
    assign token_50_46 = token_out_vec_50[0];
    assign dep_chan_vld_50_48 = out_chan_dep_vld_vec_50[1];
    assign dep_chan_data_50_48 = out_chan_dep_data_50;
    assign token_50_48 = token_out_vec_50[1];
    assign dep_chan_vld_50_51 = out_chan_dep_vld_vec_50[2];
    assign dep_chan_data_50_51 = out_chan_dep_data_50;
    assign token_50_51 = token_out_vec_50[2];

    // Process: grp_shared_dataflow_fu_225.reconstruct_640_400_U0.combine_256000_true_U0
    motion60_shared_hls_deadlock_detect_unit #(56, 51, 5, 5) motion60_shared_hls_deadlock_detect_unit_51 (
        .reset(dl_reset),
        .clock(dl_clock),
        .proc_dep_vld_vec(proc_dep_vld_vec_51),
        .in_chan_dep_vld_vec(in_chan_dep_vld_vec_51),
        .in_chan_dep_data_vec(in_chan_dep_data_vec_51),
        .token_in_vec(token_in_vec_51),
        .dl_detect_in(dl_detect_out),
        .origin(origin[51]),
        .token_clear(token_clear),
        .out_chan_dep_vld_vec(out_chan_dep_vld_vec_51),
        .out_chan_dep_data(out_chan_dep_data_51),
        .token_out_vec(token_out_vec_51),
        .dl_detect_out(dl_in_vec[51]));

    assign proc_51_data_FIFO_blk[0] = 1'b0 | (~grp_shared_dataflow_fu_225.reconstruct_640_400_U0.combine_256000_true_U0.p1_blk_n);
    assign proc_51_data_PIPO_blk[0] = 1'b0;
    assign proc_51_start_FIFO_blk[0] = 1'b0;
    assign proc_51_TLF_FIFO_blk[0] = 1'b0;
    assign proc_51_input_sync_blk[0] = 1'b0;
    assign proc_51_output_sync_blk[0] = 1'b0;
    assign proc_dep_vld_vec_51[0] = dl_detect_out ? proc_dep_vld_vec_51_reg[0] : (proc_51_data_FIFO_blk[0] | proc_51_data_PIPO_blk[0] | proc_51_start_FIFO_blk[0] | proc_51_TLF_FIFO_blk[0] | proc_51_input_sync_blk[0] | proc_51_output_sync_blk[0]);
    assign proc_51_data_FIFO_blk[1] = 1'b0 | (~grp_shared_dataflow_fu_225.reconstruct_640_400_U0.combine_256000_true_U0.p1_blk_n);
    assign proc_51_data_PIPO_blk[1] = 1'b0;
    assign proc_51_start_FIFO_blk[1] = 1'b0;
    assign proc_51_TLF_FIFO_blk[1] = 1'b0;
    assign proc_51_input_sync_blk[1] = 1'b0;
    assign proc_51_output_sync_blk[1] = 1'b0;
    assign proc_dep_vld_vec_51[1] = dl_detect_out ? proc_dep_vld_vec_51_reg[1] : (proc_51_data_FIFO_blk[1] | proc_51_data_PIPO_blk[1] | proc_51_start_FIFO_blk[1] | proc_51_TLF_FIFO_blk[1] | proc_51_input_sync_blk[1] | proc_51_output_sync_blk[1]);
    assign proc_51_data_FIFO_blk[2] = 1'b0 | (~grp_shared_dataflow_fu_225.reconstruct_640_400_U0.combine_256000_true_U0.large_r_blk_n);
    assign proc_51_data_PIPO_blk[2] = 1'b0;
    assign proc_51_start_FIFO_blk[2] = 1'b0 | (~grp_shared_dataflow_fu_225.reconstruct_640_400_U0.start_for_combine_256000_true_U0_U.if_empty_n & grp_shared_dataflow_fu_225.reconstruct_640_400_U0.combine_256000_true_U0.ap_idle & ~grp_shared_dataflow_fu_225.reconstruct_640_400_U0.start_for_combine_256000_true_U0_U.if_write);
    assign proc_51_TLF_FIFO_blk[2] = 1'b0;
    assign proc_51_input_sync_blk[2] = 1'b0;
    assign proc_51_output_sync_blk[2] = 1'b0;
    assign proc_dep_vld_vec_51[2] = dl_detect_out ? proc_dep_vld_vec_51_reg[2] : (proc_51_data_FIFO_blk[2] | proc_51_data_PIPO_blk[2] | proc_51_start_FIFO_blk[2] | proc_51_TLF_FIFO_blk[2] | proc_51_input_sync_blk[2] | proc_51_output_sync_blk[2]);
    assign proc_51_data_FIFO_blk[3] = 1'b0 | (~grp_shared_dataflow_fu_225.reconstruct_640_400_U0.combine_256000_true_U0.r1_blk_n);
    assign proc_51_data_PIPO_blk[3] = 1'b0;
    assign proc_51_start_FIFO_blk[3] = 1'b0;
    assign proc_51_TLF_FIFO_blk[3] = 1'b0;
    assign proc_51_input_sync_blk[3] = 1'b0;
    assign proc_51_output_sync_blk[3] = 1'b0;
    assign proc_dep_vld_vec_51[3] = dl_detect_out ? proc_dep_vld_vec_51_reg[3] : (proc_51_data_FIFO_blk[3] | proc_51_data_PIPO_blk[3] | proc_51_start_FIFO_blk[3] | proc_51_TLF_FIFO_blk[3] | proc_51_input_sync_blk[3] | proc_51_output_sync_blk[3]);
    assign proc_51_data_FIFO_blk[4] = 1'b0 | (~grp_shared_dataflow_fu_225.reconstruct_640_400_U0.combine_256000_true_U0.r1_blk_n);
    assign proc_51_data_PIPO_blk[4] = 1'b0;
    assign proc_51_start_FIFO_blk[4] = 1'b0;
    assign proc_51_TLF_FIFO_blk[4] = 1'b0;
    assign proc_51_input_sync_blk[4] = 1'b0;
    assign proc_51_output_sync_blk[4] = 1'b0;
    assign proc_dep_vld_vec_51[4] = dl_detect_out ? proc_dep_vld_vec_51_reg[4] : (proc_51_data_FIFO_blk[4] | proc_51_data_PIPO_blk[4] | proc_51_start_FIFO_blk[4] | proc_51_TLF_FIFO_blk[4] | proc_51_input_sync_blk[4] | proc_51_output_sync_blk[4]);
    always @ (negedge dl_reset or posedge dl_clock) begin
        if (~dl_reset) begin
            proc_dep_vld_vec_51_reg <= 'b0;
        end
        else begin
            proc_dep_vld_vec_51_reg <= proc_dep_vld_vec_51;
        end
    end
    assign in_chan_dep_vld_vec_51[0] = dep_chan_vld_30_51;
    assign in_chan_dep_data_vec_51[55 : 0] = dep_chan_data_30_51;
    assign token_in_vec_51[0] = token_30_51;
    assign in_chan_dep_vld_vec_51[1] = dep_chan_vld_32_51;
    assign in_chan_dep_data_vec_51[111 : 56] = dep_chan_data_32_51;
    assign token_in_vec_51[1] = token_32_51;
    assign in_chan_dep_vld_vec_51[2] = dep_chan_vld_50_51;
    assign in_chan_dep_data_vec_51[167 : 112] = dep_chan_data_50_51;
    assign token_in_vec_51[2] = token_50_51;
    assign in_chan_dep_vld_vec_51[3] = dep_chan_vld_52_51;
    assign in_chan_dep_data_vec_51[223 : 168] = dep_chan_data_52_51;
    assign token_in_vec_51[3] = token_52_51;
    assign in_chan_dep_vld_vec_51[4] = dep_chan_vld_53_51;
    assign in_chan_dep_data_vec_51[279 : 224] = dep_chan_data_53_51;
    assign token_in_vec_51[4] = token_53_51;
    assign dep_chan_vld_51_30 = out_chan_dep_vld_vec_51[0];
    assign dep_chan_data_51_30 = out_chan_dep_data_51;
    assign token_51_30 = token_out_vec_51[0];
    assign dep_chan_vld_51_32 = out_chan_dep_vld_vec_51[1];
    assign dep_chan_data_51_32 = out_chan_dep_data_51;
    assign token_51_32 = token_out_vec_51[1];
    assign dep_chan_vld_51_50 = out_chan_dep_vld_vec_51[2];
    assign dep_chan_data_51_50 = out_chan_dep_data_51;
    assign token_51_50 = token_out_vec_51[2];
    assign dep_chan_vld_51_52 = out_chan_dep_vld_vec_51[3];
    assign dep_chan_data_51_52 = out_chan_dep_data_51;
    assign token_51_52 = token_out_vec_51[3];
    assign dep_chan_vld_51_53 = out_chan_dep_vld_vec_51[4];
    assign dep_chan_data_51_53 = out_chan_dep_data_51;
    assign token_51_53 = token_out_vec_51[4];

    // Process: grp_shared_dataflow_fu_225.reconstruct_1280_800_U0
    motion60_shared_hls_deadlock_detect_unit #(56, 52, 5, 5) motion60_shared_hls_deadlock_detect_unit_52 (
        .reset(dl_reset),
        .clock(dl_clock),
        .proc_dep_vld_vec(proc_dep_vld_vec_52),
        .in_chan_dep_vld_vec(in_chan_dep_vld_vec_52),
        .in_chan_dep_data_vec(in_chan_dep_data_vec_52),
        .token_in_vec(token_in_vec_52),
        .dl_detect_in(dl_detect_out),
        .origin(origin[52]),
        .token_clear(token_clear),
        .out_chan_dep_vld_vec(out_chan_dep_vld_vec_52),
        .out_chan_dep_data(out_chan_dep_data_52),
        .token_out_vec(token_out_vec_52),
        .dl_detect_out(dl_in_vec[52]));

    assign proc_52_data_FIFO_blk[0] = 1'b0 | (~grp_shared_dataflow_fu_225.reconstruct_1280_800_U0.combine_1024000_true_U0.p0_blk_n);
    assign proc_52_data_PIPO_blk[0] = 1'b0;
    assign proc_52_start_FIFO_blk[0] = 1'b0 | (~grp_shared_dataflow_fu_225.start_for_reconstruct_1280_800_U0_U.if_empty_n & grp_shared_dataflow_fu_225.reconstruct_1280_800_U0.ap_idle & ~grp_shared_dataflow_fu_225.start_for_reconstruct_1280_800_U0_U.if_write);
    assign proc_52_TLF_FIFO_blk[0] = 1'b0;
    assign proc_52_input_sync_blk[0] = 1'b0;
    assign proc_52_output_sync_blk[0] = 1'b0;
    assign proc_dep_vld_vec_52[0] = dl_detect_out ? proc_dep_vld_vec_52_reg[0] : (proc_52_data_FIFO_blk[0] | proc_52_data_PIPO_blk[0] | proc_52_start_FIFO_blk[0] | proc_52_TLF_FIFO_blk[0] | proc_52_input_sync_blk[0] | proc_52_output_sync_blk[0]);
    assign proc_52_data_FIFO_blk[1] = 1'b0 | (~grp_shared_dataflow_fu_225.reconstruct_1280_800_U0.combine_1024000_true_U0.p0_blk_n);
    assign proc_52_data_PIPO_blk[1] = 1'b0;
    assign proc_52_start_FIFO_blk[1] = 1'b0;
    assign proc_52_TLF_FIFO_blk[1] = 1'b0;
    assign proc_52_input_sync_blk[1] = 1'b0;
    assign proc_52_output_sync_blk[1] = 1'b0;
    assign proc_dep_vld_vec_52[1] = dl_detect_out ? proc_dep_vld_vec_52_reg[1] : (proc_52_data_FIFO_blk[1] | proc_52_data_PIPO_blk[1] | proc_52_start_FIFO_blk[1] | proc_52_TLF_FIFO_blk[1] | proc_52_input_sync_blk[1] | proc_52_output_sync_blk[1]);
    assign proc_52_data_FIFO_blk[2] = 1'b0 | (~grp_shared_dataflow_fu_225.reconstruct_1280_800_U0.upsample_640_400_5_U0.grp_upsample_640_400_5_Pipeline_VITIS_LOOP_98_2_fu_89.r1_blk_n);
    assign proc_52_data_PIPO_blk[2] = 1'b0;
    assign proc_52_start_FIFO_blk[2] = 1'b0;
    assign proc_52_TLF_FIFO_blk[2] = 1'b0;
    assign proc_52_input_sync_blk[2] = 1'b0;
    assign proc_52_output_sync_blk[2] = 1'b0;
    assign proc_dep_vld_vec_52[2] = dl_detect_out ? proc_dep_vld_vec_52_reg[2] : (proc_52_data_FIFO_blk[2] | proc_52_data_PIPO_blk[2] | proc_52_start_FIFO_blk[2] | proc_52_TLF_FIFO_blk[2] | proc_52_input_sync_blk[2] | proc_52_output_sync_blk[2]);
    assign proc_52_data_FIFO_blk[3] = 1'b0 | (~grp_shared_dataflow_fu_225.reconstruct_1280_800_U0.upsample_640_400_5_U0.grp_upsample_640_400_5_Pipeline_VITIS_LOOP_98_2_fu_89.r1_blk_n);
    assign proc_52_data_PIPO_blk[3] = 1'b0;
    assign proc_52_start_FIFO_blk[3] = 1'b0;
    assign proc_52_TLF_FIFO_blk[3] = 1'b0;
    assign proc_52_input_sync_blk[3] = 1'b0;
    assign proc_52_output_sync_blk[3] = 1'b0;
    assign proc_dep_vld_vec_52[3] = dl_detect_out ? proc_dep_vld_vec_52_reg[3] : (proc_52_data_FIFO_blk[3] | proc_52_data_PIPO_blk[3] | proc_52_start_FIFO_blk[3] | proc_52_TLF_FIFO_blk[3] | proc_52_input_sync_blk[3] | proc_52_output_sync_blk[3]);
    assign proc_52_data_FIFO_blk[4] = 1'b0 | (~grp_shared_dataflow_fu_225.reconstruct_1280_800_U0.combine_1024000_true_U0.r0_blk_n);
    assign proc_52_data_PIPO_blk[4] = 1'b0;
    assign proc_52_start_FIFO_blk[4] = 1'b0 | (~grp_shared_dataflow_fu_225.start_for_write_image_U0_U.if_full_n & grp_shared_dataflow_fu_225.reconstruct_1280_800_U0.ap_start & ~grp_shared_dataflow_fu_225.reconstruct_1280_800_U0.real_start & (trans_in_cnt_33 == trans_out_cnt_33) & ~grp_shared_dataflow_fu_225.start_for_write_image_U0_U.if_read);
    assign proc_52_TLF_FIFO_blk[4] = 1'b0;
    assign proc_52_input_sync_blk[4] = 1'b0;
    assign proc_52_output_sync_blk[4] = 1'b0;
    assign proc_dep_vld_vec_52[4] = dl_detect_out ? proc_dep_vld_vec_52_reg[4] : (proc_52_data_FIFO_blk[4] | proc_52_data_PIPO_blk[4] | proc_52_start_FIFO_blk[4] | proc_52_TLF_FIFO_blk[4] | proc_52_input_sync_blk[4] | proc_52_output_sync_blk[4]);
    always @ (negedge dl_reset or posedge dl_clock) begin
        if (~dl_reset) begin
            proc_dep_vld_vec_52_reg <= 'b0;
        end
        else begin
            proc_dep_vld_vec_52_reg <= proc_dep_vld_vec_52;
        end
    end
    assign in_chan_dep_vld_vec_52[0] = dep_chan_vld_22_52;
    assign in_chan_dep_data_vec_52[55 : 0] = dep_chan_data_22_52;
    assign token_in_vec_52[0] = token_22_52;
    assign in_chan_dep_vld_vec_52[1] = dep_chan_vld_24_52;
    assign in_chan_dep_data_vec_52[111 : 56] = dep_chan_data_24_52;
    assign token_in_vec_52[1] = token_24_52;
    assign in_chan_dep_vld_vec_52[2] = dep_chan_vld_49_52;
    assign in_chan_dep_data_vec_52[167 : 112] = dep_chan_data_49_52;
    assign token_in_vec_52[2] = token_49_52;
    assign in_chan_dep_vld_vec_52[3] = dep_chan_vld_51_52;
    assign in_chan_dep_data_vec_52[223 : 168] = dep_chan_data_51_52;
    assign token_in_vec_52[3] = token_51_52;
    assign in_chan_dep_vld_vec_52[4] = dep_chan_vld_55_52;
    assign in_chan_dep_data_vec_52[279 : 224] = dep_chan_data_55_52;
    assign token_in_vec_52[4] = token_55_52;
    assign dep_chan_vld_52_22 = out_chan_dep_vld_vec_52[0];
    assign dep_chan_data_52_22 = out_chan_dep_data_52;
    assign token_52_22 = token_out_vec_52[0];
    assign dep_chan_vld_52_24 = out_chan_dep_vld_vec_52[1];
    assign dep_chan_data_52_24 = out_chan_dep_data_52;
    assign token_52_24 = token_out_vec_52[1];
    assign dep_chan_vld_52_49 = out_chan_dep_vld_vec_52[2];
    assign dep_chan_data_52_49 = out_chan_dep_data_52;
    assign token_52_49 = token_out_vec_52[2];
    assign dep_chan_vld_52_51 = out_chan_dep_vld_vec_52[3];
    assign dep_chan_data_52_51 = out_chan_dep_data_52;
    assign token_52_51 = token_out_vec_52[3];
    assign dep_chan_vld_52_55 = out_chan_dep_vld_vec_52[4];
    assign dep_chan_data_52_55 = out_chan_dep_data_52;
    assign token_52_55 = token_out_vec_52[4];

    // Process: grp_shared_dataflow_fu_225.reconstruct_1280_800_U0.upsample_640_400_5_U0
    motion60_shared_hls_deadlock_detect_unit #(56, 53, 3, 3) motion60_shared_hls_deadlock_detect_unit_53 (
        .reset(dl_reset),
        .clock(dl_clock),
        .proc_dep_vld_vec(proc_dep_vld_vec_53),
        .in_chan_dep_vld_vec(in_chan_dep_vld_vec_53),
        .in_chan_dep_data_vec(in_chan_dep_data_vec_53),
        .token_in_vec(token_in_vec_53),
        .dl_detect_in(dl_detect_out),
        .origin(origin[53]),
        .token_clear(token_clear),
        .out_chan_dep_vld_vec(out_chan_dep_vld_vec_53),
        .out_chan_dep_data(out_chan_dep_data_53),
        .token_out_vec(token_out_vec_53),
        .dl_detect_out(dl_in_vec[53]));

    assign proc_53_data_FIFO_blk[0] = 1'b0 | (~grp_shared_dataflow_fu_225.reconstruct_1280_800_U0.upsample_640_400_5_U0.grp_upsample_640_400_5_Pipeline_VITIS_LOOP_98_2_fu_89.r1_blk_n);
    assign proc_53_data_PIPO_blk[0] = 1'b0;
    assign proc_53_start_FIFO_blk[0] = 1'b0;
    assign proc_53_TLF_FIFO_blk[0] = 1'b0;
    assign proc_53_input_sync_blk[0] = 1'b0;
    assign proc_53_output_sync_blk[0] = 1'b0;
    assign proc_dep_vld_vec_53[0] = dl_detect_out ? proc_dep_vld_vec_53_reg[0] : (proc_53_data_FIFO_blk[0] | proc_53_data_PIPO_blk[0] | proc_53_start_FIFO_blk[0] | proc_53_TLF_FIFO_blk[0] | proc_53_input_sync_blk[0] | proc_53_output_sync_blk[0]);
    assign proc_53_data_FIFO_blk[1] = 1'b0 | (~grp_shared_dataflow_fu_225.reconstruct_1280_800_U0.upsample_640_400_5_U0.grp_upsample_640_400_5_Pipeline_VITIS_LOOP_98_2_fu_89.r1_blk_n);
    assign proc_53_data_PIPO_blk[1] = 1'b0;
    assign proc_53_start_FIFO_blk[1] = 1'b0;
    assign proc_53_TLF_FIFO_blk[1] = 1'b0;
    assign proc_53_input_sync_blk[1] = 1'b0;
    assign proc_53_output_sync_blk[1] = 1'b0;
    assign proc_dep_vld_vec_53[1] = dl_detect_out ? proc_dep_vld_vec_53_reg[1] : (proc_53_data_FIFO_blk[1] | proc_53_data_PIPO_blk[1] | proc_53_start_FIFO_blk[1] | proc_53_TLF_FIFO_blk[1] | proc_53_input_sync_blk[1] | proc_53_output_sync_blk[1]);
    assign proc_53_data_FIFO_blk[2] = 1'b0 | (~grp_shared_dataflow_fu_225.reconstruct_1280_800_U0.upsample_640_400_5_U0.grp_upsample_640_400_5_Pipeline_VITIS_LOOP_104_3_fu_98.large_r_blk_n);
    assign proc_53_data_PIPO_blk[2] = 1'b0;
    assign proc_53_start_FIFO_blk[2] = 1'b0 | (~grp_shared_dataflow_fu_225.reconstruct_1280_800_U0.start_for_combine_1024000_true_U0_U.if_full_n & grp_shared_dataflow_fu_225.reconstruct_1280_800_U0.upsample_640_400_5_U0.ap_start & ~grp_shared_dataflow_fu_225.reconstruct_1280_800_U0.upsample_640_400_5_U0.real_start & (trans_in_cnt_32 == trans_out_cnt_32) & ~grp_shared_dataflow_fu_225.reconstruct_1280_800_U0.start_for_combine_1024000_true_U0_U.if_read);
    assign proc_53_TLF_FIFO_blk[2] = 1'b0;
    assign proc_53_input_sync_blk[2] = 1'b0;
    assign proc_53_output_sync_blk[2] = 1'b0;
    assign proc_dep_vld_vec_53[2] = dl_detect_out ? proc_dep_vld_vec_53_reg[2] : (proc_53_data_FIFO_blk[2] | proc_53_data_PIPO_blk[2] | proc_53_start_FIFO_blk[2] | proc_53_TLF_FIFO_blk[2] | proc_53_input_sync_blk[2] | proc_53_output_sync_blk[2]);
    always @ (negedge dl_reset or posedge dl_clock) begin
        if (~dl_reset) begin
            proc_dep_vld_vec_53_reg <= 'b0;
        end
        else begin
            proc_dep_vld_vec_53_reg <= proc_dep_vld_vec_53;
        end
    end
    assign in_chan_dep_vld_vec_53[0] = dep_chan_vld_49_53;
    assign in_chan_dep_data_vec_53[55 : 0] = dep_chan_data_49_53;
    assign token_in_vec_53[0] = token_49_53;
    assign in_chan_dep_vld_vec_53[1] = dep_chan_vld_51_53;
    assign in_chan_dep_data_vec_53[111 : 56] = dep_chan_data_51_53;
    assign token_in_vec_53[1] = token_51_53;
    assign in_chan_dep_vld_vec_53[2] = dep_chan_vld_54_53;
    assign in_chan_dep_data_vec_53[167 : 112] = dep_chan_data_54_53;
    assign token_in_vec_53[2] = token_54_53;
    assign dep_chan_vld_53_49 = out_chan_dep_vld_vec_53[0];
    assign dep_chan_data_53_49 = out_chan_dep_data_53;
    assign token_53_49 = token_out_vec_53[0];
    assign dep_chan_vld_53_51 = out_chan_dep_vld_vec_53[1];
    assign dep_chan_data_53_51 = out_chan_dep_data_53;
    assign token_53_51 = token_out_vec_53[1];
    assign dep_chan_vld_53_54 = out_chan_dep_vld_vec_53[2];
    assign dep_chan_data_53_54 = out_chan_dep_data_53;
    assign token_53_54 = token_out_vec_53[2];

    // Process: grp_shared_dataflow_fu_225.reconstruct_1280_800_U0.combine_1024000_true_U0
    motion60_shared_hls_deadlock_detect_unit #(56, 54, 4, 4) motion60_shared_hls_deadlock_detect_unit_54 (
        .reset(dl_reset),
        .clock(dl_clock),
        .proc_dep_vld_vec(proc_dep_vld_vec_54),
        .in_chan_dep_vld_vec(in_chan_dep_vld_vec_54),
        .in_chan_dep_data_vec(in_chan_dep_data_vec_54),
        .token_in_vec(token_in_vec_54),
        .dl_detect_in(dl_detect_out),
        .origin(origin[54]),
        .token_clear(token_clear),
        .out_chan_dep_vld_vec(out_chan_dep_vld_vec_54),
        .out_chan_dep_data(out_chan_dep_data_54),
        .token_out_vec(token_out_vec_54),
        .dl_detect_out(dl_in_vec[54]));

    assign proc_54_data_FIFO_blk[0] = 1'b0 | (~grp_shared_dataflow_fu_225.reconstruct_1280_800_U0.combine_1024000_true_U0.p0_blk_n);
    assign proc_54_data_PIPO_blk[0] = 1'b0;
    assign proc_54_start_FIFO_blk[0] = 1'b0;
    assign proc_54_TLF_FIFO_blk[0] = 1'b0;
    assign proc_54_input_sync_blk[0] = 1'b0;
    assign proc_54_output_sync_blk[0] = 1'b0;
    assign proc_dep_vld_vec_54[0] = dl_detect_out ? proc_dep_vld_vec_54_reg[0] : (proc_54_data_FIFO_blk[0] | proc_54_data_PIPO_blk[0] | proc_54_start_FIFO_blk[0] | proc_54_TLF_FIFO_blk[0] | proc_54_input_sync_blk[0] | proc_54_output_sync_blk[0]);
    assign proc_54_data_FIFO_blk[1] = 1'b0 | (~grp_shared_dataflow_fu_225.reconstruct_1280_800_U0.combine_1024000_true_U0.p0_blk_n);
    assign proc_54_data_PIPO_blk[1] = 1'b0;
    assign proc_54_start_FIFO_blk[1] = 1'b0;
    assign proc_54_TLF_FIFO_blk[1] = 1'b0;
    assign proc_54_input_sync_blk[1] = 1'b0;
    assign proc_54_output_sync_blk[1] = 1'b0;
    assign proc_dep_vld_vec_54[1] = dl_detect_out ? proc_dep_vld_vec_54_reg[1] : (proc_54_data_FIFO_blk[1] | proc_54_data_PIPO_blk[1] | proc_54_start_FIFO_blk[1] | proc_54_TLF_FIFO_blk[1] | proc_54_input_sync_blk[1] | proc_54_output_sync_blk[1]);
    assign proc_54_data_FIFO_blk[2] = 1'b0 | (~grp_shared_dataflow_fu_225.reconstruct_1280_800_U0.combine_1024000_true_U0.large_r_blk_n);
    assign proc_54_data_PIPO_blk[2] = 1'b0;
    assign proc_54_start_FIFO_blk[2] = 1'b0 | (~grp_shared_dataflow_fu_225.reconstruct_1280_800_U0.start_for_combine_1024000_true_U0_U.if_empty_n & grp_shared_dataflow_fu_225.reconstruct_1280_800_U0.combine_1024000_true_U0.ap_idle & ~grp_shared_dataflow_fu_225.reconstruct_1280_800_U0.start_for_combine_1024000_true_U0_U.if_write);
    assign proc_54_TLF_FIFO_blk[2] = 1'b0;
    assign proc_54_input_sync_blk[2] = 1'b0;
    assign proc_54_output_sync_blk[2] = 1'b0;
    assign proc_dep_vld_vec_54[2] = dl_detect_out ? proc_dep_vld_vec_54_reg[2] : (proc_54_data_FIFO_blk[2] | proc_54_data_PIPO_blk[2] | proc_54_start_FIFO_blk[2] | proc_54_TLF_FIFO_blk[2] | proc_54_input_sync_blk[2] | proc_54_output_sync_blk[2]);
    assign proc_54_data_FIFO_blk[3] = 1'b0 | (~grp_shared_dataflow_fu_225.reconstruct_1280_800_U0.combine_1024000_true_U0.r0_blk_n);
    assign proc_54_data_PIPO_blk[3] = 1'b0;
    assign proc_54_start_FIFO_blk[3] = 1'b0;
    assign proc_54_TLF_FIFO_blk[3] = 1'b0;
    assign proc_54_input_sync_blk[3] = 1'b0;
    assign proc_54_output_sync_blk[3] = 1'b0;
    assign proc_dep_vld_vec_54[3] = dl_detect_out ? proc_dep_vld_vec_54_reg[3] : (proc_54_data_FIFO_blk[3] | proc_54_data_PIPO_blk[3] | proc_54_start_FIFO_blk[3] | proc_54_TLF_FIFO_blk[3] | proc_54_input_sync_blk[3] | proc_54_output_sync_blk[3]);
    always @ (negedge dl_reset or posedge dl_clock) begin
        if (~dl_reset) begin
            proc_dep_vld_vec_54_reg <= 'b0;
        end
        else begin
            proc_dep_vld_vec_54_reg <= proc_dep_vld_vec_54;
        end
    end
    assign in_chan_dep_vld_vec_54[0] = dep_chan_vld_22_54;
    assign in_chan_dep_data_vec_54[55 : 0] = dep_chan_data_22_54;
    assign token_in_vec_54[0] = token_22_54;
    assign in_chan_dep_vld_vec_54[1] = dep_chan_vld_24_54;
    assign in_chan_dep_data_vec_54[111 : 56] = dep_chan_data_24_54;
    assign token_in_vec_54[1] = token_24_54;
    assign in_chan_dep_vld_vec_54[2] = dep_chan_vld_53_54;
    assign in_chan_dep_data_vec_54[167 : 112] = dep_chan_data_53_54;
    assign token_in_vec_54[2] = token_53_54;
    assign in_chan_dep_vld_vec_54[3] = dep_chan_vld_55_54;
    assign in_chan_dep_data_vec_54[223 : 168] = dep_chan_data_55_54;
    assign token_in_vec_54[3] = token_55_54;
    assign dep_chan_vld_54_22 = out_chan_dep_vld_vec_54[0];
    assign dep_chan_data_54_22 = out_chan_dep_data_54;
    assign token_54_22 = token_out_vec_54[0];
    assign dep_chan_vld_54_24 = out_chan_dep_vld_vec_54[1];
    assign dep_chan_data_54_24 = out_chan_dep_data_54;
    assign token_54_24 = token_out_vec_54[1];
    assign dep_chan_vld_54_53 = out_chan_dep_vld_vec_54[2];
    assign dep_chan_data_54_53 = out_chan_dep_data_54;
    assign token_54_53 = token_out_vec_54[2];
    assign dep_chan_vld_54_55 = out_chan_dep_vld_vec_54[3];
    assign dep_chan_data_54_55 = out_chan_dep_data_54;
    assign token_54_55 = token_out_vec_54[3];

    // Process: grp_shared_dataflow_fu_225.write_image_U0
    motion60_shared_hls_deadlock_detect_unit #(56, 55, 5, 5) motion60_shared_hls_deadlock_detect_unit_55 (
        .reset(dl_reset),
        .clock(dl_clock),
        .proc_dep_vld_vec(proc_dep_vld_vec_55),
        .in_chan_dep_vld_vec(in_chan_dep_vld_vec_55),
        .in_chan_dep_data_vec(in_chan_dep_data_vec_55),
        .token_in_vec(token_in_vec_55),
        .dl_detect_in(dl_detect_out),
        .origin(origin[55]),
        .token_clear(token_clear),
        .out_chan_dep_vld_vec(out_chan_dep_vld_vec_55),
        .out_chan_dep_data(out_chan_dep_data_55),
        .token_out_vec(token_out_vec_55),
        .dl_detect_out(dl_in_vec[55]));

    assign proc_55_data_FIFO_blk[0] = 1'b0 | (~grp_shared_dataflow_fu_225.write_image_U0.grp_write_image_Pipeline_VITIS_LOOP_161_1_fu_70.r0_blk_n);
    assign proc_55_data_PIPO_blk[0] = 1'b0;
    assign proc_55_start_FIFO_blk[0] = 1'b0 | (~grp_shared_dataflow_fu_225.start_for_write_image_U0_U.if_empty_n & grp_shared_dataflow_fu_225.write_image_U0.ap_idle & ~grp_shared_dataflow_fu_225.start_for_write_image_U0_U.if_write);
    assign proc_55_TLF_FIFO_blk[0] = 1'b0;
    assign proc_55_input_sync_blk[0] = 1'b0;
    assign proc_55_output_sync_blk[0] = 1'b0;
    assign proc_dep_vld_vec_55[0] = dl_detect_out ? proc_dep_vld_vec_55_reg[0] : (proc_55_data_FIFO_blk[0] | proc_55_data_PIPO_blk[0] | proc_55_start_FIFO_blk[0] | proc_55_TLF_FIFO_blk[0] | proc_55_input_sync_blk[0] | proc_55_output_sync_blk[0]);
    assign proc_55_data_FIFO_blk[1] = 1'b0 | (~grp_shared_dataflow_fu_225.write_image_U0.grp_write_image_Pipeline_VITIS_LOOP_161_1_fu_70.r0_blk_n);
    assign proc_55_data_PIPO_blk[1] = 1'b0;
    assign proc_55_start_FIFO_blk[1] = 1'b0;
    assign proc_55_TLF_FIFO_blk[1] = 1'b0;
    assign proc_55_input_sync_blk[1] = 1'b0;
    assign proc_55_output_sync_blk[1] = 1'b0;
    assign proc_dep_vld_vec_55[1] = dl_detect_out ? proc_dep_vld_vec_55_reg[1] : (proc_55_data_FIFO_blk[1] | proc_55_data_PIPO_blk[1] | proc_55_start_FIFO_blk[1] | proc_55_TLF_FIFO_blk[1] | proc_55_input_sync_blk[1] | proc_55_output_sync_blk[1]);
    assign proc_55_data_FIFO_blk[2] = 1'b0;
    assign proc_55_data_PIPO_blk[2] = 1'b0;
    assign proc_55_start_FIFO_blk[2] = 1'b0;
    assign proc_55_TLF_FIFO_blk[2] = 1'b0;
    assign proc_55_input_sync_blk[2] = 1'b0;
    assign proc_55_output_sync_blk[2] = 1'b0 | (ap_done_reg_3 & grp_shared_dataflow_fu_225.write_image_U0.ap_done & ~grp_shared_dataflow_fu_225.phase_band_1280_800_U0.ap_done);
    assign proc_dep_vld_vec_55[2] = dl_detect_out ? proc_dep_vld_vec_55_reg[2] : (proc_55_data_FIFO_blk[2] | proc_55_data_PIPO_blk[2] | proc_55_start_FIFO_blk[2] | proc_55_TLF_FIFO_blk[2] | proc_55_input_sync_blk[2] | proc_55_output_sync_blk[2]);
    assign proc_55_data_FIFO_blk[3] = 1'b0;
    assign proc_55_data_PIPO_blk[3] = 1'b0;
    assign proc_55_start_FIFO_blk[3] = 1'b0;
    assign proc_55_TLF_FIFO_blk[3] = 1'b0;
    assign proc_55_input_sync_blk[3] = 1'b0;
    assign proc_55_output_sync_blk[3] = 1'b0 | (ap_done_reg_3 & grp_shared_dataflow_fu_225.write_image_U0.ap_done & ~grp_shared_dataflow_fu_225.phase_band_640_400_U0.ap_done);
    assign proc_dep_vld_vec_55[3] = dl_detect_out ? proc_dep_vld_vec_55_reg[3] : (proc_55_data_FIFO_blk[3] | proc_55_data_PIPO_blk[3] | proc_55_start_FIFO_blk[3] | proc_55_TLF_FIFO_blk[3] | proc_55_input_sync_blk[3] | proc_55_output_sync_blk[3]);
    assign proc_55_data_FIFO_blk[4] = 1'b0;
    assign proc_55_data_PIPO_blk[4] = 1'b0;
    assign proc_55_start_FIFO_blk[4] = 1'b0;
    assign proc_55_TLF_FIFO_blk[4] = 1'b0;
    assign proc_55_input_sync_blk[4] = 1'b0;
    assign proc_55_output_sync_blk[4] = 1'b0 | (ap_done_reg_3 & grp_shared_dataflow_fu_225.write_image_U0.ap_done & ~grp_shared_dataflow_fu_225.phase_band_320_200_U0.ap_done);
    assign proc_dep_vld_vec_55[4] = dl_detect_out ? proc_dep_vld_vec_55_reg[4] : (proc_55_data_FIFO_blk[4] | proc_55_data_PIPO_blk[4] | proc_55_start_FIFO_blk[4] | proc_55_TLF_FIFO_blk[4] | proc_55_input_sync_blk[4] | proc_55_output_sync_blk[4]);
    always @ (negedge dl_reset or posedge dl_clock) begin
        if (~dl_reset) begin
            proc_dep_vld_vec_55_reg <= 'b0;
        end
        else begin
            proc_dep_vld_vec_55_reg <= proc_dep_vld_vec_55;
        end
    end
    assign in_chan_dep_vld_vec_55[0] = dep_chan_vld_22_55;
    assign in_chan_dep_data_vec_55[55 : 0] = dep_chan_data_22_55;
    assign token_in_vec_55[0] = token_22_55;
    assign in_chan_dep_vld_vec_55[1] = dep_chan_vld_30_55;
    assign in_chan_dep_data_vec_55[111 : 56] = dep_chan_data_30_55;
    assign token_in_vec_55[1] = token_30_55;
    assign in_chan_dep_vld_vec_55[2] = dep_chan_vld_38_55;
    assign in_chan_dep_data_vec_55[167 : 112] = dep_chan_data_38_55;
    assign token_in_vec_55[2] = token_38_55;
    assign in_chan_dep_vld_vec_55[3] = dep_chan_vld_52_55;
    assign in_chan_dep_data_vec_55[223 : 168] = dep_chan_data_52_55;
    assign token_in_vec_55[3] = token_52_55;
    assign in_chan_dep_vld_vec_55[4] = dep_chan_vld_54_55;
    assign in_chan_dep_data_vec_55[279 : 224] = dep_chan_data_54_55;
    assign token_in_vec_55[4] = token_54_55;
    assign dep_chan_vld_55_52 = out_chan_dep_vld_vec_55[0];
    assign dep_chan_data_55_52 = out_chan_dep_data_55;
    assign token_55_52 = token_out_vec_55[0];
    assign dep_chan_vld_55_54 = out_chan_dep_vld_vec_55[1];
    assign dep_chan_data_55_54 = out_chan_dep_data_55;
    assign token_55_54 = token_out_vec_55[1];
    assign dep_chan_vld_55_22 = out_chan_dep_vld_vec_55[2];
    assign dep_chan_data_55_22 = out_chan_dep_data_55;
    assign token_55_22 = token_out_vec_55[2];
    assign dep_chan_vld_55_30 = out_chan_dep_vld_vec_55[3];
    assign dep_chan_data_55_30 = out_chan_dep_data_55;
    assign token_55_30 = token_out_vec_55[3];
    assign dep_chan_vld_55_38 = out_chan_dep_vld_vec_55[4];
    assign dep_chan_data_55_38 = out_chan_dep_data_55;
    assign token_55_38 = token_out_vec_55[4];


`include "motion60_shared_hls_deadlock_report_unit.vh"
