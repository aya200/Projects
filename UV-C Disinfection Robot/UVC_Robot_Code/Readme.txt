Full code for UV-C Disinfection Robot

Code collectively written by Ufuoma Aya, Hasin Abrar, Matthew Blinkhorn & Yatrik Pamnani
Code cleaned by Ufuoma Aya

The programs begins in the IDLE state and waits for an input from the GUI (UV-C Power ON) or physical push button (blue button).

Upon activation, the program goes into the PERIMETER state and launches a count down timer.  The program operates in this state until the time count down is done.

Once the time count down is done, the program goes into INTERIOR state immediately and launches another countdown timer. It operates in this state until the time count down is done.

Upon the time count down being done, the program goes into the COMPLETED state and later returns to the IDLE after 5 seconds.

Note: While in operation, the program pauses and the LEDs shutdown when nearby motion is detected.