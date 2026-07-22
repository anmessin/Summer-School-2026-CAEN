from lab4list_Functions import *
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


    ReadDataNumber = 0
    TargetDataNumber = 1000
    Timeout_ms = 1000
    DownloadDataValues = []

    if (LISTMODULE_List_0_RESET(handle) != 0): 
        print("Reset Error")
    if (LISTMODULE_List_0_START(handle) == True):
            while(ReadDataNumber < TargetDataNumber):
                [err, List_Status, Count] = LISTMODULE_List_0_GET_STATUS(handle)
                DownloadDataNumber = min(TargetDataNumber - ReadDataNumber, Count)
                if (DownloadDataNumber>0):
                    [err, List_Data, List_Read_Data, List_Valid_Data] = LISTMODULE_List_0_GET_DATA(DownloadDataNumber, Timeout_ms, handle)
                    ReadDataNumber += List_Valid_Data
                    DownloadDataValues+=List_Data[0:List_Valid_Data]
                #stampa a coppie in hex i dati di List_Data
                    for i in range(0,List_Valid_Data):
                        print(hex(List_Data[i]))
                
            print("Total Downloaded Data: ", ReadDataNumber)
    else:
        print("Start Error")        

