/*
 * Trajectory_sid.h
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

/* statically allocated instance data for model: Trajectory */
{
  {
    /* Local SimStruct for the generated S-Function */
    static LocalS slS;
    LocalS *lS = &slS;
    ssSetUserData(rts, lS);

    /* block I/O */
    {
      static B_Trajectory_T sfcnB;
      void *b = (real_T *) &sfcnB;
      ssSetLocalBlockIO(rts, b);
      (void) memset(b, 0,
                    sizeof(B_Trajectory_T));
    }

    {
      static nonContDerivSigCache_Trajectory_T nonContDerivSigs;
      void *pNonContDerivSig = (void *) &nonContDerivSigs;
      (void) memset((char *) pNonContDerivSig, 0,
                    sizeof(nonContDerivSigCache_Trajectory_T));
      ssSetLocalNonContDerivSig(rts, pNonContDerivSig);
    }

    /* model checksums */
    ssSetChecksumVal(rts, 0, 4084302161U);
    ssSetChecksumVal(rts, 1, 1749031085U);
    ssSetChecksumVal(rts, 2, 2623379078U);
    ssSetChecksumVal(rts, 3, 776112461U);
  }
}
