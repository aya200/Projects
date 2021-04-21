#include "gpio.h"

#include "stm32f10x.h"

void clock_init(void)
{
    uint32_t temp = 0x00;

    RCC->CFGR = 0x00050002;                  // Output PLL/2 as MCO, PLLMUL X3, PREDIV1 is PLL input
    RCC->CR = 0x01010081;                    // Turn on PLL, HSE, HSI

    while (temp != 0x02000000)               // Wait for the PLL to stabilize
    {
        temp = RCC->CR & 0x02000000;         //Check to see if the PLL lock bit is set
    }
}

void gpio_init(void)
{
		RCC->APB2ENR |= RCC_APB2ENR_IOPAEN | RCC_APB2ENR_IOPBEN | RCC_APB2ENR_IOPCEN;
	
		// Write a 0xB ( 1011b ) into the configuration and mode bits for PA9 (GPIO)
    GPIOA->CRH |= GPIO_CRH_MODE9 | GPIO_CRH_MODE10 | GPIO_CRH_MODE11 | GPIO_CRH_MODE12;
    GPIOA->CRH &= ~GPIO_CRH_CNF9 & ~GPIO_CRH_CNF10 & ~GPIO_CRH_CNF11 & ~GPIO_CRH_CNF12;
}

void LED_init(void)
{
    RCC->APB2ENR |= RCC_APB2ENR_IOPCEN | RCC_APB2ENR_IOPBEN | RCC_APB2ENR_IOPAEN;                   // Enable peripheral clocks for ports A, B & C

    GPIOA->CRH |= GPIO_CRH_MODE9 | GPIO_CRH_MODE10 | GPIO_CRH_MODE11 | GPIO_CRH_MODE12;             // Set PA9-12 as push-pull outputs (up  to  50 MHz)
    GPIOA->CRH &= ~GPIO_CRH_CNF9 & ~GPIO_CRH_CNF10 & ~GPIO_CRH_CNF11 & ~GPIO_CRH_CNF12;
		GPIOC->CRH |= GPIO_CRH_MODE8 | GPIO_CRH_MODE9;                                                  // Set PC8 & 9 as push-pull outputs (up  to  50 MHz)
    GPIOC->CRH &= ~GPIO_CRH_CNF8 & ~GPIO_CRH_CNF9;
}

uint32_t switches(void)
{
		return ((GPIOA->IDR & (GPIO_IDR_IDR5)) >> 5) | ((GPIOC->IDR & (GPIO_IDR_IDR12)) >> 11);          //
}

void delay(uint32_t count)
{
    int i=0;
    for(i=0; i< count; ++i)
    {
    }
}

void LED_display(void)
{
		int i = 1200000;
    uint32_t BOB = switches();
}
