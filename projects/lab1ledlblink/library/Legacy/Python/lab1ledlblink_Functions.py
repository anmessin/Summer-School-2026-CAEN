
import lab1ledlblink_RegisterFile
from ctypes import *
import array
import numpy as np
import os

mydll = cdll.LoadLibrary(os.path.dirname(__file__) +'/SCIDK_Lib.dll')

def ConnectDevice(board):
    handle = c_void_p(256)
    err = mydll.SCIDK_ConnectUSB(board, byref(handle))
    return err, handle

def CloseConnect(handle):
    err = mydll.NI_CloseConnection(byref(handle))
    return err	
	
def ListDevices():
    count = c_int(0)
    s = create_string_buffer(2048)
    err = mydll.NI_USBEnumerate(byref(s), b"SCIDK", byref(count))
    str_con = (s.value.decode('ascii')) 
    str_devices = str_con.split(';')
    dev_count = count.value
    return str_devices, dev_count 

def __abstracted_reg_write(data, address, handle):
    err = mydll.NI_WriteReg(data, address, byref(handle))
    return err

def __abstracted_reg_read(address, handle):
    data = c_uint(0)
    err = mydll.NI_ReadReg(byref(data), address, byref(handle))
    return err, data.value

def __abstracted_mem_write(data, count, address, timeout_ms, handle):
    written_data = c_uint(0)
    err = mydll.NI_WriteData(data, count, address, 0, timeout_ms, byref(handle), byref(written_data))
    return err, written_data.value

def __abstracted_mem_read(count, address, timeout_ms, handle):
    data = (c_uint * (2* count))()
    read_data = c_uint(0)
    valid_data = c_uint(0)
    err = mydll.NI_ReadData(byref(data), count, address, 0, timeout_ms, byref(handle), byref(read_data), byref(valid_data))
    return err, data, read_data.value, valid_data.value

def __abstracted_fifo_write(data, count, address, timeout_ms, handle):
    written_data = c_uint(0)
    err = mydll.NI_WriteData(data, count, address, 1, timeout_ms, byref(handle), byref(written_data))
    return err, written_data.value

def __abstracted_fifo_read(count, address, address_status, blocking, timeout_ms, handle):
    data = (c_uint * (2 * count))()
    read_data = c_uint(0)
    valid_data = c_uint(0)
    err = mydll.NI_ReadData(byref(data), count, address, 1, timeout_ms, byref(handle), byref(read_data), byref(valid_data))
    return err, data, read_data, valid_data 	
	
def REG_ANALOG_OFFSET_SET(data, handle):
    err = __abstracted_reg_write(data, lab1ledlblink_RegisterFile.SCI_REG_ANALOG_OFFSET, handle)
    return err

