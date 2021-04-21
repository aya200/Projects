; Ufuoma Aya
; 200327306
; ENSE 352 Project



; GPIO Test program - Dave Duguid, 2011
; Modified Trevor Douglas 2014

;;; Directives
            PRESERVE8
            THUMB       

        		 
;;; Equates

INITIAL_MSP	EQU		0x20001000	; Initial Main Stack Pointer Value


;PORT A GPIO - Base Addr: 0x40010800
GPIOA_CRL	EQU		0x40010800	; (0x00) Port Configuration Register for Px7 -> Px0
GPIOA_CRH	EQU		0x40010804	; (0x04) Port Configuration Register for Px15 -> Px8
GPIOA_IDR	EQU		0x40010808	; (0x08) Port Input Data Register
GPIOA_ODR	EQU		0x4001080C	; (0x0C) Port Output Data Register
GPIOA_BSRR	EQU		0x40010810	; (0x10) Port Bit Set/Reset Register
GPIOA_BRR	EQU		0x40010814	; (0x14) Port Bit Reset Register
GPIOA_LCKR	EQU		0x40010818	; (0x18) Port Configuration Lock Register

;PORT B GPIO - Base Addr: 0x40010C00
GPIOB_CRL	EQU		0x40010C00	; (0x00) Port Configuration Register for Px7 -> Px0
GPIOB_CRH	EQU		0x40010C04	; (0x04) Port Configuration Register for Px15 -> Px8
GPIOB_IDR	EQU		0x40010C08	; (0x08) Port Input Data Register
GPIOB_ODR	EQU		0x40010C0C	; (0x0C) Port Output Data Register
GPIOB_BSRR	EQU		0x40010C10	; (0x10) Port Bit Set/Reset Register
GPIOB_BRR	EQU		0x40010C14	; (0x14) Port Bit Reset Register
GPIOB_LCKR	EQU		0x40010C18	; (0x18) Port Configuration Lock Register

;The onboard LEDS are on port C bits 8 and 9
;PORT C GPIO - Base Addr: 0x40011000
GPIOC_CRL	EQU		0x40011000	; (0x00) Port Configuration Register for Px7 -> Px0
GPIOC_CRH	EQU		0x40011004	; (0x04) Port Configuration Register for Px15 -> Px8
GPIOC_IDR	EQU		0x40011008	; (0x08) Port Input Data Register
GPIOC_ODR	EQU		0x4001100C	; (0x0C) Port Output Data Register
GPIOC_BSRR	EQU		0x40011010	; (0x10) Port Bit Set/Reset Register
GPIOC_BRR	EQU		0x40011014	; (0x14) Port Bit Reset Register
GPIOC_LCKR	EQU		0x40011018	; (0x18) Port Configuration Lock Register

;Registers for configuring and enabling the clocks
;RCC Registers - Base Addr: 0x40021000
RCC_CR		EQU		0x40021000	; Clock Control Register
RCC_CFGR	EQU		0x40021004	; Clock Configuration Register
RCC_CIR		EQU		0x40021008	; Clock Interrupt Register
RCC_APB2RSTR	EQU	0x4002100C	; APB2 Peripheral Reset Register
RCC_APB1RSTR	EQU	0x40021010	; APB1 Peripheral Reset Register
RCC_AHBENR	EQU		0x40021014	; AHB Peripheral Clock Enable Register

RCC_APB2ENR	EQU		0x40021018	; APB2 Peripheral Clock Enable Register  -- Used

RCC_APB1ENR	EQU		0x4002101C	; APB1 Peripheral Clock Enable Register
RCC_BDCR	EQU		0x40021020	; Backup Domain Control Register
RCC_CSR		EQU		0x40021024	; Control/Status Register
RCC_CFGR2	EQU		0x4002102C	; Clock Configuration Register 2

ADC_CR1 EQU 0x00000000
ADC_CR2 EQU 0x00000000

; Times for Delay routines
        
DelayTIME	EQU		1600000		; (200 ms/24MHz PLL)


; Vector Table Mapped to Address 0 at Reset
            AREA    RESET, Data, READONLY
            EXPORT  __Vectors

