"""
Filename: infrared_sensors.py
Project: UV-C Disinfection Robot
Capstone 2021: ESE Group 1
School: University of Regina
"""

#Get access to modules and packeges
from motor_driver import *
import I2C_LCD_driver
import RPi.GPIO as GPIO
import time

GPIO.setwarnings(False)

#Use broadcom SOC channel numbering for pins
GPIO.setmode(GPIO.BCM)

IS1 = 18            #Left infrared sensor
IS2 = 12            #Right infrared sensor
IS3 = 16            #Front infrared sensor

#Setting port pins ('IN' for input port & 'OUT' for ouput port)
GPIO.setup(IS1, GPIO.IN)
GPIO.setup(IS2, GPIO.IN)
GPIO.setup(IS3, GPIO.IN)

mylcd = I2C_LCD_driver.lcd()

#Function definition for the right and left infrared sensors
def IR_side_sensor():
    #When the right infrared sensor input is LOW (edge detected), move left
    if(GPIO.input(IS2)==False):
        move_left()
    #When the left infrared sensor input is LOW (edge detected), move right
    elif(GPIO.input(IS1)==False):
        move_right()
    #When the right and left infrared sensor inputs are HIGH (no edge detected), move forward
    else:
        move_forward()
        #time.sleep(1)
        #move_stop()
        #time.sleep(3)

#Function definition for the front infrared sensors
def IR_front_sensor():
    #when the front infrared sensor input is LOW (edge detected), move back then turn left
    if(GPIO.input(IS3)==False):
        move_backward()
        time.sleep(0.5)
        move_left()
        time.sleep(1.7)
    #When the front infrared sensor input is HIGH (no edge detected), move forward
    else:
        move_forward()
        #time.sleep(1)
        #move_stop()
        #time.sleep(3)

"""#Test
#while(1):
    #IR_front_sensor()
"""
