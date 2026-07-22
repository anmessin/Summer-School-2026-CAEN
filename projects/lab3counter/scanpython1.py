import time
import matplotlib.pyplot as plt

from scisdk.scisdk import SciSDK
from scisdk.scisdk_defines import *


sdk = SciSDK()

#DT1260
res = sdk.AddNewDevice("usb:53673","dt1260", "projects/lab3counter/library/RegisterFile.json","board0")

if not res == 0:
    print("Program exit due connection error")
    exit()

thresholds = []
counts = []

sdk.SetRegister("board0:/Registers/WIDTH", 65000000)

for i in range(30): #range(2120, 2430, 5):
    i = 2500
    sdk.SetRegister("board0:/Registers/THRESHOLD", i)
    sdk.SetRegister("board0:/Registers/DELTA", 25)

    sdk.SetRegister("board0:/Registers/RESET", 1)
    sdk.SetRegister("board0:/Registers/RESET", 0)

    while True:
        err, regR = sdk.GetRegister("board0:/Registers/RUNNING")
        if regR == 0:
            break
        time.sleep(0.01)

    err, regC = sdk.GetRegister("board0:/Registers/COUNTS")
    print("Threshold", i, " - Counts ", regC)

    time.sleep(1)

    thresholds.append(i)
    counts.append(regC)

plt.plot(thresholds,counts,marker='.')
plt.xlabel("Threshold")
plt.ylabel("Counts")
plt.title("Counter Scan")
plt.grid(alpha=0.3)
plt.show()