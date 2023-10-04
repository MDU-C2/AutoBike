/*
 * Selection_sf.c
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

#include "Selection_sf.h"
#include "rtwtypes.h"
#include "Selection_sf_private.h"
#include "simstruc.h"
#include "fixedpoint.h"
#if defined(RT_MALLOC) || defined(MATLAB_MEX_FILE)

extern void *Selection_malloc(SimStruct *S);

#endif

#ifndef __RTW_UTFREE__
#if defined (MATLAB_MEX_FILE)

extern void * utMalloc(size_t);
extern void utFree(void *);

#endif
#endif                                 /* #ifndef __RTW_UTFREE__ */

#if defined(MATLAB_MEX_FILE)
#include "rt_nonfinite.c"
#endif

static const char_T *RT_MEMORY_ALLOCATION_ERROR =
  "memory allocation error in generated S-Function";

/* System initialize for root system: '<Root>' */
#define MDL_INITIALIZE_CONDITIONS

static void mdlInitializeConditions(SimStruct *S)
{
  if (ssIsFirstInitCond(S)) {
    /* InitializeConditions for UnitDelay: '<S1>/Unit Delay' */
    ((real_T *)ssGetDWork(S, 0))[0] = 1.0;
  } else {
    /* InitializeConditions for UnitDelay: '<S1>/Unit Delay' */
    ((real_T *)ssGetDWork(S, 0))[0] = 1.0;
  }
}

/* Start for root system: '<Root>' */
#define MDL_START

static void mdlStart(SimStruct *S)
{
  /* instance underlying S-Function data */
#if defined(RT_MALLOC) || defined(MATLAB_MEX_FILE)
#if defined(MATLAB_MEX_FILE)

  /* non-finites */
  rt_InitInfAndNaN(sizeof(real_T));

#endif

  Selection_malloc(S);
  if (ssGetErrorStatus(S) != (NULL) ) {
    return;
  }

#endif

  {
  }
}

/* Outputs for root system: '<Root>' */
static void mdlOutputs(SimStruct *S, int_T tid)
{
  B_Selection_T *_rtB;
  real_T M;
  real_T ids;
  int32_T SFunction_DIMS4_tmp;
  int32_T b;
  int32_T c;
  int32_T d;
  int32_T e;
  int32_T f;
  int32_T g;
  int32_T stop;
  _rtB = ((B_Selection_T *) ssGetLocalBlockIO(S));

  /* MATLAB Function: '<S1>/Local reference selection & stop funcion' incorporates:
   *  Outport: '<Root>/Local_Psiref'
   *  Outport: '<Root>/Local_Xref'
   *  Outport: '<Root>/Local_Yref'
   *  UnitDelay: '<S1>/Unit Delay'
   */
  ids = (((real_T *)ssGetDWork(S, 0))[0] + *((const real_T **)
          ssGetInputPortSignalPtrs(S, 3))[0]) - 1.0;
  M = ids + 20.0;
  if (ids + 20.0 > 101.0) {
    M = 101.0;
  }

  stop = 0;
  if (ids >= 90.0) {
    stop = 1;
  }

  if (ids - 1.0 > M) {
    c = 0;
    b = 0;
    e = 0;
    d = 0;
    g = 0;
    f = 0;
  } else {
    c = (int32_T)(ids - 1.0) - 1;
    b = (int32_T)M;
    e = (int32_T)(ids - 1.0) - 1;
    d = (int32_T)M;
    g = (int32_T)(ids - 1.0) - 1;
    f = (int32_T)M;
  }

  f -= g;
  ((int32_T *)ssGetDWork(S, 3))[0] = f;
  _rtB->ids = ids;
  b -= c;
  ((int32_T *)ssGetDWork(S, 1))[0] = b;
  SFunction_DIMS4_tmp = d - e;
  ((int32_T *)ssGetDWork(S, 2))[0] = SFunction_DIMS4_tmp;

  /* Outport: '<Root>/Local_Xref' incorporates:
   *  MATLAB Function: '<S1>/Local reference selection & stop funcion'
   */
  ((int32_T *)&ssGetCurrentOutputPortDimensionsAndRecordIndex(S, 0, 0))[0] =
    ((int32_T *)ssGetDWork(S, 1))[0];
  for (d = 0; d < b; d++) {
    ((real_T *)ssGetOutputPortSignal(S, 0))[d] = *((const real_T **)
      ssGetInputPortSignalPtrs(S, 0))[c + d];
  }

  /* Outport: '<Root>/Local_Yref' incorporates:
   *  MATLAB Function: '<S1>/Local reference selection & stop funcion'
   */
  ((int32_T *)&ssGetCurrentOutputPortDimensionsAndRecordIndex(S, 1, 0))[0] =
    ((int32_T *)ssGetDWork(S, 2))[0];
  for (d = 0; d < SFunction_DIMS4_tmp; d++) {
    ((real_T *)ssGetOutputPortSignal(S, 1))[d] = *((const real_T **)
      ssGetInputPortSignalPtrs(S, 1))[e + d];
  }

  /* Outport: '<Root>/Local_Psiref' incorporates:
   *  MATLAB Function: '<S1>/Local reference selection & stop funcion'
   */
  ((int32_T *)&ssGetCurrentOutputPortDimensionsAndRecordIndex(S, 2, 0))[0] =
    ((int32_T *)ssGetDWork(S, 3))[0];
  for (d = 0; d < f; d++) {
    ((real_T *)ssGetOutputPortSignal(S, 2))[d] = *((const real_T **)
      ssGetInputPortSignalPtrs(S, 2))[g + d];
  }

  /* Stop: '<S1>/Stop Simulation' incorporates:
   *  MATLAB Function: '<S1>/Local reference selection & stop funcion'
   */
  if (stop != 0) {
    ssSetStopRequested(S, 1);
  }

  /* End of Stop: '<S1>/Stop Simulation' */
  UNUSED_PARAMETER(tid);
}

