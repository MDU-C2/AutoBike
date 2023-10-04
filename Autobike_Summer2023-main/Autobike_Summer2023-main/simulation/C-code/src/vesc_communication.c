#include "../submodules/bldc_uart_comm_stm32f4_discovery/bldc_interface.h"
#include "../submodules/bldc_uart_comm_stm32f4_discovery/bldc_interface_uart.h"
#include <stdint.h>
#include <string.h>

static unsigned char packetPascalString[256] = {0};
static mc_values values = {0};

/**
 * Argument to bldc_interface_uart_init
 *
 * Captures an outgoing packet and stores it as a Pascal string. Pascal strings are used instead of C strings since C
 * strings cannot hold null bytes.
 *
 * @see https://www.ni.com/docs/en-US/bundle/labview/page/lvexcodeconcepts/array_and_string_options.html
 *
 * @author Ossian Eriksson
 */
static void sendPacket(unsigned char *data, unsigned int len)
{
    if (len < 256)
    {
        packetPascalString[0] = len;
        memcpy(&packetPascalString[1], data, len);
    }
    else
    {
        packetPascalString[0] = 0;
    }
}

/**
 * Argument to bldc_interface_set_rx_value_func
 *
 * @author Ossian Eriksson
 */
static void rxValue(mc_values *v) { values = *v; }

/**
 * Initializes the VESC. You should call this function before calling any other functions from this library.
 *
 * @author Ossian Eriksson
 */
extern void VESCInit()
{
    bldc_interface_uart_init(sendPacket);
    bldc_interface_set_rx_value_func(rxValue);
}

/**
 * Process recieved UART bytes
 *
 * @param[in] bytes The recieved bytes
 * @param[in] length The number of bytes
 *
 * @author Ossian Eriksson
 */
extern void VESCRecieveBytes(unsigned char *bytes, uint32_t length)
{
    for (uint32_t i = 0; i < length; i++)
    {
        bldc_interface_uart_process_byte(bytes[i]);
    }
}

/**
 * Returns UART package requesting values
 *
 * NOTE: The returned string is a Pascal string, make sure to select this option when configuring the return type from
 * within the "Call Library Function Node" in LabVIEW.
 *
 * @return UART package as Pascal string
 *
 * @see https://www.ni.com/docs/en-US/bundle/labview/page/lvexcodeconcepts/array_and_string_options.html
 *
 * @author Ossian Eriksson
 */
extern unsigned char *VESCGetValuesPackage()
{
    bldc_interface_get_values();
    return packetPascalString;
}

/**
 * Returns UART package for setting motor RPM
 *
 * NOTE: The returned string is a Pascal string, make sure to select this option when configuring the return type from
 * within the "Call Library Function Node" in LabVIEW.
 *
 * @param[in] RPM Desired motor RPM [rpm]
 * @return UART package as Pascal string
 *
 * @see https://www.ni.com/docs/en-US/bundle/labview/page/lvexcodeconcepts/array_and_string_options.html
 *
 * @author Ossian Eriksson
 */
extern unsigned char *VESCSetRPMPackage(int32_t RPM)
{
    bldc_interface_set_rpm(RPM);
    return packetPascalString;
}

/**
 * Gets current values
 *
 * @param[out] RPM Output for motor RPM [rpm]
 * @param[out] currentIn Output for motor controller input current [A]
 * @param[out] currentMotor Output for motor current [A]
 * @param[out] tempMOS Output for MOSFET temperature [°C]
 *
 * @author Ossian Eriksson
 */
extern void VESCGetValues(double *RPM, double *currentIn, double *currentMotor, double *tempMOS)
{
    *RPM = values.rpm;
    *currentIn = values.current_in;
    *currentMotor = values.current_motor;
    *tempMOS = values.temp_mos;
}
