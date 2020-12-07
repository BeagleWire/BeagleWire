module top (input         clk,
            inout  [15:0] gpmc_ad,
            input         gpmc_advn,
            input         gpmc_csn1,
            input         gpmc_wein,
            input         gpmc_oen,
            input         gpmc_clk,

            output [7:0]   pmod1,
            output [7:0]   pmod2,
            output [7:0]   pmod3,
            output [7:0]   pmod4,
            output [3:0]   led,
            output [7:0]   gr,

            output [12:0] sdram_addr,
            inout  [7:0]  sdram_data,
            output [1:0]  sdram_bank,

            output        sdram_clk,
            output        sdram_cke,
            output        sdram_we,
            output        sdram_cs,
            output        sdram_dqm,
            output        sdram_ras,
            output        sdram_cas);

parameter ADDR_WIDTH = 5;
parameter DATA_WIDTH = 16;
parameter RAM_DEPTH = 1 << ADDR_WIDTH;

reg [DATA_WIDTH-1:0] mem [0:RAM_DEPTH];

reg oe;
reg we;
reg cs;
wire[ADDR_WIDTH-1:0]  addr;
reg [DATA_WIDTH-1:0]  data_out;
wire [DATA_WIDTH-1:0]  data_in;

always @ (posedge clk)
begin
    if (!cs && !we && oe) begin
        mem[addr] <= data_out;
    end
end

always @ (posedge clk)
begin
    if (!cs && we && !oe) begin
        data_in <= mem[addr];
    end else begin
        data_in <= 0;
    end
end

gpmc_sync #(
    .DATA_WIDTH(DATA_WIDTH),
    .ADDR_WIDTH(ADDR_WIDTH))
gpmc_controller (
    .clk(clk),

    .gpmc_ad(gpmc_ad),
    .gpmc_advn(gpmc_advn),
    .gpmc_csn1(gpmc_csn1),
    .gpmc_wein(gpmc_wein),
    .gpmc_oen(gpmc_oen),
    .gpmc_clk(gpmc_clk),

    .oe(oe),
    .we(we),
    .cs(cs),
    .address(addr),
    .data_out(data_out),
    .data_in(data_in),
);

assign pmod1 = mem[0][7:0];
assign pmod2 = mem[0][15:8];
assign pmod3 = mem[1][7:0];
assign pmod4 = mem[1][15:8];
assign gr    = mem[2][7:0];
assign led   = mem[2][11:8];
/* 
assign sdram_clk = clk;

wire [24:0] sd_addr;
wire [7:0]  sd_rd_data;
wire [7:0]  sd_wr_data;
wire        sd_wr_enable;
wire        sd_rd_enable;
wire        sd_busy;
wire        sd_rd_ready; 
wire        sd_rst;

assign sd_addr[15:0]  = mem[1];
assign sd_addr[24:16] = mem[2][8:0];
assign sd_wr_data     = mem[3][7:0];

assign sd_wr_enable = mem[0][3];
assign sd_rd_enable = mem[0][2];
assign sd_rst       = mem[0][0];

sdram_controller sdram_controller_1 (
    .wr_addr(sd_addr),
    .wr_enable(sd_wr_enable),
    .wr_data(sd_wr_data),

    .rd_addr(sd_addr),
    .rd_enable(sd_rd_enable),
    .rd_data(sd_rd_data),
    .rd_ready(sd_rd_ready),
    .busy(sd_busy),
    
    .clk(clk),
    .rst_n(sd_rst),
    
    .addr(sdram_addr),
    .bank_addr(sdram_bank),
    .data(sdram_data),
    .clock_enable(sdram_cke),
    .cs_n(sdram_cs),
    .ras_n(sdram_ras),
    .cas_n(sdram_cas),
    .we_n(sdram_we),
    .data_mask(sdram_dqm)
);
*/
endmodule
