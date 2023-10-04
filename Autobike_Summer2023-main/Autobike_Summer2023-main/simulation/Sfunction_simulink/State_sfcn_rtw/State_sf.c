/*
 * State_sf.c
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

#include "State_sf.h"
#include "rtwtypes.h"
#include <math.h>
#include <emmintrin.h>
#include "rt_nonfinite.h"
#include "State_sf_private.h"
#include "simstruc.h"
#include "fixedpoint.h"
#if defined(RT_MALLOC) || defined(MATLAB_MEX_FILE)

extern void *State_malloc(SimStruct *S);

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
    int32_T i;

    /* InitializeConditions for Delay: '<S1>/Delay' */
    for (i = 0; i < 7; i++) {
      ((real_T *)ssGetDWork(S, 0))[i] = State_ConstP.Delay_InitialCondition[i];
    }

    /* End of InitializeConditions for Delay: '<S1>/Delay' */

    /* InitializeConditions for UnitDelay: '<S2>/Output' */
    ((uint8_T *)ssGetDWork(S, 1))[0] = 0U;
  } else {
    int32_T i;

    /* InitializeConditions for Delay: '<S1>/Delay' */
    for (i = 0; i < 7; i++) {
      ((real_T *)ssGetDWork(S, 0))[i] = State_ConstP.Delay_InitialCondition[i];
    }

    /* End of InitializeConditions for Delay: '<S1>/Delay' */

    /* InitializeConditions for UnitDelay: '<S2>/Output' */
    ((uint8_T *)ssGetDWork(S, 1))[0] = 0U;
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

  State_malloc(S);
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
  __m128d tmp_3;
  B_State_T *_rtB;
  real_T Est_States_l[7];
  real_T Est_states_l[7];
  real_T y_l[7];
  real_T y_l_0[7];
  real_T rtb_Switch[5];
  real_T gyro_corr[3];
  real_T tmp[3];
  real_T Est_states_l_tmp;
  real_T q_0;
  real_T tmp_0;
  real_T tmp_1;
  real_T tmp_2;
  real_T varargin_1_data;
  int32_T i;
  int32_T trueCount;
  boolean_T positiveInput_data;
  boolean_T q;
  _rtB = ((B_State_T *) ssGetLocalBlockIO(S));

  /* MATLAB Function: '<S1>/Linearized Bicycle Model on Constant Velocity' incorporates:
   *  Constant: '<S1>/Constant'
   *  Delay: '<S1>/Delay'
   */
  Est_states_l_tmp = sin(((real_T *)ssGetDWork(S, 0))[2]);
  q_0 = cos(((real_T *)ssGetDWork(S, 0))[2]);
  Est_states_l[0] = ((real_T *)ssGetDWork(S, 0))[0] * q_0 + ((real_T *)
    ssGetDWork(S, 0))[1] * Est_states_l_tmp;
  Est_states_l[1] = -((real_T *)ssGetDWork(S, 0))[0] * Est_states_l_tmp +
    ((real_T *)ssGetDWork(S, 0))[1] * q_0;
  Est_states_l[2] = 0.0;
  Est_states_l[3] = ((real_T *)ssGetDWork(S, 0))[3];
  Est_states_l[4] = ((real_T *)ssGetDWork(S, 0))[4];
  Est_states_l[5] = ((real_T *)ssGetDWork(S, 0))[5];
  Est_states_l[6] = ((real_T *)ssGetDWork(S, 0))[6];
  y_l[0] = (real_T)(*((const real_T **)ssGetInputPortSignalPtrs(S, 1))[0] * q_0)
    + *((const real_T **)ssGetInputPortSignalPtrs(S, 1))[1] * Est_states_l_tmp;
  y_l[1] = -*((const real_T **)ssGetInputPortSignalPtrs(S, 1))[0] *
    Est_states_l_tmp + *((const real_T **)ssGetInputPortSignalPtrs(S, 1))[1] *
    q_0;
  y_l[5] = *((const real_T **)ssGetInputPortSignalPtrs(S, 1))[5] *
    0.93969262078590832;
  y_l[6] = *((const real_T **)ssGetInputPortSignalPtrs(S, 1))[6];
  y_l[1] -= 0.0 * sin(((real_T *)ssGetDWork(S, 0))[3]);
  tmp_0 = *((const real_T **)ssGetInputPortSignalPtrs(S, 1))[3];
  tmp_1 = *((const real_T **)ssGetInputPortSignalPtrs(S, 1))[4];
  tmp_2 = *((const real_T **)ssGetInputPortSignalPtrs(S, 1))[2];
  for (i = 0; i <= 0; i += 2) {
    __m128d tmp_4;
    __m128d tmp_5;
    __m128d tmp_6;

    /* MATLAB Function: '<S1>/Linearized Bicycle Model on Constant Velocity' */
    tmp_3 = _mm_set1_pd(0.0);
    tmp_4 = _mm_loadu_pd(&State_ConstP.LinearizedBicycleModelonCons_eg[i + 6]);
    tmp_5 = _mm_loadu_pd(&State_ConstP.LinearizedBicycleModelonCons_eg[i + 3]);
    tmp_6 = _mm_loadu_pd(&State_ConstP.LinearizedBicycleModelonCons_eg[i]);
    _mm_storeu_pd(&gyro_corr[i], _mm_add_pd(_mm_mul_pd(tmp_4, _mm_set1_pd(tmp_1)),
      _mm_add_pd(_mm_mul_pd(tmp_5, tmp_3), _mm_add_pd(_mm_mul_pd(tmp_6,
      _mm_set1_pd(tmp_0)), tmp_3))));
    _mm_storeu_pd(&tmp[i], _mm_add_pd(_mm_mul_pd(tmp_4, tmp_3), _mm_add_pd
      (_mm_mul_pd(tmp_5, _mm_set1_pd(tmp_2)), _mm_add_pd(_mm_mul_pd(tmp_6, tmp_3),
      tmp_3))));
  }

  /* MATLAB Function: '<S1>/Linearized Bicycle Model on Constant Velocity' incorporates:
   *  Constant: '<S1>/Constant2'
   *  Constant: '<S1>/Constant4'
   *  Delay: '<S1>/Delay'
   *  UnitDelay: '<S2>/Output'
   */
  for (i = 2; i < 3; i++) {
    real_T gyro_corr_tmp;
    real_T gyro_corr_tmp_0;
    gyro_corr_tmp = State_ConstP.LinearizedBicycleModelonCons_eg[i + 3];
    gyro_corr_tmp_0 = State_ConstP.LinearizedBicycleModelonCons_eg[i + 6];
    gyro_corr[i] = (gyro_corr_tmp * 0.0 +
                    State_ConstP.LinearizedBicycleModelonCons_eg[i] * tmp_0) +
      gyro_corr_tmp_0 * tmp_1;
    tmp[i] = (gyro_corr_tmp * tmp_2 +
              State_ConstP.LinearizedBicycleModelonCons_eg[i] * 0.0) +
      gyro_corr_tmp_0 * 0.0;
  }

  y_l[2] = tmp[1];
  y_l[3] = gyro_corr[0];
  y_l[4] = gyro_corr[2];
  for (i = 0; i < 7; i++) {
    tmp_0 = 0.0;
    for (trueCount = 0; trueCount < 7; trueCount++) {
      tmp_0 += State_ConstP.LinearizedBicycleModelonConstan[7 * trueCount + i] *
        Est_states_l[trueCount];
    }

    Est_States_l[i] = State_ConstP.LinearizedBicycleModelonConst_e[i] * *((const
      real_T **)ssGetInputPortSignalPtrs(S, 0))[0] + tmp_0;
  }

  for (i = 0; i < 7; i++) {
    Est_states_l[i] = 0.0;
  }

  if (((uint8_T *)ssGetDWork(S, 1))[0] == 0) {
    for (i = 0; i < 7; i++) {
      tmp_0 = 0.0;
      for (trueCount = 0; trueCount < 7; trueCount++) {
        tmp_0 += State_ConstP.LinearizedBicycleModelonConst_h[7 * trueCount + i]
          * Est_States_l[trueCount];
      }

      y_l_0[i] = y_l[i] - (State_ConstP.LinearizedBicycleModelonConst_i[i] * *((
        const real_T **)ssGetInputPortSignalPtrs(S, 0))[0] + tmp_0);
    }

    for (i = 0; i < 7; i++) {
      tmp_0 = 0.0;
      for (trueCount = 0; trueCount < 7; trueCount++) {
        tmp_0 += State_ConstP.Constant2_Value[7 * trueCount + i] *
          y_l_0[trueCount];
      }

      Est_states_l[i] = Est_States_l[i] + tmp_0;
    }
  } else {
    Est_states_l[0] = Est_States_l[0];
    Est_states_l[1] = Est_States_l[1];
    Est_states_l[2] = Est_States_l[2];
    for (i = 0; i <= 2; i += 2) {
      tmp_3 = _mm_loadu_pd(&y_l[i + 2]);
      _mm_storeu_pd(&rtb_Switch[i], _mm_sub_pd(tmp_3, _mm_add_pd(_mm_add_pd
        (_mm_add_pd(_mm_add_pd(_mm_mul_pd(_mm_loadu_pd
        (&State_ConstP.LinearizedBicycleModelonCons_ek[i + 5]), _mm_set1_pd
        (Est_States_l[4])), _mm_mul_pd(_mm_loadu_pd
        (&State_ConstP.LinearizedBicycleModelonCons_ek[i]), _mm_set1_pd
        (Est_States_l[3]))), _mm_mul_pd(_mm_loadu_pd
        (&State_ConstP.LinearizedBicycleModelonCons_ek[i + 10]), _mm_set1_pd
        (Est_States_l[5]))), _mm_mul_pd(_mm_loadu_pd
        (&State_ConstP.LinearizedBicycleModelonCons_ek[i + 15]), _mm_set1_pd
        (Est_States_l[6]))), _mm_mul_pd(_mm_loadu_pd
        (&State_ConstP.LinearizedBicycleModelonConst_p[i]), _mm_set1_pd(*((const
        real_T **)ssGetInputPortSignalPtrs(S, 0))[0])))));
    }

    for (i = 4; i < 5; i++) {
      rtb_Switch[i] = y_l[i + 2] -
        ((((State_ConstP.LinearizedBicycleModelonCons_ek[i + 5] * Est_States_l[4]
            + State_ConstP.LinearizedBicycleModelonCons_ek[i] * Est_States_l[3])
           + State_ConstP.LinearizedBicycleModelonCons_ek[i + 10] *
           Est_States_l[5]) + State_ConstP.LinearizedBicycleModelonCons_ek[i +
          15] * Est_States_l[6]) +
         State_ConstP.LinearizedBicycleModelonConst_p[i] * *((const real_T **)
          ssGetInputPortSignalPtrs(S, 0))[0]);
    }

    for (i = 0; i < 4; i++) {
      tmp_0 = 0.0;
      for (trueCount = 0; trueCount < 5; trueCount++) {
        tmp_0 += State_ConstP.Constant4_Value[(trueCount << 2) + i] *
          rtb_Switch[trueCount];
      }

      Est_states_l[i + 3] = Est_States_l[i + 3] + tmp_0;
    }
  }

  _rtB->Est_states[2] = ((real_T *)ssGetDWork(S, 0))[2] + Est_states_l[2];
  _rtB->Est_states[0] = Est_states_l[0] * q_0 - Est_states_l[1] *
    Est_states_l_tmp;
  _rtB->Est_states[1] = Est_states_l[0] * Est_states_l_tmp + Est_states_l[1] *
    q_0;
  _rtB->Est_states[3] = Est_states_l[3];
  _rtB->Est_states[4] = Est_states_l[4];
  _rtB->Est_states[5] = Est_states_l[5];
  _rtB->Est_states[6] = Est_states_l[6];
  q = ((_rtB->Est_states[2] < -3.1415926535897931) || (_rtB->Est_states[2] >
        3.1415926535897931));
  trueCount = 0;
  if (q) {
    trueCount = 1;
  }

  for (i = 0; i < trueCount; i++) {
    if (rtIsNaN(_rtB->Est_states[2] + 3.1415926535897931) || rtIsInf
        (_rtB->Est_states[2] + 3.1415926535897931)) {
      Est_states_l_tmp = (rtNaN);
    } else if (_rtB->Est_states[2] + 3.1415926535897931 == 0.0) {
      Est_states_l_tmp = 0.0;
    } else {
      boolean_T rEQ0;
      Est_states_l_tmp = fmod(_rtB->Est_states[2] + 3.1415926535897931,
        6.2831853071795862);
      rEQ0 = (Est_states_l_tmp == 0.0);
      if (!rEQ0) {
        q_0 = fabs((_rtB->Est_states[2] + 3.1415926535897931) /
                   6.2831853071795862);
        rEQ0 = !(fabs(q_0 - floor(q_0 + 0.5)) > 2.2204460492503131E-16 * q_0);
      }

      if (rEQ0) {
        Est_states_l_tmp = 0.0;
      } else if (_rtB->Est_states[2] + 3.1415926535897931 < 0.0) {
        Est_states_l_tmp += 6.2831853071795862;
      }
    }

    varargin_1_data = Est_states_l_tmp;
  }

  for (i = 0; i < trueCount; i++) {
    positiveInput_data = ((varargin_1_data == 0.0) && (_rtB->Est_states[2] +
      3.1415926535897931 > 0.0));
  }

  if (positiveInput_data && (trueCount - 1 >= 0)) {
    varargin_1_data = 6.2831853071795862;
  }

  if (q) {
    _rtB->Est_states[2] = varargin_1_data - 3.1415926535897931;
  }

  /* Switch: '<S1>/Switch' */
  for (i = 0; i < 5; i++) {
    rtb_Switch[i] = _rtB->Est_states[i];
  }

  /* End of Switch: '<S1>/Switch' */

  /* Outport: '<Root>/Estimated_X//Y//Psi' */
  ((real_T *)ssGetOutputPortSignal(S, 0))[0] = rtb_Switch[0];
  ((real_T *)ssGetOutputPortSignal(S, 0))[1] = rtb_Switch[1];
  ((real_T *)ssGetOutputPortSignal(S, 0))[2] = rtb_Switch[2];

  /* Outport: '<Root>/Estimated_Roll' */
  ((real_T *)ssGetOutputPortSignal(S, 1))[0] = rtb_Switch[3];

  /* Outport: '<Root>/Estimated_Roll_Rate' */
  ((real_T *)ssGetOutputPortSignal(S, 2))[0] = rtb_Switch[4];

  /* Switch: '<S5>/FixPt Switch' incorporates:
   *  Constant: '<S4>/FixPt Constant'
   *  Sum: '<S4>/FixPt Sum1'
   *  UnitDelay: '<S2>/Output'
   */
  if ((uint8_T)(((uint8_T *)ssGetDWork(S, 1))[0] + 1) > 9) {
    /* Switch: '<S5>/FixPt Switch' incorporates:
     *  Constant: '<S5>/Constant'
     */
    _rtB->FixPtSwitch = 0U;
  } else {
    /* Switch: '<S5>/FixPt Switch' */
    _rtB->FixPtSwitch = (uint8_T)(((uint8_T *)ssGetDWork(S, 1))[0] + 1);
  }

  /* End of Switch: '<S5>/FixPt Switch' */
  UNUSED_PARAMETER(tid);
}

