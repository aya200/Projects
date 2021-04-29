"""
Filename: motor_driver.py
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
IN1 = 7             #Right motor input 1
IN2 = 8             #Right motor input 2
IN3 = 9             #Left motor input 3
IN4 = 10            #Left motor input 4
ENA = 25            #Enable for right motor
ENB = 11            #Enable for left motor
#temp1 = 1

#Setting port pins ('IN' for input port & 'OUT' for ouput port)
GPIO.setup(IN1,GPIO.OUT)
GPIO.setup(IN2,GPIO.OUT)
GPIO.setup(IN3,GPIO.OUT)
GPIO.setup(IN4,GPIO.OUT)
GPIO.setup(ENA,GPIO.OUT)
GPIO.setup(ENB,GPIO.OUT)

#Setting default output ports pins as LOW
GPIO.output(IN1,GPIO.LOW)
GPIO.output(IN2,GPIO.LOW)
GPIO.output(IN3,GPIO.LOW)
GPIO.output(IN4,GPIO.LOW)

#Assigning PWM to ENA & ENB pins on the motor driver
motor1 = GPIO.PWM(ENA,1000)           #Right motor
motor2 = GPIO.PWM(ENB,1000)           #Left motor

#Default speed
motor1.start(30)
motor2.start(30)

"""
Drive train for the motors
            |    Enable A   |    Enable B   |
| Direction |  IN1  |  IN2  |  IN3  |  IN4  |
|  Forward  |  HIGH |  LOW  |  HIGH |  LOW  |
|  Backward |  LOW  |  HIGH |  LOW  |  HIGH |
|   Right   |  LOW  |  HIGH |  HIGH |  LOW  |
|   Left    |  HIGH |  LOW  |  LOW  |  HIGH |
|   Stop    |  LOW  |  LOW  |  LOW  |  LOW  |
"""

#Function definition to move forward
def move_forward():
    GPIO.output(IN1,GPIO.HIGH)
    GPIO.output(IN2,GPIO.LOW)
    GPIO.output(IN3,GPIO.HIGH)
    GPIO.output(IN4,GPIO.LOW)

#Function definition to move backward
def move_backward():
    GPIO.output(IN1,GPIO.LOW)
    GPIO.output(IN2,GPIO.HIGH)
    GPIO.output(IN3,GPIO.LOW)
    GPIO.output(IN4,GPIO.HIGH)

#Function definition to move right
def move_right():
    GPIO.output(IN1,GPIO.LOW)
    GPIO.output(IN2,GPIO.HIGH)
    GPIO.output(IN3,GPIO.HIGH)
    GPIO.output(IN4,GPIO.LOW)

#Function definition to move left
def move_left():
    GPIO.output(IN1,GPIO.HIGH)
    GPIO.output(IN2,GPIO.LOW)
    GPIO.output(IN3,GPIO.LOW)
    GPIO.output(IN4,GPIO.HIGH)

#Function definition to stop moving
def move_stop():
    GPIO.output(IN1,GPIO.LOW)
    GPIO.output(IN2,GPIO.LOW)
    GPIO.output(IN3,GPIO.LOW)
    GPIO.output(IN4,GPIO.LOW)

#Function definition for low speed (perimeter)
#Slightly faster speed for motor2 to keep to the edge
def low_speed_per():
    motor1.ChangeDutyCycle(30)
    motor2.ChangeDutyCycle(33)

#Function definition for low speed (35% duty cycle)
def low_speed():
    motor1.ChangeDutyCycle(35)
    motor2.ChangeDutyCycle(35)

#Function definition for medium speed (50% duty cycle)
def medium_speed():
    motor1.ChangeDutyCycle(50)
    motor2.ChangeDutyCycle(50)

#Function definition for high speed (80% duty cycle)
def high_speed():
    motor1.ChangeDutyCycle(80)
    motor2.ChangeDutyCycle(80)
