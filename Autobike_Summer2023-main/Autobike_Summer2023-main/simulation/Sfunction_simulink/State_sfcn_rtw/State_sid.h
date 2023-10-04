/*
 * State_sid.h
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
 *
 * SOURCES: State_sf.c
 */

/* statically allocated instance data for model: State */
{
  {
    /* Local SimStruct for the generated S-Function */
    static LocalS slS;
    LocalS *lS = &slS;
    ssSetUserData(rts, lS);

    /* block I/O */
    {
      static B_State_T sfcnB;
      void *b = (real_T *) &sfcnB;
      ssSetLocalBlockIO(rts, b);
      (void) memset(b, 0,
                    sizeof(B_State_T));
    }

    /* model checksums */
    ssSetChecksumVal(rts, 0, 2938353751U);
    ssSetChecksumVal(rts, 1, 1690924806U);
    ssSetChecksumVal(rts, 2, 4230454994U);
    ssSetChecksumVal(rts, 3, 3035734691U);
  }
}
