#ifndef traj_sel
#define traj_sel
#include <stdint.h>

// Functions
void trajectory_selector(double *traj, int32_t *traj_size_in, double closest_point, int Ns, double reset, double *X_loc,
                         double *Y_loc, double *Psi_loc, double X_est, double Y_est, double Psi_est, int abort);

#endif