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
    reg [3:0] digit;
    wire[6:0] led_out;
    assign uio_out[6:0] = led_out;
    assign uio_out[7] = 1'b0;

   // ui_in[0] = 0 = start
   // ui_in[0] = 1 = stop
  
  //assign enable paths uio_oe to outputs
  assign uio_oe  = 8'b11111111;

  // assign unused inputs  
  assign temp1 = ui_in[7:1];
  assign temp2 = uio_in;
    
    // Counter flip flop
    always @(posedge clk) begin
        counter_out <= next;
    end    

    assign uo_out = counter_out;

  // List all unused inputs to prevent warnings
    wire _unused = &{ena, temp1, temp2};

    always @(*) begin
        digit = 4'h0;
         next = 8'h0;
        if (~rst_n) begin
            digit = 4'h0;
            next = 8'h0;
        end else if (ui_in[0] == 1'b0) begin
            digit = digit + 1'b1;
            next = uo_out + 8'h1;
        end else if (ui_in[0] == 1'b1) begin
            next = uo_out;
        end else begin 
            next = uo_out;
        end
    end
    
    //instatiate 7seg display
    seg7 seg7(.counter(digit), .segments(led_out));
endmodule
