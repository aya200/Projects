"""
Filename: motion_sensors.py
Project: UV-C Disinfection Robot
Capstone 2021: ESE Group 1
School: University of Regina
"""

#Get access to modules and packeges
from sound_buzzer import *
from motor_driver import *
import I2C_LCD_driver
import RPi.GPIO as GPIO
import time

GPIO.setwarnings(False)

#Use broadcom SOC channel numbering for pins
GPIO.setmode(GPIO.BCM)

#Variable declaration
MS1 = 4

#Setting port pins ('IN' for input port & 'OUT' for ouput port)
GPIO.setup(MS1, GPIO.IN)
#GPIO.setup(MS1, GPIO.IN, pull_up_down=GPIO.PUD_DOWN)

mylcd = I2C_LCD_driver.lcd()

#Function definition for motion detection
def motion_detected():
    MS1_state = GPIO.input(MS1)           #Variable declaration for GPIO 4
    
    #When the motion sensor output is LOW, no motion is not detected
    if (MS1_state == 0):
        pass
        #SB_soundOFF()
    #When the motion sensor output is HIGH, motion is detected
    elif (MS1_state == 1):
        #Display on the LCD
        mylcd.lcd_display_string("Motion detected     ", 2)
        mylcd.lcd_display_string("Please stay 6ft away", 3)
        
        #Function calls
        move_stop()
        SB_warning()            #Give a warning signal

#Interrupt (rising edge detection) using callbacks whenever MS1_state changes
GPIO.add_event_detect(MS1, GPIO.RISING, callback=motion_detected(), bouncetime=100)
