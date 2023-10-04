/*
 * Trajectory_sf.c
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

#include "Trajectory_sf.h"
#include "rtwtypes.h"
#include "rt_nonfinite.h"
#include <math.h>
#include "Trajectory_sf_private.h"
#include "simstruc.h"
#include "fixedpoint.h"
#if defined(RT_MALLOC) || defined(MATLAB_MEX_FILE)

extern void *Trajectory_malloc(SimStruct *S);

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
    X_Trajectory_T *_rtX;
    _rtX = ((X_Trajectory_T *) ssGetContStates(S));

    /* InitializeConditions for TransferFcn: '<S1>/Transfer Fcn' */
    _rtX->TransferFcn_CSTATE = 0.0;
  } else {
    X_Trajectory_T *_rtX;
    _rtX = ((X_Trajectory_T *) ssGetContStates(S));

    /* InitializeConditions for TransferFcn: '<S1>/Transfer Fcn' */
    _rtX->TransferFcn_CSTATE = 0.0;
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

  /* Check for invalid switching between solver types */
  if (ssIsVariableStepSolver(S)) {
    ssSetErrorStatus(S, "This Simulink Coder generated "
                     "S-Function cannot be used in a simulation with "
                     "a solver type of variable-step "
                     "because this S-Function was created from a model with "
                     "solver type of fixed-step and it has continuous time blocks. "
                     "See the Solver page of the simulation parameters dialog.");
    return;
  }

  if (ssGetSolverMode(S) == SOLVER_MODE_MULTITASKING) {
    ssSetErrorStatus(S, "This Simulink Coder generated "
                     "S-Function cannot be used in a simulation with "
                     "solver mode set to auto or multitasking "
                     "because this S-Function was created from a model with "
                     "solver mode set to singletasking. "
                     "See the Solver page of the simulation parameters dialog.");
    return;
  }

#endif

  Trajectory_malloc(S);
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
  B_Trajectory_T *_rtB;
  X_Trajectory_T *_rtX;
  real_T q;
  real_T varargin_1_data;
  boolean_T positiveInput_data;
  _rtX = ((X_Trajectory_T *) ssGetContStates(S));
  _rtB = ((B_Trajectory_T *) ssGetLocalBlockIO(S));
  if (1) {
    /* TransferFcn: '<S1>/Transfer Fcn' */
    _rtB->TransferFcn = 2.2058823529411762 * _rtX->TransferFcn_CSTATE;
  }

  if (ssIsSampleHit(S, 2, 0)) {
    real_T D_psiref;
    real_T c_a;
    real_T c_a_tmp;
    real_T d_a;
    real_T d_a_tmp;
    real_T q_0;
    int32_T closestpoint_heading_idx;
    int_T iy;
    boolean_T rEQ0;

    /* MATLAB Function: '<S1>/Trajectory controller' incorporates:
     *  Constant: '<S1>/Constant'
     *  Constant: '<S1>/Constant1'
     *  Constant: '<S1>/Constant2'
     *  Inport: '<Root>/Local_Psiref'
     *  Inport: '<Root>/Local_Xref'
     *  Inport: '<Root>/Local_Yref'
     */
    iy = 1;
    int32_T exitg1;
    do {
      exitg1 = 0;
      D_psiref = ((const real_T *)ssGetInputPortSignal(S, 0))[iy] - *((const
        real_T **)ssGetInputPortSignalPtrs(S, 3))[0];
      q = ((const real_T *)ssGetInputPortSignal(S, 1))[iy] - *((const real_T **)
        ssGetInputPortSignalPtrs(S, 3))[1];
      c_a_tmp = ((const real_T *)ssGetInputPortSignal(S, 0))[iy + 1];
      c_a = c_a_tmp - *((const real_T **)ssGetInputPortSignalPtrs(S, 3))[0];
      d_a_tmp = ((const real_T *)ssGetInputPortSignal(S, 1))[iy + 1];
      d_a = d_a_tmp - *((const real_T **)ssGetInputPortSignalPtrs(S, 3))[1];
      if ((D_psiref * D_psiref + q * q >= c_a * c_a + d_a * d_a) && (iy + 1 <=
           ((const int32_T *)&ssGetCurrentInputPortDimensions(S, 0, 0))[0] - 2))
      {
        iy++;
      } else {
        exitg1 = 1;
      }
    } while (exitg1 == 0);

    closestpoint_heading_idx = iy;
    D_psiref = ((const real_T *)ssGetInputPortSignal(S, 2))[iy + 1] - ((const
      real_T *)ssGetInputPortSignal(S, 2))[iy];
    if (D_psiref >= 3.1415926535897931) {
      q = D_psiref;
      if (rtIsInf(D_psiref)) {
        D_psiref = (rtNaN);
      } else {
        D_psiref = fmod(D_psiref, -6.2831853071795862);
        rEQ0 = (D_psiref == 0.0);
        if (!rEQ0) {
          q = fabs(q / -6.2831853071795862);
          rEQ0 = !(fabs(q - floor(q + 0.5)) > 2.2204460492503131E-16 * q);
        }

        if (rEQ0) {
          D_psiref = -0.0;
        } else {
          D_psiref -= 6.2831853071795862;
        }
      }
    }

    if (D_psiref <= -3.1415926535897931) {
      q = D_psiref;
      if (rtIsInf(D_psiref)) {
        D_psiref = (rtNaN);
      } else {
        D_psiref = fmod(D_psiref, 6.2831853071795862);
        rEQ0 = (D_psiref == 0.0);
        if (!rEQ0) {
          q = fabs(q / 6.2831853071795862);
          rEQ0 = !(fabs(q - floor(q + 0.5)) > 2.2204460492503131E-16 * q);
        }

        if (rEQ0) {
          D_psiref = 0.0;
        } else {
          D_psiref += 6.2831853071795862;
        }
      }
    }

    d_a = ((const real_T *)ssGetInputPortSignal(S, 0))[iy - 1];
    q = d_a - *((const real_T **)ssGetInputPortSignalPtrs(S, 3))[0];
    q_0 = ((const real_T *)ssGetInputPortSignal(S, 1))[iy - 1];
    c_a = q_0 - *((const real_T **)ssGetInputPortSignalPtrs(S, 3))[1];
    d_a = ((const real_T *)ssGetInputPortSignal(S, 0))[iy] - d_a;
    q_0 = ((const real_T *)ssGetInputPortSignal(S, 1))[iy] - q_0;
    if (fabs(cos(atan(c_a / q) - ((const real_T *)ssGetInputPortSignal(S, 2))[iy])
             * sqrt(q * q + c_a * c_a)) >= sqrt(d_a * d_a + q_0 * q_0)) {
      closestpoint_heading_idx = iy + 1;
    }

    q = (*((const real_T **)ssGetInputPortSignalPtrs(S, 3))[1] - ((const real_T *)
          ssGetInputPortSignal(S, 1))[iy]) * cos(((const real_T *)
      ssGetInputPortSignal(S, 2))[closestpoint_heading_idx]) - (*((const real_T **)
      ssGetInputPortSignalPtrs(S, 3))[0] - ((const real_T *)ssGetInputPortSignal
      (S, 0))[iy]) * sin(((const real_T *)ssGetInputPortSignal(S, 2))
                         [closestpoint_heading_idx]);
    c_a = *((const real_T **)ssGetInputPortSignalPtrs(S, 3))[2] - ((const real_T
      *)ssGetInputPortSignal(S, 2))[closestpoint_heading_idx];
    rEQ0 = ((c_a < -3.1415926535897931) || (c_a > 3.1415926535897931));
    closestpoint_heading_idx = 0;
    if (rEQ0) {
      closestpoint_heading_idx = 1;
    }

    if (closestpoint_heading_idx - 1 >= 0) {
      if (rtIsNaN(c_a + 3.1415926535897931) || rtIsInf(c_a + 3.1415926535897931))
      {
        d_a = (rtNaN);
      } else if (c_a + 3.1415926535897931 == 0.0) {
        d_a = 0.0;
      } else {
        boolean_T rEQ0_0;
        d_a = fmod(c_a + 3.1415926535897931, 6.2831853071795862);
        rEQ0_0 = (d_a == 0.0);
        if (!rEQ0_0) {
          q_0 = fabs((c_a + 3.1415926535897931) / 6.2831853071795862);
          rEQ0_0 = !(fabs(q_0 - floor(q_0 + 0.5)) > 2.2204460492503131E-16 * q_0);
        }

        if (rEQ0_0) {
          d_a = 0.0;
        } else if (c_a + 3.1415926535897931 < 0.0) {
          d_a += 6.2831853071795862;
        }
      }

      varargin_1_data = d_a;
    }

    if (closestpoint_heading_idx - 1 >= 0) {
      positiveInput_data = ((varargin_1_data == 0.0) && (c_a +
        3.1415926535897931 > 0.0));
    }

    if (positiveInput_data && (closestpoint_heading_idx - 1 >= 0)) {
      varargin_1_data = 6.2831853071795862;
    }

    q_0 = c_a;
    if (rEQ0) {
      q_0 = varargin_1_data - 3.1415926535897931;
    }

    c_a = c_a_tmp - ((const real_T *)ssGetInputPortSignal(S, 0))[iy];
    d_a = d_a_tmp - ((const real_T *)ssGetInputPortSignal(S, 1))[iy];
    _rtB->dpsiref = D_psiref / (sqrt(c_a * c_a + d_a * d_a) / 3.0);
    if (rtIsNaN(q)) {
      D_psiref = (rtNaN);
    } else if (q < 0.0) {
      D_psiref = -1.0;
    } else {
      D_psiref = (q > 0.0);
    }

    D_psiref = (-0.0044721359549995789 * D_psiref * fmin(fabs(q),
      11.330974290709815) - q_0 * 0.096779556966603147) + _rtB->TransferFcn;
    if (D_psiref >= 0.78539816339744828) {
      D_psiref = 0.78539816339744828;
    }

    if (D_psiref <= -0.78539816339744828) {
      D_psiref = -0.78539816339744828;
    }

    D_psiref = -atan(tan(D_psiref * 0.93969262078590832) * 8.2191780821917817 /
                     -9.81);
    q = q_0;

    /* Outport: '<Root>/roll_ref' */
    ((real_T *)ssGetOutputPortSignal(S, 0))[0] = D_psiref;

    /* Outport: '<Root>/closest_point' incorporates:
     *  MATLAB Function: '<S1>/Trajectory controller'
     */
    ((real_T *)ssGetOutputPortSignal(S, 1))[0] = (real_T)(iy + 1) - 1.0;

    /* Outport: '<Root>/Outport1' */
    ((real_T *)ssGetOutputPortSignal(S, 2))[0] = D_psiref;
  }

  {
    nonContDerivSigCache_Trajectory_T *pNonContDerivSig =
      (nonContDerivSigCache_Trajectory_T *)ssGetLocalNonContDerivSig(S);
    if (memcmp(pNonContDerivSig->cache_0, (char *)&((B_Trajectory_T *)
          ssGetLocalBlockIO(S))->dpsiref,
               1*sizeof(real_T)) != 0) {
      (void) memcpy(pNonContDerivSig->cache_0, (char *)&((B_Trajectory_T *)
        ssGetLocalBlockIO(S))->dpsiref,
                    1*sizeof(real_T));
      ssSetSolverNeedsReset(S);
    }
  }

  UNUSED_PARAMETER(tid);
}

