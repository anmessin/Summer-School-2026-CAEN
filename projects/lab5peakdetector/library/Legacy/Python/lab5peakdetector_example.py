from lab5peakdetector_Functions import *
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

