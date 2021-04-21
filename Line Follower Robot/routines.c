#include "stm32f10x.h"
#include "gpio.h"
#include "sensors.h"
#include "motors.h"
#include "routines.h"

void wiggle()
{
		move_backward();
		delay(1000000);
		
		for (int i = 200000; 1; i = i + 1.5*200000)
		{		
				sharp_right();		
				delay(i);
				move_stop();
				
				if (line_sensor() == 0x0000)
				{
						return;
				}
				
				sharp_left();		
				delay(1.15*i);		
				move_stop();
				
				if (line_sensor() == 0x0000)
				{
						return;
				}
		}	
}

void line_following()
{
		while(1)
		{
				if (line_sensor() == 0x0000)
				{
					move_forward();
				}		
				else
				{
					wiggle();
				}		
		}	
}