__Vectors	DCD		INITIAL_MSP			; stack pointer value when stack is empty
        	DCD		Reset_Handler		; reset vector
			
            AREA    MYCODE, CODE, READONLY
			EXPORT	Reset_Handler
			ENTRY

Reset_Handler		PROC
		BL GPIO_ClockInit
		BL GPIO_Init
	
MainLoop
		BL ready_mode
		BL numCycles
		B   MainLoop
		ENDP

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;Subroutines;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    
	ALIGN
		
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; This routine enables the clock for the Port A, B & C;
;;; Reset value: 0x0000 0000
;;;	Registers:
;;;		R4: Loads the address of RCC_APB2ENR
;;; 	R0: Moves required hex values to enable clock 
;;;		R0: Stores required value in R0
GPIO_ClockInit  PROC

		PUSH {R4}						
		LDR		R4, =RCC_APB2ENR    
		MOV		R0, #0x1C        
		STR		R0, [R4]			
		POP {R4}					
		BX LR
		
		ENDP
	
	ALIGN

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; This routine enables the GPIO for LEDs; 
;;; Reset Value is 0x4444 4444 
;;; CNF: General purpose push pull (00)
;;; Mode: Max speed, 50 Mhz  (11)
;;;	LED1 - PA9, LED2 - PA10, LED3 - PA11, LED4 - PA12
;;;	Registers:
;;;		R5: Loads address of GPIOA_CRH (CRH for GPIO pins 8-15)
;;; 	R6: Moves required hex values to enable GPIO
;;; 	R7: Loads hex value in address of R5 to R7
GPIO_Init  PROC	
		PUSH {R5, R6, R7}
		LDR		R5, =GPIOA_CRH		
		LDR		R7, [R5]						
		LDR		R6, =0x44433334
		ORR		R7,R6
		STR		R7,[R5]	
		POP {R5, R6, R7}		
		BX LR
		ENDP

	ALIGN
		

ready_mode PROC
	MOV R3,#0x0		
	LDR R6, =500000				; for PrelimWait
	LDR R8, =500000 			; for reactTime & delayTime
	
	MOV R2,#0x1E00										
							
TurnOnLED
	LDR R9,=GPIOA_ODR
	EOR R2,R2,#0x1E00
	STR R2,[R9]
	MOV R10,#0x0
	MOV R11,#0x0

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; This routine enables the GPIO for Switches; 
;;; Reset Value is ox0000 xxxx 
;;;	SW2 - PB8, SW3 - PB9, SW4 - PC12, SW5 - PA5
;;;	Registers:
;;;		R7: Loads address of GPIOx_IDR
;;; 	R4: Moves required hex values to enable GPIO
DelayVal
	CMP R10,R6
	BEQ TurnOnLED
	ADD R10,#0x5
	
	PUSH {R7,R4}
	LDR R5,= 0x0
	LDR	R7, = GPIOC_IDR		; Loads address of Port C input data register	    
	LDR	R0,[R7]
	
	LDR R4,= 0x1000			; Loads required hex value for SW4 (Blue)
	AND R0,R4				
	LSR R0, #12				; 0x1000 -> 0x1
	MOV R5,#0x4	
	CMP R0,#0x0				; Check if R0 is 0
	BEQ PortCWait_Init		; If yes, branch to PortCWait_Init
	
	LDR R5,= 0x0
	LDR	R7, = GPIOB_IDR		; Loads address of Port B input data register	    
	LDR	R0,[R7]

	LDR R4,= 0x300			; Loads required hex value for SW2 (Red) and SW3 (Black)		
	AND R0,R4			
	LSR R0, #8				; 0x300 -> 0x3
	MOV R5,#0x2
	CMP R0,#0x1				; Check if R0 is 1
	BEQ PortBWait_Init		; If yes, branch to PortBWait_Init

	MOV R5,#0x1
	CMP R0,#0x2
	BEQ PortBWait_Init
	
	LDR R5,= 0x0
	LDR	R7, = GPIOA_IDR		; Loads address of Port A input data register	    
	LDR	R0,[R7]

	LDR R4,= 0x20			; Loads required hex value for SW5 (Green)			
	AND R0,R4
	LSR R0, #5				; 0x20 -> 0x1
	MOV R5,#0x8
	CMP R0,#0x0				; Check if R0 is 0
	BEQ PortAWait_Init		; If yes, branch to PortAWait_Init	
	
	POP {R7,R4}
	
	B DelayVal

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;UC2;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; This routine waits for signal from input port registers 
;;;	Registers:
;;;		R7: Loads address of GPIOx_IDR
;;; 	R4: Moves required hex values to enable GPIO	
;;;		R6: Initial react time	

