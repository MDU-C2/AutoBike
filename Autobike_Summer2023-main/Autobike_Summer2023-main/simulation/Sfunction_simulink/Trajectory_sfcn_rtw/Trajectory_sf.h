/*
 * Trajectory_sf.h
 *
 * Prerelease License - for engineering feedback and testing purposes
 * only. Not for sale.
 *
 * Code generation for model "Trajectory_sf".
 *
 * Model version              : 3.200
 * Simulink Coder version : 9.8 (R2022b) 13-May-2022
 * C source code generated on : Mon Mar 20 12:59:27 2023
 *
 * Target selection: rtwsfcn.tlc
 * Note: GRT includes extra infrastructure and instrumentation for prototyping
 * Embedded hardware selection: Intel->x86-64 (Windows64)
 * Code generation objective: Execution efficiency
 * Validation result: Not run
 */

#ifndef RTW_HEADER_Trajectory_sf_h_
#define RTW_HEADER_Trajectory_sf_h_
#ifndef Trajectory_sf_COMMON_INCLUDES_
#define Trajectory_sf_COMMON_INCLUDES_
#include <stdlib.h>
#define S_FUNCTION_NAME                Trajectory_sf
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
#endif                                 /* Trajectory_sf_COMMON_INCLUDES_ */

#include "Trajectory_sf_types.h"
#include "rtGetNaN.h"
#include "rt_nonfinite.h"
#include <string.h>
#include "rtGetInf.h"
#include <stddef.h>
#include "rt_defines.h"

typedef struct {
  char cache_0[1*sizeof(real_T)];
} nonContDerivSigCache_Trajectory_T;

/* Block signals (default storage) */
typedef struct {
  real_T TransferFcn;                  /* '<S1>/Transfer Fcn' */
  real_T dpsiref;                      /* '<S1>/Trajectory controller' */
} B_Trajectory_T;

/* Continuous states (default storage) */
typedef struct {
  real_T TransferFcn_CSTATE;           /* '<S1>/Transfer Fcn' */
} X_Trajectory_T;

/* State derivatives (default storage) */
typedef struct {
  real_T TransferFcn_CSTATE;           /* '<S1>/Transfer Fcn' */
} XDot_Trajectory_T;

/* State disabled  */
typedef struct {
  boolean_T TransferFcn_CSTATE;        /* '<S1>/Transfer Fcn' */
} XDis_Trajectory_T;

/* External inputs (root inport signals with default storage) */
typedef struct {
  real_T *local_Xref[101];             /* '<Root>/Local_Xref' */
  real_T *local_Yref[101];             /* '<Root>/Local_Yref' */
  real_T *local_Psiref[101];           /* '<Root>/Local_Psiref' */
  real_T *Estimated_states[3];         /* '<Root>/Estimated_states' */
} ExternalUPtrs_Trajectory_T;

/* External input sizes (for root inport signals with variable sizes) */
typedef struct {
  int32_T local_Xref;                  /* '<Root>/Local_Xref' */
  int32_T local_Yref;                  /* '<Root>/Local_Yref' */
  int32_T local_Psiref;                /* '<Root>/Local_Psiref' */
} ExternalUSizePtrs_Trajectory_T;

/* External outputs (root outports fed by signals with default storage) */
typedef struct {
  real_T *roll_ref;                    /* '<Root>/roll_ref' */
  real_T *closest_point;               /* '<Root>/closest_point' */
  real_T *Outport1;                    /* '<Root>/Outport1' */
} ExtY_Trajectory_T;

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
 * hilite_system('Main_CCODE/Trajectory controller')    - opens subsystem Main_CCODE/Trajectory controller
 * hilite_system('Main_CCODE/Trajectory controller/Kp') - opens and selects block Kp
 *
 * Here is the system hierarchy for this model
 *
 * '<Root>' : 'Main_CCODE'
 * '<S1>'   : 'Main_CCODE/Trajectory controller'
 * '<S2>'   : 'Main_CCODE/Trajectory controller/Trajectory controller'
 */
#endif                                 /* RTW_HEADER_Trajectory_sf_h_ */
