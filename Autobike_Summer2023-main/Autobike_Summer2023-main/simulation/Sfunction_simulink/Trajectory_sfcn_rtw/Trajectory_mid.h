/*
 * Trajectory_mid.h
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
 *
 * SOURCES: Trajectory_sf.c
 */

#if defined(MATLAB_MEX_FILE) || defined(RT_MALLOC)

static int_T RegNumInputPorts(SimStruct *S, int_T nInputPorts)
{
  _ssSetNumInputPorts(S,nInputPorts);
  return true;
}

static int_T RegNumOutputPorts(SimStruct *S, int_T nOutputPorts)
{
  _ssSetNumOutputPorts(S,nOutputPorts);
  return true;
}

static int_T FcnSetErrorStatus(const SimStruct *S, DTypeId arg2)
{
  static char msg[256];
  if (strlen(ssGetModelName(S)) < 128) {
    sprintf(msg,
            "S-function %s does not have a tlc file. It cannot use macros that access regDataType field in simstruct.",
            ssGetModelName(S));
  } else {
    sprintf(msg,
            "A S-function does not have a tlc file. It cannot use macros that access regDataType field in simstruct.");
  }

  ssSetErrorStatus(S, msg);
  UNUSED_PARAMETER(arg2);
  return 0;
}

static void * FcnSetErrorStatusWithReturnPtr(const SimStruct *S, DTypeId arg2)
{
  FcnSetErrorStatus(S,0);
  UNUSED_PARAMETER(arg2);
  return 0;
}

static int_T FcnSetErrorStatusWithArgPtr(const SimStruct *S, const void* arg2)
{
  FcnSetErrorStatus(S,0);
  UNUSED_PARAMETER(arg2);
  return 0;
}

#endif

/* Instance data for model: Trajectory */
void *Trajectory_malloc(SimStruct *rts)
{
  /* Local SimStruct for the generated S-Function */
  LocalS *lS = (LocalS *) malloc(sizeof(LocalS));
  ss_VALIDATE_MEMORY(rts,lS);
  (void) memset((char *) lS, 0,
                sizeof(LocalS));
  ssSetUserData(rts, lS);

  /* block I/O */
  {
    void *b = malloc(sizeof(B_Trajectory_T));
    ss_VALIDATE_MEMORY(rts,b);
    ssSetLocalBlockIO(rts, b);
    (void) memset(b, 0,
                  sizeof(B_Trajectory_T));
  }

  {
    void *pNonContDerivSig = (void *)malloc(sizeof
      (nonContDerivSigCache_Trajectory_T));
    ss_VALIDATE_MEMORY(rts,pNonContDerivSig);
    (void) memset((char *) pNonContDerivSig, 0,
                  sizeof(nonContDerivSigCache_Trajectory_T));
    ssSetLocalNonContDerivSig(rts, pNonContDerivSig);
  }

  /* model checksums */
  ssSetChecksumVal(rts, 0, 4084302161U);
  ssSetChecksumVal(rts, 1, 1749031085U);
  ssSetChecksumVal(rts, 2, 2623379078U);
  ssSetChecksumVal(rts, 3, 776112461U);
  return (NULL);
}
