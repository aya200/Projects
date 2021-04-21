#include "ADC.h"

#include "stm32f10x.h"

void adc_init (void) 
{
		RCC->APB2ENR |=  RCC_APB2ENR_ADC1EN;          // Enable ADC clock 
		ADC1->CR2 |= 0x0005;				                  // Cal bit and ON bit 
		ADC1->SMPR2 |= ADC_SMPR2_SMP0; 			          // Use the max rate 239.5 cycles 
}

void adc_restart (int PA) 
{
		ADC1->SMPR2 |= ADC_SMPR2_SMP0;	
		ADC1->SQR3 &= 0;                        // This will reset the channels 
		ADC1->SQR3 |= PA; 					            // Select sequence in which channels will be converted 
		ADC1->CR2 |= 0x0001;					          //Starts the conversion sequence 
}

uint32_t adc (void)
{
		while ((ADC1->SR & 0x2) != 0x2)         // Waits for the sequence to complete
		{
			
		}
		return (ADC1->DR);									    // Will read the data form the adc data register 
}