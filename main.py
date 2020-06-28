#!/usr/bin/env python3
import time,sys
from tools.bottle import get,post,run,request,template
from tools.config_manager import config_manager
import RPi.GPIO as GPIO

is_login=False

test_cfg = "./default.config"
config=config_manager(test_cfg)
ret=config.read()
base_uri=config.conf_parser["USER"]["base_uri"]
root_uri=base_uri==""and "/" or base_uri

if ret==False:
    print("Read config file error:%s"%(test_cfg))
    sys.exit()


#web route
@get(root_uri)
def index():
    return template("index")

@post(base_uri+"/cmd")
def cmd():
    global is_login
    str_ret=request.body.read().decode()
    x = str_ret.split("+", 1)
    print("Pressed button: "+x[0])

    command=x[0]

    if x[1]==config.conf_parser["USER"]["password"]:
        is_login=True
        if command == "Reset":
            GPIO.output(resetPin, GPIO.LOW)
            time.sleep(0.5)
            GPIO.output(resetPin, GPIO.HIGH)
        elif command == "Power":
            GPIO.output(powerPin, GPIO.LOW)
            time.sleep(0.5)
            GPIO.output(powerPin, GPIO.HIGH)
        elif command == "Force power down":
            GPIO.output(powerPin, GPIO.LOW)
            time.sleep(8)
            GPIO.output(powerPin, GPIO.HIGH)
        return "OK"
    else:
        return "Please Check password"

@post(base_uri+"/get_status")
def cmd():
    str_ret=request.body.read().decode()
    x = str_ret.split("+", 1)
    print("get_status: "+x[0])

    global is_login

    if True or is_login:
        if x[0]=="LED":
            if GPIO.input(statusPin) == 1 :
                return "OFF"
            else:
                return "ON"
        else:
            return "Not checked"
    else:
        return "Not checked"


config.write(test_cfg)

powerPin = config.conf_parser.getint('USER', 'power_pin')
resetPin = config.conf_parser.getint('USER', 'reset_pin')
statusPin = config.conf_parser.getint('USER', 'status_pin')

GPIO.setwarnings(False) 
# Pin Setup:
GPIO.setmode(GPIO.BCM) # Broadcom pin-numbering scheme
GPIO.setup(powerPin, GPIO.OUT) 
GPIO.output(powerPin, GPIO.HIGH)

GPIO.setup(resetPin, GPIO.OUT) 
GPIO.output(resetPin, GPIO.HIGH)
GPIO.setup(statusPin, GPIO.IN,pull_up_down=GPIO.PUD_DOWN) 

run(server="paste",host=config.conf_parser["USER"]["listen_address"], port=config.conf_parser.getint('USER', 'port'),debug=True)
