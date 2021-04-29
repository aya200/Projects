"""
Filename: UVC_LED.py
Project: UV-C Disinfection Robot
Capstone 2021: ESE Group 1
School: University of Regina
"""

#Get access to modules and packeges
import RPi.GPIO as GPIO
import time

GPIO.setwarnings(False)

#Use broadcom SOC channel numbering for pins
GPIO.setmode(GPIO.BCM)

#Variable declaration
LED1 = 27
LED2 = 22

#Setting port pins ('IN' for input port & 'OUT' for ouput port)
GPIO.setup(LED1, GPIO.OUT)
GPIO.setup(LED2, GPIO.OUT)

#Setting default output port pins as LOW
GPIO.output(LED1, GPIO.LOW)
GPIO.output(LED2, GPIO.LOW)

#Function definition for the turning ON surface LEDs only
def LED_surface():
    GPIO.output(LED1, 1)
    GPIO.output(LED2, 0)

#Function definition for the turning ON wing LEDs only
def LED_wing():
    GPIO.output(LED1, 0)
    GPIO.output(LED2, 1)

#Function definition for the turning ON both surface and wing LEDs
def LED_allON():
    GPIO.output(LED1, 1)
    GPIO.output(LED2, 1)

#Function definition for the turning OFF both surface and wing LEDs
def LED_allOFF():
    GPIO.output(LED1, 0)
    GPIO.output(LED2, 0)
