#include <stdio.h>

// Function to implement the PI controller (it probably won't be used here)
void pi_function(float reference_speed, float measured_speed, float Kp, float Ki, float Tasking_period,
                 float *control_signal)
{
    // Define static variables to store the integral term and previous error
    static float integral_sum = 0.0;
    static float error = 0.0;

    //  in the Labview, the Tasking period is in microseconds, so we convert it to seconds here
    float Tasking_period_s = Tasking_period / 1000000.0;

    // Calculate the current error
    error = reference_speed - measured_speed;

    // Calculate the integral term
    integral_sum += error;

    // Bumpless transfer
    if (Ki == 0.0)
    {
        integral_sum = 0.0;
    }

    // Calculate the control signal (output) using the PI controller formula
    *control_signal = Kp * error + (Ki * integral_sum) * Tasking_period_s;
}

// Function to implement the PD controller (incorrect and not used)
void pd_function(float reference_speed, float measured_speed, float Kp, float Kd, float Tasking_period,
                 float *control_signal)
{
    // Define static variables to store the previous error and previous measured speed
    static float prev_measured_speed = 0.0;
    static float error = 0.0;

    // in the Labview, the Tasking period is in microseconds, so we convert it to seconds here
    Tasking_period = Tasking_period / 1000000.0;

    // Calculate the current error
    error = reference_speed - measured_speed;

    // Calculate the derivative term
    float derivative = measured_speed - prev_measured_speed;

    // Calculate the control signal (output) using the PD controller formula
    *control_signal = Kp * error + (Kd * derivative) / Tasking_period;

    // Update previous measured speed for the next iteration
    prev_measured_speed = measured_speed;
}

/**
 * PI controller
 * Gets the value of the current to send to the motor
 * For safety reasons, this value is limited, right now between 0 and 35A but it should depend on the bike
 *
 * @param[in] Ki
 * @param[in] Kp
 * @param[in] measured_speed (estimated speed of the wheel) [rad/s]
 * @param[in] reference_speed (provided on the Labview front panel) [rad/s]
 *
 * @return control_signal (current) [A]
 * @author Geraldine Doussain
 */
extern float PIcontroller(float Ki, float Kp, float measured_speed, float reference_speed, float Tasking_period)
{
    float control_signal; // Local variable to store the control signal
    // Call the PD controller function to get the control signal
    pi_function(reference_speed, measured_speed, Kp, Ki, Tasking_period, &control_signal);
    if (control_signal > 35.0)
    {
        control_signal = 35.0;
    }
    if (control_signal < 0.0)
    {
        control_signal = 0.0;
    }
    return control_signal;
}
