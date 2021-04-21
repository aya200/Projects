/******************************************************
Course: ENEL 387 (Microcomputer systems design)
Project name: Line follower robot
Programmers: Ufuoma Aya & Lel Bartha
******************************************************/

#include <stdint.h>

#include "ADC.h"
#include "gpio.h"
#include "interrupts.h"
#include "LCD.h"
#include "motors.h"
#include "routines.h"
#include "sensors.h"
#include "stm32f10x.h"

int main(void)
{
		int adcVal = 0;
		clock_init();
		adc_init();
		LED_init();
		LCD_config();
		commandToLCD(LCD_CLR);
		pwm_clock();
		tim4pwm_init();
		motor_clock();
		Systic_Config();
		init_exti0();	
	
		while(go)
		{
				int i = 12000000;
				int u = 1200000;
			
				commandToLCD(LCD_8B2L);
				commandToLCD(LCD_LN1);
				commandToLCD(LCD_DCB);
				adc_restart(2); 
				adcVal = adc();
				stringToLCD("");
				status();

				commandToLCD(LCD_LN2);
				commandToLCD(LCD_DCB);
				adc_restart(1); 
				adcVal = adc();
				stringToLCD("Edges #");
				dataToLCD(lines);
				stringToLCD("    ");
				printDeg(adcVal);
				
				if (line_sensor() == 0x0000)
				{
						move_forward();
				}			
				else
				{
						wiggle();
				}
		}
		
		move_stop();	
		return (0);
}