#include <stdio.h>
#include <stdlib.h>
#include <math.h>
//#include "../src/kalman_filter.c"

int main() {
    double X = 0;
    double Y = 0;
    double Psi = 0;
    double roll = 0;
    double rollRate = 0;
    double delta = 0;
    double v = 0;

    double dot_delta = 1;
    double latitude = 0;
    double longitude = 0;
    double a_y= 0;
    double w_x= 0;
    double w_z= 0;
    double delta_enc= 0;
    double speed= 0;
    // double *Kalman_Gain = malloc(7*7 * sizeof(*Kalman_Gain));
    // double *A_d = malloc(7* 7 * sizeof(*A_d));
    // double *B_d = malloc(7 * sizeof(*B_d));
    // double *C = malloc(7* 7 * sizeof(*C));
    // double *D = malloc(7 * sizeof(*D));
    double reset = 0;

    // for (int i = 0; i < 7; i++){

    //     B_d[i] = 0;
    //     D[i] = 0;
    //     for (int h = 0; h < 7; h++){
    //         A_d[7*i+h] = 0;
    //         C[7*i+h] = 0; 
    //         Kalman_Gain[7*i+h] = 0;
    //     }

    // }

    double Est_States[7] = {1,1,1,1,1,1,1};
    double Est_states_l_1[7] = {1.381773,-0.301169,0,1,1,1,1};
    double Est_states_l[7];


    double y_pred[7] = {0,0,0,0,0,0,0};
    double result1[7] = {0,0,0,0,0,0,0};
    double result2[7] = {0,0,0,0,0,0,0};
    double result3;
    static double GPSflag_1 = 0;

    // TODO: THINK ABOUT HOW TO DIFFERENCIATE SAMPLING RATES HERE
    // Est_states_l = Est_States_l;

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
    
    printf("X: %f",Est_states[0]);
    printf("Y: %f",Est_states[1]);
    printf("Psi: %f",Est_states[2]);
    printf("Roll: %f",Est_states[3]);
    printf("RollRate: %f",Est_states[4]);
    printf("Delta: %f",Est_states[5]);
    printf("vel: %f\n",Est_states[6]);
}
