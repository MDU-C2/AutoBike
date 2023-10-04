/*
 * State_sf.h
 *
 * Prerelease License - for engineering feedback and testing purposes
 * only. Not for sale.
 *
 * Code generation for model "State_sf".
 *
 * Model version              : 3.201
 * Simulink Coder version : 9.8 (R2022b) 13-May-2022
 * C source code generated on : Mon Mar 20 13:49:21 2023
 *
 * Target selection: rtwsfcn.tlc
 * Note: GRT includes extra infrastructure and instrumentation for prototyping
 * Embedded hardware selection: Intel->x86-64 (Windows64)
 * Code generation objective: Execution efficiency
 * Validation result: Not run
 */

#ifndef RTW_HEADER_State_sf_h_
#define RTW_HEADER_State_sf_h_
#ifndef State_sf_COMMON_INCLUDES_
#define State_sf_COMMON_INCLUDES_
#include <stdlib.h>
#define S_FUNCTION_NAME                State_sf
#define S_FUNCTION_LEVEL               2
#ifndef RTW_GENERATED_S_FUNCTION
#define RTW_GENERATED_S_FUNCTION
#endif

#include "rtwtypes.h"
#include "simstruc.h"
#include "fixedpoint.h"
#if !defined(MATLAB_MEX_FILE)
#include "rt_matrx.h"
#endif

#if !defined(RTW_SFUNCTION_DEFINES)
#define RTW_SFUNCTION_DEFINES

typedef struct {
  void *blockIO;
  void *defaultParam;
  void *nonContDerivSig;
} LocalS;

#define ssSetLocalBlockIO(S, io)       ((LocalS *)ssGetUserData(S))->blockIO = ((void *)(io))
#define ssGetLocalBlockIO(S)           ((LocalS *)ssGetUserData(S))->blockIO
#define ssSetLocalDefaultParam(S, paramVector) ((LocalS *)ssGetUserData(S))->defaultParam = (paramVector)
#define ssGetLocalDefaultParam(S)      ((LocalS *)ssGetUserData(S))->defaultParam
#define ssSetLocalNonContDerivSig(S, pSig) ((LocalS *)ssGetUserData(S))->nonContDerivSig = (pSig)
#define ssGetLocalNonContDerivSig(S)   ((LocalS *)ssGetUserData(S))->nonContDerivSig
#endif
#endif                                 /* State_sf_COMMON_INCLUDES_ */

#include "State_sf_types.h"
#include "rtGetNaN.h"
#include "rt_nonfinite.h"
#include <string.h>
#include "rtGetInf.h"
#include <stddef.h>
#include "rt_defines.h"

/* Block signals (default storage) */
typedef struct {
  real_T Est_states[7];
                      /* '<S1>/Linearized Bicycle Model on Constant Velocity' */
  uint8_T FixPtSwitch;                 /* '<S5>/FixPt Switch' */
} B_State_T;

/* Constant parameters (default storage) */
typedef struct {
  /* Expression: A_d
   * Referenced by: '<S1>/Linearized Bicycle Model on Constant Velocity'
   */
  real_T LinearizedBicycleModelonConstan[49];

  /* Expression: B_d
   * Referenced by: '<S1>/Linearized Bicycle Model on Constant Velocity'
   */
  real_T LinearizedBicycleModelonConst_e[7];

  /* Expression: C1
   * Referenced by: '<S1>/Linearized Bicycle Model on Constant Velocity'
   */
  real_T LinearizedBicycleModelonConst_h[49];

  /* Expression: C2
   * Referenced by: '<S1>/Linearized Bicycle Model on Constant Velocity'
   */
  real_T LinearizedBicycleModelonCons_ek[20];

  /* Expression: D1
   * Referenced by: '<S1>/Linearized Bicycle Model on Constant Velocity'
   */
  real_T LinearizedBicycleModelonConst_i[7];

  /* Expression: D2
   * Referenced by: '<S1>/Linearized Bicycle Model on Constant Velocity'
   */
  real_T LinearizedBicycleModelonConst_p[5];

  /* Expression: T
   * Referenced by: '<S1>/Linearized Bicycle Model on Constant Velocity'
   */
  real_T LinearizedBicycleModelonCons_eg[9];

  /* Expression: [initial_state_estimate.x initial_state_estimate.y initial_state_estimate.heading initial_state.roll initial_state.roll_rate initial_state.steering v]
   * Referenced by: '<S1>/Delay'
   */
  real_T Delay_InitialCondition[7];

  /* Expression: Kalman_gain1
   * Referenced by: '<S1>/Constant2'
   */
  real_T Constant2_Value[49];

  /* Expression: Kalman_gain2
   * Referenced by: '<S1>/Constant4'
   */
  real_T Constant4_Value[20];
} ConstP_State_T;

/* External inputs (root inport signals with default storage) */
typedef struct {
  real_T *steer_rate;                  /* '<Root>/steer_rate' */
  real_T *measurements[7];             /* '<Root>/measurements' */
} ExternalUPtrs_State_T;

/* External outputs (root outports fed by signals with default storage) */
typedef struct {
  real_T *Estimated_XYPsi[3];          /* '<Root>/Estimated_X//Y//Psi' */
  real_T *Estimated_Roll;              /* '<Root>/Estimated_Roll' */
  real_T *Estimated_Roll_Rate;         /* '<Root>/Estimated_Roll_Rate' */
} ExtY_State_T;

/* Constant parameters (default storage) */
extern const ConstP_State_T State_ConstP;

/*-
 * The generated code includes comments that allow you to trace directly
 * back to the appropriate location in the model.  The basic format
 * is <system>/block_name, where system is the system number (uniquely
 * assigned by Simulink) and block_name is the name of the block.
 *
 * Note that this particular code originates from a subsystem build,
 * and has its own system numbers different from the parent model.
 * Refer to the system hierarchy for this subsystem below, and use the
 * MATLAB hilite_system command to trace the generated code back
 * to the parent model.  For example,
 *
 * hilite_system('Main_CCODE/State estimator')    - opens subsystem Main_CCODE/State estimator
 * hilite_system('Main_CCODE/State estimator/Kp') - opens and selects block Kp
 *
 * Here is the system hierarchy for this model
 *
 * '<Root>' : 'Main_CCODE'
 * '<S1>'   : 'Main_CCODE/State estimator'
 * '<S2>'   : 'Main_CCODE/State estimator/Counter Limited'
 * '<S3>'   : 'Main_CCODE/State estimator/Linearized Bicycle Model on Constant Velocity'
 * '<S4>'   : 'Main_CCODE/State estimator/Counter Limited/Increment Real World'
 * '<S5>'   : 'Main_CCODE/State estimator/Counter Limited/Wrap To Zero'
 */
#endif                                 /* RTW_HEADER_State_sf_h_ */
