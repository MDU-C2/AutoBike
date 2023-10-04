/*
 * Trajectory_sf_private.h
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

#ifndef RTW_HEADER_Trajectory_sf_private_h_
#define RTW_HEADER_Trajectory_sf_private_h_
#include "rtwtypes.h"
#include "multiword_types.h"
#include "Trajectory_sf_types.h"
#if !defined(ss_VALIDATE_MEMORY)
#define ss_VALIDATE_MEMORY(S, ptr)     if(!(ptr)) {\
 ssSetErrorStatus(S, RT_MEMORY_ALLOCATION_ERROR);\
 }
#endif

#if !defined(rt_FREE)
#if !defined(_WIN32)
#define rt_FREE(ptr)                   if((ptr) != (NULL)) {\
 free((ptr));\
 (ptr) = (NULL);\
 }
#else

/* Visual and other windows compilers declare free without const */
#define rt_FREE(ptr)                   if((ptr) != (NULL)) {\
 free((void *)(ptr));\
 (ptr) = (NULL);\
 }
#endif
#endif

#if defined(MULTITASKING)
#  error Model (Trajectory_sf) was built in \
SingleTasking solver mode, however the MULTITASKING define is \
present. If you have multitasking (e.g. -DMT or -DMULTITASKING) \
defined on the Code Generation page of Simulation parameter dialog, please \
remove it and on the Solver page, select solver mode \
MultiTasking. If the Simulation parameter dialog is configured \
correctly, please verify that your template makefile is \
configured correctly.
#endif
#endif                                 /* RTW_HEADER_Trajectory_sf_private_h_ */
