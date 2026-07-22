from scisdk.scisdk import SciSDK
from scisdk.scisdk_defines import *
import time
import matplotlib.pyplot as plt
import matplotlib.animation as animation

sdk = SciSDK()

fig = plt.figure("Oscilloscope analog data - channel 0")
ax1 = fig.add_subplot(1,1,1)

#DT1260
res = sdk.AddNewDevice("usb:54982","dt1260", "./library/RegisterFile.json","board0")

if not res == 0:
    print("Program exit due connection error")
    exit()

# set oscilloscope parameters
res = sdk.SetParameterString("board0:/MMCComponents/Oscilloscope_0.data_processing","decode")
res = sdk.SetParameterInteger("board0:/MMCComponents/Oscilloscope_0.trigger_level", 2400)
res = sdk.SetParameterString("board0:/MMCComponents/Oscilloscope_0.trigger_mode","analog")
res = sdk.SetParameterInteger("board0:/MMCComponents/Oscilloscope_0.trigger_channel", 0)
res = sdk.SetParameterInteger("board0:/MMCComponents/Oscilloscope_0.pretrigger", 150)
decimator = 1
res = sdk.SetParameterInteger("board0:/MMCComponents/Oscilloscope_0.decimator", decimator)
res = sdk.SetParameterString("board0:/MMCComponents/Oscilloscope_0.acq_mode", "blocking")
res = sdk.SetParameterInteger("board0:/MMCComponents/Oscilloscope_0.timeout", 3000)
# allocate buffer for oscilloscope
res, buf = sdk.AllocateBuffer("board0:/MMCComponents/Oscilloscope_0")

for i in range(0, 10):
    fp = open("waveform_data_" + str(i) + ".csv", "w")
    #save waveform in csv, one wave per line, columns are samples
    res, buf = sdk.ReadData("board0:/MMCComponents/Oscilloscope_0", buf)

    for index in range(buf.info.samples_analog):
        fp.write(str(buf.analog[index]) + "\n")
   
    fp.close()