#include <stdint.h>

// gpio.c function prototypes
void clock_init(void);
void gpio_init(void);
void LED_init(void);
uint32_t switches(void);
void delay(uint32_t count);
void LED_display(void);