/* Update for root system: '<Root>' */
#define MDL_UPDATE

static void mdlUpdate(SimStruct *S, int_T tid)
{
  UNUSED_PARAMETER(tid);
}

/* Derivatives for root system: '<Root>' */
#define MDL_DERIVATIVES

static void mdlDerivatives(SimStruct *S)
{
  B_Trajectory_T *_rtB;
  XDot_Trajectory_T *_rtXdot;
  X_Trajectory_T *_rtX;
  _rtXdot = ((XDot_Trajectory_T *) ssGetdX(S));
  _rtX = ((X_Trajectory_T *) ssGetContStates(S));
  _rtB = ((B_Trajectory_T *) ssGetLocalBlockIO(S));

  /* Derivatives for TransferFcn: '<S1>/Transfer Fcn' */
  _rtXdot->TransferFcn_CSTATE = -6.04351329572925 * _rtX->TransferFcn_CSTATE;
  _rtXdot->TransferFcn_CSTATE += _rtB->dpsiref;
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
#include "Trajectory_mid.h"
#endif

/* Function to initialize sizes. */
static void mdlInitializeSizes(SimStruct *S)
{
  ssSetNumSampleTimes(S, 3);           /* Number of sample times */
  ssSetNumContStates(S, 1);            /* Number of continuous states */
  ssSetNumPeriodicContStates(S, 0);   /* Number of periodic continuous states */
  ssSetNumNonsampledZCs(S, 0);         /* Number of nonsampled ZCs */

  /* Number of output ports */
  if (!ssSetNumOutputPorts(S, 3))
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

  /* outport number: 1 */
  if (!ssSetOutputPortVectorDimension(S, 1, 1))
    return;
  if (ssGetSimMode(S) != SS_SIMMODE_SIZES_CALL_ONLY) {
    ssSetOutputPortDataType(S, 1, SS_DOUBLE);
  }

  ssSetOutputPortSampleTime(S, 1, 0.01);
  ssSetOutputPortOffsetTime(S, 1, 0.0);
  ssSetOutputPortOptimOpts(S, 1, SS_REUSABLE_AND_LOCAL);

  /* outport number: 2 */
  if (!ssSetOutputPortVectorDimension(S, 2, 1))
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
    ssSetInputPortRequiredContiguous(S, 0, true);
    ssSetInputPortDimensionsMode(S, 0, VARIABLE_DIMS_MODE);
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
    ssSetInputPortRequiredContiguous(S, 1, true);
    ssSetInputPortDimensionsMode(S, 1, VARIABLE_DIMS_MODE);
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
    ssSetInputPortRequiredContiguous(S, 2, true);
    ssSetInputPortDimensionsMode(S, 2, VARIABLE_DIMS_MODE);
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
    if (!ssSetInputPortVectorDimension(S, 3, 3))
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
  if (!ssSetNumDWork(S, 3)) {
    return;
  }

  /* '<Root>/Local_Xref': DWORK1 */
  ssSetDWorkName(S, 0, "DWORK0");
  ssSetDWorkWidth(S, 0, 1);
  ssSetDWorkDataType(S, 0, SS_INT32);

  /* '<Root>/Local_Yref': DWORK1 */
  ssSetDWorkName(S, 1, "DWORK1");
  ssSetDWorkWidth(S, 1, 1);
  ssSetDWorkDataType(S, 1, SS_INT32);

  /* '<Root>/Local_Psiref': DWORK1 */
  ssSetDWorkName(S, 2, "DWORK2");
  ssSetDWorkWidth(S, 2, 1);
  ssSetDWorkDataType(S, 2, SS_INT32);

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
  ssSetSampleTime(S, 0, 0.0);
  ssSetSampleTime(S, 1, 0.005);
  ssSetSampleTime(S, 2, 0.01);

  /* task offsets */
  ssSetOffsetTime(S, 0, 0.0);
  ssSetOffsetTime(S, 1, 0.0);
  ssSetOffsetTime(S, 2, 0.0);
}

#if defined(MATLAB_MEX_FILE)
#include "fixedpoint.c"
#include "simulink.c"
#else
#undef S_FUNCTION_NAME
#define S_FUNCTION_NAME                Trajectory_sf
#include "cg_sfun.h"
#endif                                 /* defined(MATLAB_MEX_FILE) */
