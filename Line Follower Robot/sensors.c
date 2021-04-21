#include "sensors.h"

#include "gpio.h"
#include "stm32f10x.h"

uint16_t right_sensor(void)
{
    if((GPIOB->IDR & GPIO_IDR_IDR10) == 0)
    {
        return 0xFFFF;
		}
    else
    {
        return 0x0000;		
		}	
}

uint16_t left_sensor(void)
{
    if((GPIOB->IDR & GPIO_IDR_IDR11) == 0)
    {
        return 0xFFFF;
		}
    else
    {
        return 0x0000;
		}		
}

uint16_t rear_sensor(void)
{
    if((GPIOB->IDR & GPIO_IDR_IDR13) == 0)
    {
        return 0xFFFF;
		}
    else
    {
        return 0x0000;
		}		
}

uint16_t front_sensor(void)
{
    if((GPIOB->IDR & GPIO_IDR_IDR14) == 0)
    {
        return 0xFFFF;
		}
    else
    {
        return 0x0000;
		}		
}	

uint16_t line_sensor(void)
{
    if((GPIOB->IDR & GPIO_IDR_IDR12) == 0)
    {
        return 0xFFFF;
		}
    else
    {
        return 0x0000;
		}	
}
