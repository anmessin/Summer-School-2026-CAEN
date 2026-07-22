import time
import matplotlib.pyplot as plt
import matplotlib.animation as animation

from scisdk.scisdk import SciSDK
from scisdk.scisdk_defines import *
from struct import *

sdk = SciSDK()

fig = plt.figure("Oscilloscope analog data - channel 0")
ax1 = fig.add_subplot(1,1,1)

#DT1260
res = sdk.AddNewDevice("usb:53673","dt1260", "projects/lab4list/library/RegisterFile.json","board0")

if not res == 0:
    print("Program exit due connection error")
    exit()

res = sdk.SetParameterString("board0:/MMCComponents/List_0.thread", "false")
res = sdk.SetParameterInteger("board0:/MMCComponents/List_0.timeout", 500)
res = sdk.SetParameterString("board0:/MMCComponents/List_0.acq_mode", "blocking")

# allocate buffer raw, size 1024
res, buf = sdk.AllocateBuffer("board0:/MMCComponents/List_0", 1024)

res = sdk.ExecuteCommand("board0:/MMCComponents/List_0.stop", "")

res = sdk.ExecuteCommand("board0:/MMCComponents/List_0.start", "")

while True:
    res, buf = sdk.ReadData("board0:/MMCComponents/List_0", buf)
    if res == 0:
        for i in range(0, int(buf.info.valid_samples/4)):
            print(unpack('<L', buf.data[i*4:(i+1)*4]))
            #print (buf.data[i])
