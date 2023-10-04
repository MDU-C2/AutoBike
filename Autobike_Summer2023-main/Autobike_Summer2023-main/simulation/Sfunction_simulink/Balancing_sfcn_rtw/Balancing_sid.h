/*
 * Balancing_sid.h
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
 *
 * SOURCES: Balancing_sf.c
 */

/* statically allocated instance data for model: Balancing */
{
  {
    /* Local SimStruct for the generated S-Function */
    static LocalS slS;
    LocalS *lS = &slS;
    ssSetUserData(rts, lS);

    /* block I/O */
    {
      static B_Balancing_T sfcnB;
      void *b = (real_T *) &sfcnB;
      ssSetLocalBlockIO(rts, b);
      (void) memset(b, 0,
                    sizeof(B_Balancing_T));
    }

    /* model checksums */
    ssSetChecksumVal(rts, 0, 1489270631U);
    ssSetChecksumVal(rts, 1, 3723046663U);
    ssSetChecksumVal(rts, 2, 953378781U);
    ssSetChecksumVal(rts, 3, 4235571746U);
  }
}
