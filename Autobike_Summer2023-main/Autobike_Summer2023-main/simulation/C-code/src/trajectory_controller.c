#include <math.h>
#include <stdbool.h>
#include <stdint.h>
#include <stdio.h>

#define g 9.81

/**
 * Trajectory controller
 *
 * Input:
 * @param traj                  Trajectory reference [X_ref Y_ref Psi_ref]
 * @param X_est                 X position estimated state from kalman filter
 * @param Y_est                 Y position estimated state from kalman filter
 * @param Psi_est               Heading estimated state from kalman filter
 *
 * Output:
 * @param Roll_ref                Roll reference fot the balance control
 * @param closestpoint_idx_out
 *
 * Parameters:
 * @param bike_params             Gravity parameter     [g lr lf lambda]
 * @param traj_params             Trajectory parameters [k1 k2 e1_max]
 * @param v                       Velocity
 * @param Ad_t
 * @param Bd_t
 * @param C_t
 * @param D_t
 *
 */

// sign value for double
double sign(double value)
{
    if (value > 0.0)
    {
        return 1;
    }
    else if (value < 0.0)
    {
        return -1;
    }
    else
    {
        return 0;
    }
}

// Min function for double
double min(double a, double b)
{
    if (a < b)
    {
        return a;
    }
    else
    {
        return b;
    }
}

// Modulo function (remainder of a division)
double mod(double a, double b)
{
    double quotient = a / b;
    double quotient_floor = floor(quotient);
    double remainder = a - quotient_floor * b;
    return remainder;
}

// Wrap angle between pi and -pi
double wrap_angle(double angle)
{
    double wrapped_angle = fmod(angle + M_PI, 2 * M_PI);
    if (wrapped_angle < 0)
    {
        wrapped_angle += 2 * M_PI;
    }
    return wrapped_angle - M_PI;
}

