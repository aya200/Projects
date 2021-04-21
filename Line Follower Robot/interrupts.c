#include "interrupts.h"

#include "gpio.h"
#include "motors.h"
#include "routines.h"
#include "stm32f10x.h"

//12000000 = 1 second
int lines = 0x30;
int target = 0;
int go = 1;

void Systic_Config(void)
{
		SysTick->CTRL = 0x0;			                 //SysTick is disabled
		SysTick->VAL = 0x0;				                 //Clear the counter
		SysTick->LOAD = 12000000;			             //amount of time to count down
		SysTick->CTRL = 0x07;					             //Free running clock, enable the interrupt, enable systick
}

void SysTick_Handler(void)
{
		if (lines <= 0x32 && lines > 0x30)
		{
				target = 1;	
		}
		else if (lines <= 0x35 && lines > 0x32)
		{
				target = 2;
		}
		else if (lines >= 0x36)
		{
				target = 3;
		}
	
		lines = 0x30;			                                  // What happens when the sysTick clock reaches 0 in the countdown	
}

void init_exti0(void)
{
		RCC->APB2ENR |= RCC_APB2ENR_AFIOEN;
		
		AFIO->EXTICR[3] |= AFIO_EXTICR4_EXTI14_PB;          // Setting the port for the interrupt (set to port B)
		EXTI->IMR |= EXTI_IMR_MR14;								          // Unmasking the input on pin 14
		EXTI->RTSR |= EXTI_RTSR_TR14;							          // Setting rising or falling edge on pin 14
		
		AFIO->EXTICR[2] |= AFIO_EXTICR3_EXTI10_PB;          // Setting the port for the interrupt (set to port B)
		EXTI->IMR |= EXTI_IMR_MR10;								          // Unmasking the input on pin 10
		EXTI->FTSR |= EXTI_FTSR_TR10;							          // Setting rising or falling edge on pin 10
		
		AFIO->EXTICR[2] |= AFIO_EXTICR3_EXTI11_PB;          // Setting the port for the interrupt (set to port B)
		EXTI->IMR |= EXTI_IMR_MR11;								          // Unmasking the input on pin 10
		EXTI->RTSR |= EXTI_RTSR_TR11;                       // Setting rising or falling edge on pin 10
		
		NVIC_EnableIRQ(EXTI15_10_IRQn);					            // Enables the interrupts on pins 15 to 10
}

void EXTI15_10_IRQHandler(void)
{
		if (EXTI->PR & EXTI_PR_PR10)				                // Clear the pending interrupt bit
		{
				delay(3000);		
				Systic_Config();
				lines++;
				
				EXTI->PR |= EXTI_PR_PR10;
		}
	
		if (EXTI->PR & EXTI_PR_PR14)				                // Clear the pending interrupt bit
		{
				move_backward();
				delay(1500000);
				left();
			
				EXTI->PR |= EXTI_PR_PR10;	
		}
		
		if (EXTI->PR & EXTI_PR_PR11)
		{
				move_stop();
				EXTI->IMR &= ~EXTI_IMR_MR15;
				EXTI->IMR &= ~EXTI_IMR_MR12;
				
				go = 0;
		}
}