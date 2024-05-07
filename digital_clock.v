module digital_clock(
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

// Outputs
output [5:0] seconds_out;
output [5:0] minutes_out;
output [3:0] hours_out;
output am_pm_out;
output [3:0] stopwatch_hours_out;
output [5:0] stopwatch_minutes_out;
output [5:0] stopwatch_seconds_out;
output alarm_ring_out; 

// Inputs
input Clk_1sec; // Clock with 1 Hz frequency
input reset_in; // Active high reset
input set_time_in; // Input 1 to select set time option
input [3:0] set_hour_in; // Input hour
input [5:0] set_minute_in; // Input minute
input set_ampm_in; // 0 for am and 1 for pm
input [3:0] alarm_hour_in;
input [5:0] alarm_minute_in;
input alarm_ampm_in; // 0 for am and 1 for pm
input stopwatch_on_in;
input stopwatch_reset_in;

// Internal variables.
reg [5:0] seconds_out;
reg [5:0] minutes_out;
reg [3:0] hours_out;
reg am_pm_out;
reg [3:0] stopwatch_hours_out;
reg [5:0] stopwatch_minutes_out;
reg [5:0] stopwatch_seconds_out;
reg alarm_ring_out = 0;

// Execute the always blocks when the Clock or reset inputs are changing from 0 to 1 (positive edge of the signal)
always @ (posedge(Clk_1sec), posedge(reset_in), posedge(set_time_in)) begin
    
    if (reset_in) begin // Check for active high reset and reset the time.
        seconds_out = 0;
        minutes_out = 0;
        hours_out = 12;
        am_pm_out = 0; 
    end
    
    else if (set_time_in) begin // Set time manually
        seconds_out = 0;
        minutes_out = set_minute_in;
        hours_out = set_hour_in;
        am_pm_out = set_ampm_in; 
    end
    
    else if (Clk_1sec) begin // At the beginning of each second
        seconds_out = seconds_out + 1; // Increment sec
        if (seconds_out == 60) begin // Check for max value of sec
            seconds_out = 0; // Reset seconds
            minutes_out = minutes_out + 1; // Increment minutes
            if (minutes_out == 60) begin // Check for max value of min
                minutes_out = 0; // Reset minutes
                hours_out = hours_out + 1; // Increment hours
                if (hours_out == 12) begin // Check for max value of hours
                    am_pm_out = ~am_pm_out; // Toggle am_pm
                end
                else if (hours_out == 13) begin
                    hours_out = 1;
                end
            end
        end
        alarm_ring_out = !((hours_out^alarm_hour_in) | (minutes_out^alarm_minute_in) | (am_pm_out^alarm_ampm_in)); // Compare alarm time with present time
    end

end

always @ (posedge(Clk_1sec), posedge(stopwatch_reset_in)) begin

    if (stopwatch_reset_in) begin // Check for active high reset and reset the time.
        stopwatch_seconds_out = 0;
        stopwatch_minutes_out = 0;
        stopwatch_hours_out = 0; 
    end
            
    else if (stopwatch_on_in) begin // At the beginning of each second
        stopwatch_seconds_out = stopwatch_seconds_out + 1;
        // Increment sec
        if (stopwatch_seconds_out == 60) begin // Check for max value of sec
            stopwatch_seconds_out = 0; // Reset seconds
            stopwatch_minutes_out = stopwatch_minutes_out + 1;
            // Increment minutes
            if (stopwatch_minutes_out == 60) begin // Check for max value of min
                stopwatch_minutes_out = 0; // Reset minutes
                stopwatch_hours_out = stopwatch_hours_out + 1;
                // Increment hours
                if (stopwatch_hours_out == 24) begin // Check for max value of hours
                    stopwatch_hours_out = 0; // Reset hours
                end
            end
        end
    end
end

endmodule
