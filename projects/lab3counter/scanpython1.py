import time
from scisdk.scisdk import SciSDK
from scisdk.scisdk_defines import *

sdk = SciSDK()

#DT1260
res = sdk.AddNewDevice("usb:53673","dt1260", "library/RegisterFile.json","board0")

if not res == 0:
    print("Program exit due connection error")
    exit()

sdk.SetRegister("board0:/Registers/THRESHOLD", 2500)
sdk.SetRegister("board0:/Registers/DELTA", 25)

sdk.SetRegister("board0:/Registers/RESET", 1)
sdk.SetRegister("board0:/Registers/RESET", 0)

time.sleep(1)

err, regC = sdk.GetRegister("board0:/Registers/COUNTS")
print("Register COUNTS value is ", regC)