module blcok_mem_ddr (
           input  clk,

           output reg app_wdf_rdy,
           output reg app_rdy,

           input [27:0]  app_addr,
           input [2:0]   app_cmd,
           input app_en,


           input [511:0] app_wdf_data,
           input [63:0]  app_wdf_mask,
           input app_wdf_wren,
           input app_wdf_end,

           output [511:0] app_rd_data,
           output app_rd_data_end,
           output reg app_rd_data_valid
       );
    parameter[3:0] WAIT = 3'b000;
    parameter[3:0] WAIT_READ = 3'b001;
    reg[3:0] state;
    reg app_en_r;
    always @(posedge clk)
        app_en_r <= app_en;

    always @(posedge clk)
    begin
        case (state)
            WAIT:
            begin
                app_rd_data_valid <= 1'b0;
                app_wdf_rdy <= 1'b1;
                app_rdy <= 1'b1;
                if(app_cmd[0] == 1'b0 & app_en)
                begin
                    app_wdf_rdy <= 1'b0;
                    app_rdy <= 1'b0;

                    state <= WAIT_READ;
                end
            end

            WAIT_READ:
            begin
                app_wdf_rdy <= 1'b1;
                app_rdy <= 1'b1;
                app_rd_data_valid <= 1'b1;
                state <= WAIT;
            end
            default
            begin
                state <= WAIT;
            end

        endcase
    end

    blk_mem_512b_dep1024 blk_mem_512b_dep1024(
                            .clka(clk),
                            .rsta (1'b0),

                            .ena (app_en | app_en_r), //因为读有延迟所以至少要延迟两拍
                            .wea(app_cmd[0] & app_en &app_wdf_wren),   //write enable
                            .dina(app_wdf_data),  //i_511:0

                            .addra(app_addr[12:3]), //i_9:0
                            .douta(app_rd_data) //o_511:0
                        );
endmodule //blcok_mem_ddr