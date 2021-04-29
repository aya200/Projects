"""
Filename: sound_buzzer.py
Project: UV-C Disinfection Robot
Capstone 2021: ESE Group 1
School: University of Regina
"""

#Get access to modules and packeges
import RPi.GPIO as GPIO
import time

GPIO.setwarnings(False)

SB1 = 24

#Use broadcom SOC channel numbering for pins
GPIO.setmode(GPIO.BCM)

#Setting port pins ('IN' for input port & 'OUT' for ouput port)
GPIO.setup(SB1, GPIO.OUT)

#Setting default output port pin as LOW
GPIO.output(SB1,GPIO.LOW)

#Function definition for turning buzzer OFF
def SB_soundOFF():
    GPIO.output(SB1, 0)         #OFF time
    time.sleep(0.1)

#Function definition for turning buzzer warning ON
def SB_warning():
    GPIO.output(SB1, 1)         #ON time
    time.sleep(0.5)
    GPIO.output(SB1, 0)         #OFF time
    time.sleep(0.5)

#Function definition for turning buzzer completed ON
def SB_completed():
    GPIO.output(SB1, 1)         #ON time
    time.sleep(0.25)
    GPIO.output(SB1, 0)         #OFF time
    time.sleep(1)
    GPIO.output(SB1, 1)         #ON time
    time.sleep(0.25)
    GPIO.output(SB1, 0)         #OFF time
    time.sleep(1)
    GPIO.output(SB1, 1)         #ON time
    time.sleep(1)
    GPIO.output(SB1, 0)         #OFF time
