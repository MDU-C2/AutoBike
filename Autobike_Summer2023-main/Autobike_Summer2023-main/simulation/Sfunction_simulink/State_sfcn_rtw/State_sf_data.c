/*
 * State_sf_data.c
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
#include "State_sf_private.h"

/* Constant parameters (default storage) */
const ConstP_State_T State_ConstP = {
  /* Expression: A_d
   * Referenced by: '<S1>/Linearized Bicycle Model on Constant Velocity'
   */
  { 1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0,
    0.03, 1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, -0.18883541867179982, 0.0,
    0.0, 0.0, 0.0, 0.0, 0.01, 1.0, 0.0, 0.0, 0.0, 0.012779819642688355,
    0.025745003309202964, 0.0, 0.15796260849502061, 1.0, 0.0, 0.01, 0.0, 0.0,
    0.0, 0.0, 0.0, 1.0 },

  /* Expression: B_d
   * Referenced by: '<S1>/Linearized Bicycle Model on Constant Velocity'
   */
  { 0.0, 0.0, 0.0, 0.0, 0.0246002303035387, 0.01, 0.0 },

  /* Expression: C1
   * Referenced by: '<S1>/Linearized Bicycle Model on Constant Velocity'
   */
  { 1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0,
    0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, -5.7500384985563038, 0.0, 0.0, 0.0,
    0.0, 0.0, 0.0, 0.0, 1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 4.327304910117947, 0.0,
    2.5745003309202965, 1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0 },

  /* Expression: C2
   * Referenced by: '<S1>/Linearized Bicycle Model on Constant Velocity'
   */
  { -5.7500384985563038, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 0.0, 0.0, 0.0,
    4.327304910117947, 0.0, 2.5745003309202965, 1.0, 0.0, 0.0, 0.0, 0.0, 0.0,
    1.0 },

  /* Expression: D1
   * Referenced by: '<S1>/Linearized Bicycle Model on Constant Velocity'
   */
  { 0.0, 0.0, -0.52890495152608208, 0.0, 0.0, 0.0, 0.0 },

  /* Expression: D2
   * Referenced by: '<S1>/Linearized Bicycle Model on Constant Velocity'
   */
  { -0.52890495152608208, 0.0, 0.0, 0.0, 0.0 },

  /* Expression: T
   * Referenced by: '<S1>/Linearized Bicycle Model on Constant Velocity'
   */
  { 1.0, 0.0, 0.0, 0.0, 1.0, 0.0, 0.0, 0.0, 1.0 },

  /* Expression: [initial_state_estimate.x initial_state_estimate.y initial_state_estimate.heading initial_state.roll initial_state.roll_rate initial_state.steering v]
   * Referenced by: '<S1>/Delay'
   */
  { 40.0, 0.0, 1.5958275963228663, 0.0, 0.0, 0.0, 3.0 },

  /* Expression: Kalman_gain1
   * Referenced by: '<S1>/Constant2'
   */
  { 0.618055292830545, 0.0, 0.0, 0.0, 0.0, 0.0, 0.001055689088936086, 0.0,
    0.64745138884053977, 0.60897542810820016, 7.08066702310684E-5, 0.0,
    8.2452072001038963E-5, 0.0, 0.0, 9.5178403845486961E-5,
    9.9305251439791878E-5, 0.0, 0.032064074734303588, 0.011851394868651378, 0.0,
    0.0, 0.0, 2.2710192934524325E-5, 0.0063112244956454715, 0.6182169928846214,
    0.00014510570538883084, 0.0, 0.0, 0.0039180491671098275,
    0.0082769047161482551, 0.21139476903659082, 0.0059397185237092514,
    0.28794319456512862, 0.0, 0.0, 0.0015218678048136991, 0.0032149557786963086,
    0.0821109892656429, 0.0023071344961086088, 0.11184430279804954, 0.0,
    0.0072359948139116984, 0.0, 0.0, 0.0, 0.0, 0.0, 0.61803057249756288 },

  /* Expression: Kalman_gain2
   * Referenced by: '<S1>/Constant4'
   */
  { 0.0, 0.03206407418448793, 0.011851383420001353, 0.0, 0.00631122533521145,
    0.61821699293311227, 0.00014510668217535848, 0.0, 0.21139481057238632,
    0.0059397208368232018, 0.28794324291237383, 0.0, 0.08211100539917969,
    0.0023071353945796581, 0.11184432157732291, 0.0, 0.0, 0.0, 0.0,
    0.6180339887498949 }
};
