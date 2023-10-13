#include <stdio.h>

#define PID_SET_REFERENCE 'R'
#define PID_SET_P 'P'
#define PID_SET_I 'I'
#define PID_SET_D 'D'
#define PID_GET_REFERENCE 'r'
#define PID_GET_P 'p'
#define PID_GET_I 'i'
#define PID_GET_D 'd'

float PID(float input, char usageMode) {
  static float reference;
  static float P = 1;
  static float I = 0;
  static float D = 0;
  static double errorSum = 0;
  static float lastError = 0; /* Is it better to use input - lastInput instead of error - lastError? */

  
  switch(usageMode) {
  case 'R':
    reference = input;
    return reference;
    
  case 'P':
    P = input;
    return P;

  case 'I':
    I = input;
    return I;

  case 'D':
    D = input;
    return D;
    
  case 'r':
    return reference;
  case 'p':
    return P;
  case 'i':
    return I;
  case 'd':
    return D;
  case 's':
    return errorSum;
  case 'l':
    return lastError;
  }
  
  float error = reference - input;
  errorSum += error;
  float errorChange = error - lastError;

  return P * error + I * errorSum + D * errorChange;
}


/* int main(void) { */
/*   /\* printf("%f\n", PID(1,0,1)); *\/ */
/*   /\* printf("%f\n", PID(1,'P',1)); *\/ */
/*   /\* printf("%f\n", PID(1,0,1)); *\/ */
/*   /\* printf("%f\n", PID(2,'I',1)); *\/ */
/*   /\* printf("%f\n", PID(1,0,1)); *\/ */
/*   /\* printf("%f\n", PID(3,'D',1)); *\/ */
/*   /\* printf("%f\n", PID(1,0,1)); *\/ */
/*   printf("P: %f I: %f D: %f\n", PID(0,'p'), PID(0,'i'), PID(0,'d')); */
/* } */
