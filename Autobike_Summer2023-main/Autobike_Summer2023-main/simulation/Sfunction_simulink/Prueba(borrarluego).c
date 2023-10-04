
//description: 
//  Inputs
//    Est_States := [X Y psi phi phi_dot delta v] are global at time t 
//    dot_delta_e := effective steering rate
//    y := measurement vector
//    Kalman_gain1 := Computed state_feedback gain including GPS meas
//    Kalman_gain2 := Computed state_feedback gain excluding GPS meas
//    bike_params := vector of bike parameters + gravity
//    Ts := Estimator sampling rate
//    v := constant velocity
//    flag := [0-1] increasing counter reseted at 1. When flag == 0 means
//            that GPS measurement is available
//  Outputs:
//    Est_states : = [X Y psi phi phi_dot delta v] global at time t+1

#include <math.h>
#include <stddef.h>

void Kalman_Filter(double *Est_states, double dot_delta, double *y, double *Kalman_gain1,double *Kalman_gain2, double *bike_params, int flag, double *A_d, 
         double *B_d,double *C1, double *C2, double *D1, double *D2, double lambda, double T)
{
    double Est_States_l[7];
    double y_l[7];
    double raw_acc[3];
    double raw_gyro[3];
    double acc_corr[3];
    double gyro_corr[3];
    double K[7];

    // Transform the states to local frame
    Est_States_l[0] = Est_states[0] * cos(Est_states[2]) + Est_states[1] * sin(Est_states[2]);
    Est_States_l[1] = -Est_states[0] * sin(Est_states[2]) + Est_states[1] * cos(Est_states[2]);
    Est_States_l[2] = 0;
    Est_States_l[3] = Est_states[3];
    Est_States_l[4] = Est_states[4];
    Est_States_l[5] = Est_states[5];
    Est_States_l[6] = Est_states[6];

    // Transform measurements to local frame
    y_l[0] = y[0] * cos(Est_states[2]) + y[1] * sin(Est_states[2]);
    y_l[1] = -y[0] * sin(Est_states[2]) + y[1] * cos(Est_states[2]);
    y_l[2] = y[2];
    y_l[3] = y[3];
    y_l[4] = y[4];
    y_l[5] = y[5] * sin(lambda);
    y_l[6] = y[6];

    // // Correct for parameter values/sensor positions
    // double X_gps_mod = bike_params[0];
    // double Y_gps_mod = bike_params[1];
    // double H_gps_mod = bike_params[2];

    // y_l[0] = y_l[0] - X_gps_mod;
    // y_l[1] = y_l[1] - Y_gps_mod - H_gps_mod * sin(Est_states[3]);

    // // IMU correction
    // raw_acc[0] = 0;
    // raw_acc[1] = y_l[2];
    // raw_acc[2] = 0;
    // raw_gyro[0] = y_l[3];
    // raw_gyro[1] = 0;
    // raw_gyro[2] = y_l[5];

    // // Apply the correction to the accelerometer measurement
    // acc_corr[0] = T * raw_acc[0];
    // acc_corr[1] = T * raw_acc[1];
    // acc_corr[2] = T * raw_acc[2];

    // // Apply the correction to the gyro measurement
    // gyro_corr[0] = T * raw_gyro[0];
    // gyro_corr[1] = T * raw_gyro[1];
    // gyro_corr[2] = T * raw_gyro[2];

    // y_l[2] = acc_corr[1];
    // y_l[3] = gyro_corr[0];
    // y_l[4] = gyro_corr[2];

    // Time update in local frame (from t to t+1)
    int i, j;
    double


}