;;;	Wait for initial input from Port C
PortCWait_Init	
	ADD R11,#0x1
	CMP R11,R6
	BEQ Exit_Init
	
	LDR	R7, = GPIOC_IDR	    
	LDR	R0,[R7]
	LDR R4,= 0x1000
	AND R0,R4				
	LSR R0, #12
	CMP R0,#0x0
	BEQ PortCReset_Init
	B PortCWait_Init

PortCReset_Init
	MOV R11,#0x0
	B PortCWait_Init

;;;	Wait for initial input from Port B
PortBWait_Init	
	ADD R11,#0x1
	CMP R11,R6
	BEQ Exit_Init
	
	LDR	R7, = GPIOB_IDR	    
	LDR	R0,[R7]
	LDR R4,= 0x300		
	AND R0,R4			
	LSR R0, #8
	CMP R0,#0x1
	BEQ PortBReset_Init
	CMP R0,#0x2
	BEQ PortBReset_Init
	B PortBWait_Init
	
PortBReset_Init
	MOV R11,#0x0
	B PortBWait_Init	

;;;	Wait for initial input from Port A
PortAWait_Init	
	ADD R11,#0x1
	CMP R11,R6
	BEQ Exit_Init
	
	LDR	R7, = GPIOA_IDR	    
	LDR	R0,[R7]
	LDR R4,= 0x20			
	AND R0,R4
	LSR R0, #5
	CMP R0,#0x0
	BEQ PortAReset_Init
	B PortAWait_Init	
	
PortAReset_Init
	MOV R11,#0x0	
	B PortAWait_Init	
	
Exit_Init
	MOV R2,#0x0
	LSL R2, #9
	MVN R2,R2
	LDR R9,=GPIOA_ODR
	STR R2,[R9]
	MOV R11,#0x0

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;UC3;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Initial waiting time
PrelimWait		
	ADD R11,#0x1
	CMP R11,R6				
	BEQ RandomOnLED
	B PrelimWait

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; This routine lights up random LEDs
;;; Registers: 
;;; 	R9: Loads address of GPIOA_ODR
RandomOnLED
	MOV R11,#0x0
	LDR R9,=GPIOA_ODR
	AND R10,R10,#0x3
	MOV R2,#0x1
	LSL R2, R10
	MOV R10,#0x0
	LSL R2,#9
	MVN R2,R2
	STR R2,[R9]

;;;;;;;;;;;;;;;;;;;;;;;;;;game play;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
Delay										
	ADD R10,#0x1
	
	PUSH {R7,R4}
	LDR R5,= 0x0
	LDR	R7, = GPIOC_IDR	    
	LDR	R0,[R7]
	LDR R4,= 0x1000
	AND R0,R4				
	LSR R0, #12
	MOV R5,#0x4	
	CMP R0,#0x0
	BEQ PortCWait	
	
	LDR R5,= 0x0
	LDR	R7, = GPIOB_IDR	    
	LDR	R0,[R7]
	LDR R4,= 0x300		
	AND R0,R4			
	LSR R0, #8
	MOV R5,#0x2
	CMP R0,#0x1
	BEQ PortBWait
	MOV R5,#0x1
	CMP R0,#0x2
	BEQ PortBWait
	
	LDR R5,= 0x0
	LDR	R7, = GPIOA_IDR	    
	LDR	R0,[R7]
	LDR R4,= 0x20			
	AND R0,R4
	LSR R0, #5
	MOV R5,#0x8
	CMP R0,#0x0
	BEQ PortAWait	
	
	POP {R7,R4}
	
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	CMP R10,R8
	BEQ LosingSignalTime ; branch to fail mode when react time is elapsed
	B Delay

