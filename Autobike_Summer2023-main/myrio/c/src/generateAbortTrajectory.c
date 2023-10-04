#include <math.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>

/**
 * Trajectory abort generator
 *
 * Input:
 * @param traj                  Pointer to trajectory reference [X_ref Y_ref Psi_ref]
 * @param X_est                 X position estimated state from kalman filter
 * @param Y_est                 Y position estimated state from kalman filter
 * @param Psi_est               Heading estimated state from kalman filter
 *
 * Output:
 * @param int                   0 for success
 *
 * Parameters:
 * @param rad                   Radius of generated circle
 * @param step                  Distance between points
 * @param N                     Number of steps to calculate
 *
 */

const int rad = 5; // Radius of generated circle
float step = 0.1;
// int N = 100; // Number of steps to calculate

int genAbortTraj(double *X_loc, double *Y_loc, double *Psi_loc, double X_est, double Y_est, double Psi_est, int N)
{
    // This function generates an circle going right from the starting location inputted to the function with radius
    // defined above
    float offset_x = rad * sin(-Psi_est); // Offset between circle center and starting location
    float offset_y = rad * cos(-Psi_est);
    float x_center = X_est + offset_x;
    float y_center = Y_est + offset_y;

    float t = 0;
    for (int i = 0; i < N; i++)
    {

        X_loc[i] = rad * sin(-t + 3.14159 - Psi_est) + x_center; // X-ref generated from circle center
        Y_loc[i] = rad * cos(-t + 3.14159 - Psi_est) + y_center;

        if (i > 0) // Psi_ref needs two values to be calculated, if first loop just set as Psi_est
        {
            Psi_loc[i] = atan2((Y_loc[i] - Y_loc[i - 1]), (X_loc[i] - Y_loc[i - 1]));
        }
        else
            Psi_loc[i] = Psi_est;

        t += step;
    }
    return 0;
}

// psiref=atan2(yref(2:N)-yref(1:N-1),xref(2:N)-xref(1:N-1));
