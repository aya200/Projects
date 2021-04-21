1.
What the game is?
The game is called Whack-a-Mole. This is an arcade game in which players use a mallet to hit toy moles, which appear at random, back into their holes. In this case, the LEDs represent the moles and the switches represent the mallet to hit a mole in a specific hole.

2.
How to play?
The game is played by pressing a switch to the corresponding LED position. You press SW2 (Red) for LED1, SW3 (Black) for LED2, SW4 (Blue) for LED3 and SW5 (Green) for LED4.

To begin the game, the player is required to press the RESET button. All LEDs must be flashing at the same time which indicates that the game is ready to be played. The player is required to press any of the four switches to start play mode and must continuously hit the corresponding switch of the lit LED within a reaction time.

As the player makes successful hits, the player's score is incremented by a value of one and the reaction time reduces.

To win the game, the player required to hit 15 number of cycles, if the player successfully makes 15 hits, the LEDs display a winning signal pattern which is depicted by the LEDs flashing, when LED1 & LED3 are ON, LED2 & LED4 are OFF and when LED1 & LED3 are OFF, LED2 & LED4 are ON. The player receives a score which is displayed on the LEDs after the winning signal is stopped.

If a player does not successfully make 15 hits, the player loses the game and receives a losing signal. the losing signal pattern is depicted by the LEDs flashing, when LED1 & LED4 are ON, LED2 & LED3 are OFF and when LED1 & LED4 are OFF, LED2 & LED3 are ON. The player receives a score after the losing signal is stopped.

3.
Any information about problems encountered, features you failed to implement, extra features you implemented beyond the basic requirements, possible future expansion, etc.?
The problem I encountered is making the LEDs display the score in the right order, the player gets the right score if the board is positioned in a way that the DC input of the board faces the player e.g. if the player's score is 3, 1100 is displayed instead of 0011, but if you flipped the board around, it's 0011.

4.
;;; line 141
ready_mode PROC
	MOV R3,#0x0		
	LDR R6, =500000	
	LDR R8, =500000 
a.
;;; line 286
PrelimWait 		
	ADD R11,#0x1
	CMP R11,R6				
	BEQ RandomOnLED
	B PrelimWait

Changing the load value of R6. 

b.
;;; line 348
CMP R10,R8
	BEQ LosingSignalTime ; branch to fail mode when react time is elapsed
	B Delay	

Changing the load value of R8.

c.
Number of cycles (numCycles) in the game is 15

d.
Value of WinningSignalTime is 15, while the values of LosingSignalTime is 0-14. These values are binary and are displayed using the LEDs.

1 = 0001
2 = 0010
3 = 0011
4 = 0100
5 = 0101
6 = 0110
7 = 0111
8 = 1000
9 = 1001
10 = 1010
11 = 1011
12 = 1100
13 = 1101
14 = 1110
15 = 1111



