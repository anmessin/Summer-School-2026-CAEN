import time
import matplotlib.pyplot as plt
import matplotlib.animation as animation
import numpy as np

from scisdk.scisdk import SciSDK
from scisdk.scisdk_defines import *
from struct import *
from tqdm import tqdm

sdk = SciSDK()

fig = plt.figure("Oscilloscope analog data - channel 0")
ax1 = fig.add_subplot(1,1,1)

#DT1260
res = sdk.AddNewDevice("usb:53673","dt1260", "projects/lab4list/library/RegisterFile.json","board0")

if not res == 0:
    print("Program exit due connection error")
    exit()

sdk.SetRegister("board0:/Registers/THRESHOLD", 2500)
sdk.SetRegister("board0:/Registers/DELTA", 25)

res = sdk.SetParameterString("board0:/MMCComponents/List_0.thread", "false")
res = sdk.SetParameterInteger("board0:/MMCComponents/List_0.timeout", 500)
res = sdk.SetParameterString("board0:/MMCComponents/List_0.acq_mode", "blocking")

# allocate buffer raw, size 1024
res, buf = sdk.AllocateBuffer("board0:/MMCComponents/List_0", 1024)
res = sdk.ExecuteCommand("board0:/MMCComponents/List_0.stop", "")
res = sdk.ExecuteCommand("board0:/MMCComponents/List_0.start", "")

old_time = None
time_list = []

for i in tqdm(range(100)):
    res, buf = sdk.ReadData("board0:/MMCComponents/List_0", buf)
    if res == 0:
        for i in range(0, int(buf.info.valid_samples/4)):
            new_time = unpack('<L', buf.data[i*4:(i+1)*4])[0]

            if old_time is not None:
                time_list.append(new_time - old_time)

            old_time = new_time            

res, lost = sdk.GetRegister("board0:/Registers/LOST")
res, good = sdk.GetRegister("board0:/Registers/GOOD")
print(f"LOST: {lost}, GOOD: {good}")

plt.hist(time_list, bins=np.linspace(0,5000,1000))
plt.title("Histogram of time differences")
plt.xlabel("Time difference (ticks)")
plt.ylabel("Frequency")
plt.xlim(0, 100)
plt.show()