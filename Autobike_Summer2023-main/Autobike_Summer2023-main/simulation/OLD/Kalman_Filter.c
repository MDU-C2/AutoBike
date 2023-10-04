#include <stdio.h>
#include <stdbool.h>
#include <math.h>
#include <stdint.h>

#define RADIUS_OF_THE_EARTH 6371000.0

/**
 * State estimator using a Kalman filter
 * 
 * Estimated states output
 * @param X             State variable -  X position [m]
 * @param Y             State variable - Y position [m]
 * @param Psi           State variable - track/yaw angle [rad]
 * @param roll          State variable - roll angle [rad]
 * @param rollRate      State variable - time derivative of roll angle [rad/s]
 * @param delta         State variable - Steering [rad]
 * @param v             State variable - Speed [m/s]
 * 
 * Input:
 * @param dot_delta     Input of the model
 * 
 * Measurements:
 * @param y[0]      GPS latitude [rad]
 * @param longitude     GPS longitude [rad]
 * @param a_y           Accelerometer Y value [m/s²]
 * @param w_x           Accelerometer roll rate (around X axis) [rad/s]
 * @param w_z           Accelerometer around Z axis value [rad/s]
 * @param delta_enc     Encoder steering value [rad]
 * @param speed         Approximative current speed of bike, e.g. reference speed [m/s]
 * 
 * Parameters: 
 * @param Kalman_Gain   Kalman gain including GPS measurements
 * @param A_d           Discrete linear bike model (A matrix)
 * @param B_d           Discrete linear bike model (B matrix)
 * @param C             Measurement model (C matrix) when GPS meas
 * @param D             Measurement model (D matrix) when GPS meas
 * @param Ts            Time step [s]
 * 
 */


// extern void update_pointer(double *estimatedStatesOutput, int32_t k, double y)
// {
//     static double currentState[7];

//     if (k == 0) {
//         for (int i = 0; i < 7; i++) {
//             currentState[i] = 0;
//         }
//     }

//     double K = 1;
//     double C = 1;

//     currentState[0] += K*(C*currentState[0] - y);

//     *estimatedStatesOutput = currentState[0];
// }


/**
 * Sets *value to *lastValue if *value is NaN.
 * Otherwise *lastValue is set to *value.
 * 
 * @param value Current value
 * @param lastValue The last known good value
 * 
*/
static void useLastValueIfNaN(double *value, double *lastValue)
{
    if (isnan(*value))
    {
        *value = *lastValue;
    }
    else
    {
        *lastValue = *value;
    }
}

// Generate the matrices due to Labview
extern void transform_mat(double *input, double (*matrix)[7]) {
    for (int i = 0; i < 7; i++) {
        for (int j = 0; j < 7; j++) {
            matrix[i][j] = input[7*i + j];
        }
    }
}

// Transform the GPS measurement (longitude/latitude) into X/Y measurement
extern void transform_latlog_to_XY_l(double longitude, double latitude, double* X_GPS, double* Y_GPS, double Est_States[7], double GPSflag)
{
    static bool initializedLatLon = false;
    static double latitude0, longitude0;
    static double lastLatitude = NAN;
    static double lastLongitude = NAN;
    // X and Y pos from GPS in global frame
    double X_GPS_g = 0;
    double Y_GPS_g = 0; 

    useLastValueIfNaN(&latitude, &lastLatitude);
    useLastValueIfNaN(&longitude, &lastLongitude);

    if (!initializedLatLon && !isnan(latitude) && !isnan(longitude) && GPSflag != 0)
    {
        latitude0 = latitude;
        longitude0 = longitude;

        initializedLatLon = true;
    }
    if (initializedLatLon)  
    {
        X_GPS_g = RADIUS_OF_THE_EARTH * (longitude - longitude0) * cos(latitude0);
        Y_GPS_g = RADIUS_OF_THE_EARTH * (latitude - latitude0);
    }

    // Transform to local
    *X_GPS = X_GPS_g * cos(Est_States[2]) + Y_GPS_g * sin(Est_States[2]);
    *Y_GPS = -X_GPS_g * sin(Est_States[2]) + Y_GPS_g * cos(Est_States[2]);
    // *X_GPS = X_GPS_g;
    // *Y_GPS = Y_GPS_g;
}

