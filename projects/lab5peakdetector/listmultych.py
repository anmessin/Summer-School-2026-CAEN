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

sdk.SetRegister("board0:/Registers/BL_M",8)
sdk.SetRegister("board0:/Registers/BL_HOLD",700)
sdk.SetRegister("board0:/Registers/PEAK_DELAY",100)

sdk.SetRegister("board0:/Registers/page_subdesign_1_0_THRESHOLD", 2400)
sdk.SetRegister("board0:/Registers/page_subdesign_1_0_DELTA", 20)

sdk.SetRegister("board0:/Registers/page_subdesign_1_1_THRESHOLD", 2400)
sdk.SetRegister("board0:/Registers/page_subdesign_1_1_DELTA", 20)

res = sdk.SetParameterString("board0:/MMCComponents/List_0.thread", "false")
res = sdk.SetParameterInteger("board0:/MMCComponents/List_0.timeout", 500)
res = sdk.SetParameterString("board0:/MMCComponents/List_0.acq_mode", "blocking")

# allocate buffer raw, size 1024
res, buf = sdk.AllocateBuffer("board0:/MMCComponents/List_0", 128)
res = sdk.ExecuteCommand("board0:/MMCComponents/List_0.stop", "")
res = sdk.ExecuteCommand("board0:/MMCComponents/List_0.start", "")

previous = [None, None]
time_list = [[] for _ in range(2)]
energy_list = [[] for _ in range(2)]
for i in tqdm(range(100)):
    res, buf = sdk.ReadData("board0:/MMCComponents/List_0", buf)
    if res == 0:
        for i in range(0, int(buf.info.valid_samples/8)):
            # MSB 8 bits for channel
            # 40 bits for timestamp
            # 16 bits for ADC value
            # we unpack this data
           
            data = unpack('<Q', buf.data[i*8:(i+1)*8])[0]
            channel = (data >> 56) & 0xFF
            tdata = (data >> 16) & 0xFFFFFFFFFF
            adc = data & 0xFFFF

            if channel > 1:
                print(f"Invalid channel: {channel}")
                continue
           
            if previous[channel] is not None:
                time_list[channel].append(tdata - previous[channel])
            previous[channel] = tdata
            energy_list[channel].append(adc)
            #print (buf.data[i])



#plot histograms of time differences and energy for both channels
fig, axs = plt.subplots(2, 2, figsize=(12, 8))

# time difference histograms
axs[0, 0].hist(time_list[0], bins=np.linspace(0, 5000, 1000))
axs[0, 0].set_title("Time differences - Channel 0")
axs[0, 0].set_xlabel("Time difference (ticks)")
axs[0, 0].set_ylabel("Frequency")

axs[0, 1].hist(time_list[1], bins=np.linspace(0, 5000, 1000))
axs[0, 1].set_title("Time differences - Channel 1")
axs[0, 1].set_xlabel("Time difference (ticks)")
axs[0, 1].set_ylabel("Frequency")

# energy histograms
axs[1, 0].hist(energy_list[0], bins=np.linspace(0, 4096, 4096))
axs[1, 0].set_title("Energy - Channel 0")
axs[1, 0].set_xlabel("Energy (ADC)")
axs[1, 0].set_ylabel("Frequency")

axs[1, 1].hist(energy_list[1], bins=np.linspace(0, 4096, 4096))
axs[1, 1].set_title("Energy - Channel 1")
axs[1, 1].set_xlabel("Energy (ADC)")
axs[1, 1].set_ylabel("Frequency")

plt.tight_layout()
plt.show()



