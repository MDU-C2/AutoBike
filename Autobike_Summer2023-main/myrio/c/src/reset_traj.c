#include <math.h>
#include <stdbool.h>
#include <stdint.h>
#include <stdio.h>

#define RADIUS_OF_THE_EARTH 6371000.0

extern void reset_traj(double *traj, double *traj_init, double reset_traj, double latitude, double longitude, double *size_traj, double reset)
{

        // Unpack the trajectory
    int size_traj = traj_size[0]; // length of the trajectory
    double X_loc[size_traj];
    double Y_loc[size_traj];
    double Psi_loc[size_traj];
    int counter = 0;

    for (int i = 0; i < size_traj; i++)
    {
        if (reset != 0)
        {
        X_loc[counter] = traj[i];
        Y_loc[counter] = traj[i + size_traj];
        Psi_loc[counter] = traj[i + 2 * size_traj];
        }
        else
        {
        X_loc[counter] = traj_init[i];
        Y_loc[counter] = traj_init[i + size_traj];
        Psi_loc[counter] = traj_init[i + 2 * size_traj];
        }
        counter += 1;
    }
;
    if (reset_traj == 1)
    {

        // Transform measurement
        double X_GPS_g = RADIUS_OF_THE_EARTH * longitude;
        double Y_GPS_g = RADIUS_OF_THE_EARTH * latitude;
        
        // Compute correction
        double X_correction = X_GPS_g - X_loc[0];
        double Y_correction = Y_GPS_g - Y_loc[0];

        // Change the trajectory
        for (int i=0; i<size_traj; i++)
        {
            X_loc[i] += X_correction;
            Y_loc[i] += Y_correction;
        }

        // Output the trajectory
        for (int i=0; i < size_traj*3; i++)
        {
            *traj[i] = X_loc[i];
            *traj[i + size_traj] = Y_loc[i];
        }
    }
    else
    {
        for (int i=0; i < size_traj*3; i++)
        {
            *traj[i] = traj[i];
        }
    }
}

