`timescale 1ns/1ps
`include "digital_clock.v"

module tb_clock_with_reset;

// Outputs
wire [5:0] seconds_out;
wire [5:0] minutes_out;
wire [3:0] hours_out;
wire am_pm_out;
wire [3:0] stopwatch_hours_out;
wire [5:0] stopwatch_minutes_out;
wire [5:0] stopwatch_seconds_out;
wire alarm_ring_out; 

// Inputs
reg Clk_1sec; // Clock with 1 Hz frequency
reg reset_in; // Active high reset
reg set_time_in; // Input 1 to select set time option
reg [3:0] set_hour_in; // Input hour
reg [5:0] set_minute_in; // Input minute
reg set_ampm_in; // 0 for am and 1 for pm
reg [3:0] alarm_hour_in;
reg [5:0] alarm_minute_in;
reg alarm_ampm_in; // 0 for am and 1 for pm
reg stopwatch_on_in;
reg stopwatch_reset_in;

digital_clock dc(
    seconds_out,
    minutes_out,
    hours_out,
    am_pm_out,
    stopwatch_hours_out,
    stopwatch_minutes_out,
    stopwatch_seconds_out,
    alarm_ring_out, 
    Clk_1sec, 
    reset_in, 
    set_time_in, 
    set_hour_in, 
    set_minute_in, 
    set_ampm_in,
    alarm_hour_in,
    alarm_minute_in,
    alarm_ampm_in, 
    stopwatch_on_in,
    stopwatch_reset_in
); 

initial begin
    #0 Clk_1sec = 1;
    forever #0.5 Clk_1sec = ~Clk_1sec;
end

initial begin
    $dumpfile("clock_with_reset.vcd");
    $dumpvars(0, tb_clock_with_reset);

    #0 
    set_time_in = 1;
    set_minute_in = 58;
    set_hour_in = 3;
    set_ampm_in = 1;
    #0.1 
    set_time_in = 0;
    #9.9 
    reset_in = 1;
    #0.1 
    reset_in = 0;
    #200
    $finish;
end

endmodule