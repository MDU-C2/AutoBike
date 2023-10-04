/*
 * Selection_sid.h
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
 *
 * SOURCES: Selection_sf.c
 */

/* statically allocated instance data for model: Selection */
{
  {
    /* Local SimStruct for the generated S-Function */
    static LocalS slS;
    LocalS *lS = &slS;
    ssSetUserData(rts, lS);

    /* block I/O */
    {
      static B_Selection_T sfcnB;
      void *b = (real_T *) &sfcnB;
      ssSetLocalBlockIO(rts, b);
      (void) memset(b, 0,
                    sizeof(B_Selection_T));
    }

    /* model checksums */
    ssSetChecksumVal(rts, 0, 3214386611U);
    ssSetChecksumVal(rts, 1, 3407974051U);
    ssSetChecksumVal(rts, 2, 2906843629U);
    ssSetChecksumVal(rts, 3, 169405482U);
  }
}
