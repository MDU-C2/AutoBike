#include <stdint.h>

/**
 * Trajectory controller
 *
 * Input:
 * @param traj              Trajectory reference [X_ref Y_ref Psi_ref]
 * @param closest_point     Closest point index in the trajectory
 *
 * Output:
 * @param X_loc             Local X coordinates from reference trajectory
 * @param Y_loc             Local Y coordinates from refence trajectory
 * @param Psi_loc           Local Heading from reference trajectory
 *
 * Parameters:
 * @param Ns                Number of points in the local traj
 */
extern void trajectory_selector(double *traj, int32_t *traj_size_in, double closest_point, int Ns, double reset,
                                double *traj_loc)
{
    static double ids;
    int size_traj = traj_size_in[0]; // length of the trajectory

    // Initialize the variables in first iteration
    if (reset == 0)
    {
        ids = 0;
        closest_point = 1;
    }

    // Calculate the initial point of the local_traj_ref
    ids = ids - 1 + closest_point;

    // Transform the traj matrix into usable information
    double X_traj[size_traj];
    double Y_traj[size_traj];
    double Psi_traj[size_traj];

    for (int j = 0; j < size_traj; j++)
    {
        X_traj[j] = traj[j];
        Y_traj[j] = traj[j + size_traj];
        Psi_traj[j] = traj[j + 2 * size_traj];
    }

    // Select the local_traj from traj
    int M = ids + Ns; // index of the last point of the local trajectort
    int counter = 0;
    double traj_loc_int[3 * Ns];

    if (M < size_traj)
    {
        for (int i = ids - 1; i < ids + Ns; i++)
        {
            traj_loc_int[counter] = X_traj[i];
            traj_loc_int[counter + Ns] = Y_traj[i];
            traj_loc_int[counter + 2 * Ns] = Psi_traj[i];
            counter += 1;
        }
    }
    else
    {
        for (int i = ids - 1; i < size_traj; i++)
        {
            traj_loc_int[counter] = X_traj[i];
            traj_loc_int[counter + Ns] = Y_traj[i];
            traj_loc_int[counter + 2 * Ns] = Psi_traj[i];
            counter += 1;
        }
        for (int i = 0; i < (ids - 1 + Ns) - size_traj; i++)
        {
            // TODO: what happens when we reach the end of the trajectory
            traj_loc_int[counter] = 0;
            traj_loc_int[counter + Ns] = 0;
            traj_loc_int[counter + 2 * Ns] = 0;
            counter += 1;
        }
    }

    for (int i = 0; i < Ns; i++)
    {
        traj_loc[i] = traj_loc_int[i];
    }
}