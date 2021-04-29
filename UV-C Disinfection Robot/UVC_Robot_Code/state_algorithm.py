"""
Filename: state_algorithm.py
Project: UV-C Disinfection Robot
Capstone 2021: ESE Group 1
School: University of Regina
"""

#Get access to modules and packeges
from infrared_sensors import *
from motor_driver import *
from sound_buzzer import *
from ultrasonic_sensors import *
from UVC_LED import *
import I2C_LCD_driver

#mylcd = I2C_LCD_driver.lcd()

#Function definition for the Idle state
def ST_idle():
    #Function call
    move_stop()
    
    #Display on the LCD
    st = "Idle         "
    mylcd.lcd_display_string("UV-C Disinfection   ", 1)
    mylcd.lcd_display_string("State: " + st, 2)
    mylcd.lcd_display_string("Press blue button   ", 3)
    
    #Function call
    US_back_sensor()

#Function definition for the Perimeter state
def ST_perimeter():
    #Function calls
    low_speed_per()
    LED_wing()
    
    #Display on the LCD
    st = "Perimeter    "
    mylcd.lcd_display_string("State: " + st, 2)
    
    #Function calls
    IR_side_sensor()
    US_back_sensor()

#Function definition for the Interior state
def ST_interior():
    #Function calls
    low_speed()
    LED_surface()
    
    #Display on the LCD
    st = "Interior     "
    mylcd.lcd_display_string("State: " + st, 2)
    
    #Function calls
    IR_front_sensor()
    IR_side_sensor()
    US_back_sensor()

#Function definition for the Completed state
def ST_completed():
    #Function calls
    move_stop()
    time.sleep(1)
    LED_allOFF()
    time.sleep(1)
    SB_completed()
    
    #Display on the LCD
    st = "Completed    "
    mylcd.lcd_display_string("State: " + st, 2)
    
    #Function call
    US_back_sensor()

"""#Test
#while(1):
    #ST_completed()
"""
