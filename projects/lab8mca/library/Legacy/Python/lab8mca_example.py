from lab8mca_Functions import *
from ctypes import *
import matplotlib.pyplot as plt
import time

[ListOfDevices, count] = ListDevices()
if (count > 0):

    board = ListOfDevices[0].encode('utf-8')

    [err, handle] = ConnectDevice(board)
    if (err == 0):
        print("Successful connection to board ", board)
    else:
        print("Connection Error")


    plt.ion()
    Oscilloscope_Status = 0
    Timeout_ms = 1000
    Decimator = 0
    Pre_Trigger = 100
    Trigger_Level = 1000
    Trigger_Channel = 0
    Trigger_Mode = "Free" #"Free", "Analog", "Digital0", "Digital1", "Digital2", "Digital3"
    Trigger_Edge = "Rising" #"Rising", "Falling"
    
    while(1):
        if (OSCILLOSCOPE_Oscilloscope_0_SET_DECIMATOR(Decimator, handle) != 0): 
            print("Set Decimator Error")
            exit
        if (OSCILLOSCOPE_Oscilloscope_0_SET_PRETRIGGER(Pre_Trigger, handle) != 0): 
            print("Set PreTrigger Error")
            exit
        if (OSCILLOSCOPE_Oscilloscope_0_SET_TRIGGER_LEVEL(Trigger_Level, handle) != 0):
            print("Set Trigger Level Error")
            exit
        if (OSCILLOSCOPE_Oscilloscope_0_SET_TRIGGER_MODE(Trigger_Mode, Trigger_Channel, Trigger_Edge, handle) != 0):
            print("Set Trigger Mode Error")
            exit
        if (OSCILLOSCOPE_Oscilloscope_0_START(handle) == True):
            while (Oscilloscope_Status != 1):
                [err, Oscilloscope_Status] = OSCILLOSCOPE_Oscilloscope_0_GET_STATUS(handle)
            [err, Event_Position] = OSCILLOSCOPE_Oscilloscope_0_GET_POSITION(handle)
            [err, Oscilloscope_Data, Oscilloscope_Read_Data, Oscilloscope_Valid_Data] = OSCILLOSCOPE_Oscilloscope_0_GET_DATA(Timeout_ms, handle)
            [Analog, Digital0, Digital1, Digital2, Digital3] = OSCILLOSCOPE_Oscilloscope_0_RECONSTRUCT_DATA(Oscilloscope_Data, Event_Position, Pre_Trigger)
            plt.cla()
            plt.plot(Analog)
            plt.pause(0.01)
        else:
            print("Start Error")

    Spectrum_acq_mode = "Free" #"Free", "Events", "Time"
    Spectrum_target_value = 0
    Spectrum_bin = 4096
    Timeout_ms = 1000
    Spectrum=[]
    for i in range(Spectrum_bin):
        Spectrum.append(0)

    plt.ion()
    if (SPECTRUM_Spectrum_1_SET_PARAMETERS(Spectrum_bin, Spectrum_acq_mode, Spectrum_target_value, handle) != 0): 
        print("Set Parameters Error")    
    if (SPECTRUM_Spectrum_1_RESET(handle) != 0): 
        print("Reset Error")
    if (SPECTRUM_Spectrum_1_FLUSH(handle) != 0): 
        print("Flush Error")
    if (SPECTRUM_Spectrum_1_START(handle) == 0):
        while 1:
            [err, Spectrum_Status] = SPECTRUM_Spectrum_1_GET_STATUS(handle)
            [err, Spectrum_Data, Spectrum_Read_Data, Spectrum_Valid_Data] = SPECTRUM_Spectrum_1_GET_DATA(Spectrum_bin, Timeout_ms, handle)
            for i in range(Spectrum_bin):
                Spectrum[i] = Spectrum_Data[i] 
            plt.plot(Spectrum)
            plt.draw()
            plt.pause(0.0001)
            plt.clf()        

    else:
        print("Start Error")


