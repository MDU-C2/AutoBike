/**
 * PD control for transfering roll to steering angle rate.
 *
 * @param[in] rollReference Desired roll [rad]
 * @param[in] roll Current roll [rad]
 * @param[in] rollRate Current roll rate [rad/s]
 * @param[in] Kp PD proportionality constant [s⁻¹]
 * @param[in] Kd PD derivative constant [1]
 * @return Steering angle rate [rad/s]
 *
 * @author Ossian Eriksson
 */
extern double balancingController(double rollReference, double roll, double rollRate, double Kp, double Kd)
{
    return (Kp * ( rollReference - roll) - Kd * rollRate);
}
