#include "LCD.h"

#include "interrupts.h"
#include "string.h"
#include "stm32f10x.h"

void LCD_config (void)
{
		GPIOC->CRL |= GPIO_CRL_MODE0 | GPIO_CRL_MODE1 | GPIO_CRL_MODE2 | GPIO_CRL_MODE3;          // PORT C: Pins C0-3 are outputs connecting 4 data pins of LCD	
		GPIOC->CRL &= ~GPIO_CRL_CNF0 & ~GPIO_CRL_CNF1 & ~GPIO_CRL_CNF2 & ~GPIO_CRL_CNF3;
		GPIOC->CRL |= GPIO_CRL_MODE4 | GPIO_CRL_MODE5 | GPIO_CRL_MODE6 | GPIO_CRL_MODE7;          // PORT C- Pins C4-7 are outputs connecting 4 data pins of LCD	
		GPIOC->CRL &= ~GPIO_CRL_CNF4 & ~GPIO_CRL_CNF5 & ~GPIO_CRL_CNF6 & ~GPIO_CRL_CNF7;
		GPIOB->CRL |= GPIO_CRL_MODE0 | GPIO_CRL_MODE1 | GPIO_CRL_MODE5;                           // Enabling RS R/W and W pins as outputs 
		GPIOB->CRL &= ~GPIO_CRL_CNF0 & ~GPIO_CRL_CNF1 & ~GPIO_CRL_CNF5;
}

void delay_1(uint32_t count)
{
    int i=0;
    for(i=0; i< count; ++i)
    {
		}
}

void commandToLCD(uint8_t data)
{
		GPIOB->BSRR = LCD_CM_ENA;          // RS low, E high
		GPIOC->ODR &= 0xFF00;              //GOOD: clears the low bits without affecting high bits
		GPIOC->ODR |= data;					       //GOOD: only affects lowest 8 bits of Port C
		delay_1(8000);
		GPIOB->BSRR = LCD_CM_DIS; 		     //RS low, E low
		delay_1(80000);
}

void dataToLCD(uint8_t data)
{
		GPIOB->BSRR = LCD_DM_ENA;          //RS low, E high
		GPIOC->ODR &= 0xFF00;					     //GOOD: clears the low bits without affecting high bits
		GPIOC->ODR |= data;					       //GOOD: 
		delay_1(8000);
		GPIOB->BSRR = LCD_DM_DIS; 		     //RS low, E low
		delay_1(80000);
}

void LCD_init(void) 
{
		commandToLCD(LCD_8B2L);
		commandToLCD(LCD_CLR);
		delay_1(8000000);
}
	
void dSwitch (uint32_t switchValue)
{
		switch (switchValue) 
		{
				case (0):
						stringToLCD("0");
						break;
				case (1): 
						stringToLCD("1");
						break;
				case (2): 
						stringToLCD("2");
						break;
				case (3): 
						stringToLCD("3");
						break;
				case (4): 
						stringToLCD("4");
						break;
				case (5): 
						stringToLCD("5");
						break;
				case (6): 
						stringToLCD("6");
						break;
				case (7): 
						stringToLCD("7");
						break;
				case (8): 
						stringToLCD("8");
						break;
				case (9): 
						stringToLCD("9");
						break;
				case (10): 
						stringToLCD("A");
						break;
				case (11): 
						stringToLCD("B");
						break;
				case (12): 
						stringToLCD("C");
						break;
				case (13): 
						stringToLCD("D");
						break;
				case (14): 
						stringToLCD("E");
						break;
				case (15): 
						stringToLCD("F");
						break;
				default:
						break;
		}
}
	
void stringToLCD(char *message)
{ 
		int i = 0;
		uint16_t length = strlen(message); 
		for(i=0; i<length; i++)
		{
				dataToLCD(message[i]);
		}
}
	
void printDeg (uint32_t data) 
{
		data *= ((3.3 / 4095) * 1000); 
		dSwitch((data % 1000) / 100); 
		dSwitch((data % 100) / 10); 
		dataToLCD('.');
		dSwitch((data % 10) / 1); 
		stringToLCD("C ");
}

void status(void)
{ 
		if(target == 1)
		{
				stringToLCD("Target 1 found");
		}
		else if (target == 2)
		{
				stringToLCD("Target 2 found");
		}
		else if (target == 3)
		{
				stringToLCD("Target 3 found");
		}
		else
				stringToLCD("");
}	