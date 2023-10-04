/*
 * Selection_sf.h
 *
 * Prerelease License - for engineering feedback and testing purposes
 * only. Not for sale.
 *
 * Code generation for model "Selection_sf".
 *
 * Model version              : 3.199
 * Simulink Coder version : 9.8 (R2022b) 13-May-2022
 * C source code generated on : Mon Mar 20 12:30:03 2023
 *
 * Target selection: rtwsfcn.tlc
 * Note: GRT includes extra infrastructure and instrumentation for prototyping
 * Embedded hardware selection: Intel->x86-64 (Windows64)
 * Code generation objective: Execution efficiency
 * Validation result: Not run
 */

#ifndef RTW_HEADER_Selection_sf_h_
#define RTW_HEADER_Selection_sf_h_
#ifndef Selection_sf_COMMON_INCLUDES_
#define Selection_sf_COMMON_INCLUDES_
#include <stdlib.h>
#define S_FUNCTION_NAME                Selection_sf
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
#endif                                 /* Selection_sf_COMMON_INCLUDES_ */

#include "Selection_sf_types.h"
#include <string.h>
#include "rtGetNaN.h"
#include "rt_nonfinite.h"
#include <stddef.h>
#include "rt_defines.h"

/* Block signals (default storage) */
typedef struct {
  real_T ids;              /* '<S1>/Local reference selection & stop funcion' */
} B_Selection_T;

/* External inputs (root inport signals with default storage) */
typedef struct {
  real_T *Xref[101];                   /* '<Root>/Xref' */
  real_T *Yref[101];                   /* '<Root>/Yref' */
  real_T *Psiref[101];                 /* '<Root>/Psiref' */
  real_T *closes_point;                /* '<Root>/closes_point' */
} ExternalUPtrs_Selection_T;

/* External outputs (root outports fed by signals with default storage) */
typedef struct {
  real_T *Local_Xref[101];             /* '<Root>/Local_Xref' */
  real_T *Local_Yref[101];             /* '<Root>/Local_Yref' */
  real_T *Local_Psiref[101];           /* '<Root>/Local_Psiref' */
} ExtY_Selection_T;

/* External output sizes (for root outports fed by signals with variable sizes) */
typedef struct {
  int32_T Local_Xref;                  /* '<Root>/Local_Xref' */
  int32_T Local_Yref;                  /* '<Root>/Local_Yref' */
  int32_T Local_Psiref;                /* '<Root>/Local_Psiref' */
} ExtYSize_Selection_T;

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
 * hilite_system('Main_v3/Selection of local reference from total reference')    - opens subsystem Main_v3/Selection of local reference from total reference
 * hilite_system('Main_v3/Selection of local reference from total reference/Kp') - opens and selects block Kp
 *
 * Here is the system hierarchy for this model
 *
 * '<Root>' : 'Main_v3'
 * '<S1>'   : 'Main_v3/Selection of local reference from total reference'
 * '<S2>'   : 'Main_v3/Selection of local reference from total reference/Local reference selection & stop funcion'
 */
#endif                                 /* RTW_HEADER_Selection_sf_h_ */