extern void trajectory_controller(double *traj, int32_t *traj_size, double X_est, double Y_est, double Psi_est,
                                  double v, double lr, double lf, double lambda, double k1, double k2, double e1_max,
                                  double Ad_t, double Bd_t, double C_t, double D_t, double *roll_ref, int32_t *closestpoint_idx_out,
                                  double *e1_out, double *e2_out, double *delta_ref_psi_out, double *lat_err_cont, double *head_err_cont, double reset)
{
    // Unpack the trajectory
    int size_traj = traj_size[0]; // length of the trajectory
    double X_loc[size_traj];
    double Y_loc[size_traj];
    double Psi_loc[size_traj];
    int counter = 0;

    for (int i = 0; i < size_traj; i++)
    {
        X_loc[counter] = traj[i];
        Y_loc[counter] = traj[i + size_traj];
        Psi_loc[counter] = traj[i + 2 * size_traj];
        counter += 1;
    }

    // Second point in traj is current selected closest point
    static int closestpoint_idx;
    if (reset == 0)
    {
        closestpoint_idx = 1;
        *closestpoint_idx_out = 0;
    }

    // Search for closest point (find the closest point going forward, stop when distance increases)
    while (pow(X_loc[closestpoint_idx] - X_est, 2.0) + pow(Y_loc[closestpoint_idx] - Y_est, 2.0) >=
           pow(X_loc[closestpoint_idx + 1] - X_est, 2.0) + pow(Y_loc[closestpoint_idx + 1] - Y_est, 2.0) &&
           closestpoint_idx <= size_traj - 3)
    {
        closestpoint_idx += 1;
        // closestpoint_idx = 5;
    }

    // select same closest point for heading and position error
    int closestpoint_heading_idx = closestpoint_idx;

    // Compute X and Y distance from current location to selected closest point
    double dx, dy;
    dx = X_est - X_loc[closestpoint_idx];
    dy = Y_est - Y_loc[closestpoint_idx];

    // Compute difference from current heading and heading reference points
    double D_psiref = Psi_loc[closestpoint_idx + 1] - Psi_loc[closestpoint_idx];

    // Limit D_psiref between -pi and pi
    if (D_psiref >= M_PI)
    {
        D_psiref = mod(D_psiref, -2 * M_PI);
    }
    if (D_psiref <= -M_PI)
    {
        D_psiref = mod(D_psiref, 2 * M_PI);
    }

    // Interpolation algorithm (IMPROVEMENT)
    // Compute distance between point before closespoint and current location
    double dis_true_previous =
        sqrt(pow(X_loc[closestpoint_idx - 1] - X_est, 2.0) + pow(Y_loc[closestpoint_idx - 1] - Y_est, 2.0));
    // Angle of line between previous closestpoint and current location
    double alpha_star = atan((Y_loc[closestpoint_idx - 1] - Y_est) / (X_loc[closestpoint_idx - 1] - X_est));
    // heading of previous closestpoint - alpha_star
    double alpha_projected_dist = alpha_star - Psi_loc[closestpoint_idx];
    // Distance from previous closestpoint to the projection of the bike in the trajectory
    double projected_dist = fabs(dis_true_previous * cos(alpha_projected_dist));
    double compared_dist = sqrt(pow(X_loc[closestpoint_idx] - X_loc[closestpoint_idx - 1], 2.0) +
                                pow(Y_loc[closestpoint_idx] - Y_loc[closestpoint_idx - 1], 2.0));

    // When bike passses the closestpoint, heading from next point is taken
    if (projected_dist >= compared_dist)
    {
        closestpoint_heading_idx = closestpoint_idx + 1;
    }

    // Compute e1 and e2
    double e1 = dy * cos(Psi_loc[closestpoint_heading_idx]) - dx * sin(Psi_loc[closestpoint_heading_idx]);
    double e2 = Psi_est - Psi_loc[closestpoint_heading_idx];

    // Closestpoint in the local trajectory
    double ref_X = X_loc[closestpoint_idx];
    double ref_Y = Y_loc[closestpoint_idx];
    double ref_Psi = Psi_loc[closestpoint_heading_idx];

    // Keep heading error between -pi and pi
    e2 = wrap_angle(e2);

    // Compute time between psiref(idx) and psiref(idx+1)
    double dX = X_loc[closestpoint_idx + 1] - ref_X;
    double dY = Y_loc[closestpoint_idx + 1] - ref_Y;

    double dis = sqrt(pow(dX, 2.0) + pow(dY, 2.0));
    double Ts_psi = dis / v;

    // Sample dpsiref
    double dpsiref = D_psiref / Ts_psi;

    // // Reset closespoint index as feedback for local selection
    // *closestpoint_idx_out = 0;
    *closestpoint_idx_out = closestpoint_idx;

    // Steering contribution from trajectory error
    double delta_ref_error = -k1 * sign(e1) * min(fabs(e1), e1_max) - k2 * e2;

    // Steering contribution from heading change
    static double x = 0;
    double x_dot = 0;

    x_dot = Ad_t * x + Bd_t * dpsiref;
    double delta_ref_psi = C_t * x + D_t * dpsiref;

    x = x_dot;

    // Total steering reference
    double delta_ref = delta_ref_psi + delta_ref_error;

    // Limit steer angle reference between -pi/4 and pi/4
    if (delta_ref >= M_PI / 4)
    {
        delta_ref = M_PI / 4;
    }
    if (delta_ref <= -M_PI / 4)
    {
        delta_ref = -M_PI / 4;
    }

    // Transform steering reference into roll reference for the balance control
    double eff_delta_ref = delta_ref * sin(lambda);
    *roll_ref = -1 * atan(tan(eff_delta_ref) * (pow(v, 2.0) / (lr + lf)) / g);

    // // Constant roll ref to make a circle when we get close to the end of the trajectory
    // if (closestpoint_idx > size_traj-10)
    // {
    //     *roll_ref = 0;
    // }

    // Output different variables that will give us important info for validation
    *e1_out = e1;
    *e2_out = e2;
    *delta_ref_psi_out = delta_ref_psi;
    *lat_err_cont = -k1 * sign(e1) * min(fabs(e1), e1_max);
    *head_err_cont = - k2 * e2;
}