// Transform from global to local frame
extern void transform_global_to_local(double Est_States[7], double Est_States_l[7])
{
    Est_States_l[0] = Est_States[0] * cos(Est_States[2]) + Est_States[1] * sin(Est_States[2]);
    Est_States_l[1] = -Est_States[0] * sin(Est_States[2]) + Est_States[1] * cos(Est_States[2]);
    Est_States_l[2] = 0;
    Est_States_l[3] = Est_States[3];
    Est_States_l[4] = Est_States[4];
    Est_States_l[5] = Est_States[5];
    Est_States_l[6] = Est_States[6];
}

// Transform from global to local frame
extern void transform_local_to_global(double Est_states_l[7], double Est_States[7], double Est_states[7])
{

    Est_states[0] = Est_states_l[0] * cos(Est_States[2]) - Est_states_l[1] * sin(Est_States[2]);
    Est_states[1] = Est_states_l[0] * sin(Est_States[2]) + Est_states_l[1] * cos(Est_States[2]);
    Est_states[2] = Est_states_l[2] + Est_States[2];
    Est_states[3] = Est_states_l[3];
    Est_states[4] = Est_states_l[4];
    Est_states[5] = Est_states_l[5];
    Est_states[6] = Est_states_l[6];
}

// Time update from t-1 to t
extern void time_update(double Est_States_l[7], double dot_delta, double (*A_d)[7], double B_d[7],double Est_States_l_1[7])
{
    double result1[7] = {0,0,0,0,0,0,0};
    double result2[7] = {0,0,0,0,0,0,0};

    // A_d*x
    for (int i = 0; i < 7; i++)
    {
        for (int j = 0; j < 7; j++)
        {
            result1[i] += A_d[i][j] * Est_States_l[j];
        }
    }

    // B_d*u
    for(int k = 0; k < 7; k++)
    {
        result2[k] = B_d[k] * (dot_delta)  ;
    }

    // Time update
    for(int h = 0; h < 7; h++) 
    {
        Est_States_l_1[h] = result1[h] + result2[h];
    }
   
}

// Measurement update using the sensor data at time t
extern void measurement_update(double Est_States_l_1[7], double dot_delta, double y[7], double (*Kalman_Gain)[7], double (*C)[7], double D[7], double Est_states_l[7], double GPSflag)
{
    double y_pred[7] = {0,0,0,0,0,0,0};
    double result1[7] = {0,0,0,0,0,0,0};
    double result2[7] = {0,0,0,0,0,0,0};
    double result3 = 0;
    static double GPSflag_1 = 0;

    // TODO: THINK ABOUT HOW TO DIFFERENCIATE SAMPLING RATES HERE
    // Est_states_l = Est_States_l;
    GPSflag = 0;

    if (GPSflag_1 == GPSflag) // Update w/out GPS
    {
        // CGPS*x
        for (int i = 2; i < 7; i++)
        {
            for (int j = 3; j < 7; j++)
            {
                result1[i] += C[i][j] * Est_States_l_1[j];
            }
        }
        // DGPS*u
        for(int k = 2; k < 7; k++)
        {
            result2[k] = D[k] * (dot_delta)  ;
        } 
        // y_predGPS = CGPS * Est_States_l + DGPS * dot_delta;
        for(int h = 2; h < 7; h++) 
        {
            y_pred[h] = result1[h] + result2[h];
        }
        // Measurement update w/out GPS
        for (int z = 3; z < 7; z++)
        {
        result3 = 0;
            for (int l = 2; l < 7; l++)
            {
                result3 += Kalman_Gain[z][l] * (y[l] - y_pred[l]);
            }
        Est_states_l[z] = Est_States_l_1[z] + result3;
        }
        Est_states_l[0] = Est_States_l_1[0];
        Est_states_l[1] = Est_States_l_1[1];
        Est_states_l[2] = Est_States_l_1[2];
    }
    else // update with GPS
    {
        // C*x
        for (int i = 0; i < 7; i++)
        {
            for (int j = 0; j < 7; j++)
            {
                result1[i] += C[i][j] * Est_States_l_1[j];
            }
        } 
        // D*u
        for(int k = 0; k < 7; k++)
        {
            result2[k] = D[k] * (dot_delta)  ;
        } 
        // y_pred = C1 * Est_States_l + D1 * dot_delta;
        for(int h = 0; h < 7; h++) 
        {
            y_pred[h] = result1[h] + result2[h];
        }
        // Measurement update
        for (int z = 0; z < 7; z++)
        {
        result3 = 0;
            for (int l = 0; l < 7; l++)
            {
                result3 += Kalman_Gain[z][l] * (y[l] - y_pred[l]);
            }
        Est_states_l[z] = Est_States_l_1[z] + result3;
        }
    }

    // Set the actual flag to previous flag for next iteration
    GPSflag_1 = GPSflag;

    // // C1*x
    // for (int i = 0; i < 7; i++)
    // {
    //     for (int j = 0; j < 7; j++)
    //     {
    //         result1[i] += C[i][j] * Est_States_l_1[j];
    //     }
    // }

    // // D1*u
    // for(int k = 0; k < 7; k++)
    // {
    //     result2[k] = D[k] * (dot_delta)  ;
    // }

    // // y_pred = C1 * Est_States_l + D1 * dot_delta;
    // for(int h = 0; h < 7; h++) 
    // {
    //     y_pred[h] = result1[h] + result2[h];
    // }

    // // Measurement update
    // for (int z = 0; z < 7; z++)
    // {
    //     result3 = 0;
    //     for(int l = 0; l < 7; l++)
    //     {
    //         result3 += Kalman_Gain[z][l] * (y[l] - y_pred[l]);
    //     }
    //     Est_states_l[z] = Est_States_l_1[z] + result3;
    // }

}


