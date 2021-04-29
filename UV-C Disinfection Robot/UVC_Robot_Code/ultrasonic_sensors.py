"""
Filename: ultrasonic_sensors.py
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

mylcd = I2C_LCD_driver.lcd()

#Function definition for the right ultrasonic sensor
def US_back_sensor():
    #Variable declaration
    TRIG_B = 5
    ECHO_B = 6

    #Setting port pins ('IN' for input port & 'OUT' for ouput port)
    GPIO.setup(TRIG_B,GPIO.OUT)
    GPIO.setup(ECHO_B,GPIO.IN)
    
    #Setting the Trigger pin as LOW
    GPIO.output(TRIG_B, False)
    time.sleep(.5)
    
    #Setting the Trigger pin as HIGH then LOW after 10µs
    GPIO.output(TRIG_B, True)
    time.sleep(0.00001)
    GPIO.output(TRIG_B, False)

    #store time when the Echo pin is LOW, this is the start time
    #store time when the Echo pin is HIGH, this is the end time
    while GPIO.input(ECHO_B)==0:
      pulse_start = time.time()
    while GPIO.input(ECHO_B)==1:
      pulse_end = time.time()

    #Calculations to get the time (s) & distance (cm)
    #Display distance in the LCD (line 3)
    pulse_duration = pulse_end - pulse_start
    distance = pulse_duration * 17150
    distance = round(distance, 2)
    str_dist = "Distance: " + str(distance) + " cm "
    mylcd.lcd_display_string(str_dist, 4)

    #Check if distance is equal to or less than 4cm
    if (distance <= 4.0):
        #if True, return 1111111111111111 (binary)
        return 0xFFFF
    elif (distance > 4.0):
        #if False, return 0 (binary), move forward then stop
        return 0x0000
        move_forward()
        time.sleep(1)
        move_stop()

"""#Test
#while(1):
    #US_back_sensor()
"""
