/*
 * Balancing_sf.h
 *
 * Prerelease License - for engineering feedback and testing purposes
 * only. Not for sale.
 *
 * Code generation for model "Balancing_sf".
 *
 * Model version              : 3.202
 * Simulink Coder version : 9.8 (R2022b) 13-May-2022
 * C source code generated on : Tue Mar 21 12:24:28 2023
 *
 * Target selection: rtwsfcn.tlc
 * Note: GRT includes extra infrastructure and instrumentation for prototyping
 * Embedded hardware selection: Intel->x86-64 (Windows64)
 * Code generation objective: Execution efficiency
 * Validation result: Not run
 */

#ifndef RTW_HEADER_Balancing_sf_h_
#define RTW_HEADER_Balancing_sf_h_
#ifndef Balancing_sf_COMMON_INCLUDES_
#define Balancing_sf_COMMON_INCLUDES_
#include <stdlib.h>
#define S_FUNCTION_NAME                Balancing_sf
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
#endif                                 /* Balancing_sf_COMMON_INCLUDES_ */

#include "Balancing_sf_types.h"
#include <string.h>
#include "rtGetNaN.h"
#include "rt_nonfinite.h"
#include <stddef.h>
#include "rt_defines.h"

/* Block signals (default storage) */
typedef struct {
  real_T Tsamp;                        /* '<S82>/Tsamp' */
  real_T Tsamp_c;                      /* '<S32>/Tsamp' */
  real_T IntegralGain;                 /* '<S34>/Integral Gain' */
} B_Balancing_T;

/* External inputs (root inport signals with default storage) */
typedef struct {
  real_T *roll_ref;                    /* '<Root>/Reference Roll' */
  real_T *EstimatedRoll;               /* '<Root>/Estimated Roll' */
  real_T *EstimatedRollRate;           /* '<Root>/Estimated Roll Rate' */
} ExternalUPtrs_Balancing_T;

