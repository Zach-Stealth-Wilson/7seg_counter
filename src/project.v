/*
 * Copyright (c) 2024 Your Name
 * SPDX-License-Identifier: Apache-2.0
 */

`default_nettype none

module tt_um_example (
    input  wire [7:0] ui_in,    // Dedicated inputs
    output wire [7:0] uo_out,   // Dedicated outputs
    input  wire [7:0] uio_in,   // IOs: Input path
    output wire [7:0] uio_out,  // IOs: Output path
    output wire [7:0] uio_oe,   // IOs: Enable path (active high: 0=input, 1=output)
    input  wire       ena,      // always 1 when the design is powered, so you can ignore it
    input  wire       clk,      // clock
    input  wire       rst_n     // reset_n - low to reset
);

  // All output pins must be assigned. If not used, assign to 0.
    reg [7:0] counter_out;
    reg [7:0] next;
    wire [6:0] temp1;
    wire [7:0] temp2;

   // ui_in[0] = 0 = start
   // ui_in[0] = 1 = stop
  
  assign uio_out = 0;
  assign uio_oe  = 0;
  assign temp1 = ui_in[7:1];
  assign temp2 = uio_in;
    
    // Counter flip flop
    always @(posedge clk) begin
        counter_out <= next;
    end    

    assign uo_out = counter_out;

  // List all unused inputs to prevent warnings
    //wire _unused = &{ena, temp1[6], temp1[5], temp1[4], temp1[3], temp1[2], temp1[1], temp1[0], temp2[7], temp2[6], temp2[5], temp2[4], temp2[3], temp2[2], temp2[1], temp2[0], clk};
    wire _unused = &{ena, temp1, temp2};

        always @(*) begin
        if (~rst_n)
            next = 8'h0;
        else if (ui_in[0] == 1'b0)
            next = uo_out + 8'h1;    
        else if (ui_in[0] == 1'b1)
            next = uo_out;
        else
            next = uo_out;
    end

endmodule