// Main function
extern void Kalman_filter(double* X, double* Y, double* Psi, double* roll, double* rollRate, double* delta, double* v, 
                          double dot_delta, double latitude, double longitude, double a_y, double w_x,
                          double w_z, double delta_enc, double speed, double *Kalman_Gain_flat, double *A_d_flat,
                          double *B_d, double *C_flat, double *D, double reset, double GPSflag, double *init)
{

    static double Est_States[7];        //Global frame t-1
    static double Est_States_l[7];      //Local frame t-1
    static double Est_States_l_1[7];    //Local frame after time update
    static double Est_states_l[7];      //Local frame after meas update
    static double Est_states[7];        // Global frame estimation of t
    double y[7];

    // Reset the state variables
    if (reset == 0) {
        for (int h = 0; h < 7; h++) {
            Est_States[h] = 0;
            Est_States_l[h] = 0;
            Est_States_l_1[h]=0;
            Est_states_l[h] = 0;
            Est_states[h] = init[h];
        }
    }


    // Initialize the states vector at time t-1
    for (int i = 0; i < 7; i++)
    {
        Est_States[i] = Est_states[i];
    }
        

    // Generate the matrices
    double Kalman_Gain[7][7];
    double A_d[7][7];  
    double C[7][7];  
  

    transform_mat(Kalman_Gain_flat, Kalman_Gain);
    transform_mat(A_d_flat, A_d);
    transform_mat(C_flat, C);

    // 1. Transformation of states at time t-1 and measurements at time t into local frame
    transform_global_to_local(Est_States, Est_States_l);
        //      for (int j = 0; j < 7; j++)
        // {
        //     Est_states_l[j] = Est_States[j];
        // }
    

    // 2. Time update
    time_update(Est_States_l, dot_delta, A_d, B_d,Est_States_l_1);

    // 3. Measurement update 
    // Transform the GPS lat/long into X/Y measurements
    double X_GPS;
    double Y_GPS;

    transform_latlog_to_XY_l(longitude, latitude, &X_GPS, &Y_GPS, Est_States, GPSflag);

        // Wrap the measurements into an array:
    y[0] = X_GPS;
    y[1] = Y_GPS;
    y[2] = a_y;
    y[3] = w_x;
    y[4] = w_z;
    y[5] = delta_enc;
    y[6] = speed;

        // Update
    measurement_update(Est_States_l_1, dot_delta, y, Kalman_Gain, C, D, Est_states_l, GPSflag);
    //  for (int j = 0; j < 7; j++)
    // {
    // Est_states_l[j] = Est_States_l_1[j];
    // }

    // 4. Transform estimated states at time t to global frame
    transform_local_to_global(Est_states_l, Est_States, Est_states);

    //Output the estimated states
    *X = Est_states[0];
    *Y = Est_states[1];
    *Psi = Est_states[2];
    *roll = Est_states[3];
    *rollRate = Est_states[4];
    *delta = Est_states[5];
    *v = Est_states[6];

    // *X = reset;
    // *Y = GPSflag;
    // *Psi = 0;
    // *roll = 0;
    // *rollRate = 0;
    // *delta = 0;
    // *v = 0;

 }