/* External outputs (root outports fed by signals with default storage) */
typedef struct {
  real_T *SteeringRate;                /* '<Root>/Steering Rate' */
} ExtY_Balancing_T;

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
 * hilite_system('Main_CCODE/Balancing Controller ')    - opens subsystem Main_CCODE/Balancing Controller
 * hilite_system('Main_CCODE/Balancing Controller /Kp') - opens and selects block Kp
 *
 * Here is the system hierarchy for this model
 *
 * '<Root>' : 'Main_CCODE'
 * '<S1>'   : 'Main_CCODE/Balancing Controller '
 * '<S2>'   : 'Main_CCODE/Balancing Controller /D term'
 * '<S3>'   : 'Main_CCODE/Balancing Controller /P term'
 * '<S4>'   : 'Main_CCODE/Balancing Controller /D term/Anti-windup'
 * '<S5>'   : 'Main_CCODE/Balancing Controller /D term/D Gain'
 * '<S6>'   : 'Main_CCODE/Balancing Controller /D term/Filter'
 * '<S7>'   : 'Main_CCODE/Balancing Controller /D term/Filter ICs'
 * '<S8>'   : 'Main_CCODE/Balancing Controller /D term/I Gain'
 * '<S9>'   : 'Main_CCODE/Balancing Controller /D term/Ideal P Gain'
 * '<S10>'  : 'Main_CCODE/Balancing Controller /D term/Ideal P Gain Fdbk'
 * '<S11>'  : 'Main_CCODE/Balancing Controller /D term/Integrator'
 * '<S12>'  : 'Main_CCODE/Balancing Controller /D term/Integrator ICs'
 * '<S13>'  : 'Main_CCODE/Balancing Controller /D term/N Copy'
 * '<S14>'  : 'Main_CCODE/Balancing Controller /D term/N Gain'
 * '<S15>'  : 'Main_CCODE/Balancing Controller /D term/P Copy'
 * '<S16>'  : 'Main_CCODE/Balancing Controller /D term/Parallel P Gain'
 * '<S17>'  : 'Main_CCODE/Balancing Controller /D term/Reset Signal'
 * '<S18>'  : 'Main_CCODE/Balancing Controller /D term/Saturation'
 * '<S19>'  : 'Main_CCODE/Balancing Controller /D term/Saturation Fdbk'
 * '<S20>'  : 'Main_CCODE/Balancing Controller /D term/Sum'
 * '<S21>'  : 'Main_CCODE/Balancing Controller /D term/Sum Fdbk'
 * '<S22>'  : 'Main_CCODE/Balancing Controller /D term/Tracking Mode'
 * '<S23>'  : 'Main_CCODE/Balancing Controller /D term/Tracking Mode Sum'
 * '<S24>'  : 'Main_CCODE/Balancing Controller /D term/Tsamp - Integral'
 * '<S25>'  : 'Main_CCODE/Balancing Controller /D term/Tsamp - Ngain'
 * '<S26>'  : 'Main_CCODE/Balancing Controller /D term/postSat Signal'
 * '<S27>'  : 'Main_CCODE/Balancing Controller /D term/preSat Signal'
 * '<S28>'  : 'Main_CCODE/Balancing Controller /D term/Anti-windup/Passthrough'
 * '<S29>'  : 'Main_CCODE/Balancing Controller /D term/D Gain/Internal Parameters'
 * '<S30>'  : 'Main_CCODE/Balancing Controller /D term/Filter/Differentiator'
 * '<S31>'  : 'Main_CCODE/Balancing Controller /D term/Filter/Differentiator/Tsamp'
 * '<S32>'  : 'Main_CCODE/Balancing Controller /D term/Filter/Differentiator/Tsamp/Internal Ts'
 * '<S33>'  : 'Main_CCODE/Balancing Controller /D term/Filter ICs/Internal IC - Differentiator'
 * '<S34>'  : 'Main_CCODE/Balancing Controller /D term/I Gain/Internal Parameters'
 * '<S35>'  : 'Main_CCODE/Balancing Controller /D term/Ideal P Gain/Passthrough'
 * '<S36>'  : 'Main_CCODE/Balancing Controller /D term/Ideal P Gain Fdbk/Disabled'
 * '<S37>'  : 'Main_CCODE/Balancing Controller /D term/Integrator/Discrete'
 * '<S38>'  : 'Main_CCODE/Balancing Controller /D term/Integrator ICs/Internal IC'
 * '<S39>'  : 'Main_CCODE/Balancing Controller /D term/N Copy/Disabled wSignal Specification'
 * '<S40>'  : 'Main_CCODE/Balancing Controller /D term/N Gain/Passthrough'
 * '<S41>'  : 'Main_CCODE/Balancing Controller /D term/P Copy/Disabled'
 * '<S42>'  : 'Main_CCODE/Balancing Controller /D term/Parallel P Gain/Internal Parameters'
 * '<S43>'  : 'Main_CCODE/Balancing Controller /D term/Reset Signal/Disabled'
 * '<S44>'  : 'Main_CCODE/Balancing Controller /D term/Saturation/Passthrough'
 * '<S45>'  : 'Main_CCODE/Balancing Controller /D term/Saturation Fdbk/Disabled'
 * '<S46>'  : 'Main_CCODE/Balancing Controller /D term/Sum/Sum_PID'
 * '<S47>'  : 'Main_CCODE/Balancing Controller /D term/Sum Fdbk/Disabled'
 * '<S48>'  : 'Main_CCODE/Balancing Controller /D term/Tracking Mode/Disabled'
 * '<S49>'  : 'Main_CCODE/Balancing Controller /D term/Tracking Mode Sum/Passthrough'
 * '<S50>'  : 'Main_CCODE/Balancing Controller /D term/Tsamp - Integral/Passthrough'
 * '<S51>'  : 'Main_CCODE/Balancing Controller /D term/Tsamp - Ngain/Passthrough'
 * '<S52>'  : 'Main_CCODE/Balancing Controller /D term/postSat Signal/Forward_Path'
 * '<S53>'  : 'Main_CCODE/Balancing Controller /D term/preSat Signal/Forward_Path'
 * '<S54>'  : 'Main_CCODE/Balancing Controller /P term/Anti-windup'
 * '<S55>'  : 'Main_CCODE/Balancing Controller /P term/D Gain'
 * '<S56>'  : 'Main_CCODE/Balancing Controller /P term/Filter'
 * '<S57>'  : 'Main_CCODE/Balancing Controller /P term/Filter ICs'
 * '<S58>'  : 'Main_CCODE/Balancing Controller /P term/I Gain'
 * '<S59>'  : 'Main_CCODE/Balancing Controller /P term/Ideal P Gain'
 * '<S60>'  : 'Main_CCODE/Balancing Controller /P term/Ideal P Gain Fdbk'
 * '<S61>'  : 'Main_CCODE/Balancing Controller /P term/Integrator'
 * '<S62>'  : 'Main_CCODE/Balancing Controller /P term/Integrator ICs'
 * '<S63>'  : 'Main_CCODE/Balancing Controller /P term/N Copy'
 * '<S64>'  : 'Main_CCODE/Balancing Controller /P term/N Gain'
 * '<S65>'  : 'Main_CCODE/Balancing Controller /P term/P Copy'
 * '<S66>'  : 'Main_CCODE/Balancing Controller /P term/Parallel P Gain'
 * '<S67>'  : 'Main_CCODE/Balancing Controller /P term/Reset Signal'
 * '<S68>'  : 'Main_CCODE/Balancing Controller /P term/Saturation'
 * '<S69>'  : 'Main_CCODE/Balancing Controller /P term/Saturation Fdbk'
 * '<S70>'  : 'Main_CCODE/Balancing Controller /P term/Sum'
 * '<S71>'  : 'Main_CCODE/Balancing Controller /P term/Sum Fdbk'
 * '<S72>'  : 'Main_CCODE/Balancing Controller /P term/Tracking Mode'
 * '<S73>'  : 'Main_CCODE/Balancing Controller /P term/Tracking Mode Sum'
 * '<S74>'  : 'Main_CCODE/Balancing Controller /P term/Tsamp - Integral'
 * '<S75>'  : 'Main_CCODE/Balancing Controller /P term/Tsamp - Ngain'
 * '<S76>'  : 'Main_CCODE/Balancing Controller /P term/postSat Signal'
 * '<S77>'  : 'Main_CCODE/Balancing Controller /P term/preSat Signal'
 * '<S78>'  : 'Main_CCODE/Balancing Controller /P term/Anti-windup/Disabled'
 * '<S79>'  : 'Main_CCODE/Balancing Controller /P term/D Gain/Internal Parameters'
 * '<S80>'  : 'Main_CCODE/Balancing Controller /P term/Filter/Differentiator'
 * '<S81>'  : 'Main_CCODE/Balancing Controller /P term/Filter/Differentiator/Tsamp'
 * '<S82>'  : 'Main_CCODE/Balancing Controller /P term/Filter/Differentiator/Tsamp/Internal Ts'
 * '<S83>'  : 'Main_CCODE/Balancing Controller /P term/Filter ICs/Internal IC - Differentiator'
 * '<S84>'  : 'Main_CCODE/Balancing Controller /P term/I Gain/Disabled'
 * '<S85>'  : 'Main_CCODE/Balancing Controller /P term/Ideal P Gain/Passthrough'
 * '<S86>'  : 'Main_CCODE/Balancing Controller /P term/Ideal P Gain Fdbk/Disabled'
 * '<S87>'  : 'Main_CCODE/Balancing Controller /P term/Integrator/Disabled'
 * '<S88>'  : 'Main_CCODE/Balancing Controller /P term/Integrator ICs/Disabled'
 * '<S89>'  : 'Main_CCODE/Balancing Controller /P term/N Copy/Disabled wSignal Specification'
 * '<S90>'  : 'Main_CCODE/Balancing Controller /P term/N Gain/Passthrough'
 * '<S91>'  : 'Main_CCODE/Balancing Controller /P term/P Copy/Disabled'
 * '<S92>'  : 'Main_CCODE/Balancing Controller /P term/Parallel P Gain/Internal Parameters'
 * '<S93>'  : 'Main_CCODE/Balancing Controller /P term/Reset Signal/Disabled'
 * '<S94>'  : 'Main_CCODE/Balancing Controller /P term/Saturation/Passthrough'
 * '<S95>'  : 'Main_CCODE/Balancing Controller /P term/Saturation Fdbk/Disabled'
 * '<S96>'  : 'Main_CCODE/Balancing Controller /P term/Sum/Sum_PD'
 * '<S97>'  : 'Main_CCODE/Balancing Controller /P term/Sum Fdbk/Disabled'
 * '<S98>'  : 'Main_CCODE/Balancing Controller /P term/Tracking Mode/Disabled'
 * '<S99>'  : 'Main_CCODE/Balancing Controller /P term/Tracking Mode Sum/Passthrough'
 * '<S100>' : 'Main_CCODE/Balancing Controller /P term/Tsamp - Integral/Disabled wSignal Specification'
 * '<S101>' : 'Main_CCODE/Balancing Controller /P term/Tsamp - Ngain/Passthrough'
 * '<S102>' : 'Main_CCODE/Balancing Controller /P term/postSat Signal/Forward_Path'
 * '<S103>' : 'Main_CCODE/Balancing Controller /P term/preSat Signal/Forward_Path'
 */
#endif                                 /* RTW_HEADER_Balancing_sf_h_ */