;;;	Wait for input from Port C
PortCWait	
	ADD R11,#0x1
	CMP R11,R6
	BEQ SWInput
	
	LDR	R7, = GPIOC_IDR	    
	LDR	R0,[R7]
	LDR R4,= 0x1000
	AND R0,R4				
	LSR R0, #12
	CMP R0,#0x0
	BEQ PortCReset
	B PortCWait
	
PortCReset
	MOV R11,#0x0
	B PortCWait

;;;	Wait for input from Port B
PortBWait	
	ADD R11,#0x1
	CMP R11,R6
	BEQ SWInput
	
	LDR	R7, = GPIOB_IDR	    
	LDR	R0,[R7]
	LDR R4,= 0x300		
	AND R0,R4			
	LSR R0, #8
	CMP R0,#0x1
	BEQ PortBReset
	CMP R0,#0x2
	BEQ PortBReset
	B PortBWait	
	
PortBReset
	MOV R11,#0x0
	B PortBWait	

;;;	Wait for input from Port A
PortAWait	
	ADD R11,#0x1
	CMP R11,R6
	BEQ SWInput
	
	LDR	R7, = GPIOA_IDR	    
	LDR	R0,[R7]
	LDR R4,= 0x20			
	AND R0,R4
	LSR R0, #5
	CMP R0,#0x0
	BEQ PortAReset
	B PortAWait	
	
PortAReset
	MOV R11,#0x0	
	B PortAWait	

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; This routine checks if player pressed the correct switch
;;; Registers:
;;;		R5: If R5 is equal to R2, branch to numCycles_count
SWInput										
	LSL R5, #9
	MVN R5, R5
	CMP R5, R2
	BEQ numCycles_count
	CMP R5, R2
	BNE LosingSignalTime							
	
NextRandomOnLED
	MOV R2,#0xF
	LSL R2, #9
	MVN R2,R2
	LDR R9,=GPIOA_ODR
	STR R2,[R9]
	MOV R11,#0x0
	
WaitEnd		
	ADD R11,#0x1
	CMP R11, R8
	BEQ RandomOnLED
	B WaitEnd

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; For WinningSignalTime:
;;;		This routine causes the LEDs to flash, then LED1 & 3 are ON, LED 2 & 4 are OFF and vice versa
;;; 	1010->0101
;;; For LosingSignalTime:
;;; 	This routine causes the LEDs to flash, then LED1 & 4 are ON, LED 2 & 3 are OFF and vice versa
;;; 	1001->0110
;;; EOR in WinLoseSignalLoop flips 1s to 0s and vice versa
WinningSignalTime													
	MOV R2,#0xA00										
	MOV R10,#0x0
	CMP R2, R2
	BEQ WinLoseSignalLoop

LosingSignalTime	
	MOV R2,#0xC00							
	MOV R10,#0x0
	
WinLoseSignalLoop
	CMP R10, #0xF						
	BEQ EndSuccess
	LDR R9,=GPIOA_ODR
	EOR R2,R2,#0x1E00
	STR R2,[R9]
	ADD R10,#0x1
	MOV R11,#0x0
	
WaitLoop		
	ADD R11,#0x1
	CMP R11, R8							
	BEQ WinLoseSignalLoop
	B WaitLoop											 

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; This routine counts the result 
;;; Registers:
;;;		R3: Counts result and increases by 1 if SW is correct.
;;;		    Goes to win mode when result is 15
;;;		R8: React time, it reduces on correct hits
numCycles_count	
	ADD R3,#0x1
	SUB R8,R8,#0xFFF
	CMP R3,#0xF			
	BEQ WinningSignalTime
	CMP R3, R3
	BEQ NextRandomOnLED	
	
EndSuccess								
	BX LR
	ENDP
	
	ALIGN

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
numCycles PROC	
	AND R3,R3,#0xF
	LSL R3, #9
	MVN R3, R3								
	LDR R9,=GPIOA_ODR
	STR R3,[R9]
	MOV R10,#0x0
	
numCycles_loop
	CMP R10, #0xF			
	BEQ gameOver
	ADD R10,#0x1
	MOV R11,#0x0
	
numCycles_wait		
	ADD R11,#0x1
	CMP R11, R8		
	BEQ numCycles_loop
	B numCycles_wait
	
gameOver	
	BX LR	
	ENDP
	
	ALIGN 
	END
		