/* Update for root system: '<Root>' */
#define MDL_UPDATE

static void mdlUpdate(SimStruct *S, int_T tid)
{
  B_State_T *_rtB;
  int32_T i;
  _rtB = ((B_State_T *) ssGetLocalBlockIO(S));

  /* Update for Delay: '<S1>/Delay' */
  for (i = 0; i < 7; i++) {
    ((real_T *)ssGetDWork(S, 0))[i] = _rtB->Est_states[i];
  }

  /* End of Update for Delay: '<S1>/Delay' */

  /* Update for UnitDelay: '<S2>/Output' */
  ((uint8_T *)ssGetDWork(S, 1))[0] = _rtB->FixPtSwitch;
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
#include "State_mid.h"
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
  if (!ssSetOutputPortVectorDimension(S, 0, 3))
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
  if (!ssSetNumInputPorts(S, 2))
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
    if (!ssSetInputPortVectorDimension(S, 1, 7))
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

  ssSetRTWGeneratedSFcn(S, 1);         /* Generated S-function */

  /* DWork */
  if (!ssSetNumDWork(S, 2)) {
    return;
  }

  /* '<S1>/Delay': DSTATE */
  ssSetDWorkName(S, 0, "DWORK0");
  ssSetDWorkWidth(S, 0, 7);
  ssSetDWorkUsedAsDState(S, 0, 1);

  /* '<S2>/Output': DSTATE */
  ssSetDWorkName(S, 1, "DWORK1");
  ssSetDWorkWidth(S, 1, 1);
  ssSetDWorkDataType(S, 1, SS_UINT8);
  ssSetDWorkUsedAsDState(S, 1, 1);

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
#define S_FUNCTION_NAME                State_sf
#include "cg_sfun.h"
#endif                                 /* defined(MATLAB_MEX_FILE) */
