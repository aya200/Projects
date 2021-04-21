#include <stdint.h>

// interrupts.c function prototypes
void Systic_Config(void);
void SysTick_Handler(void);
void init_exti0(void);
void EXTI15_10_IRQHandler(void);

// External variables declaration
extern int lines;
extern int target;
extern int go;