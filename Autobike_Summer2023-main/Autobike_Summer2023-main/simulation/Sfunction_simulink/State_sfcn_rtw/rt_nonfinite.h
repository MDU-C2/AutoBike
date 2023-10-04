

        /*
    * rt_nonfinite.h
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


    #ifndef RTW_HEADER_rt_nonfinite_h_
    #define RTW_HEADER_rt_nonfinite_h_



    
#include <stddef.h>

#include "rtwtypes.h"


    

    

    

    

    

    

    

    

    

    

    

    

    

    

        #define NOT_USING_NONFINITE_LITERALS 1

    
                extern real_T rtInf;


                extern real_T rtMinusInf;


                extern real_T rtNaN;


                extern real32_T rtInfF;


                extern real32_T rtMinusInfF;


                extern real32_T rtNaNF;



        extern void rt_InitInfAndNaN(size_t realSize);
            extern boolean_T rtIsInf(real_T value);
            extern boolean_T rtIsInfF(real32_T value);
            extern boolean_T rtIsNaN(real_T value);
            extern boolean_T rtIsNaNF(real32_T value);
    
    typedef struct  {
    struct {
        uint32_T wordH;
        uint32_T wordL;
    } words;
    } BigEndianIEEEDouble;

    typedef struct  {
    struct {
        uint32_T wordL;
        uint32_T wordH;
    } words;
    } LittleEndianIEEEDouble;

    typedef struct  {
    union {
        real32_T wordLreal;
        uint32_T wordLuint;
    } wordL;
    } IEEESingle;

    


    

    

    

    

    

    #endif /* RTW_HEADER_rt_nonfinite_h_ */