/* Update for root system: '<Root>' */
#define MDL_UPDATE

static void mdlUpdate(SimStruct *S, int_T tid)
{
  B_Selection_T *_rtB;
  _rtB = ((B_Selection_T *) ssGetLocalBlockIO(S));

  /* Update for UnitDelay: '<S1>/Unit Delay' */
  ((real_T *)ssGetDWork(S, 0))[0] = _rtB->ids;
  UNUSED_PARAMETER(tid);
}

/* Termination for root system: '<Root>' */
static void mdlTerminate(SimStruct *S)
{

#if defined(RT_MALLOC) || defined(MATLAB_MEX_FILE)

  if (ssGetUserData(S) != (NULL) ) {
    rt_FREE(ssGetLocalBlockIO(S));
  }

  rt_FREE(ssGetUserData(S));

#endif

}

#if defined(RT_MALLOC) || defined(MATLAB_MEX_FILE)
#include "Selection_mid.h"
#endif

/* Function to initialize sizes. */
static void mdlInitializeSizes(SimStruct *S)
{
  ssSetNumSampleTimes(S, 1);           /* Number of sample times */
  ssSetNumContStates(S, 0);            /* Number of continuous states */
  ssSetNumNonsampledZCs(S, 0);         /* Number of nonsampled ZCs */

  /* Number of output ports */
  if (!ssSetNumOutputPorts(S, 3))
    return;

  /* outport number: 0 */
  ssSetOutputPortDimensionsMode(S, 0, VARIABLE_DIMS_MODE);
  if (!ssSetOutputPortVectorDimension(S, 0, 101))
    return;
  if (ssGetSimMode(S) != SS_SIMMODE_SIZES_CALL_ONLY) {
    ssSetOutputPortDataType(S, 0, SS_DOUBLE);
  }

  ssSetOutputPortSampleTime(S, 0, 0.01);
  ssSetOutputPortOffsetTime(S, 0, 0.0);
  ssSetOutputPortOptimOpts(S, 0, SS_REUSABLE_AND_LOCAL);

  /* outport number: 1 */
  ssSetOutputPortDimensionsMode(S, 1, VARIABLE_DIMS_MODE);
  if (!ssSetOutputPortVectorDimension(S, 1, 101))
    return;
  if (ssGetSimMode(S) != SS_SIMMODE_SIZES_CALL_ONLY) {
    ssSetOutputPortDataType(S, 1, SS_DOUBLE);
  }

  ssSetOutputPortSampleTime(S, 1, 0.01);
  ssSetOutputPortOffsetTime(S, 1, 0.0);
  ssSetOutputPortOptimOpts(S, 1, SS_REUSABLE_AND_LOCAL);

  /* outport number: 2 */
  ssSetOutputPortDimensionsMode(S, 2, VARIABLE_DIMS_MODE);
  if (!ssSetOutputPortVectorDimension(S, 2, 101))
    return;
  if (ssGetSimMode(S) != SS_SIMMODE_SIZES_CALL_ONLY) {
    ssSetOutputPortDataType(S, 2, SS_DOUBLE);
  }

  ssSetOutputPortSampleTime(S, 2, 0.01);
  ssSetOutputPortOffsetTime(S, 2, 0.0);
  ssSetOutputPortOptimOpts(S, 2, SS_REUSABLE_AND_LOCAL);

  /* Number of input ports */
  if (!ssSetNumInputPorts(S, 4))
    return;

  /* inport number: 0 */
  {
    if (!ssSetInputPortVectorDimension(S, 0, 101))
      return;
    if (ssGetSimMode(S) != SS_SIMMODE_SIZES_CALL_ONLY) {
      ssSetInputPortDataType(S, 0, SS_DOUBLE);
    }

    ssSetInputPortDirectFeedThrough(S, 0, 1);
    ssSetInputPortSampleTime(S, 0, 0.01);
    ssSetInputPortOffsetTime(S, 0, 0.0);
    ssSetInputPortOverWritable(S, 0, 0);
    ssSetInputPortOptimOpts(S, 0, SS_NOT_REUSABLE_AND_GLOBAL);
  }

  /* inport number: 1 */
  {
    if (!ssSetInputPortVectorDimension(S, 1, 101))
      return;
    if (ssGetSimMode(S) != SS_SIMMODE_SIZES_CALL_ONLY) {
      ssSetInputPortDataType(S, 1, SS_DOUBLE);
    }

    ssSetInputPortDirectFeedThrough(S, 1, 1);
    ssSetInputPortSampleTime(S, 1, 0.01);
    ssSetInputPortOffsetTime(S, 1, 0.0);
    ssSetInputPortOverWritable(S, 1, 0);
    ssSetInputPortOptimOpts(S, 1, SS_NOT_REUSABLE_AND_GLOBAL);
  }

  /* inport number: 2 */
  {
    if (!ssSetInputPortVectorDimension(S, 2, 101))
      return;
    if (ssGetSimMode(S) != SS_SIMMODE_SIZES_CALL_ONLY) {
      ssSetInputPortDataType(S, 2, SS_DOUBLE);
    }

    ssSetInputPortDirectFeedThrough(S, 2, 1);
    ssSetInputPortSampleTime(S, 2, 0.01);
    ssSetInputPortOffsetTime(S, 2, 0.0);
    ssSetInputPortOverWritable(S, 2, 0);
    ssSetInputPortOptimOpts(S, 2, SS_NOT_REUSABLE_AND_GLOBAL);
  }

  /* inport number: 3 */
  {
    if (!ssSetInputPortVectorDimension(S, 3, 1))
      return;
    if (ssGetSimMode(S) != SS_SIMMODE_SIZES_CALL_ONLY) {
      ssSetInputPortDataType(S, 3, SS_DOUBLE);
    }

    ssSetInputPortDirectFeedThrough(S, 3, 1);
    ssSetInputPortSampleTime(S, 3, 0.01);
    ssSetInputPortOffsetTime(S, 3, 0.0);
    ssSetInputPortOverWritable(S, 3, 0);
    ssSetInputPortOptimOpts(S, 3, SS_NOT_REUSABLE_AND_GLOBAL);
  }

  ssSetRTWGeneratedSFcn(S, 1);         /* Generated S-function */

  /* DWork */
  if (!ssSetNumDWork(S, 4)) {
    return;
  }

  /* '<S1>/Unit Delay': DSTATE */
  ssSetDWorkName(S, 0, "DWORK0");
  ssSetDWorkWidth(S, 0, 1);
  ssSetDWorkUsedAsDState(S, 0, 1);

  /* '<S1>/Local reference selection & stop funcion': DWORK1 */
  ssSetDWorkName(S, 1, "DWORK1");
  ssSetDWorkWidth(S, 1, 1);
  ssSetDWorkDataType(S, 1, SS_INT32);

  /* '<S1>/Local reference selection & stop funcion': DWORK2 */
  ssSetDWorkName(S, 2, "DWORK2");
  ssSetDWorkWidth(S, 2, 1);
  ssSetDWorkDataType(S, 2, SS_INT32);

  /* '<S1>/Local reference selection & stop funcion': DWORK3 */
  ssSetDWorkName(S, 3, "DWORK3");
  ssSetDWorkWidth(S, 3, 1);
  ssSetDWorkDataType(S, 3, SS_INT32);

  /* Tunable Parameters */
  ssSetNumSFcnParams(S, 0);

  /* Number of expected parameters */
#if defined(MATLAB_MEX_FILE)

  if (ssGetNumSFcnParams(S) == ssGetSFcnParamsCount(S)) {

#if defined(MDL_CHECK_PARAMETERS)

    mdlCheckParameters(S);

#endif                                 /* MDL_CHECK_PARAMETERS */

    if (ssGetErrorStatus(S) != (NULL) ) {
      return;
    }
  } else {
    return;                /* Parameter mismatch will be reported by Simulink */
  }

#endif                                 /* MATLAB_MEX_FILE */

  /* Options */
  ssSetOptions(S, (SS_OPTION_RUNTIME_EXCEPTION_FREE_CODE |
                   SS_OPTION_PORT_SAMPLE_TIMES_ASSIGNED ));

#if SS_SFCN_FOR_SIM

  {
    ssSupportsMultipleExecInstances(S, true);
    ssHasStateInsideForEachSS(S, false);
  }

#endif

}

/* Function to initialize sample times. */
static void mdlInitializeSampleTimes(SimStruct *S)
{
  /* task periods */
  ssSetSampleTime(S, 0, 0.01);

  /* task offsets */
  ssSetOffsetTime(S, 0, 0.0);
}

#if defined(MATLAB_MEX_FILE)
#include "fixedpoint.c"
#include "simulink.c"
#else
#undef S_FUNCTION_NAME
#define S_FUNCTION_NAME                Selection_sf
#include "cg_sfun.h"
#endif                                 /* defined(MATLAB_MEX_FILE) */
