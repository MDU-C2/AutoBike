/*
 * Balancing_sf.c
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

#include "Balancing_sf.h"
#include "rtwtypes.h"
#include "Balancing_sf_private.h"
#include "simstruc.h"
#include "fixedpoint.h"
#if defined(RT_MALLOC) || defined(MATLAB_MEX_FILE)

extern void *Balancing_malloc(SimStruct *S);

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
    /* SystemInitialize for Atomic SubSystem: '<Root>/Balancing Controller ' */
    /* InitializeConditions for Delay: '<S80>/UD' */
    ((real_T *)ssGetDWork(S, 0))[0] = 0.0;

    /* InitializeConditions for Delay: '<S30>/UD' */
    ((real_T *)ssGetDWork(S, 1))[0] = 0.0;

    /* InitializeConditions for DiscreteIntegrator: '<S37>/Integrator' */
    ((real_T *)ssGetDWork(S, 2))[0] = 0.0;

    /* End of SystemInitialize for SubSystem: '<Root>/Balancing Controller ' */
  } else {
    /* SystemReset for Atomic SubSystem: '<Root>/Balancing Controller ' */
    /* InitializeConditions for Delay: '<S80>/UD' */
    ((real_T *)ssGetDWork(S, 0))[0] = 0.0;

    /* InitializeConditions for Delay: '<S30>/UD' */
    ((real_T *)ssGetDWork(S, 1))[0] = 0.0;

    /* InitializeConditions for DiscreteIntegrator: '<S37>/Integrator' */
    ((real_T *)ssGetDWork(S, 2))[0] = 0.0;

    /* End of SystemReset for SubSystem: '<Root>/Balancing Controller ' */
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

  Balancing_malloc(S);
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
  B_Balancing_T *_rtB;
  real_T rtb_Sum4;
  _rtB = ((B_Balancing_T *) ssGetLocalBlockIO(S));

  /* Outputs for Atomic SubSystem: '<Root>/Balancing Controller ' */
  /* Sum: '<S1>/Sum6' */
  rtb_Sum4 = *((const real_T **)ssGetInputPortSignalPtrs(S, 0))[0] - *((const
    real_T **)ssGetInputPortSignalPtrs(S, 1))[0];

  /* SampleTimeMath: '<S82>/Tsamp' incorporates:
   *  Gain: '<S79>/Derivative Gain'
   *
   * About '<S82>/Tsamp':
   *  y = u * K where K = 1 / ( w * Ts )
   */
  _rtB->Tsamp = 0.0 * rtb_Sum4 * 100.0;

  /* Sum: '<S1>/Sum4' incorporates:
   *  Delay: '<S80>/UD'
   *  Gain: '<S92>/Proportional Gain'
   *  Sum: '<S80>/Diff'
   *  Sum: '<S96>/Sum'
   */
  rtb_Sum4 = (1.3 * rtb_Sum4 + (_rtB->Tsamp - ((real_T *)ssGetDWork(S, 0))[0]))
    - *((const real_T **)ssGetInputPortSignalPtrs(S, 2))[0];

  /* SampleTimeMath: '<S32>/Tsamp' incorporates:
   *  Gain: '<S29>/Derivative Gain'
   *
   * About '<S32>/Tsamp':
   *  y = u * K where K = 1 / ( w * Ts )
   */
  _rtB->Tsamp_c = 0.0 * rtb_Sum4 * 100.0;

  /* Gain: '<S34>/Integral Gain' */
  _rtB->IntegralGain = 0.0 * rtb_Sum4;

  /* Outport: '<Root>/Steering Rate' incorporates:
   *  Delay: '<S30>/UD'
   *  DiscreteIntegrator: '<S37>/Integrator'
   *  Gain: '<S42>/Proportional Gain'
   *  Sum: '<S30>/Diff'
   *  Sum: '<S46>/Sum'
   */
  ((real_T *)ssGetOutputPortSignal(S, 0))[0] = (3.0 * rtb_Sum4 + ((real_T *)
    ssGetDWork(S, 2))[0]) + (_rtB->Tsamp_c - ((real_T *)ssGetDWork(S, 1))[0]);

  /* End of Outputs for SubSystem: '<Root>/Balancing Controller ' */
  UNUSED_PARAMETER(tid);
}

/* Update for root system: '<Root>' */
#define MDL_UPDATE

static void mdlUpdate(SimStruct *S, int_T tid)
{
  B_Balancing_T *_rtB;
  _rtB = ((B_Balancing_T *) ssGetLocalBlockIO(S));

  /* Update for Atomic SubSystem: '<Root>/Balancing Controller ' */
  /* Update for Delay: '<S80>/UD' */
  ((real_T *)ssGetDWork(S, 0))[0] = _rtB->Tsamp;

  /* Update for Delay: '<S30>/UD' */
  ((real_T *)ssGetDWork(S, 1))[0] = _rtB->Tsamp_c;

  /* Update for DiscreteIntegrator: '<S37>/Integrator' */
  ((real_T *)ssGetDWork(S, 2))[0] = 0.01 * _rtB->IntegralGain + ((real_T *)
    ssGetDWork(S, 2))[0];

  /* End of Update for SubSystem: '<Root>/Balancing Controller ' */
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
#include "Balancing_mid.h"
#endif

/* Function to initialize sizes. */
static void mdlInitializeSizes(SimStruct *S)
{
  ssSetNumSampleTimes(S, 1);           /* Number of sample times */
  ssSetNumContStates(S, 0);            /* Number of continuous states */
  ssSetNumNonsampledZCs(S, 0);         /* Number of nonsampled ZCs */

  /* Number of output ports */
  if (!ssSetNumOutputPorts(S, 1))
    return;

  /* outport number: 0 */
  if (!ssSetOutputPortVectorDimension(S, 0, 1))
    return;
  if (ssGetSimMode(S) != SS_SIMMODE_SIZES_CALL_ONLY) {
    ssSetOutputPortDataType(S, 0, SS_DOUBLE);
  }

  ssSetOutputPortSampleTime(S, 0, 0.01);
  ssSetOutputPortOffsetTime(S, 0, 0.0);
  ssSetOutputPortOptimOpts(S, 0, SS_REUSABLE_AND_LOCAL);

  /* Number of input ports */
  if (!ssSetNumInputPorts(S, 3))
    return;

  /* inport number: 0 */
  {
    if (!ssSetInputPortVectorDimension(S, 0, 1))
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
    if (!ssSetInputPortVectorDimension(S, 1, 1))
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
    if (!ssSetInputPortVectorDimension(S, 2, 1))
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

  ssSetRTWGeneratedSFcn(S, 1);         /* Generated S-function */

  /* DWork */
  if (!ssSetNumDWork(S, 3)) {
    return;
  }

  /* '<S80>/UD': DSTATE */
  ssSetDWorkName(S, 0, "DWORK0");
  ssSetDWorkWidth(S, 0, 1);
  ssSetDWorkUsedAsDState(S, 0, 1);

  /* '<S30>/UD': DSTATE */
  ssSetDWorkName(S, 1, "DWORK1");
  ssSetDWorkWidth(S, 1, 1);
  ssSetDWorkUsedAsDState(S, 1, 1);

  /* '<S37>/Integrator': DSTATE */
  ssSetDWorkName(S, 2, "DWORK2");
  ssSetDWorkWidth(S, 2, 1);
  ssSetDWorkUsedAsDState(S, 2, 1);

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
#define S_FUNCTION_NAME                Balancing_sf
#include "cg_sfun.h"
#endif                                 /* defined(MATLAB_MEX_FILE) */
