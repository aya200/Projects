"""
Filename: main.py
Project: UV-C Disinfection Robot
Capstone 2021: ESE Group 1
School: University of Regina
"""

#Get access to modules and packeges
#from infrared_sensors import *
from motion_sensors import *
#from motor_driver import *
#from sound_buzzer import *
from state_algorithm import *
from time import *
#from ultrasonic_sensors import *
#from UVC_LED import *
import I2C_LCD_driver
import RPi.GPIO as GPIO
import time

GPIO.setwarnings(False)

#Use broadcom SOC channel numbering for pins
GPIO.setmode(GPIO.BCM)

PB1 = 23
PB2 = 14

#Setting port pins ('IN' for input port & 'OUT' for ouput port)
GPIO.setup(PB1, GPIO.IN, pull_up_down=GPIO.PUD_UP)
GPIO.setup(PB2, GPIO.IN, pull_up_down=GPIO.PUD_UP)

while(1):
    #Function call for Idle state
    ST_idle()

    PB1_state = GPIO.input(PB1)         #Push button state (LOW/HIGH)

    #check if push button state is HIGH
    if (PB1_state == True):
        #store time in mins
        #e.g for timer_one = 2 for 2 mins or timer_one = 0.75 for 45 sec
        timer_one = 0.75
        time_end1 = time.time() + (timer_one * 60)

        #check if system time is less than the stored time
        while time.time() < time_end1:
            #if True, calculate time left (s) & round-up to whole number
            time_disp1 = time_end1 - time.time()
            time_disp1 = round(time_disp1, 0)
            
            #Display time left on LCD
            str_time1 = "Time Left: " + str(time_disp1) + " sec  "
            mylcd.lcd_display_string(str_time1, 3)
            
            #Function call for Perimeter state
            ST_perimeter()

        #store time in mins
        #e.g for timer_two = 5 for 5 mins or timer_two = 0.75 for 45 sec
        timer_two = 5
        time_end2 = time.time() + (timer_two * 60)

        #check if system time is less than the stored time
        while time.time() < time_end2:
            #if True, calculate time left (s) & round-up to whole number
            time_disp2 = time_end2 - time.time()
            time_disp2 = round(time_disp2, 0)
            
            #Display time left on LCD
            str_time2 = "Time Left: " + str(time_disp2) + " sec  "
            mylcd.lcd_display_string(str_time2, 3)
            
            #Function call for Interior state
            ST_interior()

        #Function call for Completed state
        ST_completed()
        time.sleep(5)
        
        #Calculation for total time
        time_total = (timer_one * 60) + (timer_two * 60)
        
        #Display total time on LCD
        str_disp_time = "Total time: " + str(time_total) + " sec  "
        mylcd.lcd_display_string(str_disp_time, 3)
