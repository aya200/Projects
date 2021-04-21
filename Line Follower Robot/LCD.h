#include <stdint.h>

#define LCD_8B2L 0x38                        // Enable 8 bit data, 2 display lines
#define LCD_DCB  0x0C                        // Enable Display, Cursor, Blink
#define LCD_MCR  0x06                        // Set Move Cursor Right.  should be movin left if 07
#define LCD_CLR  0x01                        // Home and clear LCD
#define LCD_LN1  0x80                        // Set DDRAM to start of line 1
#define LCD_LN2  0xC0                        // Set DDRAM to start of line 2
#define LCD_CM_ENA 0x00210002                //	0021 0002 => 0000 0000 0010 0001 || 0000 0000 0000 0010
#define LCD_CM_DIS 0x00230000                //
#define LCD_DM_ENA 0x00200003                //
#define LCD_DM_DIS 0x00220001                //

// LCD.c function prototypes
void clock_init(void);
void LCD_init(void);
void LCD_config (void);
void commandToLCD(uint8_t data);
void dataToLCD(uint8_t data); 
void stringToLCD(char *message);
void dSwitch (uint32_t switchValue); 
void printHex (uint32_t data);
void printVoltage (uint32_t data);
void printDeg (uint32_t data);
void delay_1(uint32_t count);
void status